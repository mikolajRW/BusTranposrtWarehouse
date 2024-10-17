USE ZTMbased
GO

If (object_id('viewEtlBuses') is not null) Drop View viewEtlBuses;
go

CREATE VIEW viewEtlBuses
AS
SELECT DISTINCT
	[VIN] AS [VIN],
	[Registration] AS [Registration],
	[DepotNumber] AS [DepotNumber],
	BV.ID AS [BusVariantID],
	BV.Make AS [Make],
	BV.Model AS [Model],
	CASE 
		WHEN BV.ProdYear <= 1980 THEN '<= 1980'
		WHEN BV.ProdYear >=1981 AND BV.ProdYEar <=1990 THEN '1981-1990'
		WHEN BV.ProdYear >=1991 AND BV.ProdYEar <=2000 THEN '1991-2000'
		WHEN BV.ProdYear >=2001 AND BV.ProdYEar <=2010 THEN '2001-2010'
		WHEN BV.ProdYear >=2011 AND BV.ProdYEar <=2020 THEN '2011-2020'
		WHEN BV.ProdYear >= 2021 THEN ' >= 2021'
	END AS [ProdYearZone]
FROM [BasedZTM].[dbo].[Buses]
JOIN [BasedZTM].[dbo].[BusVariants] AS BV
ON [BasedZTM].[dbo].[Buses].BusVariant_ID = BV.ID
GO


MERGE INTO Buses AS B
 USING viewEtlBuses AS EB
	ON B.VIN = EB.VIN
	AND B.Registration = EB.Registration
	AND B.DepotNumber = EB.DepotNumber
	WHEN Not Matched
				THEN
					INSERT Values (
						EB.VIN,
						EB.Registration,
						EB.DepotNumber,
						EB.BusVariantID,
						EB.Make,
						EB.Model,
						EB.ProdYearZone,
						1
						)
	WHEN Matched AND EB.ProdYearZone <> B.ProdYearZone
		THEN
			UPDATE
			SET B.IsActive = 0
	WHEN Not Matched BY Source
		THEN
			UPDATE
			SET B.IsActive = 0;



DROP VIEW viewEtlBuses

