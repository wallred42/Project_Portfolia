--Carrier Notifications Processed
USE AllData_RockyMountainReserveLLC
GO

-- SELECT * FROM ClientPlanQBEmailList;

-- SELECT * FROM CarrierContact--QBPlan;
-- ORDER BY CarrierID;

SELECT 
c.ClientName as 'Client Name', cd.DivisionName as 'Division Name', 
concat(cc.LastName,', ',cc.FirstName) as 'Carrier Contact Full Name',cc.Title, cc.Department, 
cc.Email, cc.Phone, cc.PhoneExtension as 'Extension', cc.Fax, cc.Address1 as 'Address',
cc.Address2, cc.City, cc.State as 'State or Province', cc.Country, cc.WebLink as 'Web Link',
qbp.PlanName as 'Plan Name', format(cn.ProcessedDate, 'MM/dd/yyyy hh:mm tt') as 'Generated Date Time',
--the contact information may be from the client
qbp.CarrierPlanIdentification as 'CarrierPlanIdentification' /*cpqb.CarrierPlanIdentification*/, 
cr.CarrierName as 'Carrier Name', cn.CarrierNotificationTypeName as 'Carrier Notification Type Name',
cn.CarrierNotificationDescription as 'Carrier Notification Description', 
concat(qb.LastName,', ',qb.FirstName) as 'Full Name', qb.SSN, 'Enrollment Date', 
qb.Gender as 'Sex', format(qb.DOB, 'MM/dd/yyyy hh:mm tt') as DOB,
format(cn.EnteredDate, 'MM/dd/yyyy hh:mm tt') as 'Entered Date Time', 'New Data Text',
cn.EffectiveDate as 'Effective Date', 

concat(qbd.LastName,', ',qbd.FirstName) as 'Dep Full Name', qbd.SSN as 'Dep SSN', 
format(qbd.DOB, 'MM/dd/yyyy hh:mm tt') as 'Dep DOB', 
format(qbd.OriginalEnrollmentDate, 'MM/dd/yyyy hh:mm tt') as 'Dep Enrollment Data',
qbd.Gender as 'Dep Sex', qbd.Relationship as 'Dep Relationship', 'Dep New Data Text',
qb.IndividualIdentifier, 'Notice Type', qb.State, concat(qb.LastName,', ',qb.FirstName,qb.SSN)



FROM CarrierNotification cn
LEFT JOIN QB
    ON cn.MemberID = QB.MemberID
LEFT JOIN Client c 
    ON QB.ClientID = c.ClientID
LEFT JOIN ClientDivision cd 
    ON QB.ClientDivisionID = cd.ClientDivisionID
LEFT JOIN QBPlan qbp
    ON cn.MemberID = qbp.MemberID
LEFT JOIN ClientPlanQB cpqb
    ON qbp.ClientPlanQBID = cpqb.ClientPlanQBID
LEFT JOIN CarrierContact cc 
    ON  cpqb.CarrierEnrollmentContactID = cc.CarrierContactID
LEFT JOIN Carrier cr 
    ON cpqb.CarrierID = cr.CarrierID
LEFT JOIN QBDependent qbd
    ON qbd.MemberID = cn.MemberID

WHERE ProcessedDate BETWEEN '2021-04-27 00:00:00.000' AND '2021-04-28 00:00:00.000'
    AND c.ClientName IS NOT NULL

;