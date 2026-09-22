\# Marketplace Retention \& Delivery Analytics



Analysis of the Olist Brazilian e-commerce marketplace: 96,470 delivered orders and

93,358 customers between January 2017 and August 2018.



SQL (SQLite) · Python (pandas, SciPy, Matplotlib, Seaborn) · Tableau



\---



\## The question



Olist is a marketplace: it owns the customer relationship but not the logistics. That makes

delivery reliability a product problem rather than only an operational one.



Three questions follow from that:



1\. Does late delivery hurt customer satisfaction, and by how much?

2\. Does a bad first delivery stop customers coming back?

3\. What is the marketplace's actual repeat-purchase rate?



\---



\## What the analysis found



\*\*1. A third of all negative reviews come from late orders, and most were written before the

order arrived.\*\*



Late orders are 6.8% of all orders but produce \*\*32.5% of every 1–2 star review on the

platform\*\*. Olist sends its satisfaction survey when an order is delivered \*or when the

promised delivery date passes\*, whichever comes first. For late orders the survey usually

arrives first: 96–99% of reviews on orders more than a week late were answered before the

product showed up, and those pre-arrival reviews are roughly 80% negative regardless of how

late the order eventually was.



About 91% of the negative reviews on late orders were written before the customer had the

product. That is close to 3 in 10 of all negative reviews on the marketplace, collected at

the moment of peak frustration rather than after the experience was complete.



\*\*2. Late delivery genuinely damages satisfaction, and even small delays are costly.\*\*



| Delivery outcome | Orders | 1–2 star reviews |

|---|---|---|

| Early | 88,163 | 9.2% |

| On the promised day | 1,280 | 12.3% |

| 1–3 days late | 1,852 | 32.2% |

| 4–7 days late | 1,748 | 67.6% |

| 8–14 days late | 1,446 | 80.2% |

| 15+ days late | 1,335 | 78.2% |



A delay of just one to three days more than triples the negative-review rate. The effect is

statistically significant (Welch's t-test, p < 0.001) and large (Cohen's d = 1.71). It holds

within each of the five largest states, so it is not a regional artifact, and a

Mann-Whitney U test confirms it without assuming star ratings are evenly spaced.



Restricting to reviews written \*after\* the order arrived, late delivery still roughly

doubles the negative-review rate, 19.5% against 9.2%.



\*\*3. The published repeat-purchase rate for this dataset is overstated by 29%.\*\*



Counting any customer with more than one `order\_id` gives a 3.00% repeat rate, the figure

commonly reported in public analyses of Olist. That count is wrong.



Olist splits a multi-seller basket into separate order records, so one checkout can produce

several orders. Nearly a quarter of all "second" orders arrive within \*\*sixty seconds\*\* of

the first. Requiring more than a day between orders reclassifies \*\*808 customers\*\* and gives

a corrected repeat rate of \*\*2.13%\*\*.



The same pattern appears independently in the reviews table: 789 review IDs are attached to

more than one order, and every one belongs to a single customer, 93% of them covering orders

placed within a minute of each other.



\*\*4. Late delivery is not why customers fail to return.\*\*



Comparing customers whose first order arrived late against those whose arrived on time, over

an equal 180-day window, the difference in return rate is small and not statistically

established (1.60% against 1.97%, p = 0.125).



Cohort analysis shows why. There is no retention curve to improve: about 0.48% of each cohort

returns in month one, and 0.1–0.4% in every later month with no clear decline. That is

background noise, not a decaying curve.



Nothing observable at the first purchase distinguishes the 1,993 customers who returned from

the 91,357 who did not:



| | Returners | One-time |

|---|---|---|

| Median first order value | BRL 89.00 | BRL 88.00 |

| Median items | 1 | 1 |

| First order late | 5.2% | 6.9% |

| Median freight | BRL 16.79 | BRL 17.32 |



Repeat purchase on this marketplace is close to random with respect to everything in the

transaction record.



\---



\## What this implies



\*\*Test holding the satisfaction survey until delivery.\*\* This is the most direct lever on

negative reviews and requires no logistics change. The analysis cannot estimate the size of

the improvement, since the data cannot show what those customers would have said after

receiving their order, which is precisely what an experiment would answer.



\*\*Target Rio de Janeiro first for delivery reliability.\*\* It is the second-largest market

with 12,350 orders and a 12.1% late rate, nearly three times São Paulo's 4.5%. It accounts

for roughly 23% of all late orders while being 13% of volume.



\*\*Do not treat this as a churn problem.\*\* Retention work assumes customers return and the

goal is to slow the drop-off. Here repeat purchase never begins. Improving delivery would

raise satisfaction substantially and retention barely at all.



\---



\## Method notes



\- \*\*Late\*\* means the order arrived on a later calendar day than promised. Promised dates are

&#x20; stored at midnight, so a naive "arrived after the promised timestamp" rule flags orders

&#x20; delivered during the promised day itself. That rule gave 8.1%; the corrected rate is 6.8%.

\- \*\*Welch's t-test\*\* is used rather than Student's because the two groups differ greatly in

&#x20; size and variance.

\- \*\*Cohen's d is reported alongside p-values.\*\* At n ≈ 95,000 almost any difference is

&#x20; statistically significant, so effect size is what indicates whether a finding matters.

\- \*\*Missing review scores are never imputed.\*\* A customer who chose not to review is

&#x20; different information from a low score. 646 orders have no review and are excluded from

&#x20; review analysis only.

\- \*\*Equal observation windows.\*\* The retention comparison includes only customers whose

&#x20; first purchase left a full 180 days before the data ends, so every customer had the same

&#x20; opportunity to return.

\- \*\*This analysis is observational.\*\* It establishes strong, consistent association, not

&#x20; causation.



\---



\## Repository



\- \*\*notebooks/\*\*

&#x20; - `01\_build\_database.ipynb` — nine CSVs into SQLite with an explicit schema, verified by row counts

&#x20; - `02\_sql\_analysis.ipynb` — order-level and customer-level tables, seller ranking (CTEs, `NTILE`, `RANK() OVER (PARTITION BY)`)

&#x20; - `03\_data\_audit\_and\_eda.ipynb` — every table audited for missing values, duplicates and key integrity; distributions and trends

&#x20; - `04\_delivery\_analysis.ipynb` — delivery vs satisfaction, robustness checks, delivery vs repeat purchase

&#x20; - `05\_retention\_and\_kpis.ipynb` — cohort retention, revenue concentration, KPI summary

\- \*\*sql/\*\* — the three analytical queries as standalone files

\- \*\*outputs/\*\* — charts

\- \*\*data/kpi\_summary.csv\*\* — every headline figure



\## Data



The dataset is not committed here; the geolocation table alone exceeds GitHub's file size

limit. Download it from

\[Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), extract all nine CSVs

into a `data/` folder, and run `01\_build\_database.ipynb`.

