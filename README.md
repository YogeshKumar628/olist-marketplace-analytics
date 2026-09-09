\# Marketplace Retention \& Delivery Analytics



Analysis of the Olist Brazilian e-commerce marketplace (\~100K orders, 2016–2018) examining

how delivery performance affects customer satisfaction and repeat purchase behaviour.



\*\*Status:\*\* In progress — database layer complete, analysis in development.



\---



\## Business Question



Olist is a marketplace where the platform controls the customer relationship but not the

logistics. That makes delivery reliability a product problem, not just an operations one.



This project asks three connected questions:



1\. Does late delivery measurably reduce customer satisfaction?

2\. Do customers whose first order arrives late come back less often?

3\. What is the actual repeat-purchase rate on this marketplace?



\## Key Finding So Far



\*\*The commonly reported repeat-purchase rate for this dataset is overstated.\*\*



Public analyses of Olist typically report that \~3% of customers place more than one order.

Examining the time between a customer's first and second order shows that \*\*24.8% of those

"second" orders were placed within one minute of the first.\*\*



These are not returning customers. Olist splits a multi-seller basket into separate

`order\_id` records, so a single shopping session can produce several orders. Counting

`order\_id` values without checking elapsed time inflates the repeat rate.



Requiring a genuine gap between orders lowers the real repeat rate meaningfully. Of the 927

customers with a second order inside 24 hours, only 78 ever placed a third — consistent

with split baskets rather than high-frequency buyers.



\## Approach



| Stage | Work |

|---|---|

| \*\*Database\*\* | 9 CSVs loaded into SQLite with an explicit schema (primary and foreign keys declared), verified by row-count reconciliation |

| \*\*SQL analysis\*\* | Multi-table joins, CTEs, and window functions (`NTILE`, `RANK() OVER (PARTITION BY)`) for RFM segmentation and top-sellers-per-state ranking |

| \*\*Delivery analysis\*\* | Welch's t-test on review scores for late vs on-time deliveries, reported with Cohen's d effect size |

| \*\*Retention\*\* | Monthly cohort retention; repeat rate compared by first-order delivery experience |

| \*\*Dashboard\*\* | Tableau Public dashboard covering order volume, delivery performance by state, and RFM segments |



\## Repository Structure

├── notebooks/

│ ├── 01\_build\_database.ipynb # CSV → SQLite, with verification

│ └── 02\_sql\_analysis.ipynb # joins, CTEs, window functions

├── sql/ # saved query files

├── outputs/ # charts

└── requirements.txt





\## Data



The dataset is not committed to this repository (the geolocation table alone exceeds GitHub's

file size limit). Download it from

\[Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) and extract all 9 CSVs

into a `data/` folder, then run `01\_build\_database.ipynb`.



\## Tech Stack



SQL (SQLite) · Python (pandas, NumPy, SciPy, Matplotlib, Seaborn) · Jupyter · Tableau Public



\## Notes on Method



\- \*\*`order\_status = 'delivered'` filter:\*\* cancelled and unavailable orders are excluded from

&#x20; delivery and satisfaction analysis, since they have no delivery outcome to measure.

\- \*\*Welch's t-test over Student's:\*\* the late and on-time groups have very unequal sizes and

&#x20; variances; Welch's does not assume equal variance.

\- \*\*Cohen's d reported alongside p-values:\*\* at n ≈ 90,000 almost any difference is

&#x20; statistically significant, so effect size is what indicates whether the finding matters.

\- \*\*Missing review scores are not imputed:\*\* a customer choosing not to review is different

&#x20; information from a low review.

