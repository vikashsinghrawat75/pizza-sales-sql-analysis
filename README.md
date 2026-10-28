# 🍕 Pizza Sales Analysis | SQL Server

## Objective
Analyze one year of pizza sales (2015) using T-SQL to find revenue trends, peak hours, and top-performing pizzas.

## Dataset
Dataset source: [Ayushi]([https://github.com/Ayushi0214])****
| Table | Rows | Description |
|---|---|---|
| `orders` | 21,350 | Order date and time |
| `order_details` | 48,620 | Pizzas and quantities per order |
| `pizzas` | 96 | Size and price |
| `pizza_types` | 32 | Name and category |

## Tools & Concepts
SQL Server, SSMS • JOINs • GROUP BY • Subqueries • CTEs • Window functions (`RANK`, `SUM() OVER`) • `DATEPART`

## Questions Solved
- **Basic:** total orders, total revenue, highest-priced pizza, most common size, top 5 pizzas
- **Intermediate:** quantity by category, orders by hour, category distribution, average pizzas per day, top 3 by revenue
- **Advanced:** revenue contribution per pizza, cumulative revenue, top 3 per category

## Key Insights
- **21,350 orders** brought in **$817,860** from **49,574 pizzas**, about 138 pizzas per day
- **Large** is the top size (18,956 pizzas); XL and XXL are only about 1% of sales
- **Classic** leads in both quantity and revenue
- Top revenue pizzas are all Chicken: **Thai Chicken ($43,434)**, **Barbecue Chicken ($42,768)**, **California Chicken ($41,410)**
- Orders peak at **12 to 2 PM** and **5 to 7 PM**, with 12 PM the busiest hour (2,520 orders)

## Recommendations
- Add staff during lunch and dinner rushes
- Promote top Chicken pizzas with combos
- Review the lowest-revenue pizzas (e.g. Brie Carre) for repricing or removal

## Files
- `Pizza_Sales_Analysis.sql`: all 13 queries

## Author
**[Vikash Rawat]** • [www.linkedin.com/in/vikash-rawat-b86b781a9]
