SELECT 'Total' AS label, count(*) AS value FROM esinodes
UNION ALL
SELECT 'Leased', count(*) FROM esinodes WHERE Lessee NOT IN ('', 'hwbroken') AND "Provision State" IN ('active', 'available')
UNION ALL
SELECT 'Broken', count(*) FROM esinodes WHERE Lessee = 'hwbroken'
UNION ALL
SELECT 'Failed', count(*) FROM esinodes WHERE Lessee = '' AND ("Provision State" LIKE '%failed' OR "Provision State" = 'error')
UNION ALL
SELECT 'Maintenance', count(*) FROM esinodes WHERE Lessee = '' AND NOT ("Provision State" LIKE '%failed' OR "Provision State" = 'error') AND Maintenance = 'True'
UNION ALL
SELECT 'Available', count(*) FROM esinodes WHERE "Provision State" = 'available' AND Lessee = '' AND NOT ("Provision State" LIKE '%failed' OR "Provision State" = 'error') AND Maintenance = 'False'
UNION ALL
SELECT 'WTF', count(*) FROM esinodes WHERE "Provision State" != 'available' AND Lessee = '' AND NOT ("Provision State" LIKE '%failed' OR "Provision State" = 'error') AND Maintenance = 'False'
;


WITH total AS (
  SELECT count(*) as cnt FROM esinodes
)
SELECT 'Total' as label, count(*) as value, round(100.0 * count(*)/ total.cnt, 1) as pct
  FROM esinodes, total
  GROUP BY total.cnt
UNION ALL
SELECT 'Not broken' as label,
        count(*) as value,
        round(100.0 * count(*) / total.cnt, 1) as pct
  FROM esinodes, total
  WHERE "Provision State" in ('available', 'active')
    AND Maintenance = 'False'
  GROUP BY total.cnt
UNION ALL
SELECT 'Not broken + available',
        count(*),
        round(100.0 * count(*) / total.cnt, 1)
  FROM esinodes, total
  WHERE "Provision State" in ('available', 'active')
    AND Maintenance = 'False'
    AND Lessee = ''
  GROUP BY total.cnt
;
