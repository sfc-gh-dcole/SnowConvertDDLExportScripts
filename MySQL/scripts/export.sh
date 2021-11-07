#!/bin/bash
# Optional variables for a backup script
MYSQL_USER="newuser"
MYSQL_PASS="password"
DB_HOST="localhost"
BACKUP_DIR=./output;
test -d "$BACKUP_DIR" || mkdir -p "$BACKUP_DIR"
echo "Mobilize.NET MySQL DDL Export"
# Get the database list, exclude information_schema
for db in $(mysql -B -s -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -e 'show databases' 2>/dev/null | grep -v information_schema)
do
    echo "###########################################"
    echo "Exporting database $db"
    echo "###########################################"
    #export tables
    ##############################
    DIR="$BACKUP_DIR/$db/table"
    mkdir -p $DIR
    tbl_count=0
    GET_TABLES="SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_SCHEMA='$db' and  TABLE_TYPE LIKE 'BASE TABLE'"
    for t in $(mysql -sN -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -D $db -e "$GET_TABLES" 2>/dev/null) 
    do 
        echo "DUMPING TABLE: $db.$t"
        echo "/*<sc-table> $db.$t </sc-table>*/" >  $BACKUP_DIR/$db/table/$t.sql
        mysqldump --no-data --skip-add-drop-table -h $DB_HOST -u $MYSQL_USER -p$MYSQL_PASS $db $t 2>/dev/null >> $BACKUP_DIR/$db/table/$t.sql
        tbl_count=$(( tbl_count + 1 ))
    done
    echo "$tbl_count tables dumped from database '$db' into dir=$DIR"
    #export views
    ###################
    DIR="$BACKUP_DIR/$db/view"
    mkdir -p $DIR
    v_count=0
    GET_VIEW="SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_SCHEMA='$db' and  TABLE_TYPE LIKE 'VIEW'"
    for v in $(mysql -sN -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -D $db -e "$GET_VIEW" 2>/dev/null) 
    do 
        echo "DUMPING VIEW: $db.$v"
        echo "/*<sc-view> $db.$v </sc-view>*/" >  $BACKUP_DIR/$db/view/$v.sql
        mysqldump --no-data  --skip-add-drop-table -h $DB_HOST -u $MYSQL_USER -p$MYSQL_PASS $db $v 2>/dev/null >> $BACKUP_DIR/$db/view/$v.sql
        v_count=$(( v_count + 1 ))
    done
    echo "$v_count views dumped from database '$db' into dir=$DIR"
    #export functions
    ###################
    DIR="$BACKUP_DIR/$db/function"
    mkdir -p $DIR
    f_count=0
    GET_FUNCTION="select routine_name from information_schema.routines where routine_schema='$db' and routine_type='FUNCTION'"
    
    for f in $(mysql -sN -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -D $db -e "$GET_FUNCTION" 2>/dev/null) 
    do 
        echo "DUMPING FUNCTION: $db.$f"
        echo "/*<sc-function> $db.$f </sc-function>*/" >  $BACKUP_DIR/$db/function/$f.sql
        GET_FUNCTION_DEF="select CONCAT(\"CREATE FUNCTION \",specific_name,\"(\", GROUP_CONCAT(CONCAT(parameter_mode,\" \",parameter_name,\" \",data_type)),\") RETURNS \" ,(select data_type from information_schema.parameters where specific_name='$f' and specific_schema='$db' and parameter_name is null))  from information_schema.parameters where specific_name='$f' and specific_schema='$db' and parameter_name is not null and routine_type='FUNCTION' order by ordinal_position"
        GET_FUNCTION_CODE="select routine_definition from information_schema.routines where routine_schema='$db' and routine_name='$f' and routine_type='FUNCTION'"
        mysql -sN -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -D $db -e "$GET_FUNCTION_DEF" 2>/dev/null >> $BACKUP_DIR/$db/function/$f.sql
        mysql -sN -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -D $db -e "$GET_FUNCTION_CODE" 2>/dev/null | sed 's/\\n/\
/g'>> $BACKUP_DIR/$db/function/$f.sql 
        f_count=$(( f_count + 1 ))
    done
    echo "$f_count functions dumped from database '$db' into dir=$DIR"


    #export procedures
    ###################
    DIR="$BACKUP_DIR/$db/procedure"
    mkdir -p $DIR
    p_count=0
    GET_PROC="select routine_name from information_schema.routines where routine_schema='$db' and routine_type='PROCEDURE'"
    
    for p in $(mysql -sN -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -D $db -e "$GET_PROC" 2>/dev/null) 
    do 
        echo "DUMPING PROCEDURE: $db.$p"
        echo "/*<sc-procedure> $db.$p </sc-procedure>*/" >  $BACKUP_DIR/$db/procedure/$p.sql
        GET_PROCEDURE_DEF="select CONCAT(\"CREATE PROCEDURE \",specific_name,\"(\", GROUP_CONCAT(CONCAT(parameter_mode,\" \",parameter_name,\" \",data_type)),\") \" )  from information_schema.parameters where specific_name='$p' and specific_schema='$db' and parameter_name is not null and routine_type='PROCEDURE' order by ordinal_position"
        GET_PROCEDURE_CODE="select routine_definition from information_schema.routines where routine_schema='$db' and routine_name='$p' and routine_type='PROCEDURE'"
        mysql -sN -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -D $db -e "$GET_PROCEDURE_DEF" 2>/dev/null >> $BACKUP_DIR/$db/procedure/$p.sql
        mysql -sN -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -D $db -e "$GET_PROCEDURE_CODE" 2>/dev/null | sed 's/\\n/\
/g'>> $BACKUP_DIR/$db/procedure/$p.sql 
        p_count=$(( p_count + 1 ))
    done
    echo "$p_count procedures dumped from database '$db' into dir=$DIR"

    ###################
    ## Export triggers
    DIR="$BACKUP_DIR/$db/trigger"
    mkdir -p $DIR
    t_count=0
    GET_TRIGGER="select trigger_name from information_schema.triggers where trigger_schema='$db'"
    
    for t in $(mysql -sN -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -D $db -e "$GET_TRIGGER" 2>/dev/null) 
    do 
        echo "DUMPING TRIGGER: $db.$t"
        echo "/*<sc-trigger> $db.$t </sc-trigger>*/" >  $BACKUP_DIR/$db/trigger/$t.sql
        GET_TRIGGER_DEF="select CONCAT(\"CREATE TRIGGER \",TRIGGER_SCHEMA,\".\",TRIGGER_NAME,\" \",ACTION_TIMING,\" \",EVENT_MANIPULATION,\" ON \",EVENT_OBJECT_SCHEMA,\".\",EVENT_OBJECT_TABLE,\" FOR EACH ROW\n\",ACTION_STATEMENT )  from information_schema.triggers where trigger_name='$t' and trigger_schema='$db'"
        mysql -sN -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -D $db -e "$GET_TRIGGER_DEF" 2>/dev/null | sed 's/\\n/\
/g'>> $BACKUP_DIR/$db/trigger/$t.sql 
        t_count=$(( t_count + 1 ))
    done
    echo "$t_count triggers dumped from database '$db' into dir=$DIR"    

done
