IF NOT EXISTS(SELECT 1 FROM sys.procedures WHERE name = 'pr_Task_ProcessTask' AND schema_id = SCHEMA_ID('Brkr'))
 EXEC sp_executesql N'CREATE PROCEDURE Brkr.pr_Task_ProcessTask AS BEGIN SELECT 1 END'
GO

ALTER PROCEDURE Brkr.pr_Task_ProcessTask
 @TaskId UNIQUEIDENTIFIER 
AS
BEGIN

 DECLARE @TaskType NVARCHAR(100) 

 SELECT
  @TaskType = tt.Name
 FROM Brkr.Task t
  JOIN Brkr.TaskType tt ON t.TaskTypeId = tt.TaskTypeId
 WHERE TaskId = @TaskId
 
 IF (@TaskType = 'Service Broker Message')
  BEGIN

   BEGIN TRY

    DECLARE @sql NVARCHAR(MAX),
     @ch UNIQUEIDENTIFIER,
	 @message_body VARBINARY(MAX)

	 SELECT
	  @ch = ConversationHandle,
	  @message_body = MessageBody
	 FROM Brkr.MessageTask
	 WHERE TaskId = @TaskId

     -- If ConversationHandler is null then begin new dialog
     SELECT
      @sql = CONCAT(
	   N'BEGIN DIALOG CONVERSATION @ch FROM SERVICE ', FromService,
	   N' TO SERVICE ''', ToService, ''' ON CONTRACT [',
	   Contract, '] WITH ENCRYPTION = ', CASE WHEN UseEncryption = 1 THEN 'ON' ELSE 'OFF' END,
	   '; ')
     FROM Brkr.MessageTask
     WHERE TaskId = @TaskId
      AND ConversationHandle IS NULL

     SELECT
      @sql = CONCAT(
	  @sql, N'SEND ON CONVERSATION @ch MESSAGE TYPE [',
	  MessageType, N'] (@message_body);'
	 )
     FROM Brkr.MessageTask
     WHERE TaskId = @TaskId

     EXEC sp_executesql @sql, N'@ch UNIQUEIDENTIFIER, @message_body VARBINARY(MAX)', @ch, @message_body;

	 UPDATE Brkr.Task
	 SET WasSuccessfull = 1,
	  ProcessedDateTime = GETUTCDATE()
	 WHERE TaskId = @TaskId

   END TRY
   BEGIN CATCH
    
	UPDATE Brkr.Task
	SET WasSuccessfull = 0
	WHERE TaskId = @TaskId

   END CATCH

  END

END

