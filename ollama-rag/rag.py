"""A small, dependency-light Retrieval-Augmented Generation (RAG) tool for Ollama.

Everything runs locally against an Ollama server (default http://localhost:11434):

  * embeddings  -> the `nomic-embed-text` model
  * generation  -> the `llama3` model

Documents are chunked, embedded, and stored in a plain JSON file. At query time
the question is embedded, the most similar chunks are retrieved via cosine
similarity, and they are stuffed into the prompt as grounding context.

Usage
-----
    # 1. Pull the models once (outside this script):
    #    ollama pull nomic-embed-text
    #    ollama pull llama3

    # 2. Drop .txt / .md files into ./docs (or pass --source) and build the index:
    python rag.py ingest

    # 3. Ask a one-off question:
    python rag.py query "What is the refund policy?"

    # 4. Or start an interactive chat grounded in your docs:
    python rag.py chat
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from dataclasses import dataclass, asdict
from typing import Iterable

import numpy as np
import requests

# --------------------------------------------------------------------------- #
# Configuration (override any of these with environment variables)
# --------------------------------------------------------------------------- #
OLLAMA_URL = os.environ.get("OLLAMA_URL", "http://localhost:11434")
EMBED_MODEL = os.environ.get("RAG_EMBED_MODEL", "nomic-embed-text")
CHAT_MODEL = os.environ.get("RAG_CHAT_MODEL", "llama3")

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_SOURCE = os.path.join(HERE, "docs")
DEFAULT_INDEX = os.path.join(HERE, "index.json")

CHUNK_SIZE = 1000          # characters per chunk
CHUNK_OVERLAP = 150        # characters shared between adjacent chunks
TOP_K = 4                  # chunks retrieved per query
REQUEST_TIMEOUT = 120      # seconds


# --------------------------------------------------------------------------- #
# Data model
# --------------------------------------------------------------------------- #
@dataclass
class Chunk:
    text: str
    source: str
    embedding: list[float]


# --------------------------------------------------------------------------- #
# Ollama HTTP helpers
# --------------------------------------------------------------------------- #
def embed(text: str) -> list[float]:
    """Return the embedding vector for `text` using the embedding model."""
    resp = requests.post(
        f"{OLLAMA_URL}/api/embeddings",
        json={"model": EMBED_MODEL, "prompt": text},
        timeout=REQUEST_TIMEOUT,
    )
    resp.raise_for_status()
    return resp.json()["embedding"]


def generate(prompt: str, system: str | None = None, stream: bool = True) -> str:
    """Generate a completion from the chat model, optionally streaming to stdout."""
    payload: dict = {"model": CHAT_MODEL, "prompt": prompt, "stream": stream}
    if system:
        payload["system"] = system

    resp = requests.post(
        f"{OLLAMA_URL}/api/generate",
        json=payload,
        stream=stream,
        timeout=REQUEST_TIMEOUT,
    )
    resp.raise_for_status()

    if not stream:
        return resp.json().get("response", "")

    pieces: list[str] = []
    for line in resp.iter_lines():
        if not line:
            continue
        data = json.loads(line)
        token = data.get("response", "")
        pieces.append(token)
        sys.stdout.write(token)
        sys.stdout.flush()
        if data.get("done"):
            break
    sys.stdout.write("\n")
    return "".join(pieces)


def check_ollama() -> None:
    """Fail fast with a friendly message if Ollama is not reachable."""
    try:
        requests.get(f"{OLLAMA_URL}/api/tags", timeout=5).raise_for_status()
    except requests.RequestException as exc:
        sys.exit(
            f"Could not reach Ollama at {OLLAMA_URL}.\n"
            f"Start it with `ollama serve` and pull the models:\n"
            f"  ollama pull {EMBED_MODEL}\n"
            f"  ollama pull {CHAT_MODEL}\n"
            f"(underlying error: {exc})"
        )


# --------------------------------------------------------------------------- #
# Chunking & ingestion
# --------------------------------------------------------------------------- #
def chunk_text(text: str, size: int = CHUNK_SIZE, overlap: int = CHUNK_OVERLAP) -> Iterable[str]:
    """Split `text` into overlapping character windows, snapping to whitespace."""
    text = text.strip()
    if not text:
        return
    start = 0
    n = len(text)
    while start < n:
        end = min(start + size, n)
        # Try to break on a newline or space near the window edge for cleaner chunks.
        if end < n:
            window = text[start:end]
            for sep in ("\n\n", "\n", ". ", " "):
                idx = window.rfind(sep)
                if idx > size * 0.5:  # only snap if we keep a reasonable chunk size
                    end = start + idx + len(sep)
                    break
        chunk = text[start:end].strip()
        if chunk:
            yield chunk
        if end >= n:
            break
        start = max(end - overlap, start + 1)


def iter_source_files(source: str) -> Iterable[str]:
    """Yield paths of supported text files under `source` (file or directory)."""
    exts = {".txt", ".md", ".markdown", ".rst", ".py", ".json"}
    if os.path.isfile(source):
        yield source
        return
    for root, _dirs, files in os.walk(source):
        for name in sorted(files):
            if os.path.splitext(name)[1].lower() in exts:
                yield os.path.join(root, name)


def ingest(source: str, index_path: str) -> None:
    check_ollama()
    files = list(iter_source_files(source))
    if not files:
        sys.exit(f"No supported documents found under {source!r}. Add .txt/.md files and retry.")

    chunks: list[Chunk] = []
    for path in files:
        rel = os.path.relpath(path, start=os.path.dirname(source) if os.path.isfile(source) else source)
        try:
            with open(path, "r", encoding="utf-8", errors="replace") as fh:
                content = fh.read()
        except OSError as exc:
            print(f"  ! skipping {path}: {exc}", file=sys.stderr)
            continue

        pieces = list(chunk_text(content))
        for i, piece in enumerate(pieces):
            print(f"  embedding {rel} [{i + 1}/{len(pieces)}]", end="\r", flush=True)
            chunks.append(Chunk(text=piece, source=rel, embedding=embed(piece)))
        print(f"  embedded  {rel}: {len(pieces)} chunk(s)" + " " * 20)

    with open(index_path, "w", encoding="utf-8") as fh:
        json.dump(
            {"embed_model": EMBED_MODEL, "chunks": [asdict(c) for c in chunks]},
            fh,
        )
    print(f"\nIndexed {len(chunks)} chunks from {len(files)} file(s) -> {index_path}")


# --------------------------------------------------------------------------- #
# Retrieval
# --------------------------------------------------------------------------- #
def load_index(index_path: str) -> tuple[list[Chunk], np.ndarray]:
    if not os.path.exists(index_path):
        sys.exit(f"No index at {index_path}. Run `python rag.py ingest` first.")
    with open(index_path, "r", encoding="utf-8") as fh:
        data = json.load(fh)
    if data.get("embed_model") != EMBED_MODEL:
        print(
            f"Warning: index was built with '{data.get('embed_model')}' but "
            f"current embed model is '{EMBED_MODEL}'. Re-ingest for best results.",
            file=sys.stderr,
        )
    chunks = [Chunk(**c) for c in data["chunks"]]
    matrix = np.array([c.embedding for c in chunks], dtype=np.float32)
    # Pre-normalise so retrieval is a single matrix-vector product.
    norms = np.linalg.norm(matrix, axis=1, keepdims=True)
    matrix = matrix / np.clip(norms, 1e-8, None)
    return chunks, matrix


def retrieve(query: str, chunks: list[Chunk], matrix: np.ndarray, k: int = TOP_K) -> list[tuple[float, Chunk]]:
    q = np.array(embed(query), dtype=np.float32)
    q = q / max(np.linalg.norm(q), 1e-8)
    scores = matrix @ q
    top = np.argsort(scores)[::-1][:k]
    return [(float(scores[i]), chunks[i]) for i in top]


def build_prompt(question: str, hits: list[tuple[float, Chunk]]) -> str:
    context = "\n\n".join(
        f"[Source: {c.source}]\n{c.text}" for _score, c in hits
    )
    return (
        "Use the following context to answer the question. "
        "If the answer is not contained in the context, say you don't know.\n\n"
        f"=== Context ===\n{context}\n\n"
        f"=== Question ===\n{question}\n\n"
        "=== Answer ==="
    )


SYSTEM_PROMPT = (
    "You are a helpful assistant that answers strictly from the provided context. "
    "Cite the source filenames you used. Be concise."
)


# --------------------------------------------------------------------------- #
# Commands
# --------------------------------------------------------------------------- #
def cmd_query(question: str, index_path: str, k: int, show_sources: bool) -> None:
    check_ollama()
    chunks, matrix = load_index(index_path)
    hits = retrieve(question, chunks, matrix, k)
    if show_sources:
        print("Retrieved context:")
        for score, c in hits:
            preview = c.text[:80].replace("\n", " ")
            print(f"  [{score:.3f}] {c.source}: {preview}...")
        print("-" * 60)
    generate(build_prompt(question, hits), system=SYSTEM_PROMPT, stream=True)


def cmd_chat(index_path: str, k: int) -> None:
    check_ollama()
    chunks, matrix = load_index(index_path)
    print("Grounded chat. Type your question, or 'exit' to quit.\n")
    while True:
        try:
            question = input("you> ").strip()
        except (EOFError, KeyboardInterrupt):
            print()
            break
        if not question:
            continue
        if question.lower() in {"exit", "quit", ":q"}:
            break
        hits = retrieve(question, chunks, matrix, k)
        print("bot> ", end="", flush=True)
        generate(build_prompt(question, hits), system=SYSTEM_PROMPT, stream=True)
        print()


def main(argv: list[str] | None = None) -> None:
    parser = argparse.ArgumentParser(description="Local RAG over Ollama.")
    sub = parser.add_subparsers(dest="command", required=True)

    p_ingest = sub.add_parser("ingest", help="Build the vector index from documents.")
    p_ingest.add_argument("--source", default=DEFAULT_SOURCE, help="File or directory of documents.")
    p_ingest.add_argument("--index", default=DEFAULT_INDEX, help="Where to write the index JSON.")

    p_query = sub.add_parser("query", help="Ask a single question.")
    p_query.add_argument("question", help="The question to answer.")
    p_query.add_argument("--index", default=DEFAULT_INDEX)
    p_query.add_argument("--k", type=int, default=TOP_K, help="Chunks to retrieve.")
    p_query.add_argument("--sources", action="store_true", help="Print retrieved chunks.")

    p_chat = sub.add_parser("chat", help="Interactive grounded chat.")
    p_chat.add_argument("--index", default=DEFAULT_INDEX)
    p_chat.add_argument("--k", type=int, default=TOP_K)

    args = parser.parse_args(argv)

    if args.command == "ingest":
        ingest(args.source, args.index)
    elif args.command == "query":
        cmd_query(args.question, args.index, args.k, args.sources)
    elif args.command == "chat":
        cmd_chat(args.index, args.k)


if __name__ == "__main__":
    main()
