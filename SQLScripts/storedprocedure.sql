-- Load ODS
CREATE OR ALTER PROCEDURE load_ods
AS
BEGIN
    DECLARE @ODSRecordCount INT;
    SELECT @ODSRecordCount = COUNT(*)
    FROM dbo.ODS_HR;
    IF (@ODSRecordCount = 0)
    BEGIN
        INSERT INTO ODS_HR
        (
            employee_id,
            first_name,
            last_name,
            email,
            phone_number,
            start_date,
            end_date,
            job_id,
            manager_id,
            department_id,
            department_name,
            location_id,
            city,
            state_province,
            country_name,
            region_name
        )
        SELECT emp.employee_id,
               emp.first_name,
               emp.last_name,
               emp.email,
               emp.phone_number,
               jobhistory.start_date,
               jobhistory.end_date,
               jobhistory.job_id,
               NULL AS manager_id,
               jobhistory.department_id,
               dep.department_name,
               dep.location_id,
               loc.city,
               loc.state_province,
               country.country_name,
               reg.region_name
        FROM st_job_history jobhistory
            LEFT JOIN st_employees emp
                ON jobhistory.employee_id = emp.employee_id
            LEFT JOIN st_departments dep
                ON jobhistory.department_id = dep.department_id
            LEFT JOIN st_locations loc
                ON loc.location_id = dep.location_id
            LEFT JOIN st_countries country
                ON country.country_id = loc.country_id
            LEFT JOIN st_regions reg
                ON reg.region_id = country.region_id
            LEFT JOIN st_jobs jobs
                ON jobs.job_id = emp.job_id;
    END;

    BEGIN
        INSERT INTO ODS_HR
        (
            employee_id,
            first_name,
            last_name,
            email,
            phone_number,
            start_date,
            end_date,
            job_id,
            manager_id,
            department_id,
            department_name,
            location_id,
            city,
            state_province,
            country_name,
            region_name
        )
        SELECT emp.employee_id,
               emp.first_name,
               emp.last_name,
               emp.email,
               emp.phone_number,
               emp.hire_date AS start_date,
               NULL AS end_date,
               emp.job_id,
               emp.manager_id,
               emp.department_id,
               dep.department_name,
               dep.location_id,
               loc.city,
               loc.state_province,
               country.country_name,
               reg.region_name
        FROM st_employees emp
            LEFT JOIN st_departments dep
                ON emp.department_id = dep.department_id
            LEFT JOIN st_locations loc
                ON loc.location_id = dep.location_id
            LEFT JOIN st_countries country
                ON country.country_id = loc.country_id
            LEFT JOIN st_regions reg
                ON reg.region_id = country.region_id
            LEFT JOIN st_jobs jobs
                ON jobs.job_id = emp.job_id
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM ODS_HR ods
            WHERE ods.employee_id = emp.employee_id
                  AND ods.start_date = emp.hire_date
                  AND ods.job_id = emp.job_id
                  AND ods.department_id = emp.department_id
        );

        UPDATE ods
        SET ods.first_name = Emp.first_name,
            ods.last_name = Emp.last_name,
            ods.email = Emp.email,
            ods.phone_number = Emp.phone_number,
            ods.updatedOn = GETDATE()
        FROM ODS_HR ods
            JOIN
            (
                SELECT emp.employee_id,
                       emp.first_name,
                       emp.last_name,
                       emp.email,
                       emp.phone_number,
                       emp.hire_date AS start_date,
                       NULL AS end_date,
                       emp.job_id,
                       emp.manager_id,
                       emp.department_id,
                       dep.department_name,
                       dep.location_id,
                       loc.city,
                       loc.state_province,
                       country.country_name,
                       reg.region_name
                FROM st_employees emp
                    LEFT JOIN st_departments dep
                        ON emp.department_id = dep.department_id
                    LEFT JOIN st_locations loc
                        ON loc.location_id = dep.location_id
                    LEFT JOIN st_countries country
                        ON country.country_id = loc.country_id
                    LEFT JOIN st_regions reg
                        ON reg.region_id = country.region_id
                    LEFT JOIN st_jobs jobs
                        ON jobs.job_id = emp.job_id
            ) Emp
                ON ods.employee_id = Emp.employee_id
                   AND ods.start_date = Emp.start_date
                   AND ods.job_id = Emp.job_id
                   AND ods.department_id = Emp.department_id;
    END;
END;


-- Modified to exclude job history
USE [DW]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[load_ods]
AS
BEGIN

    --DECLARE @ODSRecordCount INT;
    --	SELECT @ODSRecordCount = COUNT(*) FROM dbo.ODS_HR
    --	IF (@ODSRecordCount = 0)
    --	BEGIN
    --		INSERT INTO ODS_HR (
    --			  employee_id		
    --			, first_name		
    --			, last_name			
    --			, email				
    --			, phone_number		
    --			, start_date			
    --			, end_date			
    --			, job_id			
    --			, manager_id		
    --			, department_id		
    --			, department_name	
    --			, location_id		
    --			, city				
    --			, state_province	
    --			, country_name		
    --			, region_name
    --			)
    --		SELECT emp.employee_id
    --			, emp.first_name
    --			, emp.last_name
    --			, emp.email
    --			, emp.phone_number
    --			, jobhistory.start_date
    --			, jobhistory.end_date
    --			, jobhistory.job_id
    --			, NULL AS manager_id
    --			, jobhistory.department_id
    --			, dep.department_name
    --			, dep.location_id
    --			, loc.city
    --			, loc.state_province
    --			, country.country_name
    --			, reg.region_name
    --		FROM st_job_history jobhistory
    --		LEFT JOIN st_employees emp
    --			ON jobhistory.employee_id = emp.employee_id
    --		LEFT JOIN st_departments dep 
    --			ON jobhistory.department_id = dep.department_id
    --		LEFT JOIN st_locations loc
    --			ON loc.location_id = dep.location_id
    --		LEFT JOIN st_countries country
    --			ON country.country_id = loc.country_id
    --		LEFT JOIN st_regions reg
    --			ON reg.region_id = country.region_id
    --		LEFT JOIN st_jobs jobs
    --			ON jobs.job_id = emp.job_id
    --
    --	END;

    BEGIN
        INSERT INTO ODS_HR
        (
            employee_id,
            first_name,
            last_name,
            email,
            phone_number,
            start_date,
            end_date,
            job_id,
            manager_id,
            department_id,
            department_name,
            location_id,
            city,
            state_province,
            country_name,
            region_name,
            salary,
            commission_pct
        )
        SELECT emp.employee_id,
               emp.first_name,
               emp.last_name,
               emp.email,
               emp.phone_number,
               emp.hire_date AS start_date,
               NULL AS end_date,
               emp.job_id,
               emp.manager_id,
               emp.department_id,
               dep.department_name,
               dep.location_id,
               loc.city,
               loc.state_province,
               country.country_name,
               reg.region_name,
               emp.salary,
               emp.commission_pct
        FROM st_employees emp
            LEFT JOIN st_departments dep
                ON emp.department_id = dep.department_id
            LEFT JOIN st_locations loc
                ON loc.location_id = dep.location_id
            LEFT JOIN st_countries country
                ON country.country_id = loc.country_id
            LEFT JOIN st_regions reg
                ON reg.region_id = country.region_id
            LEFT JOIN st_jobs jobs
                ON jobs.job_id = emp.job_id
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM ODS_HR ods
            WHERE ods.employee_id = emp.employee_id
                  AND ods.start_date = emp.hire_date
                  AND ods.job_id = emp.job_id
                  AND ods.department_id = emp.department_id
        )

        UPDATE ods
        SET ods.first_name = Emp.first_name,
            ods.last_name = Emp.last_name,
            ods.email = Emp.email,
            ods.phone_number = Emp.phone_number,
            ods.updatedOn = GETDATE()
        FROM ODS_HR ods
            JOIN
            (
                SELECT emp.employee_id,
                       emp.first_name,
                       emp.last_name,
                       emp.email,
                       emp.phone_number,
                       emp.hire_date AS start_date,
                       NULL AS end_date,
                       emp.job_id,
                       emp.manager_id,
                       emp.department_id,
                       dep.department_name,
                       dep.location_id,
                       loc.city,
                       loc.state_province,
                       country.country_name,
                       reg.region_name
                FROM st_employees emp
                    LEFT JOIN st_departments dep
                        ON emp.department_id = dep.department_id
                    LEFT JOIN st_locations loc
                        ON loc.location_id = dep.location_id
                    LEFT JOIN st_countries country
                        ON country.country_id = loc.country_id
                    LEFT JOIN st_regions reg
                        ON reg.region_id = country.region_id
                    LEFT JOIN st_jobs jobs
                        ON jobs.job_id = emp.job_id
            ) Emp
                ON ods.employee_id = Emp.employee_id
                   AND ods.start_date = Emp.start_date
                   AND ods.job_id = Emp.job_id
                   AND ods.department_id = Emp.department_id
    END;

END;



-- Load Dimensional Tables

-- Location Dimension
CREATE OR ALTER PROCEDURE loadDimLoc
AS
BEGIN
    BEGIN
        INSERT INTO DimLocations
        (
            LocationId,
            StreetAddress,
            PostalCode,
            City,
            State,
            CountryName,
            RegionName
        )
        SELECT loc.location_id,
               loc.street_address,
               loc.postal_code,
               loc.city,
               loc.state_province,
               country.country_name,
               reg.region_name
        FROM st_locations loc
            JOIN st_countries country
                ON loc.country_id = country.country_id
            JOIN st_regions reg
                ON reg.region_id = country.region_id
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM DimLocations dimloc
            WHERE dimloc.LocationId = loc.location_id
        )
    END;

    BEGIN
        UPDATE dimloc
        SET dimloc.City = loc.city,
            dimloc.CountryName = loc.country_name,
            dimloc.PostalCode = loc.postal_code,
            dimloc.RegionName = loc.region_name,
            dimloc.State = loc.state_province,
            dimloc.StreetAddress = loc.street_address,
            dimloc.UpdatedOn = GETDATE()
        FROM DimLocations dimloc
            JOIN
            (
                SELECT loc.location_id,
                       loc.street_address,
                       loc.postal_code,
                       loc.city,
                       loc.state_province,
                       country.country_name,
                       reg.region_name
                FROM st_locations loc
                    JOIN st_countries country
                        ON loc.country_id = country.country_id
                    JOIN st_regions reg
                        ON reg.region_id = country.region_id
            ) loc
                ON dimloc.LocationId = loc.location_id
    END;
END;

-- Department Dimension
CREATE OR ALTER PROCEDURE loadDimDep
AS
BEGIN
    BEGIN
        INSERT INTO DimDepartments
        (
            DepartmentId,
            DepartmentName
        )
        SELECT department_id,
               department_name
        FROM st_departments dep
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM DimDepartments dimdep
            WHERE dimdep.DepartmentName = dep.department_name
        )
    END;
END;


-- Job Dimension
CREATE OR ALTER PROCEDURE loadDimJob
AS
BEGIN
    BEGIN
        INSERT INTO DimJobs
        (
            JobId,
            JobTitle,
            MinSalary,
            MaxSalary
        )
        SELECT job_id,
               job_title,
               min_salary,
               max_salary
        FROM st_jobs jobs
        WHERE NOT EXISTS
        (
            SELECT 1 FROM DimJobs dimjobs WHERE dimjobs.JobId = jobs.job_id
        )
    END;

    BEGIN
        UPDATE dimjobs
        SET dimJobs.JobTitle = jobs.job_title,
            dimJobs.MinSalary = jobs.min_salary,
            dimJobs.MaxSalary = jobs.max_salary,
            dimJobs.UpdatedOn = GETDATE()
        FROM DimJobs dimjobs
            JOIN
            (SELECT job_id, job_title, min_salary, max_salary FROM st_jobs jobs) jobs
                ON dimjobs.JobId = jobs.job_id
    END;
END;
-- Load Employee Dimension
CREATE OR ALTER PROCEDURE LoadDimEmp
AS
BEGIN
    BEGIN
        INSERT INTO DimEmployees
        (
            EmployeeId,
            FirstName,
            LastName,
            Email,
            PhoneNumber,
            HireDate
        )
        SELECT emp.employee_id,
               emp.first_name,
               emp.last_name,
               emp.email,
               emp.phone_number,
               REPLACE(CAST(emp.hire_date AS DATE), '-', '') AS HireDate
        FROM st_employees emp
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM DimEmployees dimEmp
            WHERE dimEmp.EmployeeId = emp.employee_id
                  AND dimEmp.HireDate = REPLACE(CAST(emp.hire_date AS DATE), '-', '')
        );
    END;

    BEGIN
        UPDATE dimEmp
        SET dimEmp.FirstName = emp.first_name,
            dimEmp.LastName = emp.last_name,
            dimEmp.Email = emp.email,
            dimEmp.PhoneNumber = emp.phone_number,
            dimEmp.UpdatedOn = GETDATE()
        FROM DimEmployees dimEmp
            JOIN
            (
                SELECT emp.employee_id,
                       emp.first_name,
                       emp.last_name,
                       emp.email,
                       emp.phone_number,
                       REPLACE(CAST(emp.hire_date AS DATE), '-', '') AS HireDate
                FROM st_employees emp
            ) emp
                ON dimEmp.EmployeeId = emp.employee_id
                   AND dimEmp.HireDate = emp.HireDate;
    END;
END;

-- Load manager Dimension
CREATE OR ALTER PROCEDURE LoadDimMgr
AS
BEGIN
    BEGIN
        INSERT INTO DimManagers
        (
            ManagerId,
            FirstName,
            LastName,
            Email,
            PhoneNumber,
            HireDate
        )
        SELECT mgr.employee_id,
               mgr.first_name,
               mgr.last_name,
               mgr.email,
               mgr.phone_number,
               REPLACE(CAST(mgr.hire_date AS DATE), '-', '') AS HireDate
        FROM st_employees mgr
        WHERE mgr.employee_id IN (
                                     SELECT manager_id FROM st_employees GROUP BY manager_id
                                 )
              AND NOT EXISTS
        (
            SELECT 1
            FROM DimManagers dimMgr
            WHERE dimMgr.ManagerId = mgr.employee_id
                  AND dimMgr.HireDate = REPLACE(CAST(mgr.hire_date AS DATE), '-', '')
        );
    END;

    BEGIN
        UPDATE dimMgr
        SET dimMgr.FirstName = mgr.first_name,
            dimMgr.LastName = mgr.last_name,
            dimMgr.Email = mgr.email,
            dimMgr.PhoneNumber = mgr.phone_number,
            dimMgr.UpdatedOn = GETDATE()
        FROM DimManagers dimMgr
            INNER JOIN
            (
                SELECT mgr.employee_id,
                       mgr.first_name,
                       mgr.last_name,
                       mgr.email,
                       mgr.phone_number,
                       REPLACE(CAST(mgr.hire_date AS DATE), '-', '') AS HireDate
                FROM st_employees mgr
                WHERE mgr.employee_id IN (
                                             SELECT manager_id FROM st_employees GROUP BY manager_id
                                         )
            ) mgr
                ON dimMgr.ManagerId = mgr.employee_id
                   AND dimMgr.HireDate = mgr.HireDate;
    END;
END;

-- Load Fact Table
CREATE OR ALTER PROCEDURE LoadFactHR
AS
BEGIN
    SELECT *
    INTO #ODS
    FROM ODS_HR;

    TRUNCATE TABLE FactHR;

    BEGIN
        INSERT INTO FactHR
        (
            EmployeesDimKey,
            ManagerDimKey,
            JobDimKey,
            DepartmentsDimKey,
            LocationDimKey,
            Salary,
            Commission_PCT
        )
        SELECT dimEmp.EmployeesDimKey,
               COALESCE(dimMgr.ManagerDimKey, 0) AS ManagerDimKey,
               dimJobs.JobDimKey,
               COALESCE(dimDept.DepartmentsDimKey, 0) AS DepartmentsDimKey,
               COALESCE(dimLoc.LocationDimKey, 0) AS LocationDimKey,
               ods.salary,
               ods.commission_pct
        FROM #ODS ods
            JOIN DimEmployees dimEmp
                ON ods.employee_id = dimEmp.EmployeeId
                   AND REPLACE(CAST(ods.start_date AS DATE), '-', '') = dimEmp.HireDate
            LEFT JOIN DimManagers dimMgr
                ON dimMgr.ManagerId = ods.manager_id
            LEFT JOIN DimJobs dimJobs
                ON dimJobs.JobId = ods.job_id
            LEFT JOIN DimDepartments dimDept
                ON dimDept.DepartmentId = ods.department_id
            LEFT JOIN DimLocations dimLoc
                ON dimLoc.LocationId = ods.location_id;
    END;
END;