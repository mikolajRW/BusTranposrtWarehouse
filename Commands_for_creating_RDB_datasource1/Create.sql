CREATE TABLE Drivers (
	Pesel CHAR(11) PRIMARY KEY,
	Name VARCHAR(64),
	Surname VARCHAR(64),
	EMail VARCHAR(52),
	PhoneNumber CHAR(9)
	);

CREATE TABLE BusVariants (
	ID INT IDENTITY(1,1),
	Make VARCHAR(16),
	Model VARCHAR(32),
	ProdYear INT,
	PRIMARY KEY(ID)
	);

CREATE TABLE Buses (
	VIN CHAR(19) PRIMARY KEY,
	Registration VARCHAR(11),
	DepotNumber INT,
	BusVariant_ID INT,
	FOREIGN KEY (BusVariant_ID) REFERENCES BusVariants
	);

CREATE TABLE Repairs(
	ID INT IDENTITY(1,1),
	DateStart DATETIME,
	DateEnd DATETIME,
	TotalPrice FLOAT,
	VIN CHAR(19),
	PRIMARY KEY (ID),
	FOREIGN KEY (VIN) REFERENCES Buses
	);

CREATE TABLE Services (
	ID INT IDENTITY(1,1),
	Name VARCHAR(64),
	Description TEXT,
	Price FLOAT,
	TimeOf INT,
	IdRepairs INT,
	FOREIGN KEY(IdRepairs) REFERENCES Repairs
	);

CREATE TABLE Courses (
	ID INT IDENTITY(1,1),
	Number CHAR(3),
	Name VARCHAR(64),
	Failure Char(5),
	DriverPesel CHAR(11),
	BusVin CHAR(19),
	Continuity CHAR(5),
	NumberOfStations INT,
	PRIMARY KEY (ID),
	FOREIGN KEY (DriverPesel) REFERENCES Drivers,
	FOREIGN KEY (BusVin) REFERENCES Buses
	);


CREATE TABLE Stations (
	ID INT IDENTITY(1,1),
	Name VARCHAR(64)
	PRIMARY KEY(ID)
	);
	

CREATE TABLE Stops (
	CourseID INT,
	StationID INT
	PRIMARY KEY (CourseID, StationID),
	FOREIGN KEY (CourseID) REFERENCES Courses,
	FOREIGN KEY (StationID) REFERENCES Stations
	);

	



