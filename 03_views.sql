CREATE VIEW v_project_worker_assignments AS
SELECT p.project_name, w.first_name, w.last_name, pa.start_date, pa.end_date, pa.hours_worked
FROM projects p
JOIN project_assignments pa ON p.project_id = pa.project_id
JOIN workers w ON pa.worker_id = w.worker_id;

CREATE VIEW v_project_financial_summary AS
SELECT p.project_id, p.project_name, p.budget,
       COALESCE(SUM(e.amount), 0) AS total_expenses,
       p.budget - COALESCE(SUM(e.amount), 0) AS remaining_budget,
       p.status
FROM projects p
LEFT JOIN expenses e ON p.project_id = e.project_id
GROUP BY p.project_id;