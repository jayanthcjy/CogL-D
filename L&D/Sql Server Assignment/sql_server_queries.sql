use Joy

-- Data Integrity and Constraints
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL,
    DepartmentLocation VARCHAR(50)
);

CREATE TABLE Employees(
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Age INT CHECK (Age >= 18),
    DepartmentID INT,
    CONSTRAINT FK_Department FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Insert sample data into Departments
INSERT INTO Departments (DepartmentID, DepartmentName, DepartmentLocation)
VALUES (1, 'IT', 'New York'), (2, 'HR', 'Chicago'), (3, 'Finance', 'San Francisco');

-- Insert sample data into Employees
INSERT INTO Employees (EmployeeID, EmployeeName, Email, Age, DepartmentID)
VALUES (101, 'Alice', 'alice@example.com', 30, 1),
       (102, 'Bob', 'bob@example.com', 24, 2),
       (103, 'Charlie', 'charlie@example.com', 28, 3);







-- Security and Authentication
-- Creating a login and a user for the database
CREATE LOGIN user6 WITH PASSWORD = 'user6';
CREATE USER user9 FOR LOGIN user6;



-- Assigning user roles (e.g., db_owner, db_reader)
ALTER ROLE db_owner ADD MEMBER user9;
-- Assigning db_datareader role
--ALTER ROLE db_datareader ADD MEMBER user9;

-- Grant, Revoke, and Deny Permissions
-- Grant SELECT permission on Employees table to user6
GRANT SELECT ON Employees TO user9;

-- Deny INSERT permission on Employees table to user6
DENY INSERT ON Employees TO user9;

-- Revoke permission (in case it was granted earlier)
REVOKE SELECT ON Employees FROM user9;

--execute as user='user9'







-- Normalization
-- Before normalization: Employees and Departments combined
CREATE TABLE CombinedTable (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(50),
    DepartmentName VARCHAR(50),
    DepartmentLocation VARCHAR(50)
);

-- Insert data into CombinedTable (denormalized)
INSERT INTO CombinedTable (EmployeeID, EmployeeName, DepartmentName, DepartmentLocation)
VALUES (101, 'Alice', 'IT', 'New York'),
       (102, 'Bob', 'HR', 'Chicago'),
       (103, 'Charlie', 'Finance', 'San Francisco');




-- Backup and Recovery

ALTER DATABASE Joy
SET RECOVERY FULL;

-- Full Backup
BACKUP DATABASE Joy
TO DISK = 'C:\Backups\MyDatabase.bak';

-- Differential Backup
BACKUP DATABASE Joy
TO DISK = 'C:\Backups\MyDatabase_diff.bak' 
WITH DIFFERENTIAL;

-- Transaction Log Backup
BACKUP LOG Joy
TO DISK = 'C:\Backups\MyDatabase_log.bak';


-- Restoration
-- Restore full backup
RESTORE DATABASE Jayanth
FROM DISK = 'C:\Backups\MyDatabase.bak';

-- Restore differential backup
RESTORE DATABASE Jayanth
FROM DISK = 'C:\Backups\MyDatabase_diff.bak'
WITH NORECOVERY;


RESTORE DATABASE Joy
FROM DISK = 'C:\Backups\MyDatabase_log.bak'
WITH RECOVERY;

