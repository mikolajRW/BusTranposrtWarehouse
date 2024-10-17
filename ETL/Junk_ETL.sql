USE ZTMbased

INSERT INTO [dbo].[Junk] 
SELECT s
FROM 
	( 
		VALUES
			('None'),
			('Take'),
			('Give')
	)
	AS Stand(s);

