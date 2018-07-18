SET QUOTED_IDENTIFIER ON
GO
PRINT '--------------------------------  CLR Unit tests for Habr Logic  ---------------------------------' 
IF 0 < ( SELECT count(*) FROM device)
begin
   RAISERROR ('FAILED: database must be empty for this unit test', 16, -1 )
end
GO
----------------------------------------------------------------------------------------------------------
BEGIN TRAN TestUpdate1a
declare @test_name sysname = (select TOP 1 name from sys.dm_tran_active_transactions WHERE transaction_type = 1 ORDER BY transaction_begin_time DESC) 
    + ' [TR_device] Update date by trigger'
BEGIN TRY  SET NOCOUNT ON;

-- 1. prepare data for unit test

insert into device (mli, oxygen, stamp ) values ('111',  3.14, getdate() )
insert into WaterStation (mli, ws_name, ws_stamp ) values ('111',  '111', '20000101' )

-- 2. execute unit test

UPDATE device SET oxygen = 2.71 WHERE mli = '111'

END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber,    ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE()   AS ErrorState
         , @test_name     AS ErrorProcedure, ERROR_LINE()     AS ErrorLine,     ERROR_MESSAGE() AS ErrorMessage
END CATCH

-- 3. result verification

declare @result int = ( SELECT COUNT(*) FROM WaterStation WHERE ws_stamp <> '20000101' )

IF  @result <> 1
   RAISERROR ('FAILED: %s no data for device should be presented %d  ', 16, -1, @test_name, @result ) 
ELSE
    print 'PASSED ' + @test_name

ROLLBACK TRAN TestUpdate1a
GO
----------------------------------------------------------------------------------------------------------
BEGIN TRAN TestUpdate1b
declare @test_name sysname = (select TOP 1 name from sys.dm_tran_active_transactions WHERE transaction_type = 1 ORDER BY transaction_begin_time DESC) 
    + ' [TR_device] Update date by trigger with different mli'
BEGIN TRY  SET NOCOUNT ON;

-- 1. prepare data for unit test

insert into device (mli, oxygen, stamp ) values ('111',  3.14, getdate() )
insert into WaterStation (mli, ws_name, ws_stamp ) values ('111',  '111', '20000101' )
insert into device (mli, oxygen, stamp ) values ('222',  3.14, getdate() )

-- 2. execute unit test

UPDATE device SET oxygen = 2.71 WHERE mli = '222'

END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber,    ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE()   AS ErrorState
         , @test_name     AS ErrorProcedure, ERROR_LINE()     AS ErrorLine,     ERROR_MESSAGE() AS ErrorMessage
END CATCH

-- 3. result verification

declare @result int = ( SELECT COUNT(*) FROM WaterStation WHERE ws_stamp = '20000101' )

IF  @result <> 1
   RAISERROR ('FAILED: %s no data for device should be presented %d  ', 16, -1, @test_name, @result ) 
ELSE
    print 'PASSED ' + @test_name

ROLLBACK TRAN TestUpdate1b
GO
----------------------------------------------------------------------------------------------------------
PRINT '--------------------------------------------------------------------------------------------------' 
----------------------------------------------------------------------------------------------------------
