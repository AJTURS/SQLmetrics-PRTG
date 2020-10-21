--Put script into into ....\custom sensors\sql\mssql  folder on server to be monitored

DECLARE @BatchRequests Bigint;
DECLARE @BatchResult BigInt;
DECLARE @CheckpointRequests Bigint;
DECLARE @CheckpointResult BigInt;
DECLARE @LockRequests Bigint;
DECLARE @LockResult BigInt;
DECLARE @SplitsRequests BigInt;
DECLARE @SplitsResult BigInt;
DECLARE @CompileRequests BigInt;
DECLARE @CompileResult BigInt;
DECLARE @ReCompileRequests BigInt;
DECLARE @ReCompileResult BigInt;

-- Calculate the actual working values over 1 second period
SELECT @BatchRequests = cntr_Value FROM sys.dm_os_performance_Counters WHERE counter_name = 'Batch Requests/sec';
SELECT @CheckpointRequests = cntr_Value FROM sys.dm_os_performance_Counters WHERE counter_name = 'Checkpoint pages/sec';
SELECT @LockRequests = cntr_value FROM sys.dm_os_performance_counters WHERE counter_name = 'Lock Waits/sec' AND instance_name = '_Total';
SELECT @SplitsRequests = cntr_value FROM sys.dm_os_performance_counters WHERE counter_name = 'Page Splits/sec';
SELECT @CompileRequests = cntr_value FROM sys.dm_os_performance_counters WHERE counter_name = 'SQL Compilations/sec';
SELECT @ReCompileRequests = cntr_value FROM sys.dm_os_performance_counters WHERE counter_name = 'SQL Re-Compilations/sec';
WaitFor Delay '00:00:01';
--Gather data again and calculate the change
SELECT @BatchResult= cntr_Value - @BatchRequests FROM sys.dm_os_performance_Counters WHERE counter_name = 'Batch Requests/sec';
SELECT @CheckpointResult= cntr_Value - @CheckpointRequests FROM sys.dm_os_performance_Counters WHERE counter_name = 'Checkpoint pages/sec';
SELECT @LockResult = cntr_value - @LockRequests FROM sys.dm_os_performance_counters WHERE counter_name = 'Lock Waits/sec' AND instance_name = '_Total';
SELECT @SplitsResult= cntr_value - @SplitsRequests  FROM sys.dm_os_performance_counters WHERE counter_name = 'Page Splits/sec';
SELECT @CompileResult = cntr_value - @CompileRequests FROM sys.dm_os_performance_counters WHERE counter_name = 'SQL Compilations/sec';
SELECT @ReCompileResult = cntr_value - @ReCompileRequests FROM sys.dm_os_performance_counters WHERE counter_name = 'SQL Re-Compilations/sec';

--Return the results
Select * from
(SELECT @BatchResult AS [Batch requests/Sec]) AS A,
(SELECT @CheckpointResult AS [Checkpoint pages/sec]) AS B,
(SELECT @LockResult AS [Lock Waits/sec]) AS C,
(SELECT cntr_value AS [Page life expectancy] FROM sys.dm_os_performance_counters WHERE object_name ='SQLServer:Buffer Manager' AND counter_name = 'Page life expectancy') AS D,
(SELECT @SplitsResult AS [Page Splits/sec]) AS E,
(SELECT cntr_value AS [Processes Blocked] FROM sys.dm_os_performance_counters WHERE counter_name = 'Processes Blocked') AS F,
(SELECT @CompileResult AS [SQL Compilations/sec]) AS G,
(SELECT @ReCompileResult AS [SQL ReCompilations/sec]) AS H,
(SELECT cntr_value AS [User Connections] from sys.dm_os_performance_counters where counter_name = 'User Connections') as I;
