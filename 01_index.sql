-- Guided Activity: Simple Index
-- Sample query: Retrieve assignments for a specific project
EXPLAIN SELECT * FROM project_assignments WHERE project_id = 1;

CREATE INDEX idx_project_assignments_project_id ON project_assignments(project_id);

EXPLAIN SELECT * FROM project_assignments WHERE project_id = 1;

EXPLAIN SELECT * FROM project_assignments WHERE project_id = 1 ORDER BY start_date;

CREATE INDEX idx_project_assignments_project_start ON project_assignments(project_id, start_date);

EXPLAIN SELECT * FROM project_assignments WHERE project_id = 1 ORDER BY start_date;