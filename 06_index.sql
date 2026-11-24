-- ICT371 Q9 (f): composite index for a farmer's deliveries between two dates
-- farmer_id (equality) first, delivered_on (range) second.
CREATE INDEX IF NOT EXISTS idx_deliveries_farmer_date
    ON deliveries (farmer_id, delivered_on);

ANALYZE deliveries;
SET enable_seqscan = off;   -- tiny table: force the planner to show the index

EXPLAIN
SELECT delivery_id, grade, weight_kg, total_value
FROM deliveries
WHERE farmer_id = 1
  AND delivered_on BETWEEN DATE '2026-11-01' AND DATE '2026-11-30';

RESET enable_seqscan;
