# Maji Ndogo Water Access Analysis

An end-to-end data project analyzing water service delivery across the nation of Maji Ndogo — combining **SQL** for data engineering and exploration with **Power BI / DAX** for financial and operational reporting.

## Project Overview

This project investigates water access, infrastructure quality, and service delivery gaps across rural and urban zones. It moves from raw relational data (locations, visits, water sources, employee records) through cleaning and integrity auditing, into a Power BI model that tracks regional efficiency and budget performance over time.

## Tech Stack

- **SQL (MySQL)** — schema design, data cleaning, exploratory queries, integrity audits
- **Power BI / DAX** — calculated columns, measures, regional and financial reporting
- **Database:** `md_water_services`

## Repository Structure


```

├── sql/
│   ├── md_water_services.sql        # Database schema + data dump
│   └── queries.sql                  # Exploration, cleaning, & audit queries
├── powerbi/
│   └── maji_ndogo_dashboard.pbix    # Power BI report file
├── .gitignore                       # Ignored temporary and environment files
├── LICENSE                          # MIT License
└── README.md                        # Project documentation

```

## Analysis & Insights

### 1. SQL Data Engineering & Exploration

**Database Setup & Exploration**
Mapped the core relational schema across locations, visits, and water sources to establish baseline categorization across rural and urban zones.

**Data Cleaning & Standardisation**
Identified dirty data in employee records and standardized contact information, ensuring accurate audit logs and preventing duplicate team profiles during reporting.

**Population & Water Source Distribution**
Quantified overall population coverage, revealing that over half of the region relied on shared public taps or unimproved sources rather than direct in-home connections.

**Queue Times & Data Integrity Audits**
Uncovered extreme operational bottlenecks (queue times exceeding 60 minutes) and flagged potential corruption or misreporting where field staff quality scores conflicted with independent auditor reports.

### 2. Power BI & DAX Modeling

**Calculated Columns (Location & Completion Tracking)**
Enabled demographic segmentation by separating "Rural" from "Urban" areas, revealing that rural regions faced far higher queue times and poorer water quality.

**Financial Tracking Measures (Net Balance & Expenditure)**
Monitored real-time financial burn rates against the total budget, highlighting the critical slope shift in January 2024 when reduced team travel brought expenditures back under control.

**Regional Efficiency Metrics (Cost Per Citizen & Service Access)**
Highlighted key regional performance trends — Amanzi had the lowest cost-per-citizen improvement rate, while Sokoto achieved the highest growth in basic water service access by the end of 2023.

## Key Findings

- Over half the region depends on shared or unimproved water sources rather than in-home connections.
- Rural areas face significantly longer queue times and lower water quality than urban areas.
- A January 2024 reduction in team travel costs reversed an unsustainable budget burn rate.
- Sokoto led all regions in improving basic water service access; Amanzi lagged on cost efficiency.

## How to Reproduce

1. Restore the database using MySQL CLI or MySQL Workbench:
   ```bash
   mysql -u root -p md_water_services < sql/md_water_services.sql

```

2. Execute the data cleaning and audit scripts in `sql/queries.sql`.
3. Open `powerbi/maji_ndogo_dashboard.pbix` in Power BI Desktop and refresh the data source connection to point to your local `md_water_services` instance.


*Based on the Maji Ndogo dataset, a case study used for practicing data engineering and BI workflows.*

```

```
