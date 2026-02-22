CREATE TABLE archived_projects LIKE projects;

DELIMITER //
CREATE EVENT evt_archive_completed_projects
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
  START TRANSACTION;
  INSERT INTO archived_projects
  SELECT * FROM projects
  WHERE status = 'completed' AND end_date < CURDATE() - INTERVAL 30 DAY;
  
  DELETE FROM projects
  WHERE status = 'completed' AND end_date < CURDATE() - INTERVAL 30 DAY;
  
  COMMIT;
END //
DELIMITER ;