
-- mysql table definition
CREATE TABLE voters_addresses(
   ZUPANIJA_NAZIV VARCHAR(100) NOT NULL,
   GROP_NAZIV VARCHAR(100) NOT NULL,
   NASELJE_NAZIV VARCHAR(100) NOT NULL,
   ULICA_NAZIV VARCHAR(100) NOT NULL,
   ADR_KBR VARCHAR(100) NOT NULL,
   ADR_KBR_DODA VARCHAR(100) NOT NULL,
   ADR_KBR_DODN VARCHAR(100) NOT NULL,
   BROJ_BIRACA INT,
   STATUS VARCHAR(100) NOT NULL,
   ID INT NOT NULL AUTO_INCREMENT,
   PRIMARY KEY ( ID )
)
ENGINE=InnoDB
CHARSET=utf8
;

-- second mysql table, used for storing a subset of original data
CREATE TABLE voters_addresses_zadar(
   ZUPANIJA_NAZIV VARCHAR(100) NOT NULL,
   GROP_NAZIV VARCHAR(100) NOT NULL,
   NASELJE_NAZIV VARCHAR(100) NOT NULL,
   ULICA_NAZIV VARCHAR(100) NOT NULL,
   ADR_KBR VARCHAR(100) NOT NULL,
   ADR_KBR_DODA VARCHAR(100) NOT NULL,
   ADR_KBR_DODN VARCHAR(100) NOT NULL,
   BROJ_BIRACA INT,
   STATUS VARCHAR(100) NOT NULL,
   ID INT NOT NULL AUTO_INCREMENT,
   PRIMARY KEY ( ID )
)
ENGINE=InnoDB
CHARSET=utf8
;

--mysql data import
LOAD DATA LOCAL INFILE '/home/cloudera/Desktop/voters_addresses.csv'
INTO TABLE voters_addresses
COLUMNS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
;

--example queries
SELECT * FROM voters_addresses LIMIT 10;
SELECT * FROM voters_addresses WHERE GROP_NAZIV LIKE '%ZAGREB%' LIMIT 10;
SELECT NASELJE_NAZIV, SUM(BROJ_BIRACA) FROM voters_addresses WHERE NASELJE_NAZIV IN ('NADIN', 'SESTRUNJ', 'SILBA') GROUP BY GROP_NAZIV;

-- since mysql introduced croatian characters encoding from version 6, and cloudera VM is using 5.1 version,
-- some characters are missing, which is not  important for this sqoop demonstration

-- creating user and setting privileges
CREATE USER 'elections_admin'@'quickstart.cloudera';
GRANT ALL PRIVILEGES ON elections2018.* To 'elections_admin'@'quickstart.cloudera' IDENTIFIED BY 'batman';

--mysql login
mysql -uroot -pcloudera


-- HIVE table voters_addresses definition
CREATE TABLE IF NOT EXISTS voters_addresses (
   ZUPANIJA_NAZIV String,
   GROP_NAZIV String,
   NASELJE_NAZIV String,
   ULICA_NAZIV String,
   ADR_KBR String,
   ADR_KBR_DODA String,
   ADR_KBR_DODN String,
   BROJ_BIRACA Int,
   STATUS String,
   ID Int )
COMMENT 'complete dataset'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;


-- HIVE table voters_addresses_zadar definition
CREATE TABLE IF NOT EXISTS voters_addresses_zadar (
   ZUPANIJA_NAZIV String,
   GROP_NAZIV String,
   NASELJE_NAZIV String,
   ULICA_NAZIV String,
   ADR_KBR String,
   ADR_KBR_DODA String,
   ADR_KBR_DODN String,
   BROJ_BIRACA Int,
   STATUS String,
   ID Int)
COMMENT 'subset - only voters from Zadar'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;



-- HBase voters_addresses table definition
create 'voters_addresses', 'location'
