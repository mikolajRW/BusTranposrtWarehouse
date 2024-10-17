USE ZTMbased
GO

If (object_id('etlCoursesData') is not null) Drop View etlCoursesData;
go
CREATE VIEW etlCoursesData
AS
SELECT DISTINCT
	[ID] AS [CourseID],
	[Number] AS [Number],
	[Name] AS [Name],
	[Failure] AS [Failure],
	[Continuity] AS [Continuity],
	CASE
		WHEN [NumberOfStations] < 10 THEN 'less than 10'
		WHEN [NumberOfStations] >=10 AND [NumberOfStations] <= 20 THEN 'From 10 to 20'
		ELSE 'More than 20'
	END AS [NumberOfStations],
	[ID] AS [ExtraID]
FROM [BasedZTM].[dbo].[Courses]
go





MERGE INTO TMP AS CDim
	USING etlCoursesData AS Cview
	ON CDim.Number = Cview.Number
	AND CDim.Name = Cview.Name
	AND CDim.Failure = Cview.Failure
	AND CDim.Continuity = Cview.Continuity
	WHEN Not Matched
				THEN
					INSERT
					Values (
					CView.Number,
					Cview.Name,
					Cview.Failure,
					Cview.Continuity,
					Cview.NumberOfStations,
					Cview.ExtraID
					)
	WHEN Not Matched By Source
				Then
					DELETE
					;

DROP VIEW etlCoursesData
 
USE ZTMbased
go
DELETE FROM Stops
DELETE FROM Courses
INSERT INTO Courses(Number, Name, Failure, Continuity, NumberOfStations)
SELECT Number, Name, Failure, Continuity, NumberOfStations
FROM TMP
DBCC CHECKIDENT (Courses, RESEED, 0);

                

SELECT * FROM Courses
SELECT * FROM TMP
SELECT * FROM [BasedZTM].[dbo].[Courses]









