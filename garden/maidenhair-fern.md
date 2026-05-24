# Maidenhair Fern Care Plan

**Plant:** Maidenhair Fern — *Adiantum fragrans* (Swan Reach Nursery, indoor/patio)
**Location:** Indoors, low light
**Backstory:** Discount-bin runt. Recoverable, not a write-off.
**Soil monitor:** Zigbee sensor labelled **PM4** ("Plant Monitor 4") in Home Assistant.

---

## Current condition (from intake photos)

- Significant **brown, crispy, curled fronds** — classic maidenhair drying-out / low-humidity damage. Maidenhairs crisp permanently from even a single dry-out; the dead fronds will not green up again.
- Healthy **fresh green growth** at the crown and edges — good sign, the plant is alive and pushing new fronds.
- Crown is dense and likely a bit root-bound (typical for a runt).
- Sitting in a plastic nursery pot in a low-light indoor spot.

**Prognosis:** Good, if moisture and humidity become consistent. These ferns bounce back from the rhizome as long as it never fully dries.

---

## The three things that actually matter

Maidenhairs die from exactly three causes, in this order:

1. **Drying out** — even once. Soil must stay *evenly moist, never wet, never dry*.
2. **Low humidity** — dry indoor air crisps the delicate fronds.
3. **Too much / direct sun** — scorches them. They want bright *indirect* light.

Get those right and the rest is easy.

---

## Care routine

### Water
- Keep soil **consistently moist** — think wrung-out sponge, never soggy, never dry.
- Water from the **top until it drains**, or bottom-water by standing the pot in water for ~10 min then draining. Bottom-watering is great for ferns because it wets the whole root ball evenly.
- **Never let it sit in a saucer of water** for hours — moist, not waterlogged.
- Use the PM4 sensor instead of guessing (thresholds below). Tepid water; rainwater/filtered is ideal if your tap is hard.

### Humidity (the usual indoor killer)
- Target **50%+ humidity**. Indoor air is often half that.
- Options, best to worst: small humidifier nearby > grouping with other plants > pebble tray with water under the pot > a bathroom/kitchen spot with natural humidity.
- Misting helps only briefly — don't rely on it alone.

### Light
- **Bright, indirect light.** No direct sun on the fronds.
- "Doesn't get a lot of light" indoors can actually be fine for this species — full-shade tolerant — but *too dark* = leggy, weak growth. A spot near (not in) a window, or a few hours of gentle morning light, is ideal.

### Temperature
- Happy at normal room temps (~18–24°C). Keep it **away from heater vents, AC, and cold draughts** — these dry the air and crisp fronds fast.

### Feeding
- Per the label: feed during the **growing season** (spring–summer) with slow-release or **half-strength liquid** fertiliser, roughly every 2–4 weeks. Skip in winter.
- Weak and often beats strong and rare — ferns burn easily.

### Grooming / rehab
- **Trim off the brown crispy fronds** at the base with clean scissors. They won't recover and removing them pushes energy into new growth.
- If most fronds are dead but the crown is alive, you can cut the whole thing back hard — it will reflush from the base given moisture + humidity.
- Don't repot yet — let it recover first. When it's growing strongly (next spring), pot up one size into a well-draining, peat/coir-rich mix.

---

## Recovery checklist (first 4–6 weeks)

- [ ] Trim all dead/crispy fronds.
- [ ] Move to a brighter (indirect) and more humid spot — bathroom/kitchen or near a humidifier.
- [ ] Set up PM4 moisture alerts in Home Assistant (see below).
- [ ] Keep soil evenly moist — check PM4 daily until you learn its rhythm.
- [ ] Hold off feeding until you see new growth, then start half-strength.
- [ ] Don't repot until it's visibly thriving.

---

## Home Assistant monitoring (PM4)

See `maidenhair-fern.yaml` for ready-to-use automations. They alert you when:

- Soil moisture drops too low (**the** thing that kills maidenhairs).
- Soil stays soggy too long (root rot risk).

**Suggested soil-moisture band for this fern:** keep it in roughly **50–75%** on the PM4 sensor.
- **Below ~40%** → water now (alert).
- **Above ~85%** for a long stretch → too wet, let it breathe.

Tune the numbers once you've watched a few water cycles — every sensor/soil combo reads slightly differently. Calibrate by noting the PM4 reading right after watering (your "wet" baseline) and just before the soil feels dry to a finger-test (your "water now" point).
