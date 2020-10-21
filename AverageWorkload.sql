--Put script into into ....\custom sensors\sql\mssql  folder on server to be monitored

Select * from
(SELECT cntr_Value / datediff(ss, ( SELECT create_Date FROM sys.databases WHERE name like 'tempdb'),getdate()) as [Avg Batch Requests/sec] FROM sys.dm_os_performance_Counters WHERE counter_name = 'Batch Requests/sec'   ) as A,

(SELECT cntr_Value / datediff(ss, ( SELECT create_Date FROM sys.databases WHERE name like 'tempdb'),getdate()) as [Avg Checkpoint pages/sec] FROM sys.dm_os_performance_Counters WHERE counter_name = 'Checkpoint pages/sec') as B,

(SELECT cntr_Value / datediff(ss, ( SELECT create_Date FROM sys.databases WHERE name like 'tempdb'),getdate()) as [Avg Lock Waits/sec] FROM sys.dm_os_performance_Counters WHERE counter_name = 'Lock Waits/sec' AND instance_name = '_Total') as C, 

(SELECT cntr_Value / datediff(ss, ( SELECT create_Date FROM sys.databases WHERE name like 'tempdb'),getdate()) as [Avg Page Splits/sec] FROM sys.dm_os_performance_Counters  WHERE counter_name = 'Page Splits/sec') as D,

(SELECT cntr_Value / datediff(ss, ( SELECT create_Date FROM sys.databases WHERE name like 'tempdb'),getdate()) as [Avg SQL Compilations/sec] FROM sys.dm_os_performance_Counters WHERE counter_name = 'SQL Compilations/sec') as E, 

(SELECT cntr_Value / datediff(ss, ( SELECT create_Date FROM sys.databases WHERE name like 'tempdb'),getdate()) as [Avg SQL Re-Compilations/sec] FROM sys.dm_os_performance_Counters WHERE counter_name = 'SQL Re-Compilations/sec') as F, 

(SELECT ISNULL((SELECT cast(cntr_Value / datediff(ss, ( SELECT create_Date FROM sys.databases WHERE name like 'tempdb'),getdate())as float) as [Avg SQL Compilations/sec] FROM sys.dm_os_performance_Counters WHERE counter_name = 'SQL Compilations/sec')/ NULLIF((SELECT cast(cntr_Value / datediff(ss, ( SELECT create_Date FROM sys.databases WHERE name like 'tempdb'),getdate()) as float) as [Avg Batch Requests/sec] FROM sys.dm_os_performance_Counters WHERE counter_name = 'Batch Requests/sec'),0.00),0.00)*100 as [Avg SQL Compilations/Batch Percent])as G,

(SELECT ISNULL((SELECT cast(cntr_Value / datediff(ss, ( SELECT create_Date FROM sys.databases WHERE name like 'tempdb'),getdate())as float) as [Avg SQL Compilations/sec] FROM sys.dm_os_performance_Counters WHERE counter_name = 'SQL Re-Compilations/sec')/ NULLIF((SELECT cast(cntr_Value / datediff(ss, ( SELECT create_Date FROM sys.databases WHERE name like 'tempdb'),getdate()) as float) as [Avg Batch Requests/sec] FROM sys.dm_os_performance_Counters WHERE counter_name = 'Batch Requests/sec'),0.00),0.00)*100 as [Avg SQL ReCompilations/Batch Percent]) as H;
