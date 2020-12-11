/***************************************\
*      Useful MSSQL Server Queries      *
*                    - by Marcelo Vital *
* git.marcelovital.io/vital/sql-queries *
\***************************************/

-- If you're going to use SQL Authentication, first create login at master database:

CREATE LOGIN yourlogin WITH PASSWORD ='yourpassword'; 

-- For each database you want to give access to:

CREATE USER yourlogin FOR LOGIN yourlogin; -- For SQL Authentication
CREATE USER [ADusername_or_group] FROM EXTERNAL PROVIDER; -- For Active Directory Authentication

-- Add user to the database roles:
EXEC sp_addrolemember 'db_datareader', 'yourlogin' -- Read-only
EXEC sp_addrolemember 'db_datawriter', 'yourlogin' -- Read-write
EXEC sp_addrolemember 'db_ddladmin', 'yourlogin' -- Manage objects
EXEC sp_addrolemember 'db_owner', 'yourlogin' -- DB Owner

-- Or, to remove:
EXEC sp_droprolemember 'db_datareader', 'yourlogin' -- Read-only
EXEC sp_droprolemember 'db_datawriter', 'yourlogin' -- Read-write
EXEC sp_droprolemember 'db_ddladmin', 'yourlogin' -- Manage objects
EXEC sp_droprolemember 'db_owner', 'yourlogin' -- DB Owner
