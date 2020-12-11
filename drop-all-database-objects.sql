/***************************************\
*      Useful MSSQL Server Queries      *
*                    - by Marcelo Vital *
* git.marcelovital.io/vital/sql-queries *
\***************************************/

/*  
    WARNING! THIS WILL DELETE ALL USER OBJECTS FROM A DATABASE!
    IT WAS DESIGNED FOR A USE CASE WHEN YOU WANT TO RESTORE A BACPAC TO
	A DATABASE WHICH HAS OBJECTS AND DATA, AND YOU NEED TO COMPLETELY 
	WIPE EVERYTHING. (BACPACS HAVE NO OVERWRITE OPTION, SO YOU'LL
	NEED TO DELETE OBJECTS TO BE ABLE TO RESTORE THE NEW ONES)
*/

DECLARE @Statement VARCHAR(MAX);
DECLARE @ObjName NVARCHAR(150);
DECLARE @ObjID INT;
DECLARE @DepObjName NVARCHAR(150);
DECLARE @DepObjID INT;
DECLARE @ConstraintName NVARCHAR(150);
DECLARE @TableName NVARCHAR(150);

-- Drop Views, Procedures and Functions, checking for dependencies and dropping dependencies first

SELECT @ObjName = (SELECT TOP 1 '[' + s.name + '].[' + o.name + ']' FROM sys.objects o INNER JOIN sys.schemas s ON o.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND o.type IN (N'P', N'V', N'FN', N'IF', N'TF', N'FS', N'FT', N'TR') ORDER BY s.name);
SELECT @ObjID = (SELECT TOP 1 o.object_id FROM sys.objects o INNER JOIN sys.schemas s ON o.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND o.type IN (N'P', N'V', N'FN', N'IF', N'TF', N'FS', N'FT', N'TR') ORDER BY s.name);
 
WHILE @ObjName is not null
BEGIN
	IF (SELECT COUNT(*) FROM sys.dm_sql_referencing_entities( @ObjName ,'OBJECT')) = 0 OR (SELECT TOP 1 referencing_id FROM sys.dm_sql_referencing_entities( @ObjName ,'OBJECT')) = @ObjID 
	BEGIN
		IF (SELECT type FROM sys.objects WHERE object_id = @ObjID) = 'V'
		BEGIN
			SELECT @Statement = 'DROP VIEW ' + @ObjName ;
			PRINT 'Dropping View: ' + @ObjName
			EXEC (@Statement)
			SELECT @ObjName = (SELECT TOP 1 '[' + s.name + '].[' + o.name + ']' FROM sys.objects o INNER JOIN sys.schemas s ON o.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND o.type IN (N'P', N'V', N'FN', N'IF', N'TF', N'FS', N'FT', N'TR') ORDER BY s.name);
			SELECT @ObjID = (SELECT TOP 1 o.object_id FROM sys.objects o INNER JOIN sys.schemas s ON o.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND o.type IN (N'P', N'V', N'FN', N'IF', N'TF', N'FS', N'FT', N'TR') ORDER BY s.name);
		END

		ELSE IF (SELECT type FROM sys.objects WHERE object_id = @ObjID) = 'P'
		BEGIN
			SELECT @Statement = 'DROP PROCEDURE ' + @ObjName ;
			PRINT 'Dropping Procedure: ' + @ObjName
			EXEC (@Statement)
			SELECT @ObjName = (SELECT TOP 1 '[' + s.name + '].[' + o.name + ']' FROM sys.objects o INNER JOIN sys.schemas s ON o.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND o.type IN (N'P', N'V', N'FN', N'IF', N'TF', N'FS', N'FT', N'TR') ORDER BY s.name);
			SELECT @ObjID = (SELECT TOP 1 o.object_id FROM sys.objects o INNER JOIN sys.schemas s ON o.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND o.type IN (N'P', N'V', N'FN', N'IF', N'TF', N'FS', N'FT', N'TR') ORDER BY s.name);
		END

		ELSE IF (SELECT type FROM sys.objects WHERE object_id = @ObjID) IN (N'FN', N'IF', N'TF', N'FS', N'FT')
		BEGIN
			SELECT @Statement = 'DROP FUNCTION ' + @ObjName ;
			PRINT 'Dropping Function: ' + @ObjName
			EXEC (@Statement)
			SELECT @ObjName = (SELECT TOP 1 '[' + s.name + '].[' + o.name + ']' FROM sys.objects o INNER JOIN sys.schemas s ON o.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND o.type IN (N'P', N'V', N'FN', N'IF', N'TF', N'FS', N'FT', N'TR') ORDER BY s.name);
			SELECT @ObjID = (SELECT TOP 1 o.object_id FROM sys.objects o INNER JOIN sys.schemas s ON o.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND o.type IN (N'P', N'V', N'FN', N'IF', N'TF', N'FS', N'FT', N'TR') ORDER BY s.name);
		END
		ELSE IF (SELECT type FROM sys.objects WHERE object_id = @ObjID) = 'TR'
		BEGIN
			SELECT @Statement = 'DROP TRIGGER ' + @ObjName ;
			PRINT 'Dropping Trigger: ' + @ObjName
			EXEC (@Statement)
			SELECT @ObjName = (SELECT TOP 1 '[' + s.name + '].[' + o.name + ']' FROM sys.objects o INNER JOIN sys.schemas s ON o.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND o.type IN (N'P', N'V', N'FN', N'IF', N'TF', N'FS', N'FT', N'TR') ORDER BY s.name);
			SELECT @ObjID = (SELECT TOP 1 o.object_id FROM sys.objects o INNER JOIN sys.schemas s ON o.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND o.type IN (N'P', N'V', N'FN', N'IF', N'TF', N'FS', N'FT', N'TR') ORDER BY s.name);
		END
		
	END
	ELSE
	BEGIN
		SELECT @DepObjName = (SELECT TOP 1 '[' + referencing_schema_name + '].[' + referencing_entity_name + ']' FROM sys.dm_sql_referencing_entities( @ObjName ,'OBJECT'));
		SELECT @DepObjID = (SELECT TOP 1 referencing_id FROM sys.dm_sql_referencing_entities( @ObjName ,'OBJECT'));
		PRINT @ObjName + N' depends on ' + @DepObjName;
		SET @ObjName = @DepObjName;
		SET @ObjID = @DepObjID;
	END
END

-- Turn off versioning for Temporal Tables

SELECT @ObjName = (SELECT TOP 1 '[' + s.name + '].[' + t.name + ']' FROM sys.tables t INNER JOIN sys.schemas s ON t.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND t.temporal_type = 2 ORDER BY s.name);
 
WHILE @ObjName is not null
BEGIN
	SELECT @Statement = 'ALTER TABLE ' + @ObjName + ' SET (SYSTEM_VERSIONING = OFF)';
	PRINT 'Turning off versioning for table: ' + @ObjName;
	EXEC (@Statement);
	SELECT @ObjName = (SELECT TOP 1 '[' + s.name + '].[' + t.name + ']' FROM sys.tables t INNER JOIN sys.schemas s ON t.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND t.temporal_type = 2 ORDER BY s.name);
	 
END

-- Drop constraints: Foreign Keys and then Primary Keys

SELECT @ConstraintName = (SELECT TOP 1 '[' + CONSTRAINT_NAME + ']' FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_CATALOG=DB_NAME() AND CONSTRAINT_TYPE IN ('FOREIGN KEY','PRIMARY KEY') AND CONSTRAINT_SCHEMA <> 'sys' ORDER BY CONSTRAINT_TYPE, CONSTRAINT_NAME);
SELECT @TableName= (SELECT TOP 1 '[' + TABLE_SCHEMA + '].[' + TABLE_NAME + ']' FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_CATALOG=DB_NAME() AND CONSTRAINT_TYPE IN ('FOREIGN KEY','PRIMARY KEY') AND TABLE_SCHEMA <> 'sys' AND CONSTRAINT_SCHEMA <> 'sys' ORDER BY CONSTRAINT_TYPE, CONSTRAINT_NAME);
PRINT @ConstraintName 
WHILE @ConstraintName is not null
BEGIN
	SELECT @Statement = 'ALTER TABLE ' + @TableName +' DROP CONSTRAINT ' + @ConstraintName 
	PRINT 'Dropping Constraint: ' + @ConstraintName  + ' on ' + @TableName 
	EXEC (@Statement)
	SELECT @ConstraintName = (SELECT TOP 1 '[' + CONSTRAINT_NAME + ']' FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_CATALOG=DB_NAME() AND CONSTRAINT_TYPE IN ('FOREIGN KEY','PRIMARY KEY') AND CONSTRAINT_SCHEMA <> 'sys' ORDER BY CONSTRAINT_TYPE, CONSTRAINT_NAME);
	SELECT @TableName = (SELECT TOP 1 '[' + TABLE_SCHEMA + '].[' + TABLE_NAME + ']' FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_CATALOG=DB_NAME() AND CONSTRAINT_TYPE IN ('FOREIGN KEY','PRIMARY KEY') AND TABLE_SCHEMA <> 'sys' AND CONSTRAINT_SCHEMA <> 'sys' ORDER BY CONSTRAINT_TYPE, CONSTRAINT_NAME);
END

-- Drop all Table Types

SELECT @ObjName = (SELECT TOP 1 '[' + s.name + '].[' + t.name + ']' FROM sys.table_types t INNER JOIN sys.schemas s ON t.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND t.is_user_defined = 1 ORDER BY s.name);

WHILE @ObjName is not null
BEGIN
	SELECT @Statement = 'DROP TYPE ' + @ObjName ;
	PRINT 'Dropping Table Type: ' + @ObjName
	EXEC (@Statement)
	SELECT @ObjName = (SELECT TOP 1 '[' + s.name + '].[' + t.name + ']'  FROM sys.table_types t INNER JOIN sys.schemas s ON t.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND t.is_user_defined = 1 ORDER BY s.name);
	
END

-- Drop all user tables

SELECT @ObjName = (SELECT TOP 1 '[' + s.name + '].[' + o.name + ']' FROM sys.objects o INNER JOIN sys.schemas s ON o.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND o.type = 'U' ORDER BY s.name);

WHILE @ObjName is not null
BEGIN
	IF (SELECT COUNT(*) FROM sys.dm_sql_referencing_entities( @ObjName ,'OBJECT')) = 0
	BEGIN
		SELECT @Statement = 'DROP TABLE ' + @ObjName ;
		PRINT 'Dropping Table: ' + @ObjName
		EXEC (@Statement)
		SELECT @ObjName = (SELECT TOP 1 '[' + s.name + '].[' + o.name + ']' FROM sys.objects o INNER JOIN sys.schemas s ON o.schema_id = s.schema_id WHERE s.principal_id = 1 AND s.name <> 'sys' AND o.type = 'U' ORDER BY s.name);
	END
	ELSE
	BEGIN
		SELECT @DepObjName = (SELECT TOP 1 '[' + referencing_schema_name + '].[' + referencing_entity_name + ']' FROM sys.dm_sql_referencing_entities( @ObjName ,'OBJECT'));
		SELECT @DepObjID = (SELECT TOP 1 referencing_id FROM sys.dm_sql_referencing_entities( @ObjName ,'OBJECT'));
		PRINT @ObjName + N' depends on ' + @DepObjName;
		SET @ObjName = @DepObjName;
		SET @ObjID = @DepObjID;
		
	END
END