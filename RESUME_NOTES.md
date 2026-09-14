# Resume-worthy fixes & Milestones — AEGIS-CARGO

## 2026-09-13 — 🏆 1st Place Overall Champion (Solo Entrant) — n8n University Hackathon Sydney 2026
- **Accomplishment:** Won **1st Place Overall** as a solo developer competing against multi-person university/industry engineering teams at the USYD / SUAIA / StartUp Link n8n Hackathon.
- **Architectural Scope (Solo End-to-End Delivery in <48 Hours):**
  - **Embedded IoT Hardware:** Coded Arduino Uno C++ firmware with analog LM35 thermistor filtering and a Python serial bridge daemon with hysteresis/debounce.
  - **Autonomous Cloud Orchestration:** Architected a 66-node n8n DAG running kinetic admiralty fuel physics ($F \propto v^3$), Arrhenius mean kinetic temperature (MKT) degradation modeling, and Dijkstra shortest-path waypoint optimization across 28 maritime SLOC nodes.
  - **Dual-Agent LLM Architecture:** Designed dual Gemini 1.5 Flash agents with deterministic fallbacks — Ingress agent for zero-shot spatial extraction of unstructured geopolitical news, and Egress agent synthesizing EU GDP compliant emergency directives and QA Qualified Person briefs.
  - **Human-in-the-Loop & Enterprise Compliance:** Integrated Slack interactive Block Kit war room approval cards, Twilio WhatsApp cellular dispatch, and real-time 21 CFR Part 11 electronic audit logging with millisecond-accurate milestone tracking.
  - **Tactical Geospatial Command Center:** Built a bespoke React + Three.js white-light nautical tactical console with custom-normalized GLB maritime/aviation assets, Supabase Realtime websocket state synchronization, and live audit telemetry drawer.
- **Impact & Result:** Zero demo crashes, 100% stage reliability across live hardware sensor trips, and awarded 1st Place Overall.

## 2026-09-11 — Injection drives the digital twin, workflow reads the twin
- **What was wrong:** the first design let the workflow read live crisis dynamics (temperature, rise
  rate) from a static database row seeded as healthy, so an injected "power loss" produced no reaction —
  the proof run was a $0 anticlimax. The row and the trigger disagreed and the workflow believed the row.
- **The fix (your call):** the injector (globe page, a separate server) writes the crisis into the
  cargo/vessel rows *and* pings the webhook; the workflow then reads the updated rows. One write path,
  one truth, and the button genuinely changes system state before the engine reacts.
- **Impact:** removes the dual-source ambiguity, makes every injected scenario produce a real,
  data-backed decision, and matches the locked injection-first demo model end to end.

## 2026-09-11 — Engine must be object-general, not route-specific (weight-scaled rate card)
- **What was wrong:** the Batch 2 optimizer priced onward transport with flat constants (air = $220k,
  overland = distance only) — correct only for the one seeded 4.2t container. An arbitrary cargo of any
  weight would have been mispriced.
- **The fix (your call):** you flagged that the system must handle any object (arbitrary weight, value,
  origin, destination). Split costs into a **rate card** (price per kg, per km, per tonne-km — constants)
  times **data-driven quantities** (cargo weight, haversine distance). Added `gross_weight_kg` to the
  cargo schema so air/overland/storage/handling all scale with the actual object.
- **Impact:** the decision engine now prices any consignment on any itinerary correctly, not just the
  demo row — the difference between a hardcoded demo and a real product.

## 2026-09-12 — Rejected the dark-neon dashboard for a white-light instrument interface
- **What was wrong:** the research digest for the operator console specified the default
  cyber-C2 look — near-black ground, neon cyan, alert-red glow, Kaspersky-cybermap styling. It is
  the house style of every AI-generated dashboard, it reads as generic, and saturated glow on a
  projector at pitch distance loses most of its detail.
- **The fix (your call):** you overrode the digest and specified a white, light, tactical, minimal
  interface — explicitly "should not look like edgy AI slop". Built as a nautical-chart instrument:
  warm off-white ground, flat beige land, greyscale ship and aircraft, and colour rationed to three
  accents each carrying exactly one meaning, so the single red container is the only saturated
  object on screen.
- **Impact:** the decision-critical object is unmissable without a single glow effect, the interface
  survives projector contrast, and it reads as a built instrument rather than a generated theme.

## 2026-09-12 — Design gate before implementation
- **What was wrong:** the default path was to start writing the console's application code and
  settle the visual language while building it — which bakes in whatever the first render happened
  to look like and makes later correction expensive.
- **The fix (your call):** you required the artboards to be designed, published and approved by you
  before any application code was written.
- **Impact:** the visual system was fixed and reviewed up front, so the build had a spec to hit
  rather than a look to discover; the console matched the approved artboard on its first render.

## 2026-09-12 — Commissioned an adversarial review of the console and acted on it
- **What was wrong:** the operator console had been built and was rendering live data, and the
  natural next step was to keep building features. Nothing had systematically asked what was
  unproven or missing — the gaps were the kind that only surface on stage, when there is no
  recovering from them.
- **The fix (your call):** you ran an independent model over the build as a red team, then
  directed which of its findings to implement rather than accepting the list wholesale.
  Two shipped: a guarded one-click demo-state reset, replacing hand-run SQL between pitch runs,
  and route arcs derived from the decision's actual discharge port instead of a hardcoded
  destination — which had left an entire trigger lever drawing no route at all.
- **Impact:** recovery between demo runs went from manual database surgery to one confirmed
  click, and every trigger lever now renders its diversion route rather than only the one the
  original coordinates happened to match. Chasing the second finding also exposed a live bug
  that blanked the decision panel the instant an operator approved — the single most watched
  moment of the pitch.

## 2026-09-12 — Spotted a silently ignored transform that had frozen every 3D asset at one size

- **What was wrong:** the freight vessel rendered half-buried in the globe surface and far too
  small to read at map zoom. The size constant meant to control it had been dead since the
  switch to real 3D assets — the code set a scale on a group whose matrix was then overwritten
  wholesale by the orientation pass, silently discarding it. Nothing errored, so the constant
  looked tuned when it was inert.
- **The fix (your call):** you called out the sinking hull and the undersized model from the
  render alone, which forced the transform pipeline to be traced end to end rather than the
  constant nudged again. Scale is now applied where the orientation pass cannot clobber it, and
  the model is lifted by half its own height so its hull sits on the water rather than in it.
- **Impact:** the vessel is the focal point of a three-minute live demo and now reads as a dark
  ship on a light sea from across a room, at 1.8× its previous size. The same dead-transform bug
  would have hit the air-freight asset the moment that branch fired on stage.

## 2026-09-12 — Cut an operator console down to one control per scenario, exposing a wrong-answer bug

- **What was wrong:** the crisis console asked the operator four questions per scenario — a
  three-way severity picker plus radius, duration and rate sliders — none of which a demo
  audience can read in three minutes, and any of which could silently turn the scenario into a
  no-op. The decision panel and the approval message that goes to a human were written in
  internal identifiers and raw nine-figure dollar amounts.
- **The fix (your call):** you judged all three surfaces unusable by an ordinary reader and
  directed that they be simplified to one choice per scenario and rewritten for humans rather
  than machines. Severity became a fixed value, the tuned parameters moved out of reach, and
  every screen and message now names the action in ordinary words with the saving stated once.
- **Impact:** the console went from twelve operator inputs to four, one per scenario, with the
  values that make the demo work no longer breakable by a stranger. Rewriting the decision panel
  also surfaced a live bug that had been naming the WRONG recommended option on screen — it
  displayed a $1.2M plan while the approval message for the same decision recommended the $9.5M
  one, a contradiction a judge could have read off the two screens side by side.
