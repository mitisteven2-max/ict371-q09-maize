-- ICT371 Q9 (g): pr_refresh_purchases + pg_cron
CREATE OR REPLACE PROCEDURE pr_refresh_purchases(p_day DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_day IS NULL THEN
        RAISE EXCEPTION 'p_day is required';
    END IF;

    INSERT INTO daily_purchases (purchase_date, total_weight, total_value)
    SELECT p_day,
           COALESCE(SUM(weight_kg), 0),
           COALESCE(SUM(total_value), 0)
    FROM deliveries
    WHERE delivered_on = p_day
    ON CONFLICT (purchase_date) DO UPDATE
    SET total_weight = EXCLUDED.total_weight,    -- replace, never add
        total_value  = EXCLUDED.total_value;
END;
$$;

CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Daily at 01:30 for the previous day
SELECT cron.schedule(
    'q09_purchases_daily',
    '30 1 * * *',
    $$CALL pr_refresh_purchases(CURRENT_DATE - 1)$$
);

-- Inspect:
-- SELECT jobid, jobname, schedule, command FROM cron.job;
-- SELECT * FROM cron.job_run_details ORDER BY start_time DESC LIMIT 5;
