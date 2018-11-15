
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


# TASK 4:
# transport table voters_addresses from MySql into HDFS folder /user/cloudera/cca4 as regular,
# uncompressed text file and delimit colums with hash character (#)
# verify results with:
hdfs dfs -cat /user/cloudera/cca4/part-m-00000 | head
# output should be something like:
# ... 
# 252348#HLEBINE#GABAJEVA GREDA#GABAJEVA GREDA#0178###1#0#
# 252349#HLEBINE#GABAJEVA GREDA#GABAJEVA GREDA#0179###2#0#
# 252350#HLEBINE#GABAJEVA GREDA#GABAJEVA GREDA#0180###3#0#
# ... 

sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--as-textfile \
--target-dir /user/cloudera/cca4 \
--fields-terminated-by '#';


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


# TASK 10
# speed up data transportation from table voters_addresses in MySql into HDFS folder /user/cloudera/cca10 as a regular text file
# 
sqoop import \
--connect "jdbc:mysql://quickstart.cloudera:3306/elections2018" \
--username elections_admin \
--password batman \
--table voters_addresses \
--target-dir /user/cloudera/cca10 \
--direct





--null-non-string -1000 \
--null-string "NA" \

--hive-import

