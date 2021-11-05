#!/bin/bash
echo "DB2 DDL Export script"
echo "Getting list of databases"
OUTPUTDIR="../object_extracts"
### Get List of Database

## You can modify this variable to exclude some databases:
## For example if you want to exclude database TESTDB just set:
## DATABASES_TO_EXCLUDE="TESTDB"
## If you want to exclude database TESTDB and database SAMPLE just set:
## DATABASES_TO_EXCLUDE="TESTDB|SAMPLE"
## You can use regular any valid regular expression as a pattern to exclude the databases to exclude
DATABASES_TO_EXCLUDE="XXXXXXX"

DDLS="$OUTPUTDIR/DDL"
mkdir -p $DDLS
DBS=$( db2 list db directory | grep Indirect -B 5 |grep "Database alias" |awk {'print $4'} |sort -u | uniq 2>/dev/null | grep -v -E $DATABASES_TO_EXCLUDE)
for db in $DBS
do
    mkdir -p "$DDLS/$db"
    echo "Processing Database $db"
    db2look -d $db -e -l > "$DDLS/$db/DDL_All.sql"
done