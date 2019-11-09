IF NOT EXISTS(SELECT 1 FROM sys.procedures WHERE name = 'pr_Task_AddStoredProcedure' AND schema_id = SCHEMA_ID('Brkr'))
 EXEC sp_executesql N'CREATE PROCEDURE Brkr.pr_Task_AddStoredProcedure AS BEGIN SELECT 1 END'
GO

ALTER PROCEDURE Brkr.pr_Task_AddStoredProcedure(
 @RunDateTime DATETIME2(3),
 @ProcedureName NVARCHAR(128),
 @Parameters Brkr.Parameters READONLY)
AS
BEGIN

 DECLARE @ch UNIQUEIDENTIFIER,
  @TimeOut INT,
  @TaskTypeId INT

 SELECT @TaskTypeId = TaskTypeId FROM Brkr.TaskType WHERE Name = 'Stored Procedure';
 SELECT @TimeOut = DATEDIFF(SECOND, GETUTCDATE(), @RunDateTime);

 BEGIN DIALOG CONVERSATION @ch
 FROM SERVICE TaskService
 TO SERVICE 'TaskService', 'Current Database'
 ON CONTRACT [Rubicon/Task/Contract]
 WITH ENCRYPTION = OFF;

 INSERT INTO Brkr.Task(
  TaskId,
  TaskTypeId,
  ScheduledDateTime)
 VALUES
  (@ch, @TaskTypeId, @RunDateTime);

 INSERT INTO Brkr.StoredProcedureTask(
  TaskId,
  Name)
 VALUES
  (@ch, @ProcedureName)

 INSERT INTO Brkr.StoredProcedureTaskParameters(
  TaskId,
  ParameterName,
  Value,
  Expression)
 SELECT
  @ch,
  Name,
  Value,
  Expression
 FROM @Parameters

 BEGIN CONVERSATION TIMER(@ch)
 TIMEOUT = @TimeOut; 

END