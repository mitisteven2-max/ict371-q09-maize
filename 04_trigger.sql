-- ICT371 Q9 (d): one pricing rule for every insert/update, including direct SQL
CREATE OR REPLACE FUNCTION trg_fn_delivery_pricing()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.weight_kg IS NULL OR NEW.weight_kg <= 0 THEN
        RAISE EXCEPTION 'Weight must be positive (got %)', NEW.weight_kg;
    END IF;

    NEW.unit_rate   := fn_maize_rate(NEW.grade);              -- rejects bad grades
    NEW.total_value := ROUND(NEW.weight_kg * NEW.unit_rate, 2);
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_delivery_pricing ON deliveries;

CREATE TRIGGER trg_delivery_pricing
BEFORE INSERT OR UPDATE ON deliveries
FOR EACH ROW
EXECUTE FUNCTION trg_fn_delivery_pricing();
