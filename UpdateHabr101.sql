--------------------------------------------------------------------------------------------
if object_id('TR_device') is not null drop TRIGGER TR_device
GO

CREATE TRIGGER TR_device ON device
FOR UPDATE 
NOT FOR REPLICATION
AS 
SET NOCOUNT ON
BEGIN
	UPDATE w SET ws_stamp = stamp FROM WaterStation w JOIN INSERTED ins ON w.mli=ins.mli
END
GO

UPDATE global_config set gc_value = '1.0.1' where gc_attribute = 'database.version';
GO

