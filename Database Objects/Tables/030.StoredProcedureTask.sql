IF OBJECT_ID('Brkr.StoredProcedureTask') IS NULL
 CREATE TABLE Brkr.StoredProcedureTask(
  TaskId UNIQUEIDENTIFIER NOT NULL CONSTRAINT PK_StoredProcedureTask PRIMARY KEY CLUSTERED,
  Name NVARCHAR(128) NOT NULL
 )
GO