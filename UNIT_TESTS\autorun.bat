SET back=%CD%

rem ---------- read  connection.ini                 ------------

for /f "tokens=1,2 delims==" %%a in (config.ini) do (
if %%a==server     set server=%%b
if %%a==sqlcmd     set sqlcmd=%%b
if %%a==engine     set engine=%%b
if %%a==pathengine set pathengine=%%b
if %%a==script     set script=%%b
if %%a==dbmaker    set dbmaker=%%b
) 

if exist %script% del %script% > nul
if exist scriptdb.sql del scriptdb.sql > nul
if exist dbname.ini del dbname.ini > nul
cd ..

svn up

rem ---------- run batch to create full MSSQL script  ------------
call %dbmaker%

copy %script% %back%\%script%

cd %back%

rem ---------- process sql script and replace database name  ------------

python replacedb.py 

rem ---------- create db schema in new database              ------------

copy /Y scriptdb.sql %pathengine%%script%

rem ---------- run engine                                    ------------

@echo %back%

cd %pathengine%
call %engine%
cd %back%

if exist %script% del %script% > nul
if exist scriptdb.sql del scriptdb.sql > nul

rem ---------- read  dbname.ini                               ------------

for /f "tokens=1,2 delims==" %%a in (dbname.ini) do (
if %%a==dbname set dbname=%%b
) 

rem ---------- run all unit tests in new db                  ------------

@echo %dbname% 

call autorunlocal.bat %dbname% 

rem ---------- drop database with random name -------------

call %sqlcmd% -S %server%  -E -Q  "DECLARE @sql sysname = N'DROP DATABASE [%dbname%]';EXEC SP_EXECUTESQL @sql"

if exist dbname.ini del dbname.ini > nul
if exist final.txt del final.txt > nul
if exist result.txt del result.txt > nul
