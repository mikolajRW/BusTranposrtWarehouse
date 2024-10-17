CREATE TABLE Stations (
	StationID INT IDENTITY(1,1),
	Name VARCHAR(64)
	PRIMARY KEY(StationID)
	);

CREATE TABLE Courses (
	CourseID INT IDENTITY(1,1),
	Number CHAR(3),
	Name VARCHAR(92),
	Failure VARCHAR(5),
	Continuity VARCHAR(5),
	NumberOfStations VARCHAR(14),
	PRIMARY KEY (CourseID)
	);


CREATE TABLE Drivers (
	DriverID INT IDENTITY(1,1) PRIMARY KEY,
	Pesel CHAR(11) ,
	Name VARCHAR(64),
	Surname VARCHAR(64),
	EMail VARCHAR(64),
	PhoneNumber CHAR(9),
	AgeZone VARCHAR(20),
	IsActive BIT
	);


CREATE TABLE Buses (
	BusID INT IDENTITY(1,1),
	VIN CHAR(19),
	Registration VARCHAR(11),
	DepotNumber CHAR(5),
	BusVariantID INT,
	Make VARCHAR(96),
	Model VARCHAR(164),
	ProdYearZone VARCHAR(20),
	IsActive BIT
	PRIMARY KEY(BusID)
	);

CREATE TABLE Junk (
	JunkID INT IDENTITY(1,1),
	FailureAction CHAR(4)
	PRIMARY KEY (JunkID)
	);

CREATE TABLE Date (
	DateID INT IDENTITY(1,1),
	Year INT,
	MonthNo INT,
	Month CHAR(12),
	Day INT,
	DayOfWeek CHAR(9),
	Season CHAR(6),
	DayType CHAR(7),
	Date DATE
	PRIMARY KEY (DateID)
	);


CREATE TABLE Time (
	TimeID INT IDENTITY(1,1),
	Hour INT,
	Minute INT,
	Second INT,
	PartOfDay CHAR(30)
	PRIMARY KEY (TimeID)
	);



CREATE TABLE Stops (
	CourseID INT,
	StationID INT,
	ArrivalTimeID INT,
	LeaveTimeID INT,
	ArrivalDateID INT,
	DriverID INT,
	JunkID INT,
	BusID INT,
	Delay INT,
	StopTime INT,
	PRIMARY KEY(CourseID, StationID, ArrivaltimeID, LeaveTimeID, 
				ArrivalDateID, DriverID, BusID, JunkID),
	FOREIGN KEY (CourseID) REFERENCES Courses,
	FOREIGN KEY (StationID) REFERENCES Stations,
	FOREIGN KEY (ArrivalTimeID) REFERENCES Time,
	FOREIGN KEY (LeaveTimeID) REFERENCES Time,
	FOREIGN KEY (ArrivalDateID) REFERENCES Date,
	FOREIGN KEY (DriverID) REFERENCES Drivers,
	FOREIGN KEY (BusID) REFERENCES Buses,
	FOREIGN KEY (JunkID) REFERENCES Junk
	);

