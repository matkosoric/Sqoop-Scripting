
-- mysql table definition
CREATE TABLE voters_addresses(
   id INT NOT NULL AUTO_INCREMENT,
   ZUPANIJA_NAZIV VARCHAR(100) NOT NULL,
   GROP_NAZIV VARCHAR(100) NOT NULL,
   NASELJE_NAZIV VARCHAR(100) NOT NULL,
   ULICA_NAZIV VARCHAR(100) NOT NULL,
   ADR_KBR VARCHAR(100) NOT NULL,
   ADR_KBR_DODA VARCHAR(100) NOT NULL,
   ADR_KBR_DODN VARCHAR(100) NOT NULL,
   BROJ_BIRACA INT,
   STATUS VARCHAR(100) NOT NULL,
   PRIMARY KEY ( id )
)
ENGINE=InnoDB
CHARSET=utf8
;

--data import
LOAD DATA LOCAL INFILE '/home/cloudera/Desktop/voters_addresses.csv'
INTO TABLE voters_addresses
COLUMNS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
;

--example query
SELECT * FROM voters_addresses WHERE GROP_NAZIV LIKE '%ZAGREB%' LIMIT 10;

-- since mysql introduced croatian characters encoding from version 6, and cloudera VM is using 5.1 version,
-- some characters are missing, which is not  important for this sqoop demonstration

-- creating user and setting privileges
CREATE USER 'elections_admin'@'quickstart.cloudera';
GRANT ALL PRIVILEGES ON elections2018.* To 'elections_admin'@'quickstart.cloudera' IDENTIFIED BY 'batman';

--mysql login
mysql -uroot -pcloudera
