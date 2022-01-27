--Combined Billing Query

--See D_F_Billing TO DO List for refactoring tasks
    --UNION vs FULL OUTER JOIN

USE AllData_RockyMountainReserveLLC
GO

DECLARE @MONTH varchar(2)
SET @MONTH = '05'
DECLARE @YEAR varchar(4)
SET @YEAR = '2021'
DECLARE @DATE varchar(29)
SET @DATE = @YEAR+'-'+@MONTH+'-01 00:00:00.000'

--Active NPM (114679)
SELECT DISTINCT ClientName,cd.DivisionName, n.FirstName, n.LastName,n.SSN, 
--n.EnteredDateTime as 'NPM DateTime', 
--q.EnteredDateTime as 'QB DateTime',
'Active NPM' as Type
FROM NPM n
LEFT JOIN ClientDivision cd
    ON n.ClientDivisionID = cd.ClientDivisionID
    AND cd.DivisionName NOT LIKE 'zzz%'
LEFT JOIN Client c
    ON cd.ClientID = c.ClientID
LEFT JOIN QB q
    ON n.SSN = q.SSN 
    AND c.ClientID = q.ClientID
    AND q.LastName NOT LIKE 'zzz%'
    AND q.EnteredDateTime < @DATE
LEFT JOIN ClientProcess cp --To filter out clients who have been deactived
    ON c.ClientID = cp.ClientID 
WHERE q.SSN IS NULL 
    AND cp.ClientDeactivationDate IS NULL
    AND c.ClientGroupID not IN (1) 
    AND ClientName NOT LIKE 'zzz%'
    AND n.LastName NOT LIKE 'zzz%' 
    AND cd.DivisionName NOT LIKE 'zzz%'
    AND n.HasWaivedAllCoverage = '0'
    AND n.EnteredDateTime < @DATE
    --AND c.ClientName LIKE '%Compassion%'

UNION --ALL: (126100)/Just Union: (118765)

-- Rehired NPM (11421)
SELECT DISTINCT c.ClientName,cd.DivisionName, n.FirstName, n.LastName,n.SSN,
--n.EnteredDateTime as 'NPM DateTime', 
--q.EnteredDateTime as 'QB DateTime',
 'Rehired NPM' as Type
FROM NPM n
LEFT JOIN ClientDivision cd
    ON CD.ClientDivisionID = n.ClientDivisionID
LEFT JOIN Client c
    ON cd.ClientID = c.ClientID
INNER JOIN QB q
    ON n.SSN=q.SSN 
    AND c.ClientID = q.ClientID
    AND q.LastName NOT LIKE 'zzz%'
LEFT JOIN ClientProcess cp --To filter out clients who have been deactived
    ON c.ClientID = cp.ClientID 
WHERE cp.ClientDeactivationDate IS NULL
    AND c.ClientGroupID not IN (1)
    AND ClientName NOT LIKE 'zzz%'
    AND n.LastName NOT LIKE 'zzz%' 
    AND cd.DivisionName NOT LIKE 'zzz%'
    AND n.HasWaivedAllCoverage = '0'
    AND n.EnteredDateTime > q.EnteredDateTime --This should pick only the Rehires
    AND n.EnteredDateTime < @DATE 
    --AND c.ClientName LIKE '%Compassion%'
ORDER BY ClientName;