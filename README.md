# ICT371 Q9 - Farmer Cooperative Maize Deliveries

**Student:** Steven Miti (202405283)  
**DBMS:** PostgreSQL 13+ with the pg_cron extension

## How to run
Use a fresh database for this question (several questions share table names such as `students`):

```bash
createdb ict371_q09
psql -d ict371_q09 -f run_all.sql
```

Files run in order: schema, function, procedure, trigger, view, index, scheduled job, data load, tests.
The data load (`08_load_data.sql`) runs after the trigger/procedure exist, as the question requires.

| Part | File |
|------|------|
| (a) Tables + seed data | `01_schema_seed.sql`, `08_load_data.sql` |
| (b) Function | `02_function.sql` |
| (c) Procedure | `03_procedure.sql` |
| (d) Trigger | `04_trigger.sql` |
| (e) View | `05_view.sql` |
| (f) Index + EXPLAIN | `06_index.sql` |
| (g) Scheduled job | `07_scheduled_job.sql` |
| Demonstration queries | `09_tests.sql` |

## Index
`idx_deliveries_farmer_date ON deliveries (farmer_id, delivered_on)`

A farmer's deliveries between two dates is an equality on farmer_id plus a range on delivered_on, so farmer_id goes first and delivered_on second.

## Design notes
- Rates: A = K5, B = K4, C = K3 per kg. The trigger always overwrites unit_rate and total_value, so direct SQL cannot bypass the pricing rule.
- Deliveries are loaded after the trigger is installed, as the question requires.

## Output
_Paste screenshots / output of `09_tests.sql` and the `EXPLAIN` plan here._
