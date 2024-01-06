USE DW;
GO

CREATE TABLE [dbo].[st_employees]
(
    [employee_id] INT NOT NULL,
    [first_name] NVARCHAR(20) NULL,
    [last_name] NVARCHAR(25) NOT NULL,
    [email] NVARCHAR(25) NOT NULL,
    [phone_number] NVARCHAR(20) NULL,
    [hire_date] DATE NOT NULL,
    [job_id] NVARCHAR(10) NOT NULL,
    [salary] FLOAT NULL,
    [commission_pct] FLOAT NULL,
    [manager_id] INT NULL,
    [department_id] INT NULL,
    [created_date] DATETIME
        DEFAULT GETDATE(),
    [updated_date] DATETIME NULL
);
GO

CREATE TABLE [dbo].[st_countries]
(
    [country_id] CHAR(2) NOT NULL,
    [country_name] NVARCHAR(40) NULL,
    [region_id] INT NULL,
    [created_date] DATETIME
        DEFAULT GETDATE(),
    [updated_date] DATETIME NULL
);
GO

CREATE TABLE [dbo].[st_departments]
(
    [department_id] INT NOT NULL,
    [department_name] NVARCHAR(30) NOT NULL,
    [manager_id] INT NULL,
    [location_id] INT NULL,
    [created_date] DATETIME
        DEFAULT GETDATE(),
    [updated_date] DATETIME NULL
);
GO

CREATE TABLE [dbo].[st_job_history]
(
    [employee_id] INT NOT NULL,
    [start_date] DATE NOT NULL,
    [end_date] DATE NOT NULL,
    [job_id] NVARCHAR(10) NOT NULL,
    [department_id] INT NULL,
    [created_date] DATETIME
        DEFAULT GETDATE(),
    [updated_date] DATETIME NULL
);
GO

CREATE TABLE [dbo].[st_jobs]
(
    [job_id] NVARCHAR(10) NOT NULL,
    [job_title] NVARCHAR(35) NOT NULL,
    [min_salary] FLOAT NULL,
    [max_salary] FLOAT NULL,
    [created_date] DATETIME
        DEFAULT GETDATE(),
    [updated_date] DATETIME NULL
);
GO

CREATE TABLE [dbo].[st_locations]
(
    [location_id] INT NOT NULL,
    [street_address] NVARCHAR(40) NULL,
    [postal_code] NVARCHAR(12) NULL,
    [city] NVARCHAR(30) NOT NULL,
    [state_province] NVARCHAR(25) NULL,
    [country_id] CHAR(2) NULL,
    [created_date] DATETIME
        DEFAULT GETDATE(),
    [updated_date] DATETIME NULL
);
GO

CREATE TABLE [dbo].[st_regions]
(
    [region_id] INT NOT NULL,
    [region_name] NVARCHAR(25) NULL,
    [created_date] DATETIME
        DEFAULT GETDATE(),
    [updated_date] DATETIME NULL
);
GO

SELECT COUNT(*)
FROM st_employees;
SELECT COUNT(*)
FROM st_departments;
SELECT COUNT(*)
FROM st_countries;
SELECT COUNT(*)
FROM st_job_history;
SELECT COUNT(*)
FROM st_jobs;
SELECT COUNT(*)
FROM st_locations;
SELECT COUNT(*)
FROM st_regions;

SELECT *
FROM st_departments;
SELECT *
FROM st_employees;
SELECT *
FROM st_locations;

CREATE TABLE [dbo].[dw_job_run_summary]
(
    [id] INT IDENTITY(1, 1) NOT NULL,
    [tablename] VARCHAR(100) NULL,
    [start_date_Time] DATETIME NULL,
    [end_date_Time] DATETIME NULL,
    [rows_processed] INT NULL,
    [status] VARCHAR(15) NULL,
    [error_message] VARCHAR(2000) NULL,
    [colid] BIGINT NULL,
    [job_run_id] INT NULL,
    [created_on] DATETIME NULL
        DEFAULT GETDATE()
);