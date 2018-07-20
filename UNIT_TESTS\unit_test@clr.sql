SET QUOTED_IDENTIFIER ON
GO
PRINT '--------------------------------  CLR Unit tests for Habr Logic  ---------------------------------' 

IF 0 < ( SELECT count(*) FROM device)
begin
   RAISERROR ('FAILED: database must be empty for this unit test', 16, -1 )
end
GO
----------------------------------------------------------------------------------------------------------
BEGIN TRAN TestClr1
declare @test_name sysname = (select TOP 1 name from sys.dm_tran_active_transactions WHERE transaction_type = 1 ORDER BY transaction_begin_time DESC) 
    + ' [fn_calculate_dev_status] NO records in device'
BEGIN TRY  SET NOCOUNT ON;

-- 1. prepare data for unit test

insert into device (mli, oxygen, stamp ) values ('111',  3.14, getdate() )

-- 2. execute unit test          -- SELECT dbo.fn_calculate_dev_status( 'CM603', 0.1, 1.2)
declare @result int = ( SELECT dbo.fn_calculate_dev_status( '222', 0.1, 1.2) )

END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber,    ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE()   AS ErrorState
         , @test_name     AS ErrorProcedure, ERROR_LINE()     AS ErrorLine,     ERROR_MESSAGE() AS ErrorMessage
END CATCH

-- 3. result verification

IF  @result <> -1
   RAISERROR ('FAILED: %s no data for device should be presented %d  ', 16, -1, @test_name, @result ) 
ELSE
    print 'PASSED ' + @test_name

ROLLBACK TRAN TestClr1
GO
----------------------------------------------------------------------------------------------------------
BEGIN TRAN TestClr2
declare @test_name sysname = (select TOP 1 name from sys.dm_tran_active_transactions WHERE transaction_type = 1 ORDER BY transaction_begin_time DESC) 
    + ' [fn_calculate_dev_status] record for device has wrong range'
BEGIN TRY  SET NOCOUNT ON;

-- 1. prepare data for unit test

insert into device (mli, oxygen, stamp ) values ('111',  5.55, getdate() )

-- 2. execute unit test          -- SELECT dbo.fn_calculate_dev_status( 111, 0.1, 1.2)
declare @result int = ( SELECT dbo.fn_calculate_dev_status( '111', 0.1, 1.2) )

END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber,    ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE()   AS ErrorState
         , @test_name     AS ErrorProcedure, ERROR_LINE()     AS ErrorLine,     ERROR_MESSAGE() AS ErrorMessage
END CATCH

-- 3. result verification

IF  @result <> 0
   RAISERROR ('FAILED: %s no data for device should be presented %d  ', 16, -1, @test_name, @result ) 
ELSE
    print 'PASSED ' + @test_name

ROLLBACK TRAN TestClr2
GO
----------------------------------------------------------------------------------------------------------
BEGIN TRAN TestClr3
declare @test_name sysname = (select TOP 1 name from sys.dm_tran_active_transactions WHERE transaction_type = 1 ORDER BY transaction_begin_time DESC) 
        + ' [fn_calculate_dev_status] record for device has right value'
BEGIN TRY  SET NOCOUNT ON;

-- 1. prepare data for unit test

insert into device (mli, oxygen, stamp ) values ('111',  1.14, getdate() )

-- 2. execute unit test          -- SELECT dbo.fn_calculate_dev_status( 111, 0.1, 1.2)
declare @result int = ( SELECT dbo.fn_calculate_dev_status( '111', 0.1, 1.2) )

END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber,    ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE()   AS ErrorState
         , @test_name     AS ErrorProcedure, ERROR_LINE()     AS ErrorLine,     ERROR_MESSAGE() AS ErrorMessage
END CATCH

-- 3. result verification

IF  @result <> 1
   RAISERROR ('FAILED: %s no data for device should be presented %d  ', 16, -1, @test_name, @result ) 
ELSE
    print 'PASSED ' + @test_name

ROLLBACK TRAN TestClr3
GO
----------------------------------------------------------------------------------------------------------
PRINT '--------------------------------------------------------------------------------------------------' 
---------------------------------------------------------------------------------------------------------- 
