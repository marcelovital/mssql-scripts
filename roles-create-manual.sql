/***************************************\
*      Useful MSSQL Server Queries      *
*                    - by Marcelo Vital *
* git.marcelovital.io/vital/sql-queries *
\***************************************/

-- Manually create a role and give permissions to view 'source-code' from any object

CREATE ROLE [roleName];
GRANT VIEW ANY DEFINITION TO roleName;
EXEC sp_addrolemember 'roleName', 'yourlogin'
