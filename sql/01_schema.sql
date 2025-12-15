-- 01_schema.sql
-- Cruise Management Database (MySQL)
-- Clean schema: English names, constraints, indexes

DROP DATABASE IF EXISTS cruise_management;
CREATE DATABASE cruise_management
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE cruise_management;

SET FOREIGN_KEY_CHECKS = 0;

-- Drop tables (safe re-run)
DROP TABLE IF EXISTS point_of_interest;
DROP TABLE IF EXISTS promotion;
DROP TABLE IF EXISTS contract;
DROP TABLE IF EXISTS salary;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS cruise;
DROP TABLE IF EXISTS offer;
DROP TABLE IF EXISTS ship;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS client;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================
-- Core entities
-- =========================

CREATE TABLE client (
  client_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name  VARCHAR(100) NOT NULL,
  email      VARCHAR(150) NOT NULL,
  phone      VARCHAR(20)  NULL,
  CONSTRAINT uq_client_email UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE employee (
  employee_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name  VARCHAR(100) NOT NULL,
  email      VARCHAR(150) NOT NULL,
  phone      VARCHAR(20)  NULL,
  role       VARCHAR(60)  NOT NULL,
  CONSTRAINT uq_employee_email UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE supplier (
  supplier_id INT AUTO_INCREMENT PRIMARY KEY,
  name    VARCHAR(150) NOT NULL,
  phone   VARCHAR(20)  NULL,
  email   VARCHAR(150) NULL,
  address VARCHAR(255) NULL,
  CONSTRAINT uq_supplier_email UNIQUE (email)
) ENGINE=InnoDB;

CREATE TABLE ship (
  ship_id INT AUTO_INCREMENT PRIMARY KEY,
  name           VARCHAR(150) NOT NULL,
  ship_type      VARCHAR(50)  NOT NULL,
  capacity       INT NOT NULL,
  length_m       DECIMAL(7,2) NULL,
  width_m        DECIMAL(7,2) NULL,
  crew_size      INT NULL,
  launch_year    YEAR NULL,
  company        VARCHAR(150) NULL,
  description    TEXT NULL,
  CONSTRAINT chk_ship_capacity CHECK (capacity > 0)
) ENGINE=InnoDB;

-- =========================
-- Business entities
-- =========================

CREATE TABLE offer (
  offer_id INT AUTO_INCREMENT PRIMARY KEY,
  title        VARCHAR(150) NOT NULL,
  description  TEXT NULL,
  start_date   DATE NOT NULL,
  end_date     DATE NOT NULL,
  price_amount DECIMAL(10,2) NOT NULL,
  currency     CHAR(3) NOT NULL DEFAULT 'RON',
  client_id    INT NULL,
  employee_id  INT NULL,

  CONSTRAINT chk_offer_dates CHECK (end_date >= start_date),
  CONSTRAINT chk_offer_price CHECK (price_amount >= 0),

  CONSTRAINT fk_offer_client
    FOREIGN KEY (client_id) REFERENCES client(client_id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  CONSTRAINT fk_offer_employee
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX idx_offer_client   ON offer(client_id);
CREATE INDEX idx_offer_employee ON offer(employee_id);

CREATE TABLE cruise (
  cruise_id INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(150) NOT NULL,
  route       VARCHAR(255) NOT NULL,
  duration_days INT NOT NULL,
  description TEXT NULL,
  start_date  DATE NOT NULL,
  end_date    DATE NOT NULL,
  offer_id    INT NULL,
  ship_id     INT NULL,

  CONSTRAINT chk_cruise_dates CHECK (end_date >= start_date),
  CONSTRAINT chk_cruise_duration CHECK (duration_days > 0),

  CONSTRAINT fk_cruise_offer
    FOREIGN KEY (offer_id) REFERENCES offer(offer_id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  CONSTRAINT fk_cruise_ship
    FOREIGN KEY (ship_id) REFERENCES ship(ship_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX idx_cruise_offer ON cruise(offer_id);
CREATE INDEX idx_cruise_ship  ON cruise(ship_id);

CREATE TABLE payment (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  payment_date DATE NOT NULL,
  method       VARCHAR(30) NOT NULL,      -- Card, Transfer, Cash etc.
  amount       DECIMAL(10,2) NOT NULL,
  currency     CHAR(3) NOT NULL DEFAULT 'RON',
  payment_type VARCHAR(30) NOT NULL,      -- Deposit, Full, Final etc.
  client_id    INT NULL,
  employee_id  INT NULL,

  CONSTRAINT chk_payment_amount CHECK (amount >= 0),

  CONSTRAINT fk_payment_client
    FOREIGN KEY (client_id) REFERENCES client(client_id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  CONSTRAINT fk_payment_employee
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX idx_payment_client   ON payment(client_id);
CREATE INDEX idx_payment_employee ON payment(employee_id);
CREATE INDEX idx_payment_date     ON payment(payment_date);

CREATE TABLE salary (
  salary_id INT AUTO_INCREMENT PRIMARY KEY,
  amount     DECIMAL(10,2) NOT NULL,
  pay_date   DATE NOT NULL,
  period     VARCHAR(50) NOT NULL,   -- e.g. '2025-06'
  employee_id INT NOT NULL,

  CONSTRAINT chk_salary_amount CHECK (amount >= 0),

  CONSTRAINT fk_salary_employee
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_salary_employee ON salary(employee_id);

CREATE TABLE contract (
  contract_id INT AUTO_INCREMENT PRIMARY KEY,
  start_date DATE NOT NULL,
  end_date   DATE NOT NULL,
  value_amount DECIMAL(12,2) NOT NULL,
  description TEXT NULL,
  supplier_id INT NULL,
  employee_id INT NULL,

  CONSTRAINT chk_contract_dates CHECK (end_date >= start_date),
  CONSTRAINT chk_contract_value CHECK (value_amount >= 0),

  CONSTRAINT fk_contract_supplier
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  CONSTRAINT fk_contract_employee
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX idx_contract_supplier ON contract(supplier_id);
CREATE INDEX idx_contract_employee ON contract(employee_id);

CREATE TABLE promotion (
  promotion_id INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(150) NOT NULL,
  description TEXT NULL,
  start_date  DATE NOT NULL,
  end_date    DATE NOT NULL,
  discount_percent DECIMAL(5,2) NOT NULL,
  client_id INT NULL,
  offer_id  INT NULL,

  CONSTRAINT chk_promo_dates CHECK (end_date >= start_date),
  CONSTRAINT chk_discount_range CHECK (discount_percent >= 0 AND discount_percent <= 100),

  CONSTRAINT fk_promo_client
    FOREIGN KEY (client_id) REFERENCES client(client_id)
    ON UPDATE CASCADE ON DELETE SET NULL,

  CONSTRAINT fk_promo_offer
    FOREIGN KEY (offer_id) REFERENCES offer(offer_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX idx_promo_client ON promotion(client_id);
CREATE INDEX idx_promo_offer  ON promotion(offer_id);

CREATE TABLE point_of_interest (
  poi_id INT AUTO_INCREMENT PRIMARY KEY,
  description TEXT NOT NULL,
  location    VARCHAR(150) NOT NULL,
  poi_type    VARCHAR(50) NOT NULL,   -- Beach, Museum, Historical etc.
  cruise_id   INT NOT NULL,

  CONSTRAINT fk_poi_cruise
    FOREIGN KEY (cruise_id) REFERENCES cruise(cruise_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_poi_cruise ON point_of_interest(cruise_id);

-- Optional: a clean view recruiters like
CREATE OR REPLACE VIEW v_cruise_overview AS
SELECT
  c.cruise_id,
  c.name AS cruise_name,
  c.route,
  c.duration_days,
  c.start_date,
  c.end_date,
  s.name AS ship_name,
  s.capacity,
  o.title AS offer_title,
  o.price_amount,
  o.currency
FROM cruise c
LEFT JOIN ship s ON s.ship_id = c.ship_id
LEFT JOIN offer o ON o.offer_id = c.offer_id;
