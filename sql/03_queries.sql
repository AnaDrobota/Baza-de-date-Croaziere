-- 03_queries.sql
USE cruise_management;

-- 1) View usage
SELECT * FROM v_cruise_overview;

-- 2) Cruises on ships with capacity > 500
SELECT c.cruise_id, c.name, s.name AS ship_name, s.capacity
FROM cruise c
JOIN ship s ON s.ship_id = c.ship_id
WHERE s.capacity > 500;

-- 3) Offers for a specific client (example: client_id = 1)
SELECT cl.client_id, cl.first_name, cl.last_name, o.offer_id, o.title, o.price_amount, o.currency
FROM client cl
JOIN offer o ON o.client_id = cl.client_id
WHERE cl.client_id = 1;

-- 4) Payments summary per client (reporting query)
SELECT
  cl.client_id,
  CONCAT(cl.first_name, ' ', cl.last_name) AS client_name,
  SUM(p.amount) AS total_paid,
  p.currency
FROM client cl
JOIN payment p ON p.client_id = cl.client_id
GROUP BY cl.client_id, client_name, p.currency
ORDER BY total_paid DESC;

-- 5) Number of cruises per ship
SELECT s.ship_id, s.name, COUNT(c.cruise_id) AS cruises_count
FROM ship s
LEFT JOIN cruise c ON c.ship_id = s.ship_id
GROUP BY s.ship_id, s.name
ORDER BY cruises_count DESC;

-- 6) Cruises longer than or equal to 7 days
SELECT cruise_id, name, route, duration_days
FROM cruise
WHERE duration_days >= 7
ORDER BY duration_days DESC;

-- 7) Promotions active in a date range (example range)
SELECT promotion_id, name, discount_percent, start_date, end_date
FROM promotion
WHERE start_date >= '2025-09-01' AND end_date <= '2025-09-30';
