# Image-gen prompt — homelab network topology (ISOMETRIC variant)

> One of three aesthetic-specific variants. Source of truth:
> `diagrams/homelab-network-extended.svg`.
>
> **Direction:** soft modern editorial infographic with isometric depth.

---

## Prompt (paste into the image model)

Produce a portrait infographic of the homelab network topology described
below, rendered as a **soft modern editorial poster with isometric
depth**. Canvas ~1080:4250, designed for a tall Samsung Galaxy AMOLED
phone.

### Aesthetic — editorial isometric
Cards and zones float over a subtle paper-grain field — your call on
whether the paper is warm (cream / oat) or cool (pale dusk / fog). Apply
a gentle ~25–30° axonometric tilt so each zone looks like a tray of
services seen from slightly above; each service card sits on the tray
with a small chamfered side face revealing depth. Soft drop shadows
beneath every floating element — restrained, never punchy. Palette:
muted but rich — sage, slate, terracotta, denim, mustard, dusk-rose,
walnut — pick a coherent 5–6 colour family and keep it consistent
throughout. Avoid rainbow. Glyphs are simple geometric primitives with
subtle material highlights (a soft top-light suggesting it's a real
object). Typography: a warm geometric sans (think Söhne, Inter, Greycliff)
with generous tracking, and a tight technical mono for IPs/ports.
Mood: a print spread in *Wired*, *Bloomberg Businessweek*, or *MIT
Technology Review* — calm, confident, dense but never cramped, the kind
of poster that rewards close reading.

### Topology — render exactly, top to bottom

1. **Title** at the top: *HOMELAB · NETWORK TOPOLOGY · EXTENDED*

2. **Internet (WAN)** — *"Internet"*, *"Public Internet · WAN"*

3. **Two remote-access paths** from Internet:
   - Main: link *"HTTPS · 443"* to Cloudflare.
   - Alternative **WireGuard** node, subtitle *"Remote Access · alt
     path"*, body *"UDP/13231 → RB4011"*, *"Peer: samsung-phone
     (.100.2)"*, *"Crypto auth · Not geoblocked"*. The WG path bypasses
     Cloudflare entirely and curves down to the RB4011 router near the
     bottom — render as a long arcing inked line down one side of the
     spread.

4. **Cloudflare Tunnel** — *"Cloudflare Tunnel"*,
   *"cloudflared · colebungalow.com"*.

5. **External Domain Map** (`colebungalow.com`) — 10 subdomain → service
   rows:
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

7. **Infrastructure Network zone** — *"192.168.30.0/24"*. Render the
   whole zone as a single isometric tray, with services as small blocks
   sitting on it. Contains:
   - **Nginx Proxy Manager** — *"192.168.30.28 · npm CT 118 +
     cloudflared"*. Capabilities: Reverse Proxy · SSL/TLS · Forward Auth.
     Caption: *"Cloudflared endpoint · Let's Encrypt · ACL filtering"*.
   - Two columns under NPM (two sub-trays):
     - **Docker Host** — *"192.168.30.10 · docker-vm01 (VM 102)"*,
       *"13 containers · Docker Compose"*. Featured:
       - **Authentik** — Identity Provider — `DIRECT` — `:9443 :9000`
       - **Gitea** — Git hosting · CI — `OIDC` — `:3000 :222`
       - **Gitea Runner** — CI workers · Docker-in-Docker — `act_runner`
       Also hosts: `Grafana :3001`, `Loki :3100`,
       `Promtail UDP :1515 :1516`, `Pi-hole (primary) :8080`,
       `Unbound (recursive DNS)`, `FamilyLink Auth (OAuth proxy)`,
       `Obsidian LiveSync (CouchDB)`, `Portainer Agent :9001`,
       `Dev Container SSH :2222`, `Homework (Slay) :8181`.
     - **Asustor NAS** — *"192.168.30.22 · asustor-nas"*,
       *"Media services · Portainer host"*. Services:
       - **Portainer** — `OIDC` — `:19943`
       - **Sonarr** — `FWD-AUTH` — `:18989`
       - **Radarr** — `FWD-AUTH` — `:17878`
       - **SABnzbd** — `FWD-AUTH` — `:38380`
       - **Tautulli** — `FWD-AUTH` — `:38181`
       - **Overseerr** — `FWD-AUTH` — `:25055`
   - **Additional VLAN 30 LXCs (hosted on Proxmox PVE):**
     - **Vaultwarden** — *"Self-hosted Bitwarden · secrets store"* —
       `CT 117` · `192.168.30.29`
     - **Gotify** — *"Push-notification server · alerts"* — `CT 116` ·
       `192.168.30.26`

8. **Inter-network routing** arrow between trays with a small **Firewall
   model** callout:
   *"trust_lan_interface_list — No per-flow VLAN gates · App-layer auth
   is the boundary (Authentik · NPM TLS · Forward-auth)"*.

9. **Home Network zone** — *"192.168.88.0/24"* — a second isometric tray
   with four cards in a row:
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

10. **IoT Network · VLAN 70 — ⚠ PLANNED, NOT DEPLOYED.** Render this
    tray with **wireframe construction lines only** — outlined but not
    materialised, like an architect's "future phase" overlay. The
    "PLANNED" badge can sit in full colour to stay readable.
    - CIDR `192.168.70.0/24`.
    - Warning: *"Configs exist in apps/mikrotik/ · Not applied on RB4011
      · Pending decision (ISS-260517-vlan-70-fate)"*.
    - Planned config: *"SSID · dozernet-iot"*,
      *"Block-by-default · allow-list cloud"*, *"HA → IoT permitted"*.
    - Caption: *"Smart Devices · currently on Home Network until VLAN 70
      lands"*. Devices: **Lights · Sensors · Cameras · Speakers · Zigbee
      / Wi-Fi**.

11. **VLAN Inventory · RB4011 — 8 VLANs**, as colour-coded chips in a
    grid:
    - `default · 88` — `192.168.88.0/24` — Home · mgmt · WiFi clients
    - `VLAN 30` — `192.168.30.0/24` — Infrastructure · servers
    - `VLAN 20` — `192.168.20.0/24` — Users · phones · laptops
    - `VLAN 40` — `192.168.40.0/24` — Servers (secondary)
    - `VLAN 50` — `192.168.50.0/24` — DMZ · public-exposed
    - `VLAN 60` — `192.168.60.0/24` — Guest WiFi · isolated
    - `VLAN 70` — `192.168.70.0/24` — IoT · ⚠ planned, not deployed
    - `VLAN 99` — `192.168.99.0/24` — Mgmt · leftover, not wired

12. **Network Equipment · MikroTik** — four small isometric chassis
    blocks in a row:
    - **RB4011** — Gateway Router — `.88.1 / .70.1` — DHCP · Firewall ·
      PPPoE · SQM · WG — RouterOS 7.22.2
    - **CRS310** — Managed Switch — `.88.7 / .70.7` — VLAN trunk ·
      Inter-switch links — RouterOS 7.21.3
    - **hAP ax3** — WiFi AP · Front — `.88.9 / .70.9` — Wi-Fi 6 · PoE-out ·
      Uplink to `ether10` — RouterOS 7.22.1
    - **hAP ac2** — WiFi AP · Back — `.88.4` — 2.4 + 5 GHz · Garden / pool
      zone — RouterOS 7.21.3 PIN

13. **Security · Open Issues** — three warning cards rendered in a warm
    alert tone (terracotta / rust / oxidised orange — clearly different
    from the rest of the palette):
    - **⚠ EXPOSED · LAN** — `Docker API :2375` — *".30.10 bound 0.0.0.0 ·
      no auth/TLS"* — *"ISS-260517-docker-api-exposed"*
    - **⚠ PLAINTEXT** — `RouterOS API :8728` — *"Unencrypted · LAN only ·
      MCP planned"* — *"ISS-260517-mikrotik-api-tls"*
    - **⚠ BROKEN** — `CRS310 SSH from VLAN 30` — *"Workaround: RouterOS
      API only"* — *"Works from default VLAN"*

14. **Footer** in small grey: *"Portrait 1080×4250 · True-black OLED ·
    Per .claude/domains/network.yaml · Verified 2026-05-17"*.

### Closing rules
- Every quoted label verbatim. No paraphrasing.
- Do not invent nodes, links, zones, or services not listed.
- Do not re-order the 14 sections.
- VLAN 70 / IoT in wireframe / unrealised state — clearly future-phase.
- Security cards in a warm alert tone, clearly differentiated.
- Maintain consistent ~25–30° axonometric tilt on cards and trays.
- Portrait orientation, top-to-bottom flow.
