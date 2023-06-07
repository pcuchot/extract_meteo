
# -------------------------------------------------------------------------
# Title : 1_extract_temperature 
# Author : Paul Cuchot  
# Date : 07/06/2023
# Note:
# -------------------------------------------------------------------------


# library -----------------------------------------------------------------
library(ncdf4)
library(chron)
library(lattice)
library(RColorBrewer)

# Load data ---------------------------------------------------------------

# open a netCDF file
ncin <- nc_open("C:/Users/cuchot/Desktop/meteo/tg_ens_mean_0.25deg_reg_v26.0e.nc")
print(ncin)

# get longitude 
lon <- ncvar_get(ncin,"longitude")
nlon <- dim(lon)
head(lon)

# get latitude
lat <- ncvar_get(ncin,"latitude")
nlat <- dim(lat)
head(lat)

# get time
time <- ncvar_get(ncin,"time")
head(time)

# time unit
tunits <- ncatt_get(ncin,"time","units")
nt <- dim(time)
nt

# get temperature
tmp_array <- ncvar_get(ncin, "tg")

dlname <- ncatt_get(ncin,"tg","long_name")
dunits <- ncatt_get(ncin,"tg","units")
fillvalue <- ncatt_get(ncin,"tg","_FillValue")

# get global attributes
# what don't know what it is for
title <- ncatt_get(ncin,0,"title")
institution <- ncatt_get(ncin,0,"institution")
datasource <- ncatt_get(ncin,0,"source")
references <- ncatt_get(ncin,0,"references")
history <- ncatt_get(ncin,0,"history")
Conventions <- ncatt_get(ncin,0,"Conventions")

# convert time -- split the time units string into fields
tustr <- strsplit(tunits$value, " ")
tdstr <- strsplit(unlist(tustr)[3], "-")
tmonth <- as.integer(unlist(tdstr)[2])
tday <- as.integer(unlist(tdstr)[3])
tyear <- as.integer(unlist(tdstr)[1])
ref_time <- chron(time,origin=c(tmonth, tday, tyear))

# do something with NA
tmp_array[tmp_array==fillvalue$value] <- NA


# get a single slice or layer (January)
m <- 25350 
ref_time[m]
tmp_slice <- tmp_array[,,m]

# quick map
grid <- expand.grid(lon=lon, lat=lat)
cutpts <- seq(-20,30, length.out = 300)
levelplot(tmp_slice ~ lon * lat, 
          data=grid, 
          at=cutpts,
          col.regions = colorRampPalette(rev(brewer.pal(n=10, name="RdBu"))))

# create dataframe -- reshape data
# matrix (nlon*nlat rows by 2 cols) of lons and lats
lonlat <- as.matrix(expand.grid(lon,lat))
dim(lonlat)

# vector of tg values
tmp_vec <- as.vector(tmp_slice)
length(tmp_vec)

# create dataframe and add names
tmp_df01 <- data.frame(cbind(lonlat,tmp_vec))
# names(tmp_df01) <- c("lon","lat",paste("tg", as.character(m), sep="_"))
names(tmp_df01) <- c("lon","lat",paste("tg", as.character(ref_time[m]), sep="_"))

