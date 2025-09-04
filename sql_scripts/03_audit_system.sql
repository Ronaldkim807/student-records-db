-- Audit table
CREATE TABLE acad.enrollments_audit (
  audit_id   BIGSERIAL PRIMARY KEY,
  operation  TEXT NOT NULL,
  op_tstamp  TIMESTAMPTZ DEFAULT now(),
  user_name  TEXT NOT NULL DEFAULT current_user,
  row_data   JSONB
);

-- Trigger function
CREATE OR REPLACE FUNCTION acad.fn_enrollments_audit()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO acad.enrollments_audit(operation, row_data)
    VALUES('DELETE', to_jsonb(OLD));
    RETURN OLD;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO acad.enrollments_audit(operation, row_data)
    VALUES('UPDATE', to_jsonb(NEW));
    RETURN NEW;
  ELSE
    INSERT INTO acad.enrollments_audit(operation, row_data)
    VALUES('INSERT', to_jsonb(NEW));
    RETURN NEW;
  END IF;
END;
$$;

-- Attach trigger
CREATE TRIGGER trg_enrollments_audit
AFTER INSERT OR UPDATE OR DELETE ON acad.enrollments
FOR EACH ROW EXECUTE FUNCTION acad.fn_enrollments_audit();