/***************************************\
*      Useful MSSQL Server Queries      *
*                    - by Marcelo Vital *
* git.marcelovital.io/vital/sql-queries *
\***************************************/

ALTER DATABASE [old_db_name] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE [old_db_name] MODIFY NAME = [new_db_name];
GO  
ALTER DATABASE [new_db_name] SET MULTI_USER;
GO
