IF OBJECT_ID('Brkr.MessageTask') IS NULL
 CREATE TABLE Brkr.MessageTask(
  TaskId UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_MessageTask PRIMARY KEY CLUSTERED,
  ConversationHandle UNIQUEIDENTIFIER NULL,
  FromService NVARCHAR(256) NOT NULL,
  ToService NVARCHAR(256) NOT NULL,
  Contract NVARCHAR(256) NOT NULL,
  UseEncryption BIT NOT NULL CONSTRAINT DF_MessageTask_UseEncryption DEFAULT(0),
  MessageType NVARCHAR(256) NOT NULL,
  MessageBody VARBINARY(MAX) NULL,
  RetryCount TINYINT NOT NULL CONSTRAINT DF_MessageTak_RetryCount DEFAULT(0),
  CONSTRAINT FK_MessageTask_Task FOREIGN KEY (TaskId) REFERENCES Brkr.Task(TaskId)
 )
GO