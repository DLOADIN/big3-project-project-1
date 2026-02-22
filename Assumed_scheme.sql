CREATE DATABASE big3_construction;
USE big3_construction;

CREATE TABLE projects (
  project_id INT PRIMARY KEY AUTO_INCREMENT,
  project_name VARCHAR(100) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  budget DECIMAL(12,2) NOT NULL,
  status ENUM('active', 'completed', 'pending') DEFAULT 'active'
);

CREATE TABLE workers (
  worker_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  hire_date DATE NOT NULL,
  role VARCHAR(50) NOT NULL
);

CREATE TABLE skills (
  skill_id INT PRIMARY KEY AUTO_INCREMENT,
  skill_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE worker_skills (
  worker_id INT,
  skill_id INT,
  acquired_date DATE,
  PRIMARY KEY (worker_id, skill_id),
  FOREIGN KEY (worker_id) REFERENCES workers(worker_id) ON DELETE CASCADE,
  FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE
);

CREATE TABLE project_assignments (
  assignment_id INT PRIMARY KEY AUTO_INCREMENT,
  project_id INT NOT NULL,
  worker_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  hours_worked DECIMAL(5,2),
  FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
  FOREIGN KEY (worker_id) REFERENCES workers(worker_id) ON DELETE CASCADE
);

CREATE TABLE certifications (
  cert_id INT PRIMARY KEY AUTO_INCREMENT,
  worker_id INT NOT NULL,
  cert_name VARCHAR(100) NOT NULL,
  issue_date DATE NOT NULL,
  expiry_date DATE NOT NULL,
  FOREIGN KEY (worker_id) REFERENCES workers(worker_id) ON DELETE CASCADE
);

CREATE TABLE expenses (
  expense_id INT PRIMARY KEY AUTO_INCREMENT,
  project_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  description VARCHAR(200),
  expense_date DATE NOT NULL,
  FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE
);