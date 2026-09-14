# AEGIS-CARGO (ODIN-OPS) — Hackathon Presentation Specification
> **Target Tool:** Claude Design Web (for slide deck generation)  
> **Target Event:** n8n University Hackathon Sydney 2026 (USYD / SUAIA / StartUp Link)  
> **Pitch Format:** 3-Minute Hard Stop Demo + 2-Minute Q&A  
> **Visual Style:** Palantir Gotham / Swiss Minimalist Command Deck. High-contrast, clean typography, dark-mode tactical base (`#0B0E14`) with stark white text (`#F0F6FC`) and tactical signal accents (Emerald `#2EA043`, Amber `#F0883E`, Blue `#58A6FF`, Crimson `#F85149`).

---

## 1. Visual Design & Theme Guidelines (For Claude Design)
- **Palette:**
  - Background: `#0B0E14` (Deep Tactical Black/Slate)
  - Surface/Cards: `#151B23` (Dark Navy Card Background) with border `#30363D`
  - Text Primary: `#F0F6FC` (Crisp Off-White, high legibility)
  - Text Muted: `#8B949E` (Neutral Gray)
  - Accent Emerald: `#2EA043` (Nominal / Preserved Value / Safe)
  - Accent Amber: `#F0883E` (Pending / Excursion / Attention)
  - Accent Blue: `#58A6FF` (AI Reasoning / Correlation Trace)
  - Accent Crimson: `#F85149` (Hazard / Total Loss / Dead-end Trap)
- **Typography:**
  - Headers: Clean modern Sans (Inter, Space Grotesk, or SF Pro Display), bold, tight tracking.
  - Data / Figures / Trace IDs: Monospace (JetBrains Mono, Roboto Mono).
- **Layout Philosophy:** High information density without clutter. Big bold numbers, structured comparison cards, and clear visual hierarchy. No decorative fluff.

---

## 2. Stage Staging & Alt-Tab Context-Switch Runbook
- **Pre-Pitch Screen Snapping:**
  - **Window 1 (Maximized):** This Presentation Deck (Slide 1 open).
  - **Window 2 (Pre-snapped 50/50 Split):** Left 50% = 3D Tactical Console (`globe/`); Right 50% = Live 66-node n8n workflow canvas (`ti3DOhDc2QEZCWRX`).
  - **Lectern Prop:** Physical Arduino Uno R3 with LM35 probe plugged into USB; smartphone with ringer ON placed flat on table.
- **Timing & Hotkey Flow:**
  - **0:00 – 0:45 (45s):** Slides 1 & 2 on PPT Deck.
  - **0:45 (2s):** Clean `Alt + Tab` directly into pre-snapped split-screen.
  - **0:47 – 2:00 (73s):** Live Cyber-Physical Demo (IoT pinch $\to$ n8n green wave $\to$ Slack card click $\to$ WhatsApp loud ding $\to$ Audit Drawer slide-up).
  - **2:00 (2s):** Clean `Alt + Tab` back to PPT Deck.
  - **2:02 – 3:00 (58s):** Slides 3, 4 [Verified Benchmarks], 5, and 6 (Q&A Anchor).

---

## 3. Slide-by-Slide Detailed Specifications

### SLIDE 1: THE $35B PROBLEM & THE INSURANCE TRAP
- **Header Badge:** `PROBLEM & MARKET FAILURE // LIFE SCIENCES LOGISTICS`
- **Slide Title:** **$35 Billion Lost Annually in Biopharma Transit**
- **Subtitle:** When cold-chains fail at sea, conventional insurance write-offs destroy enterprise value.
- **Layout: 3-Column Metric Card Grid**
  - **Card 1 (The Failure Rate):**
    - Stat: `7% – 12%`
    - Subtext: of all global pharmaceutical shipments experience unapproved temperature excursions.
    - Tag: `WHO / IQVIA DATA`
  - **Card 2 (The Insurance Trap — Constructive Total Loss):**
    - Stat: `0% SALVAGE`
    - Subtext: Under **FDA 21 CFR §211** & **EU GDP (2013/C 343/01)**, compromised biologics cannot be auctioned at salvage. Destroy + Claim is legally mandated biohazard disposal.
    - Tag: `STRICT REGULATORY BAN`
  - **Card 3 (The Real Enterprise Cost):**
    - Stat: `6–9 MONTHS`
    - Subtext: Lead time to re-manufacture destroyed oncology batches. Results in clinical trial collapse, hospital stock-outs, and permanent market share loss uninsurable by policies.
    - Tag: `UNINSURABLE IMPACT`
- **Bottom Callout Banner:**
  - *"Cargo owners need autonomous, real-time freight interception before kinetic thermal stability is breached."*
- **Speaker Script (25s):**
  > *"Judges, biopharmaceutical logistics faces a catastrophic $35 billion annual failure rate. When an oncology shipment loses power in the Red Sea, standard operating procedure is destructive: dump the $9.5 million batch, file an insurance claim, and wait six months to re-manufacture while patients go without medicine. Insurance doesn't save lives, and FDA regulations strictly forbid selling compromised medicine at salvage. Cargo owners need autonomous interception before thermal stability collapses."*

---

## 4. Claude Design Web Implementation Instructions
When pasting into Claude Design Web:
1. Render as a **6-slide presentation deck** (Slide 1 Problem, Slide 2 Architecture, Slide 3 Economics, Slide 4 Verified Benchmarks, Slide 5 Compliance, Slide 6 Q&A Reference).
2. Use **clean, modern card components** with dark tactical styling, rounded borders (`border-radius: 8px`), and high-contrast color badges.
3. Highlight the verified benchmark numbers prominently on Slide 4 (`$58.2M Monitored`, `$23.56M Rescued`, `100.0% Success Rate`, `18ms Latency`).
4. Keep layout **responsive and centered** with large, easily readable typography suitable for stage projection.
