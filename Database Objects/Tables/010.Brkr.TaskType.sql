IF OBJECT_ID('Brkr.TaskType') IS NULL
 CREATE TABLE Brkr.TaskType(
  TaskTypeId TINYINT NOT NULL IDENTITY (1,1) CONSTRAINT PK_TaskType PRIMARY KEY CLUSTERED,
  Name NVARCHAR(100) NOT NULL
 )
GO