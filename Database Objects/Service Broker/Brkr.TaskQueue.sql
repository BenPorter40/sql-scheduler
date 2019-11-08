IF NOT EXISTS(SELECT 1 FROM sys.service_queues WHERE name = 'TaskQueue' AND schema_id = SCHEMA_ID('Brkr'))
 EXEC sp_executesql N'CREATE QUEUE Brkr.TaskQueue WITH STATUS = OFF'
GO

ALTER QUEUE Brkr.TaskQueue
 WITH STATUS = ON, 
 RETENTION = OFF, 
 ACTIVATION (  
  STATUS = ON, 
  PROCEDURE_NAME = Brkr.pr_Task_ProcessMessages, 
  MAX_QUEUE_READERS = 5, 
  EXECUTE AS OWNER ), 
 POISON_MESSAGE_HANDLING (STATUS = ON) 
GO


