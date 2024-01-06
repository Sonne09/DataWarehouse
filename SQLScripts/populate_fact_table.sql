-- First Approach using staging table

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
       emp.salary,
       emp.commission_pct
FROM st_employees emp
    JOIN DimEmployees dimEmp
        ON emp.employee_id = dimEmp.EmployeeId
           AND REPLACE(CAST(emp.hire_date AS DATE), '-', '') = dimEmp.HireDate
    LEFT JOIN DimManagers dimMgr
        ON dimMgr.ManagerId = emp.manager_id
    LEFT JOIN DimJobs dimJobs
        ON dimJobs.JobId = emp.job_id
    LEFT JOIN DimDepartments dimDept
        ON dimDept.DepartmentId = emp.department_id
    LEFT JOIN st_departments stDep
        ON stDep.department_id = emp.department_id
    LEFT JOIN st_locations stLoc
        ON stLoc.location_id = stDep.location_id
    LEFT JOIN DimLocations dimLoc
        ON dimLoc.LocationId = stLoc.location_id;



-- Second approach using ODS table

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
FROM ODS_HR ods
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