SELECT p.project_name, COUNT(pa.worker_id) AS worker_count
FROM projects p
JOIN project_assignments pa ON p.project_id = pa.project_id
GROUP BY p.project_id
HAVING worker_count > (
  SELECT AVG(worker_count) FROM (
    SELECT COUNT(worker_id) AS worker_count
    FROM project_assignments
    GROUP BY project_id
  ) AS avg_table
);

WITH avg_workers AS (
  SELECT AVG(worker_count) AS avg_count FROM (
    SELECT COUNT(worker_id) AS worker_count
    FROM project_assignments
    GROUP BY project_id
  ) AS counts
)
SELECT p.project_name, COUNT(pa.worker_id) AS worker_count
FROM projects p
JOIN project_assignments pa ON p.project_id = pa.project_id
CROSS JOIN avg_workers
GROUP BY p.project_id
HAVING worker_count > avg_count;

SELECT p.project_name, worker_count
FROM (
  SELECT project_id, COUNT(worker_id) AS worker_count
  FROM project_assignments
  GROUP BY project_id
) AS project_counts
JOIN projects p ON project_counts.project_id = p.project_id
WHERE worker_count = (
  SELECT MAX(worker_count) FROM (
    SELECT COUNT(worker_id) AS worker_count
    FROM project_assignments
    GROUP BY project_id
  ) AS max_table
);