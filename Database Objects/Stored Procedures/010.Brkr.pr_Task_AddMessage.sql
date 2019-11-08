IF NOT EXISTS(SELECT 1 FROM sys.procedures WHERE name = 'pr_Task_AddMessage' AND schema_id = SCHEMA_ID('Brkr'))
 EXEC sp_executesql N'CREATE PROCEDURE Brkr.pr_Task_AddMessage AS BEGIN SELECT 1 END'
GO

ALTER PROCEDURE Brkr.pr_Task_AddMessage
 @RunDateTime DATETIME2(3),
 @FromService NVARCHAR(256),
 @ToService NVARCHAR(256),
 @Contract NVARCHAR(256),
 @MessageType NVARCHAR(256),
 @MessageBody VARBINARY(MAX),
 @ConversationHandle UNIQUEIDENTIFIER = NULL
AS
BEGIN

 DECLARE @ch UNIQUEIDENTIFIER,
  @TimeOut INT,
  @TaskTypeId INT

 SELECT @TaskTypeId = TaskTypeId FROM Brkr.TaskType WHERE Name = 'Service Broker Message';
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

 INSERT INTO Brkr.MessageTask(
  TaskId,
  ConversationHandle,
  FromService,
  ToService,
  Contract,
  MessageType,
  MessageBody)
 VALUES
  (@ch, @ConversationHandle, @FromService, @ToService, @Contract, @MessageType, @MessageBody);

 BEGIN CONVERSATION TIMER(@ch)
 TIMEOUT = @TimeOut;

END
GO