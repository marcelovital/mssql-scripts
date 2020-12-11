/***************************************\
*      Useful MSSQL Server Queries      *
*                    - by Marcelo Vital *
* git.marcelovital.io/vital/sql-queries *
\***************************************/

-- List all Temporal Tables

SELECT	schema_name(t.schema_id) AS TemporalTableSchema,
		t.name AS TemporalTableName,
		schema_name(h.schema_id) AS HistoryTableSchema,
		h.name AS HistoryTableSchema,
		CASE WHEN t.history_retention_period = -1 
			THEN 'INFINITE' 
			ELSE cast(t.history_retention_period as varchar) + ' ' + t.history_retention_period_unit_desc + 'S'
		END AS RetentionPeriod

FROM sys.tables T

LEFT OUTER JOIN sys.tables H
	ON T.history_table_id = H.object_id

WHERE T.temporal_type = 2

ORDER BY temporal_table_schema, temporal_table_name



SELECT  OBJECT_NAME(object_id) AS 'Temporal Table',
        OBJECT_NAME(history_table_id) AS 'History Table'

FROM sys.tables

WHERE temporal_type = 2 

ORDER BY 'Temporal Table'

-- To turn off versioning for a Table:
ALTER TABLE tablename SET (SYSTEM_VERSIONING = OFF);

-- Optionally, you can DROP PERIOD to revert the table to a non-temporal
ALTER TABLE tablename DROP PERIOD FOR SYSTEM_TIME;
