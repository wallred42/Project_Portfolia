--TODO Refine the process a little bit and clean up the code a lot
--Imports and puts Employee Navigator XML files in SSMS
DECLARE @x xml 

SELECT @x=EE
FROM OPENROWSET (BULK 
	'J:\Clients\,FTP Files\Employee Navigator\Testing Info\SampleAfterChanges_Cafeteria_SimpleSolutions_v20.xml'
	,SINGLE_BLOB) AS EMPLOYEES(EE)

DECLARE @hdoc int

EXEC sp_xml_preparedocument @hdoc OUTPUT, @x

--Step 1 - First half of the Table
SELECT FirstName, LastName, SSN, 
	concat(Address1,' ',Address2) as Address, City, State, ZIP, Email, DOB as DateOfBirth, PhoneNumber, 
	PlanMap, 
	Max(StartDate) as StartDate 
INTO EmployerNavigator
FROM OPENXML(@hdoc,
	'Data/Companies/Company/Employees/Employee/Enrollments/Enrollment',
	2)
WITH(
	FirstName varchar(50) '../../FirstName',
	LastName varchar(50) '../../LastName',
	SSN varchar(12) '../../SSN',
	Address1 varchar(100) '../../Address1', 
	Address2 varchar(100) '../../Address2', 
	City varchar(30) '../../City',
	State varchar(20) '../../State',
	Zip int '../../ZIP',
	Email varchar(12) '../../Email',
	DOB datetime '../../DOB',
	PhoneNumber varchar(12) '../../Phone',
	PlanMap varchar(10), 
	EEPerPay float 'CafeteriaData/PerPayAmount',
	ERPerPay float 'CafeteriaData/EmployerPerPayAmount',
	AnnualElection float 'CafeteriaData/AnnualAmount',
	PayrollGroup varchar(50) '../../PayrollGroup',
	CoverageLevel varchar(50),
	StartDate datetime,
	OriginalStartDate datetime 'CafeteriaData/OriginalStartDate'
	)
GROUP BY FirstName, LastName, SSN, Address1, Address2, City, State, ZIP, Email, DOB, PhoneNumber,
	PlanMap
ORDER BY LastName



--Step 2 - 2nd half of Table
SELECT FirstName, LastName, SSN, PlanMap, EEPerPay, ERPerPay, AnnualElection, 
	PayrollGroup, CoverageLevel, StartDate, CASE WHEN TerminationDate = '1900-01-01 00:00:00.000' THEN '' 
    ELSE CONVERT(VARCHAR(10), TerminationDate, 101) 
    END AS TerminationDate
INTO EmployerNavigator2
FROM OPENXML(@hdoc,
	'Data/Companies/Company/Employees/Employee/Enrollments/Enrollment',
	2)
WITH(
	FirstName varchar(50) '../../FirstName',
	LastName varchar(50) '../../LastName',
	SSN varchar(12) '../../SSN',
	Address1 varchar(100) '../../Address1', 
	Address2 varchar(100) '../../Address2', 
	City varchar(30) '../../City',
	State varchar(20) '../../State',
	Zip int '../../ZIP',
	Email varchar(12) '../../Email',
	DOB datetime '../../DOB',
	PhoneNumber varchar(12) '../../Phone',
	PlanMap varchar(10), 
	EEPerPay float 'CafeteriaData/PerPayAmount',
	ERPerPay float 'CafeteriaData/EmployerPerPayAmount',
	AnnualElection float 'CafeteriaData/AnnualAmount',
	PayrollGroup varchar(50) '../../PayrollGroup',
	CoverageLevel varchar(50),
	StartDate datetime,
	OriginalStartDate datetime 'CafeteriaData/OriginalStartDate',
	TerminationDate datetime '../../TerminationDate' 
	)
ORDER BY LastName

--STEP 3 - Joining the Tables
SELECT en1.FirstName,
	en1.LastName,
	en1.SSN,
	en1.Address,
	en1.City,
	en1.State,
	en1.ZIP,
	en1.Email,
	FORMAT(en1.DateOfBirth,N'MM/dd/yyyy') AS DOB,
	en1.PhoneNumber,
	en1.PlanMap,
	en2.EEPerPay,
	en2.EEPerPay,
	en2.AnnualElection,
	en2.PayrollGroup,
	en2.CoverageLevel,
	FORMAT(en2.StartDate,N'MM/dd/yyyy') AS StartDate,
	' ',
	en2.TerminationDate
FROM EmployerNavigator en1
LEFT JOIN EmployerNavigator2 en2
ON en1.FirstName=en2.FirstName 
	AND en1.LastName=en2.LastName
	AND en1.SSN=en2.SSN
	AND en1.PlanMap=en2.PlanMap
	AND en1.StartDate=en2.StartDate
ORDER BY en1.LastName;

--Step 4: Removing EmployerNavigator 1 & 2
--Otherwise, it won't work the next time you try and run it.
DROP TABLE EmployerNavigator;
DROP TABLE EmployerNavigator2;

--TEST: If at any time you'd like to see what the tables contain
--SELECT * FROM EmployerNavigator;
--SELECT * FROM EmployerNavigator2;

EXEC sp_xml_removedocument @hdoc;