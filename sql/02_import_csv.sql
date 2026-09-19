-- Replace C:/YOUR/PATH/scriptsense-portfolio with the extracted folder.
-- CSVs are UTF-8, LF line endings. Requires local loading on both client/server.
USE scriptsense_strategy;
LOAD DATA LOCAL INFILE 'C:/YOUR/PATH/scriptsense-portfolio/data/raw/tiers.csv'
INTO TABLE tiers
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;
SHOW WARNINGS;
LOAD DATA LOCAL INFILE 'C:/YOUR/PATH/scriptsense-portfolio/data/raw/assumptions.csv'
INTO TABLE assumptions
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;
SHOW WARNINGS;
LOAD DATA LOCAL INFILE 'C:/YOUR/PATH/scriptsense-portfolio/data/raw/scenarios.csv'
INTO TABLE scenarios
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;
SHOW WARNINGS;
LOAD DATA LOCAL INFILE 'C:/YOUR/PATH/scriptsense-portfolio/data/raw/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 LINES;
SHOW WARNINGS;
