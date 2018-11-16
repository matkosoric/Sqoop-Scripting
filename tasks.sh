
#----------------------------------------------------------------------------
# TASK 1:
# transport table voters_addresses from MySql into HDFS folder /user/cloudera/cca1 as a snappy compressed Avro file 

sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--compress \
--compression-codec org.apache.hadoop.io.compress.SnappyCodec \
--target-dir /user/cloudera/cca1 \
--as-avrodatafile;


#----------------------------------------------------------------------------
# TASK 2:
# transport table voters_addresses from MySql into HDFS folder /user/cloudera/cca2 as a snappy compressed sequence file 
sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--compress \
--compression-codec org.apache.hadoop.io.compress.SnappyCodec \
--target-dir /user/cloudera/cca2 \
--as-sequencefile;


#----------------------------------------------------------------------------
# TASK 3:
# transport table voters_addresses from MySql into HDFS folder /user/cloudera/cca3 as a gzip compressed text file
# gzip is default codec, and textfile is also a default option

sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--compress \
--target-dir /user/cloudera/cca3;


#----------------------------------------------------------------------------
# TASK 4:
# transport table voters_addresses from MySql into HDFS folder /user/cloudera/cca4 as regular,
# uncompressed text file and delimit colums with hash character (#)

sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--as-textfile \
--target-dir /user/cloudera/cca4 \
--fields-terminated-by '#';

# verify results with:
hdfs dfs -cat /user/cloudera/cca4/part-m-00000 | head
# output should be something like:
# ... 
# 252348#HLEBINE#GABAJEVA GREDA#GABAJEVA GREDA#0178###1#0#
# 252349#HLEBINE#GABAJEVA GREDA#GABAJEVA GREDA#0179###2#0#
# 252350#HLEBINE#GABAJEVA GREDA#GABAJEVA GREDA#0180###3#0#
# ... 

#----------------------------------------------------------------------------
# TASK 5:
# transport table voters_addresses from MySql into HDFS folder intended for HIVE tables with name voters_addresses.db
# result should be cbzip2c compressed avro file.
# set number of mapping tasks to 4

sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--warehouse-dir /user/hive/warehouse/voters_addresses.db \
--compress \
--compression-codec org.apache.hadoop.io.compress.BZip2Codec \
--as-avrodatafile \
-m 4;

# verify output:
hdfs dfs -ls /user/hive/warehouse/voters_addresses.db


#----------------------------------------------------------------------------
# TASK 6:
# transport table voters_addresses from MySql into HDFS folder /user/cloudera/cca6 as regular text file.
# delimit the fileds with tab \t.
# delimit the lines with new line character \n
# set level of parallelism to 3

sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--as-textfile \
--fields-terminated-by '\t' \
--lines-terminated-by '\n' \
--target-dir /user/cloudera/cca6 \
-m 3

#verify output:
hdfs dfs -cat /user/cloudera/cca6/part-m-00000 | head


#----------------------------------------------------------------------------
# TASK 7:
# import only four columns (ZUPANIJA_NAZIV,NASELJE_NAZIV,ULICA_NAZIV,BROJ_BIRACA) from the table voters_addresses
# from MySql into HDFS folder /user/cloudera/cca7 as regular text file.
# separate line with new line characters \n 
# do not specify the number of mapping tasks

sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--columns "ZUPANIJA_NAZIV,NASELJE_NAZIV,ULICA_NAZIV,BROJ_BIRACA" \
--lines-terminated-by '\n' \
--target-dir /user/cloudera/cca7

# verify output:
hdfs dfs -cat /user/cloudera/cca7/part-m-00000 | head


#----------------------------------------------------------------------------
# TASK 8:
# transport table voters_addresses from MySql into HDFS folder /user/cloudera/cca8 as parquet file.
# do not specify column or line delimiters
# set parallelism to seven

sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--as-parquetfile \
--target-dir /user/cloudera/cca8 \
--num-mappers 7

# verify output:
hdfs dfs -ls /user/cloudera/cca8


#----------------------------------------------------------------------------
#TASK 9:
# transport only rows that have 'ZADAR' as value for GROP_NAZIV from table voters_addresses in MySql into HDFS folder 
# /user/cloudera/cca9 as a regular text file
# use only one task
sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--target-dir /user/cloudera/cca9 \
--where "GROP_NAZIV = 'ZADAR'" \
--autoreset-to-one-mapper

# verify output:
hdfs dfs -cat /user/cloudera/cca9/part-m-00000 | head


#----------------------------------------------------------------------------
# TASK 10
# speed up data transportation from table voters_addresses in MySql into HDFS folder
# /user/cloudera/cca10 as a regular text file
# do not set any other parameters
sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--target-dir /user/cloudera/cca10 \
--direct

# verify output:
hdfs dfs -ls /user/cloudera/cca10/

#----------------------------------------------------------------------------
# TASK 11
# transport data from voters_addresses in MySql to HDFS folder /user/cloudera/cca11 as a regular text file.
# replace null values in numeric columns with zero, and in text columns with 'NA'
# set parallelism to 1 
sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--target-dir /user/cloudera/cca11 \
--null-non-string -0 \
--null-string "NA" \
--autoreset-to-one-mapper

# verify output:
hdfs dfs -cat /user/cloudera/cca11/part-m-00000 | head
# since there is no null values in this dataset, --null-non-string and --null-string will not have any effect


#----------------------------------------------------------------------------
# TASK 12
# transport data from voters_addresses in MySql to Hive
sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--hive-import \
--hive-drop-import-delims

## verify output:
hive
use default;
select * from voters_addresses limit 10;


#----------------------------------------------------------------------------
# TASK 13
# count the number of voters in the places of Nadin, Sestrunj, and Silba using only Sqoop
sqoop eval \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--query "SELECT NASELJE_NAZIV, SUM(BROJ_BIRACA) FROM voters_addresses WHERE NASELJE_NAZIV IN ('NADIN', 'SESTRUNJ', 'SILBA') GROUP BY GROP_NAZIV"


#----------------------------------------------------------------------------
# TASK 14
# bring back the data from HDFS created in first task into the new mysql table called voters_addresses_new
sqoop export \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses_zadar \
--export-dir /user/cloudera/cca9


#----------------------------------------------------------------------------
# TASK 15
# transport all tables from elections2018 database in MySql to HDFS
# there should be two tables (voters_addresses, voters_addresses_zadar)
# they will end up in a folder 
sqoop import-all-tables \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman

# verify output:
# output directory is $HADOOP_MAPRED_HOME, in this case /user/cloudera/ 
hdfs dfs -ls


#----------------------------------------------------------------------------
# TASK 16
# list all sqoop available jobs
sqoop job --list


#----------------------------------------------------------------------------
# TASK 17
# create sqoop job to import voters_addresses from MySql into HDFS folder /user/cloudera/cca17 as a gzip compressed text file
# and filter only rows with NASELJE_NAZIV set to LUDBREG

sqoop job --create ludbreg_job \
-- import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--where "NASELJE_NAZIV = 'LUDBREG'" \
--compress \
--target-dir /user/cloudera/cca17;


#----------------------------------------------------------------------------
# TASK 18
## view ludbreg_job parameters and then run it
sqoop job --show ludbreg_job
sqoop job --exec ludbreg_job


#----------------------------------------------------------------------------
# TASK 19
# create sqoop job to import voters_addresses from MySql into HDFS folder /user/cloudera/cca18 
# as a snappy compressed parquet file
# and filter only rows with BROJ_BIRACA larger than 20
# use two mapping tasks
# then execute the job
sqoop job --create more_than_20_voters \
-- import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--as-parquetfile \
--compress \
--compression-codec org.apache.hadoop.io.compress.SnappyCodec \
--target-dir /user/cloudera/cca19 \
--where "BROJ_BIRACA > 20" \
--num-mappers 2

# executiong the job:
sqoop job --exec more_than_20_voters


#----------------------------------------------------------------------------
# TASK 20
# use sqoop to list available databases
sqoop list-databases \
--connect "jdbc:mysql://quickstart.cloudera:3306/" \
--username elections_admin \
--password batman


#----------------------------------------------------------------------------
# TASK 21
# use sqoop to list available tables
sqoop list-tables \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman


#----------------------------------------------------------------------------
# TASK 22
# transport data from voters_addresses_zadar in MySql to Hive
# validate data transport
# FIELDS TERMINATED BY and LINES TERMINATED BY arguments must match parameters from Hive table definitio
sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses_zadar \
--fields-terminated-by '\t' \
--lines-terminated-by '\n' \
--hive-import \
--hive-drop-import-delims \
--validate

# --validate parameter shoud result with this log:
# INFO validation.RowCountValidator: Data successfully validated
# validate complete output:
hdfs dfs -cat /user/hive/warehouse/voters_addresses_zadar/part-m-00000 | head


#----------------------------------------------------------------------------
# TASK 23
# transport data from voters_addresses_zadar in MySql to Hive again.
# drop old table.
# however, validate data transport using all possible optins
sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses_zadar \
--fields-terminated-by '\t' \
--lines-terminated-by '\n' \
--hive-import \
--hive-drop-import-delims \
--validate \
--validator org.apache.sqoop.validation.RowCountValidator \
--validation-threshold org.apache.sqoop.validation.AbsoluteValidationThreshold \
--validation-failurehandler org.apache.sqoop.validation.AbortOnFailureHandler


#----------------------------------------------------------------------------
# TASK 23
# transport data from voters_addresses to HBase
# before, prepare HBase with:
# create 'voters_addresses', 'location'

sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--hbase-table voters_addresses \
--column-family location \
--hbase-row-key ID \
--num-mappers 4 \
--hbase-bulkload

# verify result in HBase with:
scan 'voters_addresses', {'LIMIT' => 10}

​