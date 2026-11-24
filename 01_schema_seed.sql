-- ICT371 Q9 (a): tables, constraints, farmers
DROP TABLE IF EXISTS daily_purchases, deliveries, farmers CASCADE;

CREATE TABLE farmers (
    farmer_id      SERIAL PRIMARY KEY,
    farmer_number  VARCHAR(20)  NOT NULL UNIQUE,
    full_name      VARCHAR(100) NOT NULL
);

CREATE TABLE deliveries (
    delivery_id   SERIAL PRIMARY KEY,
    farmer_id     INTEGER       NOT NULL REFERENCES farmers(farmer_id),
    grade         VARCHAR(1)    NOT NULL CHECK (grade IN ('A', 'B', 'C')),
    weight_kg     NUMERIC(10,2) NOT NULL,
    unit_rate     NUMERIC(10,2) NOT NULL,   -- set by the trigger
    total_value   NUMERIC(14,2) NOT NULL,   -- set by the trigger
    delivered_on  DATE          NOT NULL,
    is_paid       BOOLEAN       NOT NULL DEFAULT FALSE
);

CREATE TABLE daily_purchases (
    purchase_date  DATE PRIMARY KEY,
    total_weight   NUMERIC(14,2) NOT NULL,
    total_value    NUMERIC(16,2) NOT NULL
);

INSERT INTO farmers (farmer_number, full_name) VALUES
    ('F001', 'Mwila Chanda'),
    ('F002', 'Esnart Phiri'),
    ('F003', 'Kennedy Banda');
-- Deliveries are loaded in 08_load_data.sql after the pricing trigger exists
