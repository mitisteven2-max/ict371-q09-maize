-- ICT371 Q9 (e): v_farmer_amount_due (farmers with nothing unpaid show 0)
CREATE OR REPLACE VIEW v_farmer_amount_due AS
SELECT f.farmer_number,
       f.full_name,
       COALESCE(SUM(d.total_value), 0) AS amount_due
FROM farmers f
LEFT JOIN deliveries d
       ON d.farmer_id = f.farmer_id
      AND d.is_paid = FALSE          -- in the ON clause so every farmer is kept
GROUP BY f.farmer_id, f.farmer_number, f.full_name
ORDER BY f.farmer_number;
