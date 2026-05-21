# Image-gen prompt — homelab network topology (loose)

> **Source of truth:** `diagrams/homelab-network-extended.svg`. The SVG is
> authoritative for accuracy; this prompt asks the image model to produce a
> *stylistic poster* of the same topology. Always verify labels against the
> SVG after generation.
>
> **What this prompt does NOT prescribe:** aesthetic direction, palette,
> typography, glyph language, line treatment, depth, density. Those are the
> image model's job. Two runs of this prompt SHOULD diverge visually.
>
> **What it DOES lock:** the topology graph, every text label / IP / port,
> tier order, the planned-vs-deployed cues, the security-warning cues.
>
> For tighter / repeatable output, pick one of the variant prompts in this
> directory (`blueprint`, `neon`, `isometric`).

---

## Prompt (paste into the image model)

Produce a portrait infographic poster of the homelab network topology
described below. Canvas roughly 1080:4250 aspect ratio, designed to be
scrolled top-to-bottom on a tall Samsung Galaxy AMOLED phone.

**Aesthetic — your call.** Commit to one coherent direction and execute
it with conviction. Options like a refined ops console, a CAD-style
blueprint, neon-on-black cyberdeck, soft modern isometric depth, dark
editorial print spread, hand-drawn engineering schematic, brutalist
technical, or anything else with internal coherence are all valid — pick
one. Do **NOT** default to flat Visio / PowerPoint / stock clip-art.

You decide: palette, typography (keep IPs and ports legible in some
mono-leaning treatment), glyph language for each node type, line weighting
and dashing, depth and shadow, density and breathing room.

### Topology — render exactly, top to bottom

1. **Title** at the top: *HOMELAB · NETWORK TOPOLOGY · EXTENDED*

2. **Internet (WAN)** node — labels: *"Internet"*, *"Public Internet · WAN"*

3. **Two remote-access paths** branch from Internet:
   - **Main path (center):** labelled link *"HTTPS · 443"* descending to
     Cloudflare.
   - **Alternative path (side):** a *WireGuard* node with subtitle
     *"Remote Access · alt path"*, body lines *"UDP/13231 → RB4011"*,
     *"Peer: samsung-phone (.100.2)"*, *"Crypto auth · Not geoblocked"*.
     This path **bypasses Cloudflare entirely** and curves down to the
     RB4011 router in the network-equipment band near the bottom. Show that
     visually somehow (e.g. a long arcing line down one side).

4. **Cloudflare Tunnel** node — labels: *"Cloudflare Tunnel"*,
   *"cloudflared · colebungalow.com"*.

5. **External Domain Map** — a band/grid of 10 subdomain → service rows
   (all under `colebungalow.com`):
   - `auth` → Authentik · Direct
   - `portainer` → Portainer · OIDC
   - `gitea` → Gitea · OIDC
   - `sonarr` → Sonarr · Fwd-Auth
   - `radarr` → Radarr · Fwd-Auth
   - `sabnzb` → SABnzbd · Fwd-Auth
   - `tautulli` → Tautulli · Fwd-Auth
   - `overseerr` → Overseerr · Fwd-Auth
   - `pihole` → Pi-hole · Fwd-Auth
   - `slay` → Homework · Fwd-Auth

6. Link labelled *"Encrypted Tunnel"* down into the next zone.

7. **Infrastructure Network zone** — *"192.168.30.0/24"*. Contains:
   - **Nginx Proxy Manager** — *"192.168.30.28 · npm CT 118 + cloudflared"*.
     Capabilities: Reverse Proxy · SSL/TLS · Forward Auth. Caption:
     *"Cloudflared endpoint · Let's Encrypt · ACL filtering"*.
   - Below NPM the flow splits into two columns:
     - **Docker Host** — *"192.168.30.10 · docker-vm01 (VM 102)"*,
       *"13 containers · Docker Compose"*. Featured services with
       auth-method badges:
       - **Authentik** — Identity Provider — `DIRECT` — `:9443 :9000`
       - **Gitea** — Git hosting · CI — `OIDC` — `:3000 :222`
       - **Gitea Runner** — CI workers · Docker-in-Docker — `act_runner`
       Also hosts (dense list): `Grafana :3001`, `Loki :3100`,
       `Promtail UDP :1515 :1516`, `Pi-hole (primary) :8080`,
       `Unbound (recursive DNS)`, `FamilyLink Auth (OAuth proxy)`,
       `Obsidian LiveSync (CouchDB)`, `Portainer Agent :9001`,
       `Dev Container SSH :2222`, `Homework (Slay) :8181`.
     - **Asustor NAS** — *"192.168.30.22 · asustor-nas"*,
       *"Media services · Portainer host"*. Six services with badges:
       - **Portainer** — `OIDC` — `:19943`
       - **Sonarr** — `FWD-AUTH` — `:18989`
       - **Radarr** — `FWD-AUTH` — `:17878`
       - **SABnzbd** — `FWD-AUTH` — `:38380`
       - **Tautulli** — `FWD-AUTH` — `:38181`
       - **Overseerr** — `FWD-AUTH` — `:25055`
   - **Additional VLAN 30 LXCs (hosted on Proxmox PVE)** — small strip at
     the bottom of the zone, two chips:
     - **Vaultwarden** — *"Self-hosted Bitwarden · secrets store"* —
       `CT 117` · `192.168.30.29`
     - **Gotify** — *"Push-notification server · alerts"* — `CT 116` ·
       `192.168.30.26`

8. **Inter-network routing** arrow between zones, with a small **Firewall
   model** callout reading:
   *"trust_lan_interface_list — No per-flow VLAN gates · App-layer auth
   is the boundary (Authentik · NPM TLS · Forward-auth)"*.

9. **Home Network zone** — *"192.168.88.0/24"* — four cards in a row:
   - **Home Assistant** (`.88.43`): Automations · Smart-home hub ·
     `Web UI :8123` · Dual-NIC to `.30.20` · Bridges to IoT. Footer:
     *"VM 111 on PVE"*.
   - **Pi-hole Secondary · RPi** (`.88.35`): DNS failover · Gravity-sync ·
     *Primary on `.30.10`* · `Web UI :8080` · Netwatch flip. Footer:
     *"raspberrypi (Pi Foundation)"*.
   - **Zigbee Coord** (`.88.50`): Zigbee → IP · Used by HA · Mesh root ·
     `slzb-06m`. Footer: *"SLZB-06m bridge"*.
   - **Proxmox PVE** (`.88.10`): Hypervisor · VMs: 102 (docker), 111
     (HAOS) · LXCs: 116/117/118 (Gotify · VW · NPM). Footer: *"pve"*.

10. **IoT Network · VLAN 70 — ⚠ PLANNED, NOT DEPLOYED.** The zone MUST
    visually read as not-yet-live (faded, dashed, ghosted, "PLANNED" badge
    — your choice of treatment as long as it's unmistakable).
    - CIDR `192.168.70.0/24`.
    - Status warning text: *"Configs exist in apps/mikrotik/ · Not applied
      on RB4011 · Pending decision (ISS-260517-vlan-70-fate)"*.
    - Planned configuration: *"SSID · dozernet-iot"*,
      *"Block-by-default · allow-list cloud"*, *"HA → IoT permitted"*.
    - Caption: *"Smart Devices · currently on Home Network until VLAN 70
      lands"*. Devices: **Lights · Sensors · Cameras · Speakers · Zigbee
      / Wi-Fi**.

11. **VLAN Inventory · RB4011 — 8 VLANs**, as a grid:
    - `default · 88` — `192.168.88.0/24` — Home · mgmt · WiFi clients
    - `VLAN 30` — `192.168.30.0/24` — Infrastructure · servers
    - `VLAN 20` — `192.168.20.0/24` — Users · phones · laptops
    - `VLAN 40` — `192.168.40.0/24` — Servers (secondary)
    - `VLAN 50` — `192.168.50.0/24` — DMZ · public-exposed
    - `VLAN 60` — `192.168.60.0/24` — Guest WiFi · isolated
    - `VLAN 70` — `192.168.70.0/24` — IoT · ⚠ planned, not deployed
    - `VLAN 99` — `192.168.99.0/24` — Mgmt · leftover, not wired

12. **Network Equipment · MikroTik** — four devices in a row:
    - **RB4011** — Gateway Router — `.88.1 / .70.1` — DHCP · Firewall ·
      PPPoE · SQM · WG — RouterOS 7.22.2
    - **CRS310** — Managed Switch — `.88.7 / .70.7` — VLAN trunk ·
      Inter-switch links — RouterOS 7.21.3
    - **hAP ax3** — WiFi AP · Front — `.88.9 / .70.9` — Wi-Fi 6 · PoE-out ·
      Uplink to `ether10` — RouterOS 7.22.1
    - **hAP ac2** — WiFi AP · Back — `.88.4` — 2.4 + 5 GHz · Garden / pool
      zone — RouterOS 7.21.3 PIN

13. **Security · Open Issues** — three warning cards. Render visibly as
    warnings (your treatment):
    - **⚠ EXPOSED · LAN** — `Docker API :2375` — *".30.10 bound 0.0.0.0 ·
      no auth/TLS"* — footer *"ISS-260517-docker-api-exposed"*
    - **⚠ PLAINTEXT** — `RouterOS API :8728` — *"Unencrypted · LAN only ·
      MCP planned"* — footer *"ISS-260517-mikrotik-api-tls"*
    - **⚠ BROKEN** — `CRS310 SSH from VLAN 30` — *"Workaround: RouterOS
      API only"* — footer *"Works from default VLAN"*

14. **Footer** (small): *"Portrait 1080×4250 · True-black OLED · Per
    .claude/domains/network.yaml · Verified 2026-05-17"*.

### Closing rules (accuracy only — aesthetics stay yours)
- Render every quoted text label verbatim. Do not paraphrase service
  names, IPs, ports, or CIDRs.
- Do not invent nodes, links, zones, or services not listed above.
- Do not re-order the 14 sections.
- VLAN 70 / IoT must read visibly as not-deployed.
- The three security cards must read visibly as warnings.
- Portrait orientation, top-to-bottom flow.
