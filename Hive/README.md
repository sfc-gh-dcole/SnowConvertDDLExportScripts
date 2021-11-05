# Hive DDL Export Scripts

This repository provides some simple scripts to help exporting your Hive code
so it can be migrated to [Snowflake](https://www.snowflake.com/) using [SnowConvert](https://www.mobilize.net/products/database-migrations/snowconvert)

## Version

Release 2021-10-14

## Usage

Create a shell script with the following contents:

```
#!/bin/bash
hiveDBName=testdbname;

showcreate="show create table "
showpartitions="show partitions "
terminate=";"

tables=`hive -e "use $hiveDBName;show tables;"`
tab_list=`echo "${tables}"`

rm -f ${hiveDBName}_all_table_partition_DDL.txt

for list in $tab_list
do
   showcreatetable=${showcreatetable}${showcreate}${list}${terminate}
   listpartitions=`hive -e "use $hiveDBName; ${showpartitions}${list}"`

   for tablepart in $listpartitions
   do
      partname=`echo ${tablepart/=/=\"}`
      echo $partname
      echo "ALTER TABLE $list ADD PARTITION ($partname\");" >> ${hiveDBName}_all_table_partition_DDL.txt
   done

done

echo " ====== Create Tables ======= : " $showcreatetable

## Remove the file
rm -f ${hiveDBName}_extract_all_tables.txt

hive -e "use $hiveDBName; ${showcreatetable}" >> ${hiveDBName}_extract_all_tables.txt
```


## Reporting issues and feedback

If you encounter any bugs with the tool please file an issue in the
[Issues](https://github.com/MobilizeNet/SnowConvertDDLExportScripts/issues) section of our GitHub repo.

## License

These export scripts are licensed under the [MIT license](https://github.com/MobilizeNet/SnowConvertDDLExportScripts/blob/main/Oracle/LICENSE.txt).