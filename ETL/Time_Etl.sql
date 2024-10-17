USE ZTMbased
GO

BULK INSERT Time
from 'C:\Users\Mikolaj\Desktop\python\TimeGenerator\time.csv'
with (fieldterminator = ',',rowterminator = '\n');


SELECT * FROM Time

