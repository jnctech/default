# ollama-rag

A small, dependency-light **Retrieval-Augmented Generation** tool that runs
entirely against a local [Ollama](https://ollama.com) server. No vector
database, no cloud APIs — documents are chunked, embedded, and stored in a
single `index.json`, then retrieved by cosine similarity at query time.

* **Embeddings:** `nomic-embed-text`
* **Generation:** `llama3`
* **Vector store:** local JSON + NumPy cosine similarity

## Setup

```bash
# 1. Install and start Ollama, then pull the models:
ollama pull nomic-embed-text
ollama pull llama3

# 2. Install Python deps:
pip install -r requirements.txt
```

## Usage

```bash
# Build the index from everything under ./docs (a sample doc is included):
python rag.py ingest

# Ask a one-off question:
python rag.py query "What is the refund policy?"

# Show which chunks were retrieved:
python rag.py query "How long does shipping take?" --sources

# Interactive grounded chat:
python rag.py chat
```

Point it at your own documents with `--source`:

```bash
python rag.py ingest --source /path/to/my/docs
```

Supported file types: `.txt`, `.md`, `.markdown`, `.rst`, `.py`, `.json`.

## Configuration

Override defaults via environment variables:

| Variable           | Default                  | Purpose                       |
| ------------------ | ------------------------ | ----------------------------- |
| `OLLAMA_URL`       | `http://localhost:11434` | Ollama server address         |
| `RAG_EMBED_MODEL`  | `nomic-embed-text`       | Embedding model               |
| `RAG_CHAT_MODEL`   | `llama3`                 | Generation model              |

Chunk size, overlap, and `top-k` retrieval are constants near the top of
`rag.py` (and `--k` overrides top-k per query).

## How it works

1. **Ingest** — files are split into overlapping ~1000-char chunks (snapped to
   whitespace), each embedded via Ollama, and saved to `index.json`.
2. **Retrieve** — the question is embedded; the top-k chunks by cosine
   similarity are selected (embeddings are pre-normalized so this is one
   matrix-vector product).
3. **Generate** — retrieved chunks are stuffed into the prompt as context and
   `llama3` answers, streaming tokens to your terminal, citing source files.
