USE ZTMbased
GO

If (object_id('withAge') is not null) Drop View withAge;
go


CREATE VIEW withAge
AS
SELECT DISTINCT
	[Pesel] AS [Pesel],
	[Name] AS [Name],
	[Surname] AS [Surname],
	[Email] AS [Email],
	[PhoneNumber] AS [PhoneNumber],
	CASE 
    WHEN CAST(SUBSTRING(PESEL, 3, 2) AS INT) < 21 THEN
        FLOOR(DATEDIFF(month, '19' + SUBSTRING(PESEL, 1, 6), '2024-12-31' ) / 12)
	WHEN CAST(SUBSTRING(PESEL, 3, 2) AS INT) >= 21 THEN
        FLOOR(DATEDIFF(year, '20' + SUBSTRING(PESEL,1,2), '2024'))
END AS "Age"
FROM [BasedZTM].[dbo].[Drivers];
go


USE ZTMbased
GO

If (object_id('etlDriversData') is not null) Drop View etlDriversData;
go

CREATE VIEW etlDriversData
AS
SELECT DISTINCT
	WA.Pesel AS [Pesel],
	WA.Name AS [Name],
	WA.Surname [Surname],
	WA.Email AS [Email],
	WA.PhoneNumber AS [PhoneNumber],
	CASE
		WHEN WA.Age < 24 THEN 'Less than 24'
		WHEN WA.Age >=24 AND WA.Age <=30 THEN 'Between 24 and 30'
		WHEN WA.Age >=31 AND WA.Age <=45 THEN 'Between 31 and 45'
		WHEN WA.Age >=46 AND WA.Age <=60 THEN 'Between 46 and 60'
		WHEN WA.Age > 60 THEN 'More than 60'
	END AS [AgeZone]
FROM withAge AS WA
go

MERGE INTO Drivers AS D
 USING etlDriversData AS ED
	ON D.Pesel = ED.Pesel
	AND D.Name = ED.NAME
	AND D.Surname = ED.Surname
	AND D.Email = ED.Email
	AND D.PhoneNumber = ED.PhoneNumber
	WHEN Not Matched
				THEN
					INSERT Values (
						ED.Pesel,
						ED.Name,
						ED.Surname,
						ED.Email,
						ED.PhoneNumber,
						ED.AgeZone,
						1)
	WHEN Matched AND ED.AgeZone <> D.AgeZone
		THEN
			UPDATE 
			SET D.IsActive = 0
	WHEN Not Matched BY Source
		THEN
			UPDATE
			SET D.IsActive = 0;


INSERT INTO Drivers
	SELECT 
		Pesel,
		Name,
		Surname,
		Email,
		PhoneNumber,
		AgeZone,
		1
	FROM etlDriversData
	EXCEPT
	SELECT 
		Pesel,
		Name,
		Surname,
		Email,
		PhoneNumber,
		AgeZone,
		1
	FROM Drivers;




DROP VIEW withAge
DROP VIEW etlDriversData


SELECT * FROM Drivers WHERE Pesel = '00211816179'

SELECT * FROM Drivers