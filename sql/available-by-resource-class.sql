SELECT "Resource Class", count(*) as Count
  FROM esinodes
  WHERE "Provision State" = 'available'
    AND Lessee = ''
    AND NOT ("Provision State" LIKE '%failed' OR "Provision State" = 'error')
    AND Maintenance = 'False'
  GROUP BY "Resource Class";
