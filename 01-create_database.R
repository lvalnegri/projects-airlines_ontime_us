###########################################
# AIRLINES ONTIME US - Create Database 
###########################################

# Load packages -----------------------------------------------------------------------------------
library(RMySQL)

# Create database ---------------------------------------------------------------------------------
dbc = dbConnect(MySQL(), group = 'dataOps')
dbSendQuery(dbc, 'DROP DATABASE IF EXISTS airlines_us')
dbSendQuery(dbc, 'CREATE DATABASE airlines_us')
dbDisconnect(dbc)

# Connect to database -----------------------------------------------------------------------------
dbc = dbConnect(MySQL(), group = 'dataOps', dbname = 'airlines_us')

# AIRPORTS ----------------------------------------------------------------------------------------
strSQL <- "
    CREATE TABLE `airports` (
    	`airport_id` SMALLINT(5) UNSIGNED NOT NULL,
    	`seq_id` MEDIUMINT UNSIGNED NOT NULL,
    	`iata` CHAR(3) NOT NULL COLLATE 'utf8_unicode_ci',
    	`name` CHAR(45) NOT NULL COLLATE 'utf8_unicode_ci',
    	`city_id` SMALLINT UNSIGNED NOT NULL COLLATE 'utf8_unicode_ci',
    	`x_lon` DECIMAL(11,8) NOT NULL,
    	`y_lat` DECIMAL(10,8) NOT NULL,
    	`time_zone` DECIMAL(4,2) NOT NULL,
    	`start_date` INT(8) UNSIGNED NOT NULL,
    	`end_date` INT(8) UNSIGNED NOT NULL,
    	`is_active` TINYINT(1) UNSIGNED NOT NULL,
    	`is_latest` TINYINT(1) UNSIGNED NOT NULL,
    	INDEX `airport_id` (`airport_id`),
    	PRIMARY KEY (`seq_id`),
    	INDEX `iata` (`iata`),
    	INDEX `city_id` (`city_id`),
    	INDEX `is_latest` (`is_latest`),
    	INDEX `is_active` (`is_active`),
    	INDEX `end_date` (`end_date`),
    	INDEX `start_date` (`start_date`)
    ) COLLATE='utf8_unicode_ci' ENGINE=MyISAM ROW_FORMAT=FIXED;
"
dbSendQuery(dbc, strSQL)

# CITIES ------------------------------------------------------------------------------------------
strSQL <- "
CREATE TABLE `cities` (
	`city_id` SMALLINT UNSIGNED NOT NULL,
	`name` CHAR(30) NOT NULL COLLATE 'utf8_unicode_ci',
	`country_id` MEDIUMINT UNSIGNED NOT NULL,
	PRIMARY KEY (`city_id`),
	INDEX `country_id` (`country_id`)
    ) COLLATE='utf8_unicode_ci' ENGINE=MyISAM ROW_FORMAT=FIXED;
"
dbSendQuery(dbc, strSQL)

# COUNTRIES ---------------------------------------------------------------------------------------
strSQL <- "
    CREATE TABLE `countries` (
    	`country_id` SMALLINT(3) UNSIGNED NOT NULL,
    	`name` CHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
    	`region` CHAR(35) NOT NULL COLLATE 'utf8_unicode_ci',
    	`capital` CHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
    	`iso` CHAR(2) NOT NULL COLLATE 'utf8_unicode_ci',
    	`state_id` TINYINT(2) UNSIGNED NULL DEFAULT NULL,
    	PRIMARY KEY (`country_id`),
    	INDEX `iso` (`iso`)
    ) COLLATE='utf8_unicode_ci' ENGINE=MyISAM ROW_FORMAT=FIXED;
"
dbSendQuery(dbc, strSQL)

# CARRIERS -----------------------------------------------------------------------------------------
strSQL <- "
    CREATE TABLE `carriers` (
    ) COLLATE='utf8_unicode_ci' ENGINE=MyISAM ROW_FORMAT=FIXED;
"
dbSendQuery(dbc, strSQL)

# FLIGHTS -----------------------------------------------------------------------------------------
strSQL <- "
    CREATE TABLE `flights` (
    ) COLLATE='utf8_unicode_ci' ENGINE=MyISAM ROW_FORMAT=FIXED;
"
dbSendQuery(dbc, strSQL)

# Close DB Connection, Clean & Exit ---------------------------------------------------------------
dbDisconnect(dbc)
rm(list = ls())
gc()

