-- 02_seed.sql
USE cruise_management;

-- Employees
INSERT INTO employee (first_name, last_name, email, phone, role) VALUES
('Andrei', 'Popa', 'andrei.popa@company.com', '0745123456', 'Sales Agent'),
('Elena', 'Georgescu', 'elena.georgescu@company.com', '0756123456', 'Manager');

-- Clients
INSERT INTO client (first_name, last_name, email, phone) VALUES
('Ion', 'Popescu', 'ion.popescu@email.com', '0712345678'),
('Maria', 'Ionescu', 'maria.ionescu@email.com', '0723456789'),
('Alexandra', 'Popa', 'alexandra.popa@example.com', '0745000000');

-- Suppliers
INSERT INTO supplier (name, phone, email, address) VALUES
('Supplier One', '0212000000', 'supplier1@example.com', 'Bucharest, Example Street 1'),
('Supplier Two', '0212000001', 'supplier2@example.com', 'Bucharest, Example Street 2');

-- Ships
INSERT INTO ship (name, ship_type, capacity, length_m, width_m, crew_size, launch_year, company, description) VALUES
('Ocean Pearl', 'Cruise', 600, 250.50, 40.20, 200, 2015, 'Company X', 'Modern cruise ship with premium facilities'),
('Blue Horizon', 'Cruise', 450, 200.00, 35.00, 150, 2010, 'Company Y', 'Family-friendly cruise ship');

-- Offers
INSERT INTO offer (title, description, start_date, end_date, price_amount, currency, client_id, employee_id) VALUES
('Summer 2025 Offer', 'Discount for summer cruises', '2025-06-01', '2025-08-31', 1200.50, 'RON', 1, 1),
('Autumn 2025 Offer', 'Autumn season promotion', '2025-09-01', '2025-11-30', 1500.00, 'RON', 2, 2);

-- Cruises
INSERT INTO cruise (name, route, duration_days, description, start_date, end_date, offer_id, ship_id) VALUES
('Mediterranean Escape', 'Italy - Greece - Spain', 10, 'Mediterranean destinations and guided activities', '2025-06-10', '2025-06-20', 1, 1),
('Caribbean Dream', 'Bahamas - Jamaica - Dominican Republic', 7, 'Tropical cruise with island stops', '2025-07-05', '2025-07-12', 1, 2),
('Autumn Adriatic', 'Croatia - Montenegro', 7, 'Scenic Adriatic route', '2025-09-10', '2025-09-17', 2, 1);

-- Payments
INSERT INTO payment (payment_date, method, amount, currency, payment_type, client_id, employee_id) VALUES
('2025-06-05', 'Card', 600.00, 'RON', 'Deposit', 1, 1),
('2025-06-10', 'Card', 600.50, 'RON', 'Final',   1, 2),
('2025-07-01', 'Transfer', 1200.50, 'RON', 'Full',  2, 2);

-- Salaries
INSERT INTO salary (amount, pay_date, period, employee_id) VALUES
(6500.00, '2025-06-01', '2025-06', 1),
(7500.00, '2025-06-01', '2025-06', 2);

-- Contracts
INSERT INTO contract (start_date, end_date, value_amount, description, supplier_id, employee_id) VALUES
('2025-01-01', '2025-12-31', 50000.00, 'Service contract for cruise operations', 1, 2),
('2025-02-01', '2025-11-30', 30000.00, 'Supplies and maintenance contract', 2, 2);

-- Promotions
INSERT INTO promotion (name, description, start_date, end_date, discount_percent, client_id, offer_id) VALUES
('September Promo', '10% off for September bookings', '2025-09-01', '2025-09-30', 10.00, 2, 2);

-- Points of interest
INSERT INTO point_of_interest (description, location, poi_type, cruise_id) VALUES
('Historic Old Town Tour', 'Dubrovnik', 'Historical', 3),
('Beach Day', 'Bahamas', 'Beach', 2);
