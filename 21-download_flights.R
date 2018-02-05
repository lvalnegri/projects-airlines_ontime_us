###########################################
# AIRLINES ONTIME US - Download files 
###########################################

# load packages
lapply(c('data.table', 'RMySQL'), require, char = TRUE)

# define functions
get_months <- function(p, data_path = '/home/datamaps/data/US/airlines/on-time/'){
    if(p[2] < p[1]) p <- p[c(2, 1)]
    y1 <- as.numeric(substr(p[1], 1, 4))
    y2 <- as.numeric(substr(p[2], 1, 4))
    if(y1 == y2){
        get_months_year(p[1], p[2], data_path)
    } else {
        get_months_year(p[1], y1 * 100 + 12, data_path)
        if(y1 < y2 + 1)
            for(y in (y1 + 1):(y2 - 1))
                get_months_year(y * 100 + 1, y * 100 + 12, data_path)
        get_months_year(y2 * 100 + 1, p[2])
    }
}

get_months_year <- function(m1, m2 = m1, data_path = '/home/datamaps/data/US/airlines/on-time/'){
    for(p in m1:m2){
        y <- as.numeric(substr(p, 1, 4))
        m <- as.numeric(substring(p, 5))
        download.file(
            paste0('https://transtats.bts.gov/PREZIP/On_Time_On_Time_Performance_', y, '_', m,'.zip'),
            paste0(data_path, p, '.zip')
        )
        cat(paste0('https://transtats.bts.gov/PREZIP/On_Time_On_Time_Performance_', y, '_', m,'.zip\n'))
    }
}

p <- c(201712, 201712)
get_months(p)
