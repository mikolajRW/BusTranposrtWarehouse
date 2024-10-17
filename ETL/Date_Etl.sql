USE ZTMbased
Go


Declare @StartDate date; 
Declare @EndDate date;


SELECT @StartDate = '2015-01-01', @EndDate = '2024-12-31';

-- Step c:  Use a while loop to add dates to the table
Declare @DateInProcess datetime = @StartDate;

While @DateInProcess <= @EndDate
	Begin
	--Add a row into the date dimension table for this date
		Insert Into [dbo].[Date] 
		( [Date]
		, [Year]
		, [Month]
		, [MonthNo]
		, [DayOfWeek]
		, [DayType]
		, [Season]
		, [Day]
		)
		Values ( 
		  @DateInProcess -- [Date]
		  , Cast( Year(@DateInProcess) as varchar(4)) -- [Year]
		  , Cast( DATENAME(month, @DateInProcess) as varchar(10)) -- [Month]
		  , Cast( Month(@DateInProcess) as int) -- [MonthNo]
		  , Cast( DATENAME(dw,@DateInProcess) as varchar(15)) -- [DayOfWeek]
		  , CASE
				WHEN DATEPART(dw, @DateInProcess) = 1 THEN 'Free'
				ELSE 'Working'
			END
		  , CASE
				WHEN (Cast( Month(@DateInProcess) as int)= 12 AND CAST( Day(@DateInProcess) as INT) >= 22) OR 
				(Cast( Month(@DateInProcess) as int) BETWEEN 1 AND 2) OR
				(Cast( Month(@DateInProcess) as int) <= 3 AND CAST( Day(@DateInProcess) as INT) < 21) THEN 'Winter'
				WHEN (Cast( Month(@DateInProcess) as int) = 6 AND CAST( Day(@DateInProcess) as INT) > 21) OR 
				(Cast( Month(@DateInProcess) as int) BETWEEN 7 AND 8) OR
				(Cast( Month(@DateInProcess) as int) = 9 AND CAST( Day(@DateInProcess) as INT) < 23) THEN 'Summer'
				WHEN (Cast( Month(@DateInProcess) as int) = 3 AND CAST( Day(@DateInProcess) as INT) >= 21) OR 
				(Cast( Month(@DateInProcess) as int) BETWEEN 4 AND 5) OR
				(Cast( Month(@DateInProcess) as int) = 6 AND CAST( Day(@DateInProcess) as INT) < 22) THEN 'Spring'
				ELSE 'Autumn'
			END
		  , CAST( Day(@DateInProcess) as INT)
		);  
		-- Add a day and loop again
		Set @DateInProcess = DateAdd(d, 1, @DateInProcess);
	End
go

SELECT * FROM Date