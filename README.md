# Superstore Retail Analytics

A full-cycle retail analytics project analyzing the Sample Superstore dataset using **MySQL** and **Microsoft Excel**. The project identifies where the business generates value and where it loses money — from data cleaning through to an interactive dashboard.

<div align="center">

[![Live Demo](https://img.shields.io/badge/🌐_Live_Demo-a78bfa?style=for-the-badge&logoColor=white)](https://ayurdiet.vercel.app/)
[![GitHub Repo](https://img.shields.io/badge/GitHub_Repo-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/gauransh-singh/ayurdiet-pro)

</div>

---

## The Business Question

> **Where is the Superstore bleeding money, and what is causing it?**

---

## Key Findings

| Metric | Value |
|---|---|
| Total Sales | $2.33M |
| Total Profit | $292K |
| Profit Margin | 12.6% |
| Unique Orders | 5,111 |
| Unique Customers | 804 |

### 1. High discounts destroy profit
Orders with discounts above 40% generated **-$100,030 in total losses**. The swing from no-discount (+$66 avg profit per order) to high-discount (-$105 avg profit) is a **$171 difference per order**.

### 2. Furniture has a critically low margin (2.6%)
Despite $754K in sales — nearly as much as Technology ($840K) — Furniture generated only $19,730 in profit. Tables sub-category alone lost **$17,753**.

### 3. Central region underperforms
7.9% margin vs 15.0% in the West, despite $503K in sales. Likely driven by higher discount rates in that region.

### 4. Strong seasonality
Sep–Dec consistently peaks every year. Q4 accounts for a disproportionate share of annual profit.

### 5. Technology leads profitability
17.5% margin. Copiers ($56K) and Phones ($45K) are the top sub-categories by profit.

---

## Tech Stack

| Tool | Purpose |
|---|---|
| MySQL 8.0 | Data storage, cleaning, analysis, views |
| MySQL Workbench | SQL IDE and CSV export |
| Microsoft Excel 365 | Pivot tables, charts, interactive dashboard |

---

## Project Structure

```
superstore-retail-analysis/
├── data/
│   └── samplesuperstore.csv
├── sql/
│   └── superstore_analysis.sql
├── excel/
│   └── superstore_dashboard.xlsx
├── docs/
│   └── project_documentation.docx
|── web/
|       └── index.html
└── README.md
```

---

## SQL Analysis — Phases

### Phase 1 — Data Cleaning
- Null check on Sales and Profit → zero nulls found
- Duplicate detection across 3 levels (full row, Order_ID, Order_ID + Product_ID)
- Found and removed 2 genuine full-row duplicates
- Final table: 10,192 rows

### Phase 2 — Exploratory Analysis
- Basic metrics: total orders, sales, profit
- Date format validation and shipping day calculation

### Phase 3 — Time-Series Analysis
- Monthly sales and profit trend (2023–2026)
- Year-over-year growth using `LAG()` window function

### Phase 4 — Region Analysis
- Sales, profit, and order count by region using `WITH ROLLUP`

### Phase 5 — Category & Sub-Category Analysis
- Profit margin by category and sub-category
- Identified Tables, Bookcases, and Supplies as loss-makers

### Phase 6 — Discount Impact
- Raw discount vs avg profit correlation
- Discount banding (None / Low / Medium / High) with total profit per band

### Phase 7 — Customer RFM Analysis
- Recency (days active), Frequency (unique orders), Monetary (total sales) per customer

### Phase 8 — Shipping Performance
- Average shipping days, order count, and sales by ship mode

---

## SQL Views Created

| View | Contents |
|---|---|
| `vw_monthly_sales_trend` | Month, Sales, Profit, Margin % |
| `vw_region_performance` | Region, Orders, Sales, Profit |
| `vw_category_analysis` | Category, Sales, Profit, Margin |
| `vw_subcategory_analysis` | Sub-Category, Sales, Profit, Margin, Avg Discount |
| `vw_discount_impact` | Discount band, Orders, Avg Profit, Total Profit |
| `vw_customer_rfm` | Customer, Recency, Frequency, Monetary |
| `vw_shipping_analysis` | Ship Mode, Avg Days, Orders, Sales |
| `vw_loss_making_products` | Products with negative total profit |

---

## Excel Dashboard

The dashboard is built from pivot tables sourced from each SQL view export. Components:

- **KPI Cards** — Total Sales, Total Profit, Profit Margin, Avg Order Value
- **Monthly Trend Chart** — Area/line chart, Jan 2023 to Dec 2026
- **Region Performance** — Clustered bar chart comparing Sales and Profit
- **Category Breakdown** — Horizontal bars with margin % mini-cards
- **Discount Impact Chart** — Column chart showing avg profit by discount band
- **Shipping Overview** — Orders and sales by ship mode
- **Slicers** — Interactive filters for Segment, Region, and Category

---

## Recommendations

1. **Cap discounts at 20%** across all categories — discounts above this level consistently produce negative returns
2. **Review Tables pricing** — $17,753 total loss is unsustainable at current margins
3. **Investigate Central region** discount policies and align with West region practices
4. **Prioritize Technology and Office Supplies** in marketing — highest profit per dollar of sales
5. **Plan Q4 inventory 60 days ahead** given consistent Sep–Dec demand spikes

---

## About

**Gauransh Singh**
BCA Final Year | AI/ML Specialization | Galgotias University

- Skills: SQL · Python · Power BI · Tableau · Excel
- Certifications: IBM · AWS · Cisco · Deloitte/Forage
- Achievements: Top 11 — Smart India Hackathon | National Finalist — Code Astra IEEE Summit 2025
- Portfolio: [gauransh-singh.vercel.app](https://gauransh-singh.vercel.app)
- LinkedIn: [linkedin.com/in/gauransh-singh-211586294](https://linkedin.com/in/gauransh-singh-211586294)