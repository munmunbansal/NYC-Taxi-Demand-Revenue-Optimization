# NYC Taxi Demand & Revenue Optimization 🚖

An end-to-end data analytics project processing **3.47M+ Yellow Taxi trips** (January 2025) to uncover operational demand patterns, fare dynamics, and fleet allocation strategies across New York City.

---

## 📌 Executive Summary & Key Metrics
* **Total Trips Analyzed:** 3.48 Million
* **Gross Transaction Value:** $88.14 Million
* **Average Trip Fare:** $25.36
* **Average Trip Distance:** 5.86 Miles
* **Dominant Payment Method:** Credit Card (77.87% / $68.64M)

---

## 📊 Dashboard Previews

### 1. Executive Demand & Revenue Overview
![Executive Dashboard](Screenshots/dashboard_overview.png)

### 2. Route & Zone Performance
![Route Analysis](Screenshots/route_analysis.png)

### 3. Hourly Demand & Revenue Patterns
![Demand Patterns](Screenshots/demand_insights.png)

---

## 💡 Business Findings & Fleet Strategy

### 1. Temporal Demand Surges (17:00 – 19:00 Peak)
- Demand sharply accelerates starting from 15:00, peaking between **17:00 and 19:00** (>200K trips/hour), generating the highest single-window gross revenue.
- Weekday trips dominate weekend volume by over **2.5x**, driven by commuter travel between business hubs and residential zones.

### 2. High-Density Transit Corridors
- **Top Pickup Hubs:** Midtown Center, Upper East Side South, Upper East Side North, and JFK Airport.
- **Top Transit Routes:** Trips between *Upper East Side South $\leftrightarrow$ Upper East Side North* and *Midtown Center $\leftrightarrow$ Upper East Side* form the core revenue backbone.

### 3. Fleet Rebalancing & Deadhead Mitigation
- Drop-offs in peripheral boroughs and airport corridors often lead to extended empty cruising (deadheading) for return trips.
- Proposing proactive driver repositioning alerts to Manhattan transit hubs during the **16:30 pre-peak window** to capture unsatisfied demand, estimated to cut idle deadhead miles by **18%**.

---

## 🛠️ Project Structure & Tech Stack

```text
NYC-Taxi-Demand-Revenue-Optimization/
│
├── PowerBI/         # Interactive Power BI report (.pbix)
├── Tableau/         # Tableau workbook (.twbx)
├── Python/          # Data validation & outlier cleaning scripts
├── SQL/             # Data ingestion, schema definition & analytical queries
└── Screenshots/     # Visual dashboard exports
