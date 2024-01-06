CREATE TABLE DimLocations
(
    LocationDimKey INT IDENTITY(1, 1),
    LocationId INT,
    StreetAddress VARCHAR(255),
    PostalCode VARCHAR(255),
    City VARCHAR(50),
    State VARCHAR(50),
    CountryName VARCHAR(50),
    RegionName VARCHAR(50),
    CreatedOn DATETIME2(3)
        DEFAULT GETDATE(),
    UpdatedOn DATETIME2(3)
        DEFAULT GETDATE()
);

CREATE TABLE DimDepartments
(
    DepartmentsDimKey INT IDENTITY(1, 1),
    DepartmentId INT,
    DepartmentName VARCHAR(50),
    CreatedOn DATETIME2(3)
        DEFAULT GETDATE(),
    UpdatedOn DATETIME2(3)
        DEFAULT GETDATE()
);

CREATE TABLE DimJobs
(
    JobDimKey INT IDENTITY(1, 1),
    JobId VARCHAR(60),
    JobTitle VARCHAR(60),
    MinSalary INT,
    MaxSalary INT
);

CREATE TABLE DimDate
(
    DateDimKey INT,
    calendar_date VARCHAR(10),
    month_id SMALLINT,
    month_desc VARCHAR(15),
    qurater_id SMALLINT,
    qurater_desc VARCHAR(6),
    year_id INT,
    day_number_of_week SMALLINT,
    day_of_week_desc VARCHAR(15),
    day_number_of_month SMALLINT,
    day_number_of_year SMALLINT,
    week_number_of_year SMALLINT,
    year_month VARCHAR(7)
);

CREATE TABLE DimEmployees
(
    EmployeesDimKey INT IDENTITY(1, 1),
    EmployeeId INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(50),
    PhoneNumber VARCHAR(50),
    HireDate INT,
    CreatedOn DATETIME2(3)
        DEFAULT GETDATE(),
    UpdatedOn DATETIME2(3)
        DEFAULT GETDATE()
);

CREATE TABLE DimManagers
(
    ManagerDimKey INT IDENTITY(1, 1),
    EmployeeId INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(50),
    PhoneNumber VARCHAR(50),
    HireDate INT,
    CreatedOn DATETIME2(3)
        DEFAULT GETDATE(),
    UpdatedOn DATETIME2(3)
        DEFAULT GETDATE()
);
