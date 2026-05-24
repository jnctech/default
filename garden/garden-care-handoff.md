# Handoff: Maidenhair fern care + PM4 dashboard

**For:** an MCP-connected agent (Home Assistant MCP + GitHub access to the real repos).
**Intended home:** `jnctech/garden-care` (repo not yet created).

This brief was written in a session that could **not** reach Home Assistant (no HA MCP)
and was GitHub-scoped to `jnctech/default` only (could not read `homeassistant-backup` or
write `garden-care`). PM4 entities and live values below were supplied by the user.

## Tasks for the connected agent

1. **Use the device's native dry alarm.** PM4 exposes `binary_sensor.plant_monitor_4_dry`,
   which trips when soil moisture falls below the writable threshold
   `number.plant_monitor_4_soil_warning` (currently **20**). For this fern, **set
   soil_warning to ~45** (≈40% was already too dry — see data) and drive the notification
   off the binary_sensor rather than a hand-rolled numeric trigger.
2. **Read the dashboard standard** in `homeassistant-backup` and rebuild the DRAFT dashboard
   below to match its conventions (card types, naming, theme, sections).
3. **Scaffold `jnctech/garden-care`** and move this note + the finished dashboard/automation
   into it.
4. Optionally confirm provisional thresholds with one clean calibration cycle (below).

## PM4 entities (confirmed)

| Entity ID | Name | Value | Use |
|---|---|---|---|
| `sensor.plant_monitor_4_soil_moisture` | Moisture | 100% | primary signal; freshly-watered baseline |
| `sensor.plant_monitor_4_temperature` | Temperature | 16.9°C | cool (see care notes) |
| `sensor.plant_monitor_4_humidity` | Humidity | 93% | **ambient RH** — directly tracks the humidity care need (target >50%) |
| `sensor.plant_monitor_4_battery` | Battery | 100% | low-battery alert candidate |
| `binary_sensor.plant_monitor_4_dry` | Dry | off | **device dry-alarm**; trips when soil < soil_warning |
| `number.plant_monitor_4_soil_warning` | Soil warning | 20 → **set ~45** | dry-alarm threshold (%) |
| `number.plant_monitor_4_soil_calibration` | Soil calibration | 0 | offset, leave 0 unless calibrating |
| `number.plant_monitor_4_soil_sampling` | Soil sampling | 30 | sampling interval |
| `number.plant_monitor_4_humidity_calibration` | Humidity calibration | 0 | |
| `number.plant_monitor_4_temperature_calibration` | Temp calibration | 0 | |
| `number.plant_monitor_4_temperature_sampling` | Temp sampling | 30 | |
| `select.plant_monitor_4_temperature_unit` | Temp unit | celsius | |

## Live PM4 data (user, 2026-05-24 ~20:45)

| Reading | Value | Interpretation |
|---|---|---|
| Soil moisture, freshly watered | ~100% | top of band / "just watered" baseline |
| Soil moisture, prior standing (19:00–20:15, flat) | ~39–40% | level the soil held **while the fern was drought-crisping** → for this probe, **~40% = already too dry** |
| Soil moisture 20:25–20:40 swings (0↔100%) | artifact | probe pulled/reinserted + watering during the photo session — **ignore** |
| Ambient humidity | 93% | currently good (>50%); confirm it holds, not just a post-watering spike |
| Temperature | 16.9°C (range 16.3–17.7°C) | **cool** — below the 18–24°C ideal (safe, above ~10°C tender floor); expect slow growth |
| Battery | 100% | fine |

## Plant profile

- **Species:** Maidenhair fern, *Adiantum fragrans* (Swan Reach Nursery; tender
  Delta-maidenhair group, related to *A. raddianum*). Indoor/patio, full-shade.
- **Location:** Indoors, low light. **History:** discount-bin runt; alive and pushing new
  fronds — recoverable.

## Diagnosis (intake photos, same date)

- Extensive **brown, crispy, curled fronds** — drying-out / low-humidity damage; will not
  re-green, trim them.
- Healthy **new green growth at the crown** — good prognosis with consistent moisture +
  humidity.
- Crown dense, likely slightly root-bound (normal for a runt). Plastic nursery pot.

## Audited care facts (sourced)

Verified against Missouri Botanical Garden (Plant Finder) and RHS for *Adiantum*:

| Factor | Guidance |
|---|---|
| **Light** | Bright, *indirect* light; **leaves scorch in direct sun.** |
| **Water** | Water freely; **"fronds will die back quickly if soils are allowed to dry out."** Water sparingly in winter. |
| **Humidity** | Provide **high humidity** — pebble tray; PM4 humidity sensor lets you track it directly. |
| **Feeding** | **Half-strength** general liquid feed, **monthly, mid-spring to late summer.** |
| **Temperature** | Frost-tender. Keep ~18–24°C; current 16–17°C is cool. Avoid cold draughts and hot/dry heater/AC air. Keep above ~10°C. *(horticultural consensus, not the two sources above)* |

Matches the nursery label: "moist but not wet", "feed during growing season",
"slow-release or half-strength liquid", "full shade / indoors well-lit".

**Sources:**
- Missouri Botanical Garden Plant Finder — *Adiantum raddianum* (Delta maidenhair):
  https://www.missouribotanicalgarden.org/PlantFinder/PlantFinderDetails.aspx?kempercode=b573
- RHS — *Adiantum raddianum* 'Fragrantissimum':
  https://www.rhs.org.uk/plants/97520/adiantum-raddianum-fragrantissimum/details

## Action plan / rehab (first 4–6 weeks)

- [ ] Trim all dead/crispy fronds at the base with clean scissors.
- [ ] Move to a brighter (still indirect), humid, slightly **warmer** spot; add a pebble
      tray / small humidifier; watch `sensor.plant_monitor_4_humidity` stays >50%.
- [ ] Keep soil evenly moist — never dry, never waterlogged. Bottom-water (stand pot in
      water ~10 min, drain fully) for even wetting.
- [ ] Hold off feeding until new growth appears, then half-strength liquid, monthly, summer.
- [ ] Don't repot until visibly thriving; then up one pot size in peat/coir-rich,
      free-draining mix.

## PM4 thresholds & calibration

Capacitive "%" is only meaningful for this probe/mix. From the live data:

- **Freshly watered (observed):** ~100%.
- **Too-dry floor (observed, plant was damaged there):** ~40%.
- **Set `number.plant_monitor_4_soil_warning` = ~45** so the native dry alarm trips
  *before* the 40% point that crisped it. Healthy target band ≈ **55–90%**; brief 100%
  after watering is fine — only *sustained* saturation is a rot risk (this species likes
  it moist).

Optional confirmation cycle: water → drain 30 min → record % (wet baseline); record the %
when the top 2–3 cm *first* feels barely dry (dry floor); set soil_warning just above that.

## DRAFT dashboard (rebuild to `homeassistant-backup` standards before use)

Entities are confirmed; restyle to the established conventions — this draft does not follow
them yet.

```yaml
type: vertical-stack
title: Maidenhair Fern (PM4)
cards:
  - type: gauge
    name: Soil moisture
    entity: sensor.plant_monitor_4_soil_moisture
    min: 0
    max: 100
    severity:           # aligned to soil_warning=45
      red: 0
      yellow: 45
      green: 55
  - type: glance
    entities:
      - entity: sensor.plant_monitor_4_humidity
        name: Air RH
      - entity: sensor.plant_monitor_4_temperature
        name: Temp
      - entity: binary_sensor.plant_monitor_4_dry
        name: Dry?
      - entity: sensor.plant_monitor_4_battery
        name: Battery
  - type: history-graph
    title: Moisture / RH / temp (7 days)
    hours_to_show: 168
    entities:
      - sensor.plant_monitor_4_soil_moisture
      - sensor.plant_monitor_4_humidity
      - sensor.plant_monitor_4_temperature
```

Dry alert automation — trigger off the device's own dry binary_sensor (set soil_warning
first), pick a real notify target:

```yaml
alias: "Maidenhair Fern - soil dry (water now)"
trigger:
  - platform: state
    entity_id: binary_sensor.plant_monitor_4_dry
    to: "on"
    for: { minutes: 30 }     # de-bounce probe noise
action:
  - service: notify.notify
    data:
      title: "Maidenhair Fern needs water"
      message: >
        PM4 reports dry (soil {{ states('sensor.plant_monitor_4_soil_moisture') }}%). Water now.
mode: single
```
