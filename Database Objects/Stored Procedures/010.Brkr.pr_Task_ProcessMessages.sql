IF NOT EXISTS(SELECT 1 FROM sys.procedures WHERE name = 'pr_Task_ProcessMessages' AND schema_id = SCHEMA_ID('Brkr'))
 EXEC sp_executesql N'CREATE PROCEDURE Brkr.pr_Task_ProcessMessages AS BEGIN SELECT 1 END'
GO

ALTER PROCEDURE Brkr.pr_Task_ProcessMessages
AS 
BEGIN

 SET NOCOUNT ON;
 DECLARE @ch UNIQUEIDENTIFIER,
  @messagetypename NVARCHAR(256)

 BEGIN TRY
  BEGIN TRANSACTION;

   WAITFOR (
    RECEIVE TOP (1)
	 @ch = conversation_handle,
	 @messagetypename = message_type_name
	FROM Brkr.TaskQueue
   ), TIMEOUT 1000

   IF (@@ROWCOUNT != 0)
   BEGIN

    IF (@messagetypename = 'http://schemas.microsoft.com/SQL/ServiceBroker/DialogTimer')
	BEGIN
	 EXEC Brkr.pr_Task_ProcessTask  @ch
	 END CONVERSATION @ch;
	END

	IF (@messagetypename = 'http://schemas.microsoft.com/SQL/ServiceBroker/EndDialog')
	BEGIN
	 END CONVERSATION @ch
    END
	
   END
  
   COMMIT TRANSACTION
  END TRY
 
  BEGIN CATCH
  -- Rollback transaction if uncommittable
  IF XACT_STATE() = -1
  BEGIN
   ROLLBACK TRANSACTION;
  END

  -- Otherwise end conversation with error
  ELSE
  BEGIN

   DECLARE @errorNo INT, @message NVARCHAR(4000)
   SELECT @errorNo = ERROR_NUMBER(), @message = ERROR_MESSAGE();
   END CONVERSATION @ch WITH error = @errorNo description = @message;
   COMMIT TRANSACTION;

  END 
 END CATCH


END