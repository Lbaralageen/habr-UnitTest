create database [habr];
go
ALTER DATABASE [habr]
SET ALLOW_SNAPSHOT_ISOLATION ON
go
ALTER DATABASE [habr]
SET READ_COMMITTED_SNAPSHOT ON

-- Enable CLR integration
go
sp_configure 'show advanced options', 1
go
RECONFIGURE
go
sp_configure 'clr enabled', 1
go
RECONFIGURE
go

use [habr]
GO

CREATE TABLE device
(
	mli varchar(64) NOT NULL,
	stamp datetime2 NOT NULL CONSTRAINT df_device DEFAULT getdate(),
	oxygen float NULL,
    CONSTRAINT pk_device PRIMARY KEY ( mli )
)
GO
------------------------------------------------------------------------------
CREATE TABLE WaterStation
(
	mli       varchar(64) NOT NULL,
    ws_name   sysname   unique,
	ws_lat    float,
	ws_lon    float,
	ws_stamp  datetime2 NOT NULL CONSTRAINT df_WaterStation DEFAULT getdate(),
    CONSTRAINT pk_WaterStation PRIMARY KEY ( mli ),
    CONSTRAINT fk_WaterStation foreign key (mli) references device (mli),
    CONSTRAINT uk_WaterStation UNIQUE ( ws_name ),
)
GO
------------------------------------------------------------------------------
CREATE TABLE global_config
(
	gc_attribute		varchar(50) NOT NULL,
	gc_value			nvarchar(max) NULL,
	gc_user_name		nvarchar(128) NULL,
	gc_updatedate		datetime2 NOT NULL CONSTRAINT df_gc_updatedate DEFAULT getdate(),
    CONSTRAINT pk_global_config PRIMARY KEY ( gc_attribute ),
    INDEX ix_global_config NONCLUSTERED (gc_user_name)
)
GO
------------------------------------------------------------------------------
create function dbo.fn_calculate_dev_status( @mli varchar(64), @low float, @high float )
RETURNS INT
AS
BEGIN
  DECLARE @status INT = -1;

  IF EXISTS (SELECT * FROM device WHERE mli=@mli)
  BEGIN
      IF (SELECT oxygen FROM device WHERE mli=@mli) BETWEEN @low AND @high
      BEGIN
	    SET @status = 1;
      END
      ELSE
      BEGIN
        SET @status = 0;
      END
  END
  RETURN @status;
END
GO
------------------------------------------------------------------------------
UPDATE global_config set gc_value = '1.0.0' where gc_attribute = 'database.version';
GO
