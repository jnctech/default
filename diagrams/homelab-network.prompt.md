# Image-generation prompt — Homelab Network Topology (extended)

> **For:** Gemini's latest image model (strongest text rendering) or comparable.
> **Source of truth:** `diagrams/homelab-network-extended.svg`. Always verify labels
> against the SVG — image-gen models routinely garble service names, IPs, and
> port numbers.

---

## Prompt (paste into image model)

Render a single tall portrait infographic at a 1:3.3 aspect ratio (canvas roughly
1080×3580), optimized for viewing on a Samsung Galaxy AMOLED phone. Aesthetic:
refined dark "ops console" — true black (#000) background with a subtle dot-grid
texture, soft shadows under floating cards, weighted neon-line accents
(cyan, orange, violet, emerald, pink, amber), and a clean modern geometric
sans-serif typeface (think Inter / IBM Plex Sans) with a tight monospace
(JetBrains Mono) for IP addresses, ports and CIDRs. Do NOT use stock Visio
icons, do NOT use flat clip-art, do NOT make it look like a corporate
PowerPoint. Cards must have subtle dark gradients and 1.5–2 px colored
strokes that match each tier's accent.

The diagram is a homelab network topology, flowing strictly top-to-bottom in
this exact order, with every label rendered legibly and accurately:

1. **Title bar at top:** the eyebrow text "HOMELAB · NETWORK TOPOLOGY · EXTENDED"
   in spaced-out uppercase grey, with a thin divider rule beneath.

2. **Internet tier (cyan accent):** a wide stylized cloud outline glowing
   faintly cyan, centered, with two text lines inside: **"Internet"** (large,
   bold, white) and **"Public Internet · WAN"** (smaller, grey, monospace).

3. **Link down with label pill:** a dashed cyan vertical line ending in an
   arrowhead, with a black pill mid-link reading **"HTTPS · 443"** in
   monospace.

4. **Cloudflare Tunnel tier (orange accent):** a centered rounded rectangle
   card with the Cloudflare double-cloud glyph (an amber upper cloud overlapping
   an orange lower cloud) on the left, and three stacked text lines on the
   right: **"Cloudflare"**, **"Tunnel"**, and below in mono grey
   **"cloudflared · colebungalow.com"**.

5. **External Domain Map band:** a wide dark band with an orange dashed border
   and the title **"External Domain Map · colebungalow.com"**. Inside, a 5×2
   grid of 10 small rounded chips, each containing one subdomain (in mono,
   white) and below it an arrow to its target service in amber, in this order:
   - **auth** → Authentik · Direct
   - **portainer** → Portainer · OIDC
   - **gitea** → Gitea · OIDC
   - **sonarr** → Sonarr · Fwd-Auth
   - **radarr** → Radarr · Fwd-Auth
   - **sabnzb** → SABnzbd · Fwd-Auth
   - **tautulli** → Tautulli · Fwd-Auth
   - **overseerr** → Overseerr · Fwd-Auth
   - **pihole** → Pi-hole · Fwd-Auth
   - **slay** → Homework · Fwd-Auth

6. **Link to NPM** with a black pill labelled **"Encrypted Tunnel"**.

7. **Infrastructure Network zone (violet accent):** a large rounded rectangle
   with a faint violet fill, a violet dashed stroke, and a violet header chip
   in the top-left reading **"INFRASTRUCTURE NETWORK"** with an inset mono
   chip **"192.168.30.0/24"**. Inside:
   - **Nginx Proxy Manager** card centered at the top: a proxy glyph (two
     converging arrows) on the left, large title **"Nginx Proxy Manager"**,
     subtitle **"192.168.30.28 · nginx-proxy"** in mono, three capability
     pills below ("Reverse Proxy", "SSL / TLS", "Forward Auth"), and a small
     caption "Cloudflared tunnel endpoint · Let's Encrypt · ACL filtering".
   - Beneath it, an arrow splits into two: a left arrow to the Docker Host card
     and a right arrow to the Asustor NAS card, with a small label
     "Routes traffic to services".
   - **Docker Host card (left column, blue accent):** a stacked-containers
     glyph in the corner. Title **"Docker Host"**, subtitle
     **"192.168.30.10 · docker-vm01"**, caption "13 containers · Docker
     Compose". Below, three prominent service chips:
     - **Authentik** — Identity Provider — DIRECT badge — `:9443 :9000`
     - **Gitea** — Git hosting · CI — OIDC badge — `:3000 :222`
     - **Gitea Runner** — CI workers · Docker-in-Docker — `act_runner`
     Below a divider labelled "Also hosts (per system docs)", a dense two-column
     bullet list in monospace:
     - `· Grafana :3001`
     - `· Loki :3100`
     - `· Promtail UDP :1515 :1516`
     - `· Pi-hole (primary) :8080`
     - `· Unbound (recursive DNS)`
     - `· FamilyLink Auth (OAuth proxy)`
     - `· Obsidian LiveSync (CouchDB)`
     - `· Portainer Agent :9001`
     - `· Dev Container SSH :2222`
     - `· Homework (Slay) :8181`
   - **Asustor NAS card (right column, amber accent):** a stacked-drives
     glyph in the corner. Title **"Asustor NAS"**, subtitle
     **"192.168.30.22 · asustor-nas"**, caption "Media services · Portainer
     host". Below, six service chips each with an auth-method badge:
     - **Portainer** — OIDC — `:19943`
     - **Sonarr** — FWD-AUTH — `:18989`
     - **Radarr** — FWD-AUTH — `:17878`
     - **SABnzbd** — FWD-AUTH — `:38380`
     - **Tautulli** — FWD-AUTH — `:38181`
     - **Overseerr** — FWD-AUTH — `:25055`

8. **Inter-network Routing** link: a dotted grey vertical line with a pill
   labelled **"Inter-network Routing"**.

9. **Home Network zone (emerald accent):** rounded zone with green dashed
   stroke and header chip **"HOME NETWORK · 192.168.88.0/24"**. Three side-by-
   side cards:
   - **Home Assistant** — house glyph — IP `192.168.88.43` — bullets
     "Automations", "Smart-home hub", "Web UI :8123", "Bridges to IoT VLAN".
   - **Pi-hole (Secondary · RPi)** — shield-with-block glyph — IP
     `192.168.88.35 · raspberrypi` — bullets "DNS failover (Netwatch)",
     "Gravity-sync from primary", "Primary on docker-vm01" (in amber to flag
     it), "Web UI :8080".
   - **Zigbee Coord** — antenna-with-arcs glyph — IP
     `192.168.88.50 · slzb-06m` — bullets "Bridges Zigbee → IP", "Used by Home
     Assistant", "Mesh root".

10. **IoT Network · VLAN 70 zone (pink accent, MUTED / PLANNED):** This zone
    must look explicitly **not yet deployed**. Use a dashed pink border that
    is more broken than the other zones, slightly reduced opacity on the fill,
    and an amber **"⚠ PLANNED"** warning badge in the zone header next to the
    CIDR chip. Below the header, an amber warning row:
    **"Configs exist in apps/mikrotik/ · Not applied on RB4011 · Pending
    decision (ISS-260517-vlan-70-fate)"**. Then "Planned configuration"
    captioning three dashed pills: "SSID · dozernet-iot", "Block-by-default ·
    allow-list cloud", "HA → IoT permitted". Below, a caption "Smart Devices
    · currently on Home Network until VLAN 70 lands" with a row of slightly
    desaturated device pills: **Lights**, **Sensors**, **Cameras**,
    **Speakers**, **Zigbee / Wi-Fi**.

11. **Network Equipment · MikroTik band (slate accent):** dark slate zone
    with header **"NETWORK EQUIPMENT · MIKROTIK"** and a side chip "RouterOS
    · VLAN trunk". Four side-by-side equipment cards in a row, each with a
    tiny vector glyph and 3–4 lines of text:
    - **RB4011** — Gateway Router — `.88.1 / .70.1` — DHCP · Firewall —
      PPPoE · SQM — RouterOS 7.22.2
    - **CRS310** — Managed Switch — `.88.7 / .70.7` — VLAN trunk —
      Inter-switch links — RouterOS 7.21.3
    - **hAP ax3** — WiFi AP · Front — `.88.9 / .70.9` — Wi-Fi 6 · PoE-out —
      Uplink to ether10 — RouterOS 7.22.1
    - **hAP ac2** — WiFi AP · Back — `.88.4` — 2.4 + 5 GHz — Garden / pool
      zone — RouterOS 7.21.3

12. **Footer line** in tiny uppercase grey: "Portrait 1080×3580 · True-black
    OLED · Per .claude/domains/network.yaml · Verified 2026-05-17".

### Rendering rules (strict)
- **Render every text label exactly as quoted above.** Do not paraphrase, do
  not invent service names, do not drop port numbers, do not swap IPs.
- Treat the SVG file as the authoritative reference. If you cannot render
  text legibly at any size, leave that region blank rather than scribbling
  approximate letters.
- Keep the canvas portrait with strong top-down flow. Avoid horizontal
  sprawl — the diagram is intended to be scrolled on a phone.
- Lines connecting tiers should be weighted: dashed cyan (Internet→CF),
  dashed orange (CF→NPM), solid violet (within infra zone), dotted grey
  (inter-network).
- Use true black background so the diagram floats on an AMOLED panel.
