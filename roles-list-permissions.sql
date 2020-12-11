/***************************************\
*      Useful MSSQL Server Queries      *
*                    - by Marcelo Vital *
* git.marcelovital.io/vital/sql-queries *
\***************************************/

SELECT DISTINCT      Roles.name as Role, 
                     Roles.type_desc as Type, 
                     Perm.class_desc as PermissionType, 
                     Perm.permission_name as PermissionName, 
                     Perm.state_desc as PermissionDesc, 
                     CASE WHEN Obj.type_desc IS NULL OR Obj.type_desc = 'SYSTEM_TABLE' 
			       THEN Perm.class_desc 
				ELSE Obj.type_desc 
			END as ObjectType, 
                     SchmObj.Name as SchemaName,
                     Isnull(SchmPerm.name, Object_name(Perm.major_id)) as ObjectName

FROM   sys.database_principals Roles 
	INNER JOIN sys.database_permissions Perm 
		ON Perm.grantee_principal_id = Roles.principal_id 
	LEFT JOIN sys.schemas SchmPerm 
		ON Perm.major_id = SchmPerm.schema_id 
	LEFT JOIN sys.objects Obj 
		ON Perm.[major_id] = Obj.[object_id] 
	LEFT JOIN sys.schemas SchmObj
		ON SchmObj.schema_id = Obj.schema_id

WHERE	Roles.type_desc = 'DATABASE_ROLE' 
	AND Perm.class_desc <> 'DATABASE' 

ORDER BY	Roles.name, 
		Roles.type_desc, 
		Perm.class_desc 