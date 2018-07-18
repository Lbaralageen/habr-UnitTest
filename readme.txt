
How to setup enviroment.


1. Install Python runtime and pip package manager

    Python 2.7 x64;

    Click on the appropriate Windows installer msi link;

    Once downloaded run the msi to install Python runtime;

    Set Path in Control Panel>System and Security->System>Advanced system settings>Environment Variables...->Path>Edit>Add C:\Python27


2. Install pip


    Download get-pip.py to a folder on your computer.

    Open a command prompt window and navigate to the folder containing get-pip.py.

    Then run python get-pip.py.

    This will install pip.


3. Download pymssql module from here


Make sure you choose the correct whl file. For example : If you are using Python 2.7 on a 64 bit machine choose : pymssql?2.1.1?cp27?none?win_amd64.whl. Once you download the .whl file place it in the the C:/Python27 folder.

    Open cmd.exe;

    Install pymssql module;

    > cd c:\Python27  ;

    > pip install pymssql-2.2.0.dev0-cp27-cp27m-win_amd64.whl

4. Download simple-configparser module from here

    Unpack package to folder and run

    pip install .

    python setup.py install

5. Make sure you can svn.exe from everywhere  (Add path="c:\Program Files\TortoiseSVN\bin"); or modify for Git

6. Make sure you can SQLCMD.EXE from everywhere (Add path=c:\Program Files\Microsoft SQL Server\110\Tools\Binn\SQLCMD.EXE);


8. Install ODBC support for MSSQL. Download pyodbc-4.0.0-cp27-cp27m-win_amd64.whl and put into c:\Python27. Then install : pip install pyodbc-4.0.0-cp27-cp27m-win_amd64.whl
