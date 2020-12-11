/***************************************\
*      Useful MSSQL Server Queries      *
*                    - by Marcelo Vital *
* git.marcelovital.io/vital/sql-queries *
\***************************************/

SELECT	isnull (Users.name, 'No members') AS Username,
		Roles.name AS Role

FROM sys.database_role_members AS Membership

RIGHT OUTER JOIN sys.database_principals AS Roles
	ON Membership.role_principal_id = Roles.principal_id

LEFT OUTER JOIN sys.database_principals AS Users
	ON Membership.member_principal_id = Users.principal_id

WHERE Roles.type = 'R'
ORDER BY Username, Role