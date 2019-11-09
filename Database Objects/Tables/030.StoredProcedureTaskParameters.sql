IF OBJECT_ID('Brkr.StoredProcedureTaskParameters') IS NULL
 CREATE TABLE Brkr.StoredProcedureTaskParameters(
  TaskId UNIQUEIDENTIFIER NOT NULL CONSTRAINT FK_StoredProcedureTaskParameters_Task FOREIGN KEY REFERENCES Brkr.Task(TaskId),
  ParameterName NVARCHAR(128) NOT NULL,
  Value NVARCHAR(MAX) NULL,
  Expression NVARCHAR(MAX) NULL,
  CONSTRAINT CK_StoredProcedureTaskParameters_ValueExpression CHECK (Value IS NOT NULL OR Expression IS NOT NULL),
  CONSTRAINT PK_StoredProcedureTaskParameters PRIMARY KEY CLUSTERED (TaskId, ParameterName)
 )
GO