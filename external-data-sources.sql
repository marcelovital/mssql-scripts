/***************************************\
*      Useful MSSQL Server Queries      *
*                    - by Marcelo Vital *
* git.marcelovital.io/vital/sql-queries *
\***************************************/

--Check current external datasources and credentials:
SELECT * FROM sys.database_credentials;
SELECT * FROM sys.external_data_sources;

-- Create or alter master key:
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'masterkeypassword';
ALTER MASTER KEY REGENERATE WITH ENCRYPTION BY PASSWORD = 'masterkeypassword';

-- Create or alter credentials:
CREATE DATABASE SCOPED CREDENTIAL credentialname WITH IDENTITY = 'username_with_permissions_on_external_db', SECRET = 'that_users_password';
ALTER DATABASE SCOPED CREDENTIAL credentialname WITH IDENTITY = 'username_with_permissions_on_external_db', SECRET = 'that_users_password';
DROP DATABASE SCOPED CREDENTIAL credentialname;

-- Create or alter external datasource:
CREATE EXTERNAL DATA SOURCE datasourcename WITH (
       TYPE = RDBMS,
       LOCATION = 'destination_server_url',
       CREDENTIAL = credentialname,
       DATABASE_NAME = 'destination_database_name'
);
ALTER EXTERNAL DATA SOURCE datasourcename SET 
       LOCATION = 'destination_server_url',
       CREDENTIAL = credentialname,
       DATABASE_NAME = 'destination_database_name';