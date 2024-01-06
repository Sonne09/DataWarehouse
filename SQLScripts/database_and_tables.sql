CREATE DATABASE HR;
GO

USE HR;
GO

CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region_name NVARCHAR(25)
);

CREATE TABLE countries (
    country_id CHAR(2) PRIMARY KEY,
    country_name NVARCHAR(40),
    region_id INT,
    CONSTRAINT FK_region_id FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    street_address NVARCHAR(40),
    postal_code NVARCHAR(12),
    city NVARCHAR(30) NOT NULL,
    state_province NVARCHAR(25),
    country_id CHAR(2),
    CONSTRAINT FK_country_id FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

CREATE SEQUENCE locations_seq
  START WITH 3300
  INCREMENT BY 100
  MAXVALUE 9900
  NO CYCLE
  NO CACHE;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name NVARCHAR(30) NOT NULL,
    manager_id INT,
    location_id INT,
    CONSTRAINT FK_Locations_Departments FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE SEQUENCE departments_seq
  START WITH 280
  INCREMENT BY 10
  MAXVALUE 9990
  NO CYCLE
  NO CACHE;

CREATE TABLE jobs (
    job_id NVARCHAR(10) PRIMARY KEY,
    job_title NVARCHAR(35) NOT NULL,
    min_salary FLOAT,
    max_salary FLOAT
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name NVARCHAR(20),
    last_name NVARCHAR(25) NOT NULL,
    email NVARCHAR(25) NOT NULL,
    phone_number NVARCHAR(20),
    hire_date DATE NOT NULL,
    job_id NVARCHAR(10) NOT NULL,
    salary FLOAT,
    commission_pct FLOAT,
    manager_id INT,
    department_id INT,
    CONSTRAINT emp_salary_min CHECK (salary > 0),
    CONSTRAINT emp_email_uk UNIQUE (email),
    CONSTRAINT FK_departments FOREIGN KEY (department_id) REFERENCES departments(department_id),
    CONSTRAINT FK_jobs FOREIGN KEY (job_id) REFERENCES jobs(job_id)
);

CREATE SEQUENCE employees_seq
  START WITH 207
  INCREMENT BY 1
  NO CYCLE
  NO CACHE;

CREATE TABLE job_history (
    employee_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    job_id NVARCHAR(10) NOT NULL,
    department_id INT,
    CONSTRAINT PK_job_history PRIMARY KEY (employee_id, start_date),
    CONSTRAINT FK_employees FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT jhist_date_interval CHECK (end_date > start_date)
);

CREATE VIEW emp_details_view AS
SELECT
    e.employee_id, 
    e.job_id, 
    e.manager_id, 
    e.department_id,
    d.location_id,
    l.country_id,
    e.first_name,
    e.last_name,
    e.salary,
    e.commission_pct,
    d.department_name,
    j.job_title,
    l.city,
    l.state_province,
    c.country_name,
    r.region_name
FROM
    employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id
JOIN regions r ON c.region_id = r.region_id;