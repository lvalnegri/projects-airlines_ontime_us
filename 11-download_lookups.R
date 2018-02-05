##########################################################
# AIRLINES ONTIME US - Download and Store Lookup Data 
##########################################################
# Go to https://www.transtats.bts.gov/Tables.asp?DB_ID=595 and download, unzip in data_path and rename:
# - "World Area Codes"  ==> countries.csv
# - "Master Coordinate" ==> airports.csv

# load packages
lapply(c('data.table', 'RMySQL'), require, char = TRUE)

# set constants
data_path = '/home/datamaps/data/US/airlines/on-time/'

# AIRPORTS --------------------------------------------------------------------------------------------------
dts <- fread(
        paste0(data_path, 'airports.csv'),
        na.strings = '',
        select = c(1:4, 14, 22, 27:32),
        col.names = c('seq_id', 'airport_id', 'iata', 'name', 'city_id', 'y_lat', 'x_lon', 'time_zone', 'start_date', 'end_date', 'is_active', 'is_latest')
)
dts <- dts[city_id < 99999]
dts[, `:=`( start_date = gsub('-', '', start_date), end_date = gsub('-', '', end_date), is_active = 1 - is_active ) ]
dbc <- dbConnect(MySQL(), group = 'dataOps', dbname = 'airlines_us')
dbSendQuery(dbc, 'TRUNCATE TABLE airports')
dbWriteTable(dbc, 'airports', dts, row.names = FALSE, append = TRUE)
dbDisconnect(dbc)

# CITIES ----------------------------------------------------------------------------------------------------
dts <- fread(
        paste0(data_path, 'airports.csv'),
        select = c(14, 15, 17, 32),
        col.names = c('city_id', 'name', 'country_id', 'is_latest')
)
dts <- unique(dts)[city_id < 99999 & is_latest == 1][, is_latest := NULL]
dts <- dts[nchar(name) - nchar(gsub(',', '', name)) == 1]
dts[, name := gsub("(),.*", "\\1", name)]
dbc <- dbConnect(MySQL(), group = 'dataOps', dbname = 'airlines_us')
dbSendQuery(dbc, 'TRUNCATE TABLE cities')
dbWriteTable(dbc, 'cities', dts, row.names = FALSE, append = TRUE)
dbDisconnect(dbc)

# COUNTRIES -------------------------------------------------------------------------------------------------
dts <- fread(
        paste0(data_path, 'countries.csv'),
        na.strings = '',
        select = c(1, 3, 4, 7, 9, 10, 12, 16),
        col.names = c('country_id', 'name', 'region', 'capital', 'iso', 'st_iso', 'state_id', 'is_latest')
)
dts <- dts[is_latest == 1][, is_latest := NULL]
dts[iso == 'US', region := 'United States']
dts[iso %in% c('US', 'CA'), iso := st_iso][, st_iso := NULL]
dts <- dts[!(is.na(capital) | is.na(iso))]

dbc <- dbConnect(MySQL(), group = 'dataOps', dbname = 'airlines_us')
dbSendQuery(dbc, 'TRUNCATE TABLE countries')
dbWriteTable(dbc, 'countries', dts, row.names = FALSE, append = TRUE)
# dbSendQuery(dbc, "DELETE c FROM cities c LEFT JOIN countries ct ON ct.country_id = c.country_id WHERE c.name IS NULL")
# dbSendQuery(dbc, "DELETE a FROM airports a LEFT JOIN cities c ON c.city_id = a.city_id WHERE c.name IS NULL")
dbDisconnect(dbc)

# Close DB Connection, Clean & Exit -------------------------------------------------------------------------
dbDisconnect(dbc)
rm(list = ls())
gc()

