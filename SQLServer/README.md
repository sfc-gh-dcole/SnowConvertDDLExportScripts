# SQL Server Export Scripts

This repository provides some simple scripts to help exporting your SQLServer code so it can be migrated to [Snowflake](https://www.snowflake.com/) using [SnowConvert](https://www.mobilize.net/products/database-migrations/snowconvert)

## Version

Version 2.1
Release 2022-02-22

## Usage

The `extract-sql-server-ddl.ps1` script attempts to connect to an instance of SQL Server and, for each database/schema that survives inclusion/exclusion filters, retrieves object Data Definition Language (DDL) to files in a specified directory.

**SQL Server tested versions**: `SQL Server 2019`, `Azure SQLDatabase`

The following parameters are prompted for during script execution if not specified on the command line:

* **ServerName**: The server to connect to.  Default is to connect to the server executing the script (i.e., localhost).
* **InstanceName**: The named instance to use on **ServerName**.  Default is to use the default instance on **ServerName** (i.e., MSSQLSERVER).
* **PortNumber**: The port number to use on **ServerName**.  Overrides **InstanceName** if **InstanceName** is also specified.  Default is to not use a port number.
* **UserName**: The user name to use with SQL Authentication.  Default is to use the currently-logged-in user with Windows Authentication.
* **Password**: The password associated with **UserName** to use with SQL Authentication.  Default is to use the currently-logged-in user with Windows Authentication.
* **ScriptDirectory**: The top-level directory under which server-, instance-, database-, and object-related files are stored.  Default is '.\ScriptDirectory'.
* **IncludeDatabases**: Which database(s) to include via a comma-delimited list of patterns (using PowerShell -match syntax).  Default is to include all (other than SQL Server system databases; see **IncludeSystemDatabases**).
* **ExcludeDatabases**: Which database(s) to exclude via a comma-delimited list of patterns (using PowerShell -match syntax).  Default is to exclude none.
* **IncludeSchemas**: Which schema(s) to include via a comma-delimited list of patterns (using PowerShell -match syntax).  Default is to include all.
* **ExcludeSchemas**: Which schema(s) to exclude via a comma-delimited list of patterns (using PowerShell -match syntax).  Default is to exclude none.
* **IncludeSystemDatabases**: Specify whether to include SQL Server system databases when applying **IncludeDatabases** and **ExcludeDatabases** filters.  Default is to exclude SQL Server system databases.

The following parameters are NOT prompted for during script execution but can be optionally specified on the command line:

* **ExistingDirectoryAction**: Specify whether to automatically 'delete' or 'keep' existing directories in **ScriptDirectory**.  Default is to interactively prompt whether to 'delete' or 'keep' each existing directory encountered.
* **NoSysAdminAction**: Specify whether to automatically 'stop' or 'continue' execution should the authenticated user not be a member of the 'sysadmin' group on **InstanceName** or if role membership cannot be determined.  Default is to interactively prompt whether to 'stop' or 'continue' execution.

**INPUTS**: None.  You cannot pipe objects to extract-sql-server-ddl.ps1.

**OUTPUTS**: System.String.

## Here some examples of how to use the script:

Example 1: invoke the script, enter (default) values for all prompted parameters, respond if the authenticated user is not a member of the 'sysadmin' group, and respond if existing directores in **ScriptDirectory** are encountered

```ps
PS> .\extract-sql-server-ddl.ps1
```

Example 2: invoke the script, enter (default) values for remaining prompted parameters (including **Password**), connect as juser using SQL Authentication to the named instance bar on foo.database.windows.net, respond if the authenticated user is not a member of the 'sysadmin' group, and automatically delete existing directores in **ScriptDirectory** when encountered

```ps
PS> .\extract-sql-server-ddl.ps1 -UserName juser -ServerName foo.database.windows.net -InstanceName bar -ExistingDirectoryAction delete
```

Example 3: invoke the script, enter (default) values for all prompted parameters, automatically stop if the authenticated user isn't a member of the 'sysadmin' group, and respond if existing directores in **ScriptDirectory** are encountered

```ps
PS> .\extract-sql-server-ddl.ps1 -NoSysAdminAction stop
```

## For More Information

For more information on the Microsoft SqlServer SMO assemblies used by this script, please visit: https://docs.microsoft.com/en-us/sql/relational-databases/server-management-objects-smo/installing-smo.

For more information on PowerShell match syntax, please visit: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_regular_expressions.

## Reporting issues and feedback

If you encounter any bugs with the tool please file an issue in the
[Issues](https://github.com/MobilizeNet/SnowConvertDDLExportScripts/issues) section of our GitHub repo.

## License

These scripts are licensed under the [MIT license](https://github.com/MobilizeNet/SnowConvertDDLExportScripts/blob/main/SQLServer/LICENSE.txt).
