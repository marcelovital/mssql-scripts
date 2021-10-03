/***************************************\
*      Useful MSSQL Server Queries      *
*                    - by Marcelo Vital *
* git.marcelovital.io/vital/sql-queries *
\***************************************/

-- Manually create a role and give read permissions to all currently existing views

CREATE ROLE [roleName];
SELECT 'GRANT SELECT ON ' + ROUTINE_NAME + ' TO roleName'
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'

SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE'