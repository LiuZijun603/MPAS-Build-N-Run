load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "/data/ess-liuzj/cnmap/shapefile_utils.ncl"


begin
; Minlat = 10
; Maxlat = 50
; Minlon = 50
; Maxlon = 160

;obs
regrid_on    = True
; Minlon    = 109-10
; Maxlon    = 117+10
; Minlat    = 20-5
; Maxlat    = 26+15
char  = (/"0721","0722","0723","0800","0801","0802","0803","0804","0805","0806","0807","0808","0809",\
         "0810","0811","0812"/)
OBS_data  = new((/dimsizes(char),(Maxlat-Minlat)*10+1,(Maxlon-Minlon)*10+1/),"float","No_FillValue")
;data_test    = asciiread("/data/ess-liuzj/0907case/station/rain2023"+char(0)+"20_24.csv", -1 ,"float")
do i = 0, dimsizes(char)-1
    data1    = asciiread("/data/ess-liuzj/0907case/station/hourly/202309"+char(i)+".csv", -1 ,"float")
    pre1     = reshape(data1(:), (/(dimsizes(data1))/6,6/))
    pre_ave1 = pre1(:,5)
    lon      = pre1(:,1)
    lat      = pre1(:,2)
    if (regrid_on) then
    Opt                     = True
    Opt@SrcGridLon          = lon
    Opt@SrcGridLat          = lat
    ;Opt@DstLLCorner         = (/floor(minlat)-0.1,floor(minlon)+0.1/)
    Opt@DstLLCorner         = (/floor(Minlat),floor(Minlon)/)
    ;Opt@DstURCorner         = (/ceil(maxlat)-0.1,ceil(maxlon)+0.1/)
    Opt@DstURCorner         = (/ceil(Maxlat),ceil(Maxlon)/)
    Opt@DstGridType         = "0.1deg"
    Opt@ForceOverwrite      = True
    Opt@Debug               = True
    Opt@InterMethod         = "bilinear"
    pre_ave1                := ESMF_regrid(pre_ave1,Opt)
    end if
;printVarSummary(pre_ave1)
OBS_data(i,:,:)    = pre_ave1
delete(data1)
delete(pre1)
delete(pre_ave1)
delete(lon)
delete(lat)
delete(Opt)
end do
OBS_rain = dim_sum_n_Wrap(OBS_data,0)
OBS_lon = OBS_rain&lon
OBS_lat = OBS_rain&lat
;;obs

;gfs

; diri_gfs  = "/data/ess-liuzj/gfs/2021-07-19_22/"
; files_gfs = systemfunc("ls " + diri_gfs + "gfs.0p*" )
; f_gfs     = addfiles(files_gfs, "r")
; ListSetType (f_gfs, "cat")
; lat = f_gfs[1]->lat_0({Minlat:Maxlat})
; lon = f_gfs[1]->lon_0({Minlon:Maxlon})

; pre1  = new((/dimsizes(files_gfs),dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
; pre2  = new((/dimsizes(files_gfs),dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
; uu    = new((/dimsizes(files_gfs),dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
; vv    = new((/dimsizes(files_gfs),dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
; do i = 0,dimsizes(files_gfs)-1
; pre1(i,:,:)= f_gfs[i]->CRAIN_P0_L1_GLL0({Minlat:Maxlat},{Minlon:Maxlon})
; pre2(i,:,:)= f_gfs[i]->CFRZR_P0_L1_GLL0({Minlat:Maxlat},{Minlon:Maxlon})
; uu(i,:,:)= f_gfs[i]->UGRD_P0_L100_GLL0({85000},{Minlat:Maxlat},{Minlon:Maxlon})
; vv(i,:,:)= f_gfs[i]->VGRD_P0_L100_GLL0({85000},{Minlat:Maxlat},{Minlon:Maxlon})
; end do
; pre      = pre1(:,{Minlat:Maxlat},{Minlon:Maxlon}) + pre2(:,{Minlat:Maxlat},{Minlon:Maxlon})
; pre_gfs  = dim_sum_n_Wrap(pre(Mintime:Maxtime,:,:),0)
; u850_gfs  = dim_avg_n_Wrap(uu(Mintime:Maxtime,:,:),0)
; v850_gfs  = dim_avg_n_Wrap(vv(Mintime:Maxtime,:,:),0)
; pre_gfs!0    = "lat"
; pre_gfs&lat  = lat
; pre_gfs!1    = "lon"
; pre_gfs&lon  = lon
; copy_VarMeta(pre_gfs, u850_gfs)
; copy_VarMeta(pre_gfs, v850_gfs)
; delete(lat)
; delete(lon)
f1    = addfile ("/data/ess-liuzj/gfs/2023_09-07_08/gfs.0p25.2023090700.f012.grib2", "r") 
f2    = addfile ("/data/ess-liuzj/gfs/2023_09-07_08/gfs.0p25.2023090700.f027.grib2", "r") 
gfs_lat = f1->lat_0({Minlat:Maxlat})
gfs_lon = f1->lon_0({Minlon:Maxlon})
gfs_rain1 = f1->APCP_P8_L1_GLL0_acc12h({Minlat:Maxlat},{Minlon:Maxlon})
gfs_rain2 = f2->APCP_P8_L1_GLL0_acc27h({Minlat:Maxlat},{Minlon:Maxlon})
gfs_sum_rain  = gfs_rain2 - gfs_rain1
gfs_sum_rain!0    = "lat"
gfs_sum_rain&lat  = gfs_lat
gfs_sum_rain!1    = "lon"
gfs_sum_rain&lon  = gfs_lon
;;gfs end

;era5
;;time 0907_12:00 - 0908_03:00 UTC
Mintime = 24+24+12-3
Maxtime = 24+24+27-3
f1    = addfile ("/data/ess-liuzj/0907case/era5/rain_20230905_20230909.nc", "r") 
rain  = short2flt(f1->tp(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}))
lat   = f1->latitude({Minlat:Maxlat})
lon   = f1->longitude({Minlon:Maxlon})
rain  = rain*1000.0
ERA5_rain = rain
ERA5_sum_rain = dim_sum_n_Wrap(rain,0)
ERA5_sum_rain = ERA5_sum_rain*1.5
delete(f1)
delete(lon)
delete(lat)
delete(rain)
;;era5

print("ERA5 is ok")

;merra2
;;time 0907_12:00 - 0908_03:00 UTC
Mintime = 12
Maxtime = 27
Time = Maxtime - Mintime
f1 = addfile ("/data/ess-liuzj/0907case/mirra2/MERRA2_400.tavg1_2d_lnd_Nx.20230907.nc4", "r")
f2 = addfile ("/data/ess-liuzj/0907case/mirra2/MERRA2_400.tavg1_2d_lnd_Nx.20230908.nc4", "r")
lat  = f1->lat({Minlat:Maxlat})
lon  = f1->lon({Minlon:Maxlon})
rain = new((/24*2,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
rain(0+24*0:23+24*0,:,:) = f1->PRECTOTLAND(:,{Minlat:Maxlat},{Minlon:Maxlon})
rain(0+24*1:23+24*1,:,:) = f2->PRECTOTLAND(:,{Minlat:Maxlat},{Minlon:Maxlon})
rain!0    = "time"
rain!1    = "lat"
rain&lat  = lat
rain!2    = "lon"
rain&lon  = lon
MERRA2_rain     = rain
MERRA2_sum_rain = dim_sum_n_Wrap(rain(Mintime:Maxtime,:,:), 0)
copy_VarMeta(rain(0,:,:), MERRA2_sum_rain)
delete(f1)
delete(f2)
delete(lon)
delete(lat)
delete(rain)
;;merra2

print("MERRA2 is ok")


;60-3km
;;time 0907_12:00 - 0908_03:00 UTC
Mintime    = 9
Maxtime    = 24
Time  = Maxtime - Mintime
f1     = addfile("/data/ess-liuzj/0907case/test/60-3km/data/main.nc", "r")
f2     = addfile("/data/ess-liuzj/0907case/test/60-3km/data/static.nc", "r")
lat  = f1->latitude({Minlat:Maxlat})
lon  = f1->longitude({Minlon:Maxlon})
landmask  = (f2->landmask({Minlat:Maxlat},{Minlon:Maxlon}))
g60_3_lat  = f2->latitude({Minlat:Maxlat})
g60_3_lon  = f2->longitude({Minlon:Maxlon})
g60_3_rainc  = (f1->rainc(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}))
g60_3_rainnc = (f1->rainnc(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}))
rain         = g60_3_rainc + g60_3_rainnc
rain!0    = "time"
rain!1    = "lat"
rain&lat  = lat
rain!2    = "lon"
rain&lon  = lon
g60_3_sum_rain = rain(Time,:,:) - rain(0,:,:)
copy_VarMeta(rain(0,:,:),g60_3_sum_rain)
delete(f1)
delete(lon)
delete(lat)
;;60-3km

print("Global 60-3km is ok")


landmask_cha = linint2_Wrap(g60_3_lon,g60_3_lat,landmask,False,OBS_lon,OBS_lat,0)
delete(landmask)
landmask = landmask_cha
OBS_rain = where(landmask.eq.0, OBS_rain@_FillValue, OBS_rain)

;regional SIM
;;time 0907_12:00 - 0908_03:00 UTC
Mintime    = 18
Maxtime    = 48
Time = Maxtime - Mintime
f1     = addfile ("/data/ess-liuzj/0907case/test/regional_GFS_3km_small/data/main.nc", "r")
f2     = addfile ("/data/ess-liuzj/0907case/test/regional_GFS_3km_vari/data/main.nc", "r")
f3     = addfile ("/data/ess-liuzj/0907case/test/regional_GFS_3km_big/data/main.nc", "r")
lat  = f1->latitude({Minlat:Maxlat})
lon  = f1->longitude({Minlon:Maxlon})
r3small_rainc  = (f1->rainc(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}))
r3vari_rainc   = (f2->rainc(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}))
r3big_rainc    = (f3->rainc(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}))
r3small_rainnc = f1->rainnc(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_rainnc  = f2->rainnc(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_rainnc   = f3->rainnc(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_rainc!0    = "time"
r3small_rainc!1    = "lat"
r3small_rainc&lat  = lat
r3small_rainc!2    = "lon"
r3small_rainc&lon  = lon
copy_VarMeta(r3small_rainc,r3small_rainnc)
copy_VarMeta(r3small_rainc,r3vari_rainc)
copy_VarMeta(r3small_rainc,r3vari_rainnc)
copy_VarMeta(r3small_rainc,r3big_rainc)
copy_VarMeta(r3small_rainc,r3big_rainnc)
r3small_sum_rain = r3small_rainc(Time,:,:) + r3small_rainnc(Time,:,:) - r3small_rainc(0,:,:) - r3small_rainnc(0,:,:)
r3vari_sum_rain  = r3vari_rainc(Time,:,:) + r3vari_rainnc(Time,:,:) - r3vari_rainc(0,:,:) - r3vari_rainnc(0,:,:)
r3big_sum_rain   = r3big_rainc(Time,:,:) + r3big_rainnc(Time,:,:) - r3big_rainc(0,:,:) - r3big_rainnc(0,:,:)
copy_VarMeta(r3small_rainc(0,:,:),r3small_sum_rain)
copy_VarMeta(r3small_rainc(0,:,:),r3vari_sum_rain)
copy_VarMeta(r3small_rainc(0,:,:),r3big_sum_rain)
delete(f1)
delete(f2)
delete(f3)
delete(lat)
delete(lon)
;;regional SIM

print("regional simulations is ok")


wks   = gsn_open_wks ("pdf", "rain" )  ; send graphics to PNG file

plot  = new(8,graphic)
cn1plot  = new(8,graphic)

cmap = read_colormap_file("WhiteBlueGreenYellowRed")
res                         = True
res@gsnMaximize             = False                            ; Maximize plot
res@cnFillOn                = True                             ; tainse
res@cnLinesOn               = False                            ; dengzhixian
res@lbLabelBarOn            = False                            ; xiaotu de bar
res@cnLineLabelsOn          = False                            ; line de biaoqian
res@cnInfoLabelOn           = False                            ; line de infomation
res@cnLineLabelFontHeightF  = 0.015                            ; line de biaoqian ziti daxiao

res@cnFillMode              = "RasterFill"                     ; turn raster on      
colors                      = (/"WhiteBlueGreenYellowRed"/)    ; none
res@cnFillPalette           = colors                           ; none
res@cnLineLabelsOn          = False                            ; dengzhixian shuoming
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 10
res@cnMaxLevelValF = 100.
res@cnLevelSpacingF = 10.


;res@cnFillDrawOrder = "PreDraw"
;res@cnLineDrawOrder = "PostDraw"


res@mpFillOn                = False                            ; ditu tianse

res@gsnAddCyclic            = False                            ; quanqiu dakai, fouze guanbi
res@gsnCenterStringFontHeightF    = 0.02                       ; center biaoti zi daxiao
res@gsnCenterStringOrthogonalPosF = 0.02                     ; center biaoti shangxia yidong  "fu xiang xia"
res@gsnRightStringFontHeightF     = 0.02                       ; right biaoti zi daxiao
res@gsnRightStringOrthogonalPosF  = 0.02                     ; right biaoti shangxia yidong
res@gsnLeftStringFontHeightF      = 0.02                       ; Left biaoti zi daxiao
res@gsnLeftStringOrthogonalPosF   = 0.02                     ; Left biaoti shangxia yidong

; res@mpProjection            = "CylindricalEquidistant"         ;lat-lon map project
; res@mpMinLatF               = Minlat                           ; min lat
; res@mpMaxLatF               = Maxlat                               ; max lat
; res@mpMinLonF               = Minlon                              ; min lon
; res@mpMaxLonF               = Maxlon                              ; max lat
; res@mpCenterLonF            = (Minlon + Maxlon) / 2.              ; center lon
; res@mpCenterLatF            = (Minlat + Maxlat) / 2.              ; center lon

res@mpProjection      = "Orthographic"
leftAngle   = 35.0-20.0-3.0
rightAngle  = 35.0-20.0-3.0
bottomAngle = 30.0-20.0-2.0
topAngle    = 30.0-20.0-2.0
; leftAngle   = 10.0
; rightAngle  = 10.0
; bottomAngle = 10.0
; topAngle    = 10.0
res@mpLimitMode       = "Angles"
res@mpCenterLonF      = (Minlon + Maxlon) / 2.              ; center lon
res@mpCenterLatF      = (Minlat + Maxlat) / 2.              ; center lon
res@mpCenterLonF      = 114              ; center lon
res@mpCenterLatF      = 22             ; center lon
res@mpLeftAngleF      = leftAngle
res@mpRightAngleF     = rightAngle
res@mpBottomAngleF    = bottomAngle
res@mpTopAngleF       = topAngle


res@mpGridLonSpacingF       = 2                                ; lon jiange
res@mpGridLatSpacingF       = 2                                ; lat jiange
res@tmXTOn          = False
res@tmYROn          = False

res@tmYLMajorLengthF        = 0.01                              ; XYzhou zhuyao changdu
res@tmXBMajorLengthF        = 0.01                              ; XYzhou zhuyao changdu

res@tmXBMinorLengthF        = 0.0                              ; XYzhou ciyao changdu
res@tmYLMinorLengthF        = 0.0                              ; XYzhou ciyao changdu

res@tmXBLabelFontThicknessF = 0.4                              ; X zhou ziti lonlat cuxi
res@tmYLLabelFontThicknessF = 0.4                              ; Y zhou ziti lonlat cuxi

res@tmXBLabelFontHeightF    = 0.02                             ; X zhou ziti daxiao
res@tmYLLabelFontHeightF    = 0.02                             ; Y zhou ziti daxiao

res@tmXBLabelDeltaF         = -0.5                             ; X zhou ziti xiang X zhou kaojin
res@tmYLLabelDeltaF         = -0.5                             ; Y zhou ziti xiang Y zhou kaojin


; res@tiMainString            = ""         
; res@tiMainFontHeightF       = 0.0001         
; res@vpHeightF               = 0.5
; res@vpWidthF                = 0.65

; res@tmYLMode                = "Explicit"
; res@tmYLValues              =(/20,25,30,35,40/)
; res@tmYLLabels              =(/"20~S~o~N~N","25~S~o~N~N","30~S~o~N~N","35~S~o~N~N","40~S~o~N~N"/)
; res@tmXBMode                ="Explicit"
; res@tmXBValues              =(/100,110,120,130,140/)
; res@tmXBLabels              =(/"100~S~o~N~E","110~S~o~N~E","120~S~o~N~E","130~S~o~N~E","140~S~o~N~E"/)

res@mpGeophysicalLineColor  = "Black"
res@mpNationalLineColor     = "Black"
res@mpUSStateLineColor      = "Black"
res@mpGridLineColor         = "Black"
res@mpLimbLineColor         = "Black"
res@mpPerimLineColor        = "Black"
;res@mpOutlineBoundarySets   = "AllBoundaries"
;res@mpOutlineBoundarySets   = "National"
res@mpDataSetName           = "/data/ess-liuzj/cnmap/database/Earth..4"      ; Gives us provincial boundaries
shp_filename="/data/ess-liuzj/cnmap/cnmap/cnmap.shp"
  res@mpDataBaseVersion          = "MediumRes" ; or "Ncarg4_1"
  res@mpAreaMaskingOn            = True
  res@mpMaskAreaSpecifiers       = (/"China"/)
  res@mpOutlineSpecifiers        = (/"China","China:Provinces"/)
;res@mpOutlineSpecifiers=(/"China","Henan"/)
;res@mpProvincialLineThicknessF  = 0.0 
res@mpGeophysicalLineThicknessF = 1.8
res@mpNationalLineThicknessF  = 1.8
res@mpCountyLineThicknessF      = 1.8
;res@mpProvincialLineColor       = "black"  
res@mpCountyLineColor           = "black" 
  res@cnFillDrawOrder            = "PreDraw"
;res@mpLandFillColor            = "white"
 ; res@mpAreaMaskingOn            = True
 ;  res@mpMaskAreaSpecifiers       = (/"China"/)
 ;  res@mpOutlineSpecifiers        = (/"China","China:Provinces"/)

 res@gsnCenterString = ""
 res@gsnRightString  = ""
 res@gsnLeftString   = ""
 res@tiMainString    = ""
 res@gsnDraw         = False
 res@gsnFrame        = False

 
 
 res@pmLabelBarWidthF      = 0.65                  ;  color bar zengjia kuandu
 res@pmLabelBarHeightF     = 0.07                 ;  color bar zengjia gaodu
 res@pmLabelBarOrthogonalPosF= 0.12                  ; common color bar shangxia yidong     fu xiang xia 
 
 maxlat_region = 38
 minlat_region = 32
 maxlon_region = 117
 minlon_region = 110
 boxlat  = (/ maxlat_region,maxlat_region,minlat_region,minlat_region,maxlat_region /)
 boxlon  = (/ minlon_region,maxlon_region,maxlon_region,minlon_region,minlon_region /)
 
f1     = addfile ("./../../regional_GFS_3km_vari/ter.nc", "r")
lat  = f1->latitude
lon  = f1->longitude
 minSpacingKm = sqrt(min(f1->areaCell)*2.0/sqrt(3.0))*6371.229
 fld = minSpacingKm / (f1->meshDensity^0.25)
   r2d = 57.2957795             ; radians to degrees
 fld = fld/10000000.*1.6
fld!0    = "lat"
fld&lat  = lat
fld!1    = "lon"
fld&lon  = lon


res1 = True
res1@cnLinesOn = True
res1@cnFillOn  = False
res1@gsnLeftString = ""
res1@gsnRightString = ""
res1@cnInfoLabelOn  = False
res1@cnLineLabelsOn = False
res1@cnLevelSelectionMode  = "ExplicitLevels"
res1@cnLevels     =(/3.3/)
res1@cnLineThicknessF = 1.0
res@gsnDraw = False
res1@gsnDraw = False
res@gsnFrame = False
res1@gsnFrame = False

res@mpFillDrawOrder = "PostDraw"
res1@mpFillDrawOrder = "PostDraw"


res@gsnCenterString = "GFS"
res@gsnLeftString   = "(b)"
res@gsnRightString  = ""
plot(1)             = gsn_csm_contour_map(wks,gfs_sum_rain,res) 
cn1plot(1)          = gsn_csm_contour(wks, fld ,res1) 
overlay(plot(1), cn1plot(1))
 res@gsnCenterString = "ERA5"
 res@gsnLeftString   = "(c)"
 res@gsnRightString  = ""
 plot(2)             = gsn_csm_contour_map(wks,ERA5_sum_rain,res) 
 cn1plot(2)          = gsn_csm_contour(wks, fld ,res1) 
 overlay(plot(2), cn1plot(2))
 res@gsnCenterString = "MERRA2"
 res@gsnLeftString   = "(d)"
 ;res@gsnRightString  = "0907_16:00"
 plot(3)             = gsn_csm_contour_map(wks,MERRA2_sum_rain,res) 
cn1plot(3)           = gsn_csm_contour(wks, fld,res1) 
overlay(plot(3), cn1plot(3))
 res@gsnCenterString = "G60-3km"
 res@gsnLeftString   = "(e)"
 ;res@gsnRightString  = "0907_20:00"
 plot(4)             = gsn_csm_contour_map(wks,g60_3_sum_rain,res) 
  cn1plot(4)           = gsn_csm_contour(wks, fld ,res1) 
overlay(plot(4), cn1plot(4))
 res@gsnCenterString = "R3km.small"
 res@gsnLeftString   = "(f)"
 ;res@gsnRightString  = "0908_00:00"
 plot(5)             = gsn_csm_contour_map(wks,r3small_sum_rain,res) 
  cn1plot(5)           = gsn_csm_contour(wks, fld ,res1) 
overlay(plot(5), cn1plot(5))
 res@gsnCenterString = "R15-3km.large"
 res@gsnLeftString   = "(g)"
 ;res@gsnRightString  = "0908_04:00"
 plot(6)             = gsn_csm_contour_map(wks,r3vari_sum_rain,res) 
  cn1plot(6)           = gsn_csm_contour(wks, fld ,res1) 
overlay(plot(6), cn1plot(6))
 res@gsnCenterString = "R3km.large"
 res@gsnLeftString   = "(h)"
 ;res@gsnRightString  = ""
 plot(7)             = gsn_csm_contour_map(wks,r3big_sum_rain,res) 
 cn1plot(7)           = gsn_csm_contour(wks, fld ,res1) 
overlay(plot(7), cn1plot(7))

; res@cnFillDrawOrder = "PreDraw"
; res@cnLineDrawOrder = "PreDraw"
; res@mpOceanFillColor= "white"
; res@cnMissingValFillColor= "white"

; res1@cnFillDrawOrder = "PreDraw"
; res1@cnLineDrawOrder = "PreDraw"
; res1@mpOceanFillColor= "white"

;OBS_rain := lonFlip(OBS_rain)
; OBS_rain_mask  = shapefile_mask_data(OBS_rain,shp_filename,True)
; delete(OBS_rain)
; OBS_rain = OBS_rain_mask

res@mpAreaMaskingOn            = True
res@mpMaskAreaSpecifiers       = (/"China"/)
res@mpOutlineSpecifiers        = (/"China","China:Provinces"/)

res@gsnCenterString = "OBS"
res@gsnLeftString   = "(a)"
res@tmXBOn    = True
res@mpFillDrawOrder = "PostDraw"
plot(0)             = gsn_csm_contour_map(wks,OBS_rain,res) 
cn1plot(0)           = gsn_csm_contour(wks, fld ,res1) 
overlay(plot(0), cn1plot(0))


resP                         = True                 ; modify the panel plot
resP@gsnFrame                = False                ; don't advance panel plot
resP@gsnMaximize             = False                ; shifou zuidahua
resP@gsnPanelLabelBar        = True                 ; common colorbar kaiguan
resP@lbLabelFontHeightF      = 0.015                ; common color bar ziti daxiao
resP@pmLabelBarOrthogonalPosF= -0.02                ; common color bar shangxia yidong     fu xiang xia 
; resP@pmLabelBarWidthF      = 0.8                  ; common color bar zengjia kuandu
; resP@pmLabelBarHeightF     = 0.06                 ; common color bar zengjia gaodu
resP@lbBoxLinesOn            = True                 ; common color bar biankuangxian kaiguan 
resP@gsnPanelXWhiteSpacePercent  = 1.3                ; X fangxiang jianxi
resP@gsnPanelYWhiteSpacePercent  = 1.5               ; Y fangxiang jianxi
;resP@gsnPanelBottom          = 0.15 
resP@gsnLeftString            = ""
resP@gsnRightString           = ""
resP@gsnCenterString          = ""
resP@lbTitleString            = "Accumulated precipitation [mm]"
resP@lbTitlePosition          = "Bottom"
resP@lbTitleFontHeightF       = 0.015
; resP@gsnPanelMainString     = ""               ; set main title
; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
;resP@gsnPanelFigureStrings  = (/"(a)","(b)","(c)","(d)","(e)","(f)","(h)","(i)","(j)"/)
;resP@gsnPanelFiguvcrestringsFontHeightF   = 0.01             ;;;;;"(a)","(b)","(c)"的大小
;resP@amJust                               = "TopLeft"           ;;;;;"(a)","(b)","(c)"的位置
  resP@gsnPanelRowSpec      = True
  gsn_panel(wks, plot, (/4,4/), resP)
  ;draw(plot)
 end