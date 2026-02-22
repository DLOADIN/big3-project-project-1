
DELIMITER //
CREATE PROCEDURE sp_add_worker_with_skill(
  IN p_first_name VARCHAR(50),
  IN p_last_name VARCHAR(50),
  IN p_hire_date DATE,
  IN p_role VARCHAR(50),
  IN p_skill_name VARCHAR(50),
  IN p_acquired_date DATE
)
BEGIN
  DECLARE v_skill_id INT;
  
  INSERT INTO workers (first_name, last_name, hire_date, role)
  VALUES (p_first_name, p_last_name, p_hire_date, p_role);
  
  DECLARE v_worker_id INT DEFAULT LAST_INSERT_ID();
  
  SELECT skill_id INTO v_skill_id FROM skills WHERE skill_name = p_skill_name;
  IF v_skill_id IS NULL THEN
    INSERT INTO skills (skill_name) VALUES (p_skill_name);
    SET v_skill_id = LAST_INSERT_ID();
  END IF;
  
  INSERT INTO worker_skills (worker_id, skill_id, acquired_date)
  VALUES (v_worker_id, v_skill_id, p_acquired_date);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_assign_worker_to_project(
  IN p_project_id INT,
  IN p_worker_id INT,
  IN p_start_date DATE,
  IN p_end_date DATE,
  OUT p_message VARCHAR(100)
)
BEGIN
  IF NOT EXISTS (SELECT 1 FROM projects WHERE project_id = p_project_id) THEN
    SET p_message = 'Error: Project not found';
  ELSEIF NOT EXISTS (SELECT 1 FROM workers WHERE worker_id = p_worker_id) THEN
    SET p_message = 'Error: Worker not found';
  ELSEIF EXISTS (SELECT 1 FROM project_assignments WHERE worker_id = p_worker_id AND (start_date <= p_end_date AND end_date >= p_start_date)) THEN
    SET p_message = 'Error: Worker already assigned during this period';
  ELSE
    INSERT INTO project_assignments (project_id, worker_id, start_date, end_date)
    VALUES (p_project_id, p_worker_id, p_start_date, p_end_date);
    SET p_message = 'Success: Worker assigned';
  END IF;
END //
DELIMITER ;