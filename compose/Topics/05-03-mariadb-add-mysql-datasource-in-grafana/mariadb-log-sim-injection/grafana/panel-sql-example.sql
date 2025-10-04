
## 3. Query examples in Grafana (SQL panel)

# Count total logs (Gauge):

```sql
SELECT COUNT(*) AS total FROM mariadb_logs;
```

# Count logs per minute (time series):

```sql
SELECT
  $__timeGroup(ts, '1m') AS time,
  COUNT(*) AS logs
FROM mariadb_logs
WHERE $__timeFilter(ts)
GROUP BY time
ORDER BY time;
```

# Average query time per op (time series):

```sql
SELECT
  $__timeGroup(ts, '1m') AS time,
  op,
  AVG(query_time_ms) AS avg_query_time
FROM mariadb_logs
WHERE $__timeFilter(ts)
GROUP BY time, op
ORDER BY time;
```

# Error rate (success = 0) (time series)::

```sql
SELECT
  $__timeGroup(ts, '1m') AS time,
  COUNT(CASE WHEN success=0 THEN 1 END) AS errors,
  COUNT(*) AS total
FROM mariadb_logs
WHERE $__timeFilter(ts)
GROUP BY time
ORDER BY time;
```

---
