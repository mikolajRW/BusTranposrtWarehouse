USE ZTMbased
GO

CREATE TABLE TMP (
	CourseID INT IDENTITY(1,1),
	Number CHAR(3),
	Name VARCHAR(92),
	Failure VARCHAR(5),
	Continuity VARCHAR(5),
	NumberOfStations VARCHAR(14),
	ExtraID INT,
	PRIMARY KEY (CourseID)
	);
GO

