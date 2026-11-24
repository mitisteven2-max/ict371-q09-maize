-- (b)
SELECT fn_maize_rate('A') AS a, fn_maize_rate('B') AS b, fn_maize_rate('C') AS c;
DO $$ BEGIN PERFORM fn_maize_rate(NULL);
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;
DO $$ BEGIN PERFORM fn_maize_rate('D');
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;

-- (d) loaded rows were priced by the trigger
SELECT delivery_id, grade, weight_kg, unit_rate, total_value FROM deliveries ORDER BY 1;

-- direct SQL cannot override the pricing rule
INSERT INTO deliveries (farmer_id, grade, weight_kg, unit_rate, total_value, delivered_on)
VALUES (1, 'A', 10, 99, 1, DATE '2026-11-24');           -- stored as rate 5.00, value 50.00
SELECT unit_rate, total_value FROM deliveries ORDER BY delivery_id DESC LIMIT 1;

UPDATE deliveries SET grade = 'C' WHERE delivery_id = 1;  -- recalculated at K3/kg
SELECT grade, unit_rate, total_value FROM deliveries WHERE delivery_id = 1;   -- C, 3.00, 300.00

DO $$ BEGIN INSERT INTO deliveries (farmer_id, grade, weight_kg, delivered_on)
            VALUES (1, 'A', 0, CURRENT_DATE);             -- non-positive weight
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;

-- (c)
CALL pr_receive_delivery(3, 'B', 40, DATE '2026-11-24');
DO $$ BEGIN CALL pr_receive_delivery(99, 'A', 10, CURRENT_DATE);
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;
DO $$ BEGIN CALL pr_receive_delivery(1, 'Z', 10, CURRENT_DATE);
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;
DO $$ BEGIN CALL pr_receive_delivery(1, 'A', -5, CURRENT_DATE);
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;

-- (e) every farmer appears; amounts are unpaid totals
SELECT * FROM v_farmer_amount_due;

-- (g) run twice: values are replaced, not doubled
CALL pr_refresh_purchases(DATE '2026-11-21');
CALL pr_refresh_purchases(DATE '2026-11-21');
SELECT * FROM daily_purchases;

-- (f) EXPLAIN again now that the tables contain data
ANALYZE deliveries;
SET enable_seqscan = off;   -- tiny table: force the planner to show the index

EXPLAIN
SELECT delivery_id, grade, weight_kg, total_value
FROM deliveries
WHERE farmer_id = 1
  AND delivered_on BETWEEN DATE '2026-11-01' AND DATE '2026-11-30';

RESET enable_seqscan;
