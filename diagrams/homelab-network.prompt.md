# Image-generation prompt — Homelab Network Topology (extended)

> **For:** Gemini's latest image model (strongest text rendering) or comparable.
> **Source of truth:** `diagrams/homelab-network-extended.svg` (canvas 1080×4250).
> Always verify labels against the SVG — image-gen models routinely garble
> service names, IPs, and port numbers.

---

## Prompt (paste into image model)

Render a single tall portrait infographic at a 1080:4250 (≈ 1 : 3.94) aspect
ratio, optimized for viewing on a Samsung Galaxy AMOLED phone. Aesthetic:
refined dark "ops console" — true black (#000) background with a subtle
dot-grid texture, soft shadows under floating cards, weighted neon-line
accents (cyan, orange, violet, emerald, pink, teal, amber, slate, red),
and a clean modern geometric sans-serif typeface (Inter / IBM Plex Sans)
with a tight monospace (JetBrains Mono) for IP addresses, ports and CIDRs.
Do NOT use stock Visio icons, do NOT use flat clip-art, do NOT make it
look like a corporate PowerPoint. Cards have subtle dark gradients and
1.5–2 px colored strokes that match each tier's accent.

The diagram is a homelab network topology, flowing strictly top-to-bottom
in this exact order, with every label rendered legibly and accurately:

1. **Title bar at top:** eyebrow text "HOMELAB · NETWORK TOPOLOGY · EXTENDED"
   in spaced-out uppercase grey with a thin divider rule beneath.

2. **Internet tier (cyan accent):** a wide stylized cloud outline glowing
   faintly cyan, centered, with two text lines inside: **"Internet"** (large,
   bold, white) and **"Public Internet · WAN"** (smaller, grey, monospace).

3. **Two parallel remote-access paths beneath Internet:**
   - **Main path (center):** a dashed cyan vertical line ending in an
     arrowhead, with a black pill mid-link reading **"HTTPS · 443"** in
     monospace.
   - **Side path (right, teal accent):** a rounded card titled
     **"WireGuard"** with subtitle **"Remote Access · alt path"**. Inside:
     a small tunnel-zigzag glyph, mono line **"UDP/13231 → RB4011"**,
     **"Peer: samsung-phone (.100.2)"**, and a small teal caption
     **"Crypto auth · Not geoblocked"**. Draw a faint dashed teal curve
     from the Internet cloud down past the Cloudflare tier on the right
     side, all the way down toward the network-equipment band (signalling
     WG bypasses CF and lands at RB4011).

4. **Cloudflare Tunnel tier (orange accent):** a centered rounded rectangle
   card with the Cloudflare double-cloud glyph (amber upper cloud overlapping
   an orange lower cloud) on the left, and three stacked text lines on the
   right: **"Cloudflare"**, **"Tunnel"**, and below in mono grey
   **"cloudflared · colebungalow.com"**.

5. **External Domain Map band** (orange dashed border), header
   **"External Domain Map · colebungalow.com"**, with a 5×2 grid of 10 small
   rounded chips. Each chip shows a subdomain (mono, white) then an arrow
   to its target service in amber:
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

6. **Link to NPM** with a black pill labelled **"Encrypted Tunnel"** in orange.

7. **Infrastructure Network zone (violet accent):** large rounded rectangle
   with a faint violet fill, dashed violet stroke, violet header chip top-left
   reading **"INFRASTRUCTURE NETWORK"** with an inset mono chip
   **"192.168.30.0/24"**. Inside:
   - **Nginx Proxy Manager** card centered at the top: proxy glyph (two
     converging arrows) on the left, title **"Nginx Proxy Manager"**,
     subtitle **"192.168.30.28 · npm CT 118 + cloudflared"** in mono, three
     capability pills ("Reverse Proxy", "SSL / TLS", "Forward Auth"), tiny
     caption "Cloudflared endpoint · Let's Encrypt · ACL filtering".
   - Beneath: arrow splits left/right with a small label
     "Routes traffic to services".
   - **Docker Host card (left column, blue accent):** stacked-containers
     glyph, title **"Docker Host"**, subtitle
     **"192.168.30.10 · docker-vm01 (VM 102)"**, caption
     "13 containers · Docker Compose". Three prominent service chips:
     - **Authentik** — Identity Provider — DIRECT badge — `:9443 :9000`
     - **Gitea** — Git hosting · CI — OIDC badge — `:3000 :222`
     - **Gitea Runner** — CI workers · Docker-in-Docker — `act_runner`
     Below a divider "Also hosts (per system docs)", dense two-column
     monospace bullet list:
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
   - **Asustor NAS card (right column, amber accent):** stacked-drives glyph,
     title **"Asustor NAS"**, subtitle **"192.168.30.22 · asustor-nas"**,
     caption "Media services · Portainer host". Six service chips, each with
     an auth-method badge:
     - **Portainer** — OIDC — `:19943`
     - **Sonarr** — FWD-AUTH — `:18989`
     - **Radarr** — FWD-AUTH — `:17878`
     - **SABnzbd** — FWD-AUTH — `:38380`
     - **Tautulli** — FWD-AUTH — `:38181`
     - **Overseerr** — FWD-AUTH — `:25055`
   - **Additional VLAN 30 LXCs strip** (dashed violet border) at the bottom
     of the zone, header micro-text **"Additional VLAN 30 LXCs · hosted on
     Proxmox PVE"**. Two chips side-by-side:
     - **Vaultwarden** — lock glyph — "Self-hosted Bitwarden · secrets store"
       — `CT 117` — `192.168.30.29` (in amber)
     - **Gotify** — bell glyph — "Push-notification server · alerts" —
       `CT 116` — `192.168.30.26` (in amber)

8. **Inter-network area:** dotted grey vertical line with a pill
   **"Inter-network Routing"**. **To the left** of the arrow, a small dashed
   amber callout card titled **"Firewall model"** containing the mono text
   **"trust_lan_interface_list"**, a line "No per-flow VLAN gates · App-layer
   auth is the boundary", and a grey sub-line "(Authentik · NPM TLS ·
   Forward-auth)".

9. **Home Network zone (emerald accent):** rounded zone, green dashed stroke,
   header chip **"HOME NETWORK · 192.168.88.0/24"**. Four cards in a single
   row (instead of three):
   - **Home Assistant** — house glyph — `.88.43` — bullets "Automations",
     "Smart-home hub", "Web UI :8123", "Dual-NIC to .30.20", "Bridges to IoT",
     small footer "VM 111 on PVE".
   - **Pi-hole (Secondary · RPi)** — shield-with-block glyph — `.88.35` —
     bullets "DNS failover", "Gravity-sync", "Primary on .30.10" (in amber to
     flag), "Web UI :8080", "Netwatch flip", footer "raspberrypi (Pi
     Foundation)".
   - **Zigbee Coord** — antenna-with-arcs glyph — `.88.50` — bullets
     "Zigbee → IP", "Used by HA", "Mesh root", "slzb-06m", footer
     "SLZB-06m bridge".
   - **Proxmox PVE** — hypervisor-stack glyph — `.88.10` — bullets
     "Hypervisor", "VMs: 102 (docker)", "    111 (HAOS)", "LXCs: 116/117/118",
     amber sub-line "  Gotify·VW·NPM", footer "pve".

10. **IoT Network · VLAN 70 zone (pink accent, MUTED / PLANNED):** this zone
    must look explicitly **not yet deployed**. Use a heavily dashed pink
    border, slightly reduced opacity on fill, and an amber
    **"⚠ PLANNED"** warning badge in the zone header next to the CIDR chip.
    Below the header an amber warning row:
    **"Configs exist in apps/mikrotik/ · Not applied on RB4011 · Pending
    decision (ISS-260517-vlan-70-fate)"**. Then "Planned configuration"
    captioning three dashed pills: "SSID · dozernet-iot", "Block-by-default
    · allow-list cloud", "HA → IoT permitted". Below, caption "Smart Devices
    · currently on Home Network until VLAN 70 lands" with desaturated device
    pills: **Lights**, **Sensors**, **Cameras**, **Speakers**,
    **Zigbee / Wi-Fi**.

11. **VLAN Inventory band (teal accent):** header chip **"VLAN INVENTORY ·
    RB4011"** and side mono chip **"8 VLANs"**. A 4×2 grid of 8 VLAN chips,
    each chip showing the VLAN label (bold mono in the tier color), the
    subnet (mono grey), and a one-line purpose:
    - **default · 88** (green border) — `192.168.88.0/24` — "Home · mgmt ·
      WiFi clients"
    - **VLAN 30** (violet border) — `192.168.30.0/24` — "Infrastructure ·
      servers"
    - **VLAN 20** (blue border) — `192.168.20.0/24` — "Users · phones ·
      laptops"
    - **VLAN 40** (amber border) — `192.168.40.0/24` — "Servers (secondary)"
    - **VLAN 50** (red border) — `192.168.50.0/24` — "DMZ · public-exposed"
    - **VLAN 60** (slate border) — `192.168.60.0/24` — "Guest WiFi · isolated"
    - **VLAN 70** (pink dashed border) — `192.168.70.0/24` — purpose text in
      amber: "IoT · ⚠ planned, not deployed"
    - **VLAN 99** (slate dashed border) — `192.168.99.0/24` — purpose text
      in amber: "Mgmt · leftover, not wired"

12. **Network Equipment · MikroTik band (slate accent):** dark slate zone,
    header **"NETWORK EQUIPMENT · MIKROTIK"** and side chip
    "RouterOS · VLAN trunk". Four side-by-side equipment cards, each with a
    small vector glyph and 3–4 text lines:
    - **RB4011** — Gateway Router — `.88.1 / .70.1` — "DHCP · Firewall" —
      "PPPoE · SQM · WG" — RouterOS 7.22.2
    - **CRS310** — Managed Switch — `.88.7 / .70.7` — "VLAN trunk" —
      "Inter-switch links" — RouterOS 7.21.3
    - **hAP ax3** — WiFi AP · Front — `.88.9 / .70.9` — "Wi-Fi 6 · PoE-out"
      — "Uplink to ether10" — RouterOS 7.22.1
    - **hAP ac2** — WiFi AP · Back — `.88.4` — "2.4 + 5 GHz" — "Garden /
      pool zone" — RouterOS 7.21.3 PIN

13. **Security · Open Issues band (red accent):** dark red-tinted zone,
    header chip **"SECURITY · OPEN ISSUES"**. Three warning cards
    side-by-side, each with a red border and a "⚠" eyebrow:
    - **⚠ EXPOSED · LAN** — mono **"Docker API :2375"** — ".30.10 bound
      0.0.0.0 · no auth/TLS" — grey footer "ISS-260517-docker-api-exposed"
    - **⚠ PLAINTEXT** — mono **"RouterOS API :8728"** — "Unencrypted · LAN
      only · MCP planned" — grey footer "ISS-260517-mikrotik-api-tls"
    - **⚠ BROKEN** — mono **"CRS310 SSH from VLAN 30"** — "Workaround:
      RouterOS API only" — grey footer "Works from default VLAN"

14. **Footer line**, tiny uppercase grey:
    "Portrait 1080×4250 · True-black OLED · Per .claude/domains/network.yaml
    · Verified 2026-05-17".

### Rendering rules (strict)
- **Render every text label exactly as quoted above.** Do not paraphrase, do
  not invent service names, do not drop port numbers, do not swap IPs, do
  not re-order tiers.
- Treat the SVG file as the authoritative reference. If you cannot render
  text legibly at any size, leave that region blank rather than scribbling
  approximate letters.
- Keep the canvas portrait with strong top-down flow. Avoid horizontal
  sprawl — the diagram is intended to be scrolled on a phone.
- Line weighting: dashed cyan (Internet→CF), dashed teal (Internet→WG, long
  arcing curve on the right side), dashed orange (CF→NPM), solid violet
  (within infra zone), dotted grey (inter-network).
- Pink IoT zone is intentionally faded / dashed to signal "planned, not
  deployed". Do not render it as a live zone.
- Use true black background so the diagram floats on an AMOLED panel.
