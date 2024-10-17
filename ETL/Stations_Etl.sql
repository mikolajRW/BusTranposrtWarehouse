USE ZTMbased
GO

If (object_id('etlStationsData') is not null) Drop View etlStationsData;
go
CREATE VIEW etlStationsData
AS
SELECT DISTINCT
	[ID] as [StationID],
	[Name] as [Name]
FROM BasedZTM.dbo.Stations;
go

MERGE INTO Stations as ST
	USING etlStationsData as StView
		ON ST.Name = StView.NAme
			WHEN Not Matched
				THEN
					INSERT
					Values (
					StView.Name
					)
			WHEN Not Matched By Source
				Then
					DELETE
			;

Drop View etlStationsData;


