/***************************************\
*      Useful MSSQL Server Queries      *
*                    - by Marcelo Vital *
* git.marcelovital.io/vital/sql-queries *
\***************************************/

-- Manually create a role and give specific permissions

CREATE ROLE [roleName];

GRANT SELECT ON objectName TO roleName;

-- Add users to new role

EXEC sp_addrolemember 'roleName', 'userName'

