IF NOT EXISTS(SELECT 1 FROM sys.services WHERE name = 'TaskService')
CREATE SERVICE [TaskService]  
 ON QUEUE Brkr.TaskQueue ([Rubicon/Task/Contract])
GO


