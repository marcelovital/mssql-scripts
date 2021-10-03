-- Create a database master key if one does not already exist, using your own password. This key is used to encrypt the credential secret in next step.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'eyf5gc6Fg4gV' ;
-- Create a database scoped credential with Azure storage account key as the secret.

-- PUBLIC DATALAKE
/*CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH
IDENTITY = 'saazrPGSUSp01' ,
SECRET = '.Gnt7WOJiyrSvm106L_Jv83-Hhbey~_GCU' ;

ALTER DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH
IDENTITY = '63d7427e-033f-4c12-bfef-31a22a70c90d@https://login.microsoftonline.com/bf86fbdb-f8c2-440e-923c-05a60dc2bc9b/oauth2/v2.0/token' ,
SECRET = '.Gnt7WOJiyrSvm106L_Jv83-Hhbey~_GCU' ;

-- Create an external data source with CREDENTIAL option.
CREATE EXTERNAL DATA SOURCE MyAzureStorage
WITH ( LOCATION = 'abfss://data@bi4ddevdlstrbtz01.dfs.core.windows.net/test', CREDENTIAL = AzureStorageCredential , TYPE = HADOOP) ;
                                bi4ddevdlstrbtz01.privatelink.dfs.core.windows.net
DROP EXTERNAL DATA SOURCE MyAzureStorage
CREATE EXTERNAL DATA SOURCE MyAzureStorage
WITH ( LOCATION = 'wasbs://data@bi4ddevdlstrbtz01.blob.core.windows.net/test', CREDENTIAL = AzureStorageCredential , TYPE = HADOOP );
*/


--PRIVATE DATALAKE
CREATE DATABASE SCOPED CREDENTIAL MSI WITH IDENTITY = 'Managed Service Identity';

CREATE EXTERNAL DATA SOURCE MyAzureStorage2
WITH ( LOCATION = 'abfss://data@bi4ddevdlstrbtz01.dfs.core.windows.net/test', CREDENTIAL = MSI , TYPE = HADOOP) ;

CREATE EXTERNAL FILE FORMAT textfile_csv_withheader WITH (  
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS ( 
        FIELD_TERMINATOR = ';',
        STRING_DELIMITER = '\"',
        FIRST_ROW  = 2
        )
    );


DROP EXTERNAL TABLE dbo.Test_ExtTable
CREATE EXTERNAL TABLE dbo.Test_ExtTable ( 
    [col1] varchar(1000),
    [col2] varchar(1000), 
    [col3] varchar(1000) ) WITH ( LOCATION =
'/EB.csv', DATA_SOURCE = MyAzureStorage2, FILE_FORMAT = [textfile_csv_withheader] );


SELECT * FROM dbo.Test_ExtTable