IF NOT EXISTS(SELECT 1 FROM sys.types WHERE name = 'Parameters' AND schema_id = SCHEMA_ID('Brkr'))
 CREATE TYPE Brkr.[Parameters] AS TABLE(
  Name NVARCHAR(128) NOT NULL PRIMARY KEY,
  Value NVARCHAR(MAX) NULL,
  Expression NVARCHAR(MAX) NULL,
  CHECK (Value IS NOT NULL OR Expression IS NOT NULL)
 )
GO
  