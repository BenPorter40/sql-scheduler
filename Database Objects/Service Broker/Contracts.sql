IF NOT EXISTS(SELECT 1 FROM sys.service_contracts WHERE name = 'Rubicon/Task/Contract')
 CREATE CONTRACT [Rubicon/Task/Contract] (
  [http://schemas.microsoft.com/SQL/ServiceBroker/DialogTimer] SENT BY INITIATOR
 )
GO


