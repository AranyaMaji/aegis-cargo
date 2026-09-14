# AEGIS-CARGO (ODIN-OPS): PALANTIR-STYLE GEOPOLITICAL & CRITICAL FREIGHT INTERCEPTOR
**Target:** 1st Place Overall / Best Innovation — n8n University Hackathon Sydney 2026  
**Competitor:** Aranya Maji (UNSW Mechatronics & CS, Solo Operator)

---

## 1. The Brutal Audit: Why Most "AI Logistics" Projects Fail

When hackathon judges see a team claim to build an "AI freight router," they immediately look for three fatal flaws:
1. **The "LLM as a Calculator" Flaw:** Using an LLM to calculate speed, distance, or a thermal decay formula. An LLM is a probabilistic token predictor; using it for arithmetic or threshold checks is an immediate technical penalty.
2. **The "Fake Magic API" Lie:** Using an unauthenticated mock server returning `{"booked": true}`. Real shipping does not have public REST APIs; it runs on EDI, ERPs, and audited contracts.
3. **The 48-Hour GIS Suicide Trap:** Trying to write an A* pathfinding algorithm over spherical ocean coordinates from scratch, leading to coordinate bugs and empty canvases.

---

## 2. The 3 Irreplaceable Roles of AI (The "Minimum AI" Doctrine)

Deterministic code (JavaScript Code Nodes) handles distance, fuel math, speed/ETA calculations, and threshold alerts in **1.5 milliseconds**. 

AI is **strictly and irreplaceably reserved for three high-entropy cognitive operations**:

### A. Semantic Ingestion of Unstructured Geopolitical Telemetry
Maritime crises don't arrive as clean JSON APIs. They arrive as unstructured narrative text:
> *"UKMTO WARNING 014/MAY/2026: At 0340 UTC, MV STAR PROVIDENCE reported a missile impact in the port quarter 55 NM south-west of Al Hudaydah, Yemen. Vessel proceeding under own power. Coalition naval forces responding. Transit with extreme caution."*

- **The AI Task:** The AI Agent extracts structured tactical intelligence:
  ```json
  {
    "threat_type": "KINETIC_MISSILE_USV",
    "chokepoint_affected": "BAB_EL_MANDEB",
    "severity": "CRITICAL_EXCLUSION_ZONE",
    "radius_nm": 65,
    "confidence_score": 0.94
  }
  ```

### B. Multi-Clause War-Risk Contract & IncoTerms Ambiguity Resolution
A reroute is a massive legal liability:
- **JWC Listed Areas (JWLA-032):** Additional Premium (AP) of 0.4% to 1.2% of hull value per 7-day transit ($600,000 on a $60M ship).
- **BIMCO CONWARTIME 2013 Clauses:** Master's legal right of refusal to enter war zones.
- **The AI Task:** The agent reads the cargo manifest + charter party PDF to determine who absorbs the fuel surcharge and whether delayed delivery breaches oncology SLAs.

### C. Multi-Variable Pareto Frontier & Trade-off Synthesis
Generating 3 distinct, legally & physically feasible Courses of Action (COAs) from a pre-filtered list of operational vectors.

---

## 3. How Market & Fuel APIs Act as Autonomous Operational Triggers

In maritime operations and cold-chain integrity, market indicators are not passive metrics—they are hard mathematical constraint thresholds that trigger automated offloads and route terminations.

### A. The Admiralty Cubic Law & The Cape Inversion Formula
Fuel consumption $F$ (in metric tons/day) scales with the cube of vessel speed $v$:
$$\frac{F_2}{F_1} = \left(\frac{v_2}{v_1}\right)^3$$

A standard 15,000 TEU container ship traveling at 19 knots burns ~145 MT of Very Low Sulfur Fuel Oil (VLSFO) per day.
- **Direct Red Sea Transit (Singapore $\to$ Rotterdam):** ~8,400 NM (18.5 days at 19 knots) $\implies$ 2,682 MT VLSFO.
- **Cape of Good Hope Diversion:** ~11,900 NM (26.1 days at 19 knots) $\implies$ 3,784 MT VLSFO (+1,102 MT delta).

At $\$610$/MT, the Cape detour adds **$+\$672,220$** in direct fuel burn. However, a Red Sea transit incurs:
1. **Suez Canal Transit Toll:** $\approx \$480,000$
2. **War-Risk Additional Premium (AWRP):** Under Joint War Committee (JWC) circular JWLA-032, Red Sea AWRP escalates from 0.05% to **0.95% of Hull & Machinery (H&M) value**. For a $\$110\text{M}$ vessel, this is **$+\$1,045,000$** per 7-day transit.

**The Autonomous Cost-Inversion Trigger:**
$$\text{Cost}(\text{Red Sea}) = \text{Toll}_{\text{Suez}} + (\text{HullValue} \times \text{AWRP}_{\text{spot}}) + (F_{\text{direct}} \times P_{\text{VLSFO}})$$
$$\text{Cost}(\text{Cape}) = (F_{\text{direct}} + \Delta F_{\text{Cape}}) \times P_{\text{VLSFO}} + (\text{CharterRate}_{\text{day}} \times \Delta t_{\text{Cape}})$$

When spot Brent/VLSFO spikes past the critical breakeven threshold $P^*$, or when AWRP drops below the danger line, the financial polarity flips:
$$P^*_{\text{VLSFO}} = \frac{\text{Toll}_{\text{Suez}} + (\text{HullValue} \times \text{AWRP}_{\text{spot}}) - (\text{CharterRate} \times \Delta t_{\text{Cape}})}{\Delta F_{\text{Cape}}}$$

**AEGIS Action:** If $P_{\text{VLSFO}} > P^*$, the system disallows maritime diversion around the Cape and automatically activates **COA-1 (Intermodal Rail Land-Bridge)** or **COA-2 (Emergency Port Staging)** to prevent fuel burn bankruptcy.

### B. Cold-Chain Thermal Stability vs. Electricity Spot Cap Outages
High-value pharmaceutical biologics (e.g., mRNA vaccines, monoclonal antibodies) must be maintained at $-20^\circ\text{C}$ or $2^\circ\text{C} - 8^\circ\text{C}$ under strict **Mean Kinetic Temperature (MKT)** thresholds:
$$T_k = \frac{\frac{\Delta H}{R}}{-\ln\left(\frac{\sum e^{-\frac{\Delta H}{R \cdot T_i}}}{n}\right)}$$
- **Terminal Electricity Spot Spikes:** During heatwaves or grid distress, terminal electricity spot prices (e.g., EPEX / AEMO spot) can spike from $\$50/\text{MWh}$ to $>\$350/\text{MWh}$, triggering terminal dynamic peak-shaving surcharges or utility curtailment protocols.
- **Shipboard Generator Fuel Spikes:** Marine Gas Oil (MGO) powering onboard reefer containers spikes.
- **The Autonomous Storage Halt Trigger:** If cumulative projected MKT degradation or energy operating cost exceeds the cold-chain insurance indemnity threshold, AEGIS triggers an emergency cold-storage discharge at the nearest GDP-compliant hub before thermal degradation occurs.

---

## 4. The 5-COA Operational Spectrum (Beyond Simple Sea Diversion or Air Freight)

AEGIS-CARGO synthesizes solutions across the entire multimodal logistics hierarchy:

| COA Identifier | Operational Vector | Physical Mechanism & Infrastructure | Operational Protocols / Data Checked |
| :--- | :--- | :--- | :--- |
| **COA-1: Intermodal Rail Land-Bridge** | **Overland Rail Bypass** | Disembark at Port of Jebel Ali (UAE) $\to$ Rail corridor via Saudi Arabia (SAR) $\to$ Port of Haifa (Israel) $\to$ Short-sea European feeder. | Checks: Clip-on generator wagon power availability; clearance gauge dimensions; EDIFACT `IFTMIN` (booking) and `CODECO` (gate-in). Transit time: 4 days vs 14 days sea. |
| **COA-2: GDP Cold-Storage Staging & Cryo Refill** | **Controlled Port Offload** | Emergency discharge at nearest transshipment hub (e.g., Port of Salalah or Jebel Ali) into certified cold vault. | Checks: CEIV Pharma / WHO-GDP certified warehouse capacity; UN1845 dry-ice ($-\text{78.5}^\circ\text{C}$) sublimation replenishment; real-time MKT stability window. |
| **COA-3: Ocean Alliance Slot Swap & Feeder Relay** | **Vessel-to-Vessel Transshipment** | Transfer container slots at intermediate hub to an Ocean Alliance / 2M partner vessel that already possesses naval clearance or higher speed rating. | Checks: EDIFACT `BAPLIE v3.1` (stowage plan); hazardous materials segregation rules (IMDG Code 7.2); reefer plug availability on recipient vessel. |
| **COA-4: Naval Escort Convoy Synchronization** | **Tactical Convoy Integration** | Vessel adjusts speed to rendezvous at an IRTC (Internationally Recommended Transit Corridor) Point to join a military warship convoy (Operation Prosperity Guardian / Aspides). | Checks: Mandatory convoy speed compliance (minimum 16.5 knots sustained); UKMTO Mercury communications handshake; weapon stand-off perimeter protocol. |
| **COA-5: Vessel PMS Generator Load Balancing** | **Shipboard Energy Prioritization** | In the event of auxiliary engine or generator failure, the Vessel Power Management System (PMS) selectively sheds non-essential electrical loads. | Checks: Sheds crew hotel loads (HVAC, galleys) $\to$ implements rotational 30-min cycling on frozen food containers $\to$ guarantees 100% uninterruptible continuous power to Tier-1 oncology biologics. |

---

## 5. The Pre-COA Deterministic Pruning & Data Wiring Matrix

An LLM must **never** be handed raw database tables or asked to evaluate impossible routing physics. 

Before invoking the AI Agent, a deterministic **Pre-COA Pruning Pipeline (JavaScript Code Node)** executes in **1.8ms**, eliminating physically and legally invalid options based on 4 immutable filters:

```
[Raw Ingestion: Threat + Vessel Telemetry + Cargo Manifest]
                            │
                            ▼
     ┌──────────────────────────────────────────────────────────┐
     │      DETERMINISTIC PRE-COA PRUNING MATRIX (1.8ms)         │
     ├──────────────────────────────────────────────────────────┤
     │ 1. Draft & Berth Filter:                                 │
     │    Vessel Draft (15.8m) > Port Depth?                    │
     │    --> Prune shallow emergency ports (e.g., Djibouti).   │
     │                                                          │
     │ 2. IMDG & Cargo Integrity Filter:                        │
     │    Cargo = UN2814/Biological + MKT SLA = 72h?            │
     │    --> Prune Cape diversion (+12 days = guaranteed ruin).│
     │                                                          │
     │ 3. Hazardous & Customs Jurisdiction Filter:              │
     │    Host nation has trade sanctions / cabotage bans?       │
     │    --> Prune non-compliant rail/land bridges.            │
     │                                                          │
     │ 4. Electrical Reefer Capacity Filter:                    │
     │    Candidate port has zero CEIV Pharma reefer plugs?     │
     │    --> Prune from cold-staging candidates.               │
     └──────────────────────────────────────────────────────────┘
                            │
                            ▼ (Output: Exactly 3 Viable Candidates)
     ┌──────────────────────────────────────────────────────────┐
     │              AI AGENT CHIEF OF STAFF NODE                │
     │  Synthesizes trade-offs, drafts war-risk charter memo,   │
     │  and formats executive Slack Card with 1-click approvals. │
     └──────────────────────────────────────────────────────────┘
```

---

## 6. The Path Mapping Solution: Canonical Choke-Point Graph (1.5ms Execution)

Do NOT build a continuous A* spatial router. Ships follow **Sea Lines of Communication (SLOCs)**.

AEGIS-CARGO uses a **Topological Sea Corridor Graph** with 28 canonical deep-water waypoints (Singapore $\to$ Malacca $\to$ Bab-el-Mandeb $\to$ Suez $\to$ Gibraltar $\to$ Rotterdam vs. Cape of Good Hope).

* **How Rerouting Works in 1.5ms:**
  When the threat sentinel flags `chokepoint_affected: "BAB_EL_MANDEB"`, a simple JavaScript Code Node invalidates all edges passing through the Red Sea:
  ```javascript
  const divertedRoute = calculateOptimalSeaRoute("SINGAPORE", "ROTTERDAM", ["RED_SEA", "BAB_EL_MANDEB"]);
  // Returns: Cape of Good Hope polyline waypoints in 1.8 milliseconds!
  ```
* **The Visual HUD on the Frontend:**
  - Active corridor glows in cyan vector lines on a dark-mode Mapbox/Leaflet canvas.
  - Bab-el-Mandeb pulses neon red with a 65 NM missile exclusion radius.
  - Primary route turns dashed amber; the Cape of Good Hope divert animates in bright green.

---

## 7. The Real-World State Mutation (Zero Fake Mock APIs)

Instead of faking a fictional Maersk API, AEGIS-CARGO executes the **exact production actions used in enterprise logistics**:

```
[ Human Clicks 'Authorize Cape Reroute' in Slack ]
                        │
                        ▼ (n8n Resumable Wait Node Wakes Up)
                        ├──► 1. Supabase Digital Twin: Row updates to 'REROUTED', new GeoJSON polyline stored.
                        ├──► 2. Formal Operational Dispatch: Dispatches an official IATA/FIATA Reroute PDF via SendGrid/Gmail to live inbox.
                        ├──► 3. Mobile Actuation: Twilio SMS buzzes the presenter's phone on the desk with the Gate Pass PIN.
                        └──► 4. Financial Hold: Creates a draft Invoice in Stripe for the fuel/charter delta.
```

Hearing the phone buzz live on the table kills 100% of "this is just a mockup" judge skepticism.

---

## 8. Complete n8n Node-to-Node Blueprint

```
[Crisis Webhook Ingest] (POST /webhook/crisis-intel)
         │
         ▼
[Deterministic SHA-256 Gate] (Code Node: Drops duplicate bulletins in 2ms)
         │
         ▼
[AI Intelligence Parser] (Gemini 1.5 Flash: Unstructured text -> Structured Threat JSON)
         │
         ▼
[Supabase: Correlate Vessels] (Queries active vessels intersecting threat radius)
         │
         ▼
[Dijkstra Sea-Router (1.5ms)] (Code Node: Recomputes Cape divert vs Air-bridge waypoints & financial delta)
         │
         ▼
[Post Slack War Room Card] (Slack Block Kit: Formatted impact matrix + 1-click buttons)
         │
         ▼
[Wait for Operator Approval (HITL)] (n8n Wait Node: Pauses execution on Webhook Resume Token)
         │ (Operator Clicks Button)
         ▼
[Supabase: Mutate Digital Twin] (SQL Update: Sets status = 'REROUTED', updates active GeoJSON)
         │
         ▼
[Carrier Bridge Telemetry Webhook] (Issues dispatch packet to vessel ECDIS / mobile alert)
```

---

## 9. The 3-Minute Live Pitch Staging (Zero-Fail Script)

* **0:00 – 0:45 (The Threat):**
  Split-screen: Left = Dark Tactical Map; Right = Live n8n Canvas.
  *"MV Ocean Vanguard is carrying $18.4M of critical biologics through the Red Sea. A drone attack hits 50 NM ahead. Traditional shipping notices take 18 hours to propagate through email chains."*
* **0:45 – 1:30 (The Live Trigger & Hybrid Execution):**
  Click "Inject Geopolitical Event".
  n8n lights up green in real-time. The SHA-256 filter drops noise in 2ms. The AI Agent extracts the missile coordinates, runs the Dijkstra sea-router, evaluates war-risk insurance, and formats the response.
* **1:30 – 2:15 (The Slack HITL Intercept):**
  Open Slack on split-screen. The card pops up live:
  *Suez toll saved ($480k) vs Extra fuel ($248k) vs Avoided War-Risk ($520k) = Net +$752,000 savings.*
  You look at the judges and click **`[🔴 Authorize Cape Reroute]`**.
* **2:15 – 2:45 (The Triple Live Mutation):**
  The n8n Wait Node resumes.
  1. Supabase table flips to `REROUTED`.
  2. The dark-mode map animates the glowing green diversion around the Cape of Good Hope.
  3. Your phone buzzes on the desk with the Twilio dispatch SMS.
* **2:45 – 3:15 (The Technical Defense):**
  Zoom out to the full n8n canvas. Highlight the modular sub-workflows, 1.5ms deterministic code nodes, and red error fallback branches.
  *"Latency: 3.2 seconds. API cost: $0.003. Capital protected: $18.4M. That is Palantir operations built on n8n."*
