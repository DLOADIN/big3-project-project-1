CREATE TABLE audit_worker_changes (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  worker_id INT,
  changed_field VARCHAR(50),
  old_value VARCHAR(100),
  new_value VARCHAR(100),
  change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //
CREATE TRIGGER trg_after_update_worker
AFTER UPDATE ON workers
FOR EACH ROW
BEGIN
  IF OLD.role != NEW.role THEN
    INSERT INTO audit_worker_changes (worker_id, changed_field, old_value, new_value)
    VALUES (NEW.worker_id, 'role', OLD.role, NEW.role);
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_before_insert_certification
BEFORE INSERT ON certifications
FOR EACH ROW
BEGIN
  IF NEW.expiry_date < CURDATE() THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot insert expired certification';
  END IF;
END //
DELIMITER ;