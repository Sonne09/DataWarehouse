CREATE TABLE FactHR
(
    EmployeeDimKey INT,
    ManagerDimKey INT,
    JobDimKey INT,
    DepartmentsDimKey INT,
    LocationDimKey INT,
    Salary DECIMAL(13, 2),
    Commission_PCT DECIMAL(5, 2),
    CREATEdOn DATETIME2(3)
        DEFAULT GETDATE(),
    UpdatedOn DATETIME2(3)
        DEFAULT GETDATE()
);