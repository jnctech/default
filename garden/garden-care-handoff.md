# Handoff: Maidenhair fern care + PM4 dashboard

**Intended home:** `jnctech/garden-care` (repo not yet created).
**Why this is a handoff, not a finished job — two blockers in the session that produced it:**

1. **GitHub access was scoped to `jnctech/default` only.** The `homeassistant-backup`
   repo (which holds the established dashboard standards) and the target
   `jnctech/garden-care` repo could not be read or written. The dashboard below is a
   **DRAFT** that MUST be reconciled against the real conventions in
   `homeassistant-backup` before use.
2. **No Home Assistant MCP server was connected.** PM4's real entity IDs and live
   readings could not be retrieved, so all moisture *numbers* here are uncalibrated
   placeholders. See "PM4 calibration" — they must be set from real data.

## To continue, the next session needs

- [ ] HA MCP server connected (or PM4 entity IDs + a few readings pasted).
- [ ] Read access to `homeassistant-backup` to copy the dashboard standard.
- [ ] Confirmation of the actual PM4 entity IDs (soil moisture, soil temp, battery,
      and any light/conductivity channels the Zigbee device exposes).

---

## Plant profile

- **Species:** Maidenhair fern, *Adiantum fragrans* (Swan Reach Nursery; tender
  Delta-maidenhair group, related to *A. raddianum*). Indoor/patio, full-shade.
- **Location:** Indoors, low light.
- **History:** Discount-bin runt. Alive and pushing new fronds; recoverable.
- **Sensor:** Zigbee soil monitor labelled **PM4** / "Plant Monitor 4" in Home Assistant.

## Diagnosis (from intake photos, 2026-05-24)

- Extensive **brown, crispy, curled fronds** — consistent with drying-out / low-humidity
  damage. These will not re-green; trim them. (See sourced fact: fronds die back quickly
  once soil is allowed to dry out.)
- Healthy **new green growth at the crown** — good prognosis if moisture + humidity
  become consistent.
- Crown dense, likely slightly root-bound (normal for a runt). Plastic nursery pot.

## Audited care facts (sourced)

Verified against Missouri Botanical Garden (Plant Finder) and RHS for *Adiantum*:

| Factor | Guidance |
|---|---|
| **Light** | Bright, *indirect* light; **leaves scorch in direct sun.** |
| **Water** | Water freely; **"fronds will die back quickly if soils are allowed to dry out."** Water sparingly in winter. |
| **Humidity** | Provide **high humidity** — stand the pot on a tray of moist gravel/pebbles. |
| **Feeding** | **Half-strength** general liquid feed, **monthly, mid-spring to late summer.** |
| **Temperature** | Frost-tender (Delta-maidenhair group). Keep indoors, ~18–24°C; avoid cold draughts and the hot, dry air of heater/AC vents. Keep above ~10°C. *(horticultural consensus, not from the two sources above)* |

This matches the nursery label: "moist but not wet", "feed during growing season",
"slow-release or half-strength liquid", "full shade / indoors well-lit".

**Sources:**
- Missouri Botanical Garden Plant Finder — *Adiantum raddianum* (Delta maidenhair):
  https://www.missouribotanicalgarden.org/PlantFinder/PlantFinderDetails.aspx?kempercode=b573
- RHS — *Adiantum raddianum* 'Fragrantissimum':
  https://www.rhs.org.uk/plants/97520/adiantum-raddianum-fragrantissimum/details

## Action plan / rehab (first 4–6 weeks)

- [ ] Trim all dead/crispy fronds at the base with clean scissors (energy → new growth).
- [ ] Move to a brighter (still indirect) and more humid spot — bathroom/kitchen, or add
      a pebble tray / small humidifier nearby.
- [ ] Keep soil evenly moist at all times — never dry, never waterlogged. Bottom-watering
      (stand pot in water ~10 min, then drain fully) wets the root ball evenly.
- [ ] Hold off feeding until new growth appears, then half-strength liquid, monthly,
      through summer.
- [ ] Do **not** repot until visibly thriving; then up one pot size in a peat/coir-rich,
      free-draining mix.

## PM4 calibration (do this before trusting any threshold)

Capacitive soil sensors are not comparable across devices; a "%" only means something
relative to *this* sensor in *this* mix. Establish the band from real data:

1. Water thoroughly, let it drain ~30 min, record PM4 % → this is the **"freshly watered"**
   top of the band.
2. Over the following days, finger-test the top 2–3 cm daily and record the PM4 % at the
   point the soil first feels *barely* dry to the touch → this is the **"water now"** floor.
   (For maidenhair, act *before* it gets properly dry — they don't forgive a full dry-out.)
3. Target band = floor → freshly-watered. Set the low alert slightly above the floor.

Until calibrated, treat the auditable rule as primary: **keep evenly moist, never dry,
never waterlogged.** Numbers are convenience, not gospel.

## DRAFT dashboard (reconcile with `homeassistant-backup` standards before use)

Placeholder Lovelace card. **Replace entity IDs with the real PM4 IDs**, and re-style to
match the established dashboard conventions in `homeassistant-backup` (naming, card types,
theme, sections) — this draft does not yet follow them because that repo was unreadable.

```yaml
# DRAFT — verify entity_ids in Developer Tools > States ("plant_monitor_4" / "PM4")
type: vertical-stack
title: Maidenhair Fern (PM4)
cards:
  - type: gauge
    name: Soil moisture
    entity: sensor.plant_monitor_4_soil_moisture   # TODO confirm
    min: 0
    max: 100
    # severity bands below are PLACEHOLDERS — set from PM4 calibration
    severity:
      red: 0      # too dry — water now
      yellow: 40  # getting dry
      green: 55   # in band
  - type: entities
    title: PM4 detail
    entities:
      - entity: sensor.plant_monitor_4_soil_moisture   # TODO confirm
      - entity: sensor.plant_monitor_4_soil_temperature # TODO confirm / may not exist
      - entity: sensor.plant_monitor_4_battery          # TODO confirm
  - type: history-graph
    title: Moisture (7 days)
    hours_to_show: 168
    entities:
      - entity: sensor.plant_monitor_4_soil_moisture   # TODO confirm
```

A low-moisture **alert automation** was also drafted but pulled from this note: it
depends on the verified entity ID and a target notify service, and belongs alongside the
dashboard once PM4 is readable. Recreate it then.
