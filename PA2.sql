CREATE TABLE IF NOT EXISTS yellevate_invoices (
	country VARCHAR,
	customer_id VARCHAR,
	invoice_number NUMERIC,
	invoice_date DATE,
	due_date DATE,
	invoice_amount NUMERIC,
	disputed NUMERIC,
	dispute_lost NUMERIC,
	settled_date DATE,
	days_settled INTEGER,
	days_late INTEGER
);

--
SELECT * FROM yellevate_invoices;
-- 
SELECT country, COUNT(disputed) AS disputed_count
FROM yellevate_invoices
WHERE disputed = '1' 
GROUP BY 1;
-- 
SELECT country, COUNT(dispute_lost) AS dispute_lost_count
FROM yellevate_invoices
WHERE dispute_lost = '1' 
GROUP BY 1;
-- 
SELECT country, invoice_amount
FROM yellevate_invoices
WHERE country = 'France'
GROUP BY 1, 2;
--AVG invoice per country
SELECT DISTINCT(country), ROUND(AVG(invoice_amount),2)
FROM yellevate_invoices
GROUP BY 1;

--0-0 
SELECT country, COUNT(*)
FROM yellevate_invoices
WHERE disputed = '0' AND dispute_lost = '0'
GROUP BY 1
ORDER BY 1;
--1-0
SELECT country, COUNT(*)
FROM yellevate_invoices
WHERE disputed = '1' AND dispute_lost = '0'
GROUP BY 1;
--1-1
SELECT country, COUNT(*)
FROM yellevate_invoices
WHERE disputed = '1' AND dispute_lost = '1'
GROUP BY 1;
--------------------------------------------------------------------
--1 Average settlement days: 26 days
SELECT ROUND(AVG(days_settled),0) AS avg
FROM yellevate_invoices

--2 Average settlement days and if it is disputed: 36.18
SELECT ROUND(AVG(days_settled),2) AS avg
FROM yellevate_invoices
WHERE disputed = '1'

--3 Dispute lost = 4.10%
SELECT 
ROUND((((SELECT COUNT(*)
FROM yellevate_invoices
WHERE dispute_lost = '1')/
CAST((SELECT COUNT(*)
FROM yellevate_invoices
WHERE disputed = '1') as numeric))* 100),2)
AS Percentage_dispute_lost

--4 Nearly: 5% (4.67%)
SELECT
ROUND((((SELECT SUM(invoice_amount)
FROM yellevate_invoices
WHERE disputed = '1' AND dispute_lost = '1')/
(SELECT SUM(invoice_amount)
FROM yellevate_invoices))* 100),2)
AS precentage_revenue_lost

--5 FRANCE: 76
SELECT country, COUNT(*)
FROM yellevate_invoices
WHERE dispute_lost = '1'
GROUP BY 1;
--lost: $526,264
SELECT country, SUM(invoice_amount) AS revenue_lost
FROM yellevate_invoices
WHERE disputed = '1' AND dispute_lost = '1' AND country = 'France'
GROUP BY 1