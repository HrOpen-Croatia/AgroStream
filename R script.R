library(mapview)
library(raster)
library(happign)
library(sf)
library(leaflet)
library(gdalUtilities)
library(leafsync)
library(lattice)
library(sp)
library(leafpop)
library(stringi)

setwd("E:/Dropbox/01_Work/Nastava/grupa za agonomske podatke/datahon agrostream/layers")

bioportal_kopnene_vode <-shapefile("bioportal - kopnene vode.shp")
bioportal_vodotoci <-shapefile("bioportal - vodotoci.shp")

bioportal <-mapview(bioportal_kopnene_vode, layer.name="Bioportal - kopnene vode",map.types = "CartoDB.DarkMatter",
                 color="#42aaf5", col.regions="#42aaf5", lwd=1.5, alpha.regions=0.5, alpha=1)+
  mapview(bioportal_vodotoci,layer.name="Bioportal - Vodotoci", color="lightblue", alpha=0.5)

bioportal

hrvatskevode_dubrovnik_kopnene_vode <-shapefile("sva_vt_p.shp")
hrvatskevode_dubrovnik_vodotoci <-shapefile("sva_vt_l.shp")

HV <- mapview(hrvatskevode_dubrovnik_kopnene_vode, layer.name="HV - kopnene vode",map.types = "CartoDB.DarkMatter",
        color="#48b8a7", col.regions="#48b8a7", lwd=1.5, alpha.regions=0.5, alpha=1)+
  mapview(hrvatskevode_dubrovnik_vodotoci, layer.name="HV - vodotoci", color="#92ded2", alpha=0.5)

HV 

userdata_Mihanici <-shapefile("konavle lokve - dragica.shp")
userdata_Kobiljaca<-shapefile("User data.shp")

userdata<-mapview(userdata_Kobiljaca, color="red", label="Neverificirani korisnièki sloj - vodotoci Kobiljaèa",map.types = "Esri.WorldImagery", legend=F)+
  mapview(userdata_Mihanici, color="red", col.regions="red", label="Neverificirani korisnièki sloj - bare Mihaniæi", legend=F)

userdata


povrsinske <- shapefile("HV_monitoring povrsinskih voda i analiza.shp")
podzemne <- shapefile("HV_monitoring podzemnih voda i analiza.shp")

podzemne$Ph<-as.numeric(podzemne$Ph)
podzemne$koliform<-as.numeric(podzemne$koliform)
p<-xyplot(koliform ~ Ph, data = podzemne@data, col = "grey", pch = 20, cex = 2)
p <- mget(rep("p", length(podzemne)))

clr <- rep("grey", length(podzemne))
p <- lapply(1:length(p), function(i) {
  clr[i] <- "orange"
  update(p[[i]], col = clr)
})

povrsinske$temp<-as.numeric(povrsinske$temp)
povrsinske$orgC<-as.numeric(povrsinske$orgC)
r<-xyplot(orgC ~ temp, data = povrsinske@data, col = "grey", pch = 20, cex = 2)
r <- mget(rep("r", length(povrsinske)))

clr <- rep("grey", length(povrsinske))
r <- lapply(1:length(r), function(i) {
  clr[i] <- "magenta"
  update(r[[i]], col = clr)
})

postaje<-mapview(povrsinske, color="magenta",popup = popupGraph(r),layer.name="Monitornig povrsinskih voda", col.regions="magenta", cex=3,map.types = "CartoDB.Positron")+
  mapview(podzemne, color="orange", popup = popupGraph(p), layer.name="Monitoring podzemnih voda",col.regions="orange", cex=3)

postaje

sync(bioportal,userdata,HV,postaje)
