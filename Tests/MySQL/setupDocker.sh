#!/bin/bash

docker run --name mysqlInst -e MYSQL_ROOT_PASSWORD=root -v $CODESPACE_VSCODE_FOLDER/DB2:/DDLExportScripts/export -d mysql

# You can create an user for tests like this:

# CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
# GRANT ALL PRIVILEGES ON * . * TO 'newuser'@'localhost';