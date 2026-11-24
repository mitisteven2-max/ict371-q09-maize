-- ICT371 Q9 (b): fn_maize_rate (A = K5, B = K4, C = K3 per kg)
CREATE OR REPLACE FUNCTION fn_maize_rate(p_grade VARCHAR)
RETURNS NUMERIC
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN
    IF p_grade IS NULL THEN
        RAISE EXCEPTION 'Grade is required';
    END IF;

    IF p_grade = 'A' THEN
        RETURN 5.00;
    ELSIF p_grade = 'B' THEN
        RETURN 4.00;
    ELSIF p_grade = 'C' THEN
        RETURN 3.00;
    END IF;

    RAISE EXCEPTION 'Unsupported grade: % (use A, B or C)', p_grade;
END;
$$;
