USE ZTMbased
Go

If (object_id('dbo.ZTMotion') is not null) DROP TABLE dbo.ZTMotion;
CREATE TABLE dbo.ZTMotion(CourseID INT, StationID CHAR(40), BusNumber CHAR(3) , PlannedArrivalTime DATETIME, Delay INT, 
StopTime INT, OnDemand CHAR(5), FailureAct CHAR(4));
go

BULK INSERT dbo.ZTMotion
    FROM 'C:\Users\Mikolaj\Desktop\python\skrypty\ZTMotion.csv'
    WITH
    (
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
    )

	

	


If (object_id('viewETLStops') is not null) Drop view viewETLStops;
go
CREATE VIEW viewETLStops
AS
SELECT 
		CourseID = TMP.CourseID,
		StationID = DimStat.StationID,
		DriverID = DimDriv.DriverID,
		BusID = Buses.BusID,
		JunkID = Junk.JunkID,
		ArrivalDateID = D.DateID,
		ArrivalTimeID = T.TimeID,
		LeaveTimeID = T2.TimeID,
		Delay = ZT.Delay,
		StopTime = ZT.StopTime
		FROM dbo.ZTMotion AS ZT
		JOIN BasedZTM.dbo.Stations AS Stat
		ON ZT.StationID = Stat.ID
		JOIN BasedZTM.dbo.Courses AS BaseCourse
		ON ZT.CourseID = BaseCourse.ID
		JOIN BasedZTM.dbo.Buses AS BaseBuses
		ON BaseCourse.BusVin = BaseBuses.Vin
		JOIN Drivers AS DimDriv
		ON BaseCourse.DriverPesel = DimDriv.Pesel
		JOIN Buses
		ON BaseBuses.DepotNumber = Buses.DepotNumber
		JOIN Stations AS DimStat
		ON Stat.Name = DimStat.Name
		JOIN Junk 
		ON ZT.FailureAct = Junk.FailureAction
		JOIN Date AS D
		ON CONVERT(VARCHAR(10), D.Date, 111) = CONVERT(VARCHAR(10), ZT.PlannedArrivalTime ,111)
		JOIN Time AS T
		ON ( DATEPART(HOUR, ZT.PlannedArrivalTime) = T.Hour AND DATEPART(MINUTE, ZT.PlannedArrivalTime) = T.MINUTE 
		AND DATEPART(SECOND, ZT.PlannedArrivalTime) = T.SECOND )
		JOIN TIME AS T2
		ON ( DATEPART(HOUR, ZT.PlannedArrivalTime) = T2.Hour AND (DATEPART(MINUTE, ZT.PlannedArrivalTime) + (Delay/60)) = T2.MINUTE 
		AND (DATEPART(SECOND, ZT.PlannedArrivalTime) + StopTime) = T2.SECOND )
		JOIN TMP  
		ON BaseCourse.ID = TMP.ExtraID
GO





MERGE INTO Stops as SD
	USING viewETLStops as viewS
		ON 	SD.CourseID = viewS.CourseID
		AND SD.StationID = viewS.StationID
		AND SD.DriverID = viewS.DriverID
		AND SD.BusID = viewS.BusID
		AND SD.JunkID = viewS.JunkID
		AND SD.ArrivalDateID = viewS.ArrivalDateID
		AND SD.ArrivalTimeID = viewS.ArrivalTimeID
		AND SD.LeaveTimeID = viewS.LeaveTimeID
			WHEN Not Matched
				THEN
					INSERT
					Values (
						  viewS.CourseID,
						  viewS.StationID,
						  viewS.ArrivalTimeID,
						  viewS.LeaveTimeID,
						  viewS.ArrivalDateID,
						  viewS.DriverID,
						  viewS.JunkID,
						  viewS.BusID,
						  viewS.Delay,
						  viewS.StopTime
					);

Drop view viewETLStops;

SELECT * FROM Stops


