
# -------------------------------------------------------------------------
# Title : 1_extract_temperature 
# Author : Paul Cuchot  
# Date : 07/06/2023
# Note:
# -------------------------------------------------------------------------


# library -----------------------------------------------------------------
library(ncdf4)

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






