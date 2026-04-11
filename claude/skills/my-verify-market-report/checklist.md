# Market Report Verification Checklist

## Layer 1: Runbook Required Checks

### Policy & Tone

| ID | Check | How to verify |
|----|-------|---------------|
| P1 | No negotiation/offer tactics | Search for: "what to offer", "how to win", "concessions", "escalation", "inspection leverage", "counter", "lowball", "negotiate", "bidding strategy". Any match = FAIL. |
| P2 | No prescriptive language | Search for: "you should", "you must", "do X", "make sure you", "we recommend", "consider doing", imperative verbs directed at the reader ("ask your agent to", "request that", "insist on"). Descriptive/informational phrasing = OK. Any prescriptive match = FAIL. |
| P3 | No potential fair housing violations | Search for language describing neighborhood demographics: race, ethnicity, religion, national origin, familial status, disability, sex, "type of people", characterizations of residents. Objective data from official sources (school ratings, crime stats from police/FBI) = OK. Any demographic characterization = FAIL. |

### Sources

| ID | Check | How to verify |
|----|-------|---------------|
| S1 | No competitor portals cited or mentioned | Search for: Redfin, Realtor.com, Homes.com, Movoto, Opendoor, Offerpad. Any mention — even as "supplemental" or in a URL — = FAIL. |
| S2 | Numeric stats have allowed-source citations | Every non-obvious numeric market/stat claim must cite an allowed source. Allowed: Zillow (internal tools, research pages, HDP), government/public records (county assessor, city GIS, state agencies), FEMA, NOAA, USGS, EPA, school districts, GreatSchools, transit agencies, police/FBI dashboards. Uncited numeric claims = FAIL. |

### Comps

| ID | Check | How to verify |
|----|-------|---------------|
| C1 | Includes active (non-pending) + sold (recent) comps | Report must have two distinct comp groups: "Active Listings" and "Recent Sales". Missing either = FAIL. |
| C2 | Same property type as subject | Comps must match the subject's property type (SFR/condo/townhome). If subject is SFR and comps include condos without explicit justification = FAIL. |
| C3 | Each comp has a Zillow HDP link | Every comp row must include a zillow.com/homedetails/ URL. Any comp without one = FAIL. Count comps vs HDP links — mismatch = FAIL. |

### Visuals

| ID | Check | How to verify |
|----|-------|---------------|
| V1 | No dual-axis charts; one metric per chart | Any chart description with two Y-axes or mixed units on one chart = FAIL. If no charts present, PASS. If charts are described in markdown but rendering is unclear = WARN. |
| V2 | Charts include units + time window + sample size | Each chart/visualization must state: Y-axis unit (e.g. $, $/sqft, # of homes), time window (e.g. "last 6 months"), and sample size (n=X). Missing any element = FAIL. If chart presence cannot be confirmed from markdown = WARN. |

## Layer 2: Prompt Structural Checks

### Section Order & Presence

| ID | Check | How to verify |
|----|-------|---------------|
| ST1 | All required sections present | Must contain all of: Section 1 (Local Market Conditions & Recent Trends), Section 2 (Neighborhood Snapshot), Section 3 (What to Know About the Home), Section 4 (Comparable Homes), Section 5 (Assigned Public Schools), and a closing checklist (Tour-Day or Open House-Day). Missing any = FAIL. |
| ST2 | Sections appear in correct order | Sections must appear in order: 1 -> 2 -> 3 -> 4 -> 5 -> Checklist. Out-of-order = FAIL. |

### Executive Summary Format

| ID | Check | How to verify |
|----|-------|---------------|
| ES1 | Executive summary uses bullet points | If an Executive Summary section exists, it must be bullet points only. Prose paragraphs = FAIL. No executive summary present = PASS (it's optional). |
| ES2 | 4-6 bullets max | Count bullets in executive summary. Fewer than 4 or more than 6 = FAIL. |
| ES3 | No charts/tables in executive summary | Any table or chart markup inside the executive summary = FAIL. |
| ES4 | No prescriptive language in executive summary | Same as P2 but scoped to executive summary. Redundant with P2 but ensures this high-visibility section is clean. |

### Comp Table Format

| ID | Check | How to verify |
|----|-------|---------------|
| CT1 | Two separate tables: Active Listings + Recent Sales | Comps must be split into two distinct tables, not combined. Single table = FAIL. |
| CT2 | Narrow 2-column table format | Tables should have exactly 2 columns: Comp (with HDP link) and Details. Wide multi-column tables = FAIL. |
| CT3 | One comp per row | Each comparable must occupy exactly one row. Multiple comps in a single row = FAIL. |
| CT4 | Details cell follows format spec | Details cell should contain (in order): Status, Price, Beds/Baths, Sqft, Distance, Key difference. Missing fields or wrong order = WARN. |

### Section Length Caps

| ID | Check | How to verify |
|----|-------|---------------|
| SL1 | Overall report ~3 pages max | Estimate at ~500 words/page. Total word count > 1800 = WARN ("likely exceeds 3 pages"). > 2200 = FAIL. Cannot be precisely verified without rendering = WARN if borderline. |
| SL2 | Section 3 (Home) max ~1/3 page | Word count for Section 3 > 200 words = WARN. Must be bullets only — any prose paragraphs = FAIL. |
| SL3 | Section 5 (Schools) max ~1/3 page | Word count for Section 5 > 200 words = WARN. |
| SL4 | Checklist max 4 items | Count checklist items. More than 4 = FAIL. |
| SL5 | No trailing section summaries | No section should end with a paragraph labeled or functioning as "Summary", "Key takeaways", or similar. Any match = FAIL. |

## Layer 3: OH vs Tour Comparison Checks

### Mechanical Differences (from "Changes from Tour Prompt & Context" table)

| ID | Check | How to verify |
|----|-------|---------------|
| M1 | Title says "Open House Market Report" not "Tour Neighborhood & Market Report" | Check the OH report title. Contains "Tour" = FAIL. Does not contain "Open House" = FAIL. |
| M2 | Checklist says "Open House-Day" not "Tour-Day" | Check the closing checklist heading in the OH report. Contains "Tour-Day" = FAIL. Does not contain "Open House" = FAIL. |
| M3 | Context framing: "attending an open house" not "requested a tour with agent" | Search OH report for: "tour with", "your agent", "scheduled a tour", "tour request". Any match suggesting agent-assisted tour framing = FAIL. |
| M4 | No agent relationship assumed | Search OH report for references to an agent relationship: "your agent", "Alan", "ask your agent", "agent will", "work with your agent". Any match = FAIL. |

### Semantic Diff (context-sensitive sections only)

Compare the OH report against the Tour report in these sections. Data-heavy sections (Section 1 market stats, Section 4 comps, Section 5 schools) are expected to be similar and should NOT be flagged.

| ID | Check | Sections to compare | How to verify |
|----|-------|-------------------|---------------|
| SD1 | Executive Summary is meaningfully different | Executive Summary | Compare text similarity. If >85% similar (accounting for identical data references), the OH report likely didn't adapt framing. WARN with quoted passages. |
| SD2 | Neighborhood framing adapted for open house context | Section 2 opening paragraph + any framing text | Tour reports may reference "before your tour" or "when you visit with your agent". OH should frame for self-guided attendance. High similarity in framing = WARN. |
| SD3 | Home details framing adapted | Section 3 opening/framing | Similar check — tour framing vs open house framing. |
| SD4 | Checklist items adapted for open house | Closing checklist | Tour checklist may reference agent coordination. OH checklist should be self-guided. If items are identical = WARN. |
| SD5 | Opening paragraphs adapted across sections | All section opening paragraphs (1-2 sentence intros) | These set the tone per section. If openings are verbatim identical between Tour and OH = WARN. |
