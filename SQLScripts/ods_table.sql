CREATE TABLE ODS_HR
(
    id INT IDENTITY(1, 1) PRIMARY KEY,
    employee_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(60),
    phone_number VARCHAR(30),
    start_date DATETIME2(3),
    end_date DATETIME2(3),
    job_id VARCHAR(30),
    manager_id INT,
    department_id INT,
    department_name VARCHAR(50),
    location_id INT,
    city VARCHAR(50),
    state_province VARCHAR(50),
    country_name VARCHAR(50),
    region_name VARCHAR(50),
    salary DECIMAL(13, 2),
    commission_pct DECIMAL(5, 2),
    createdon DATETIME2(3)
        DEFAULT GETDATE(),
    updatedon DATETIME2(3)
        DEFAULT GETDATE()
);