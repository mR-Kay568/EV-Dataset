# EV-Dataset
EV Evolution & Population Analysis (SQL Server + Power BI)
Assessing the evolution of EVs and the demand for EV types in some parts of the US

Project Overview
This project explores the growth and evolution of Electric Vehicles (EVs) in Washington, USA using real-world EV registration data from 1999–2026.

The analysis focused on:
- EV adoption trends over time
- Market dominance by manufacturers and models
- Battery Electric Vehicle (BEV) vs Plug-in Hybrid Electric Vehicle (PHEV) adoption
- Electric range improvements across major EV models
- Utility and infrastructure-related EV distribution

SQL Server was used for:
- data cleaning
- schema design
- data validation and
- advanced analytical queries.

Power BI was used to build interactive dashboards and visual storytelling.
Tools & Technologies
SQL Server
T-SQL
Power BI
DAX
CSV Data Processing

Data Cleaning & Preparation
The raw dataset required extensive preprocessing before analysis.

Key data engineering tasks completed:
- Designed a clean relational schema with optimized data types
- Imported large CSV files using BULK INSERT
- Resolved truncation and delimiter issues caused by quoted CSV fields
- Checked and handled:
- NULL values
- duplicates
- whitespace inconsistencies
- Standardized identifiers and categorical fields
- Created analytical tables for trend and YoY analysis
- Important preprocessing decisions
- census_tract_2020 stored as VARCHAR to preserve formatting
- Geographic coordinates stored as text
- Window functions (LAG) used for year-on-year trend calculations
- Separate summary and trend tables created for scalable Power BI modeling
  
Key Business Questions Answered
1️. Is EV adoption growing or slowing?
Using year-over-year analysis, EV adoption was shown to increase significantly after 2015, with rapid acceleration between 2020 and 2024.

Key insight
- EV registrations peaked around 2023–2024
- Growth appears to slow slightly after peak years, suggesting the market may be entering a more mature stage
  
2️. Which manufacturers dominate the EV market?
The analysis revealed strong market concentration among a few manufacturers.

Key insight
- Tesla overwhelmingly dominates EV registrations in Washington
- Chevrolet and Nissan remain important legacy EV players
- Most manufacturers contribute relatively small market shares
The EV market is highly concentrated, meaning infrastructure demand and policy impact are heavily influenced by a small number of manufacturers.

3️. BEV vs PHEV Adoption Trends
The project compared Battery Electric Vehicles (BEVs) against Plug-in Hybrid Electric Vehicles (PHEVs).

Key insight
- BEVs significantly outperform PHEVs in total registrations
- BEV adoption accelerated rapidly after 2020
- PHEV growth remained relatively moderate and stable
Consumers increasingly prefer fully electric vehicles over transitional hybrid technologies.

4️. How has EV battery range evolved over time?
One of the most important analyses measured year-on-year electric range improvements across top EV models.
Methodology:
- Calculated yearly average electric range per model
- Used SQL window functions (LAG) to compute YoY range changes
- Ranked models by cumulative electric range improvements
Key insight
The models showing the greatest electric range evolution include:
- Tesla Model S
- Tesla Model 3
- Tesla Model X
- Kia Niro
- Tesla Model Y
Tesla models consistently demonstrated the largest cumulative improvements in battery range.
Battery technology innovation is heavily concentrated among a small number of manufacturers, with Tesla leading long-term range development.

5️. Utility & Infrastructure Distribution
The analysis identified which electric utilities serve the highest concentration of EV owners.

Key insight
A small number of utility providers account for most EV-related electricity demand.
Infrastructure investments and grid planning efforts should prioritize high-EV utility regions.

📈 Dashboard Highlights
The Power BI dashboard includes:
- KPI cards for:
    * total EVs,
    * number of states,
    * manufacturers and
    * models
- EV adoption trends over time
- BEV vs PHEV comparison visuals
- Top EV manufacturers and models
- Electric range evolution analysis
- Interactive filters and slicers

Advanced SQL Concepts Used
Common Table Expressions (CTEs)
Window Functions (LAG)
Aggregations and ranking
Year-over-year calculations
Dynamic filtering
Multi-stage analytical pipelines

Key Takeaways
- EV adoption has grown dramatically since 2015
- Tesla dominates both EV production and battery innovation
- BEVs are clearly outperforming PHEVs in adoption
- Electric range improvements accelerated significantly in recent years
- A small number of utilities and manufacturers drive most EV activity
- Real-world CSV data requires robust preprocessing and validation before analysis

Future Improvements
Potential future enhancements include:
- Forecasting future EV adoption using machine learning
- Geographic mapping of EV density
- Charging infrastructure analysis
- Demographic analysis using census tract data
- Real-time dashboard automation

Project Summary
This project demonstrates end-to-end data analytics capabilities:
data engineering,
SQL-based analysis,
business intelligence,
and stakeholder-focused storytelling.

It combines technical rigor with business-focused insights to explain how EV technology and adoption patterns have evolved over time.
