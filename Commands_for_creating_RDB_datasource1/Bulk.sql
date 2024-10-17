/*
There are two bulks operation for one table, the reason of that is that task guideline wat to prepare date in two snapshots. 
This solution allows user to check if SCD 2 is working correctly in the ETL process. 
Data generator for each of the table and for each snapshot is provided on the project respository
*/

BULK INSERT Drivers
from 'users/directory' 
with (fieldterminator = ',',rowterminator = '\n');

BULK INSERT Drivers
from 'users/directory' 
with (fieldterminator = ',',rowterminator = '\n');


BULK INSERT BusVariants
from 'users/directory'  
with (fieldterminator = ',',rowterminator = '\n');


BULK INSERT Buses
from 'users/directory' 
with (fieldterminator = ',',rowterminator = '\n');

BULK INSERT Buses
from 'users/directory' 
with (fieldterminator = ',',rowterminator = '\n');


BULK INSERT Repairs
from 'users/directory' 
with (fieldterminator = ',',rowterminator = '\n');

BULK INSERT Repairs
from 'users/directory' 
with (fieldterminator = ',',rowterminator = '\n');

BULK INSERT Services
from 'users/directory' 
with (fieldterminator = ',',rowterminator = '\n');

BULK INSERT Services
from 'users/directory' 
with (fieldterminator = ',',rowterminator = '\n');


BULK INSERT Courses 
from 'C:\Users\Mikolaj\Desktop\python\skrypty\courses2015-2020.csv' 
with (fieldterminator = ',',rowterminator = '\n');


BULK INSERT Courses 
from 'users/directory' 
with (fieldterminator = ',',rowterminator = '\n');


BULK INSERT Stations
from 'users/directory' 
with (fieldterminator = ',',rowterminator = '\n');


BULK INSERT Stations
from 'users/directory'  
with (fieldterminator = ',',rowterminator = '\n');

BULK INSERT Stops
from 'users/directory' 
with (fieldterminator = ',',rowterminator = '\n');

BULK INSERT Stops
from 'users/directory' 
with (fieldterminator = ',',rowterminator = '\n');

