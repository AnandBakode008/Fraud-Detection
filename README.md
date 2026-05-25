# Fraud Detection System

An end-to-end fraud detection project using PostgreSQL, SQL, and Power BI.

---

## What's in This Project

- 7 CSV datasets with 20,000 rows each (140,000 rows total)
- PostgreSQL database with 7 tables
- 20 SQL queries covering fraud investigation scenarios
- 4-page interactive Power BI dashboard

---

## Project Structure

```
Fraud-Detection/
├── CSV Files/
│   ├── User.csv
│   ├── Transactions.csv
│   ├── Devices.csv
│   ├── Merchant.csv
│   ├── login_activity.csv
│   ├── blacklist.csv
│   └── transaction_features.csv
├── SQL/
│   └── Fraud_Detection.sql
├── Dashboard/
│   └── Fraud_Detection_Dashboard.pbix
└── README.md
```

---

## Dataset Overview

| File | Rows | What it contains |
|---|---|---|
| User.csv | 20,000 | User profiles — name, age, location, avg monthly spend |
| Transactions.csv | 20,000 | All transactions — amount, method, merchant, fraud label |
| Devices.csv | 20,000 | Device info — type, OS, IP, compromised flag |
| Merchant.csv | 20,000 | Merchant details — name, category, city, blacklist status |
| login_activity.csv | 20,000 | Login logs — time, location, success/failed status |
| blacklist.csv | 20,000 | Blacklisted users, devices, merchants and reasons |
| transaction_features.csv | 20,000 | Risk features — velocity, device change, location change flags |

**Fraud rate:** 963 fraudulent out of 20,000 transactions (4.8%)

---

## SQL Queries

20 queries written in PostgreSQL covering:

| # | Query | Concept |
|---|---|---|
| 1 | Senior users (age > 60) | WHERE filter |
| 2 | High-value transactions (> ₹45,000) | WHERE filter |
| 3 | Compromised devices | DISTINCT |
| 4 | Merchants by city | IN clause |
| 5 | Failed login attempts | WHERE filter |
| 6 | Total spend per user | JOIN + GROUP BY + SUM |
| 7 | Avg amount by merchant category | GROUP BY + AVG + ROUND |
| 8 | Suspicious Linux desktops | JOIN + multi-condition WHERE |
| 9 | Blacklist reason count | GROUP BY + COUNT |
| 10 | International risk users | DISTINCT + JOIN |
| 11 | Transactions above monthly avg | Column-to-column comparison |
| 12 | Login location mismatch | CTE + ROW_NUMBER window function |
| 13 | High velocity + device change | Multi-condition WHERE |
| 14 | Blacklisted merchants % by city | CASE WHEN + conditional aggregation |
| 15 | Full audit report | 4-table LEFT JOIN with OR condition |
| 16 | Top 10 fraud users | JOIN + GROUP BY + LIMIT |
| 17 | Fraud rate by payment method | CASE WHEN + conditional aggregation |
| 18 | Users with 3+ devices | COUNT DISTINCT + HAVING |
| 19 | Riskiest merchant categories | Conditional aggregation + ORDER BY |
| 20 | Failed logins + fraud combo | Multi-JOIN + multi-condition WHERE |

---

## Power BI Dashboard

**Page 1 — Executive Overview**
High-level KPIs, spend by payment method, transactions by merchant category, device login status.

**Page 2 — Fraud Analysis**
Fraud trends 2020–2025, fraud by payment method, geographic fraud map by city, transaction risk funnel.

**Page 3 — Transactions**
Fraud vs legit breakdown, amount distribution, fraud heatmap by month and year.

**Page 4 — High-Risk Investigation**
Failed login trends, compromised devices, fraud risk levels, international fraud activity.

---

## Key Findings

- Users with both failed logins AND fraud transactions are the clearest sign of account takeover
- Login location mismatches can flag fraud before any transaction happens
- More than 30 transactions in 24 hours + a device change = strong automated fraud signal
- Some cities have significantly higher merchant blacklist rates — useful for geo-based risk rules

---

## How to Run

**Database setup:**
1. Install [PostgreSQL](https://www.postgresql.org/download/)
2. Create a database: `CREATE DATABASE fraud_detection;`
3. Open `Fraud_Detection.sql` in pgAdmin and run it
4. Update the file paths in the `COPY` commands to match your local folder location

**Dashboard:**
1. Install [Power BI Desktop](https://powerbi.microsoft.com/desktop/) (free)
2. Open `Fraud_Detection_Dashboard.pbix`
3. Reconnect the data source to your local CSV files if prompted

---

## Tools Used

- PostgreSQL — database and SQL queries
- Power BI Desktop — dashboard and visualisations
- CSV — raw data files

---

## Author

**Anand Bakode** — Data Analyst | Learning Data Science

[LinkedIn](https://www.linkedin.com/in/) · [GitHub](https://github.com/AnandBakode008)

---

*All data is synthetically generated for learning purposes only.*
