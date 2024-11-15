load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
; zoomin = systemfunc("echo $zoomin") ;0=zoomout 1=zoomin
; Minlat = 10
; Maxlat = 50
; Minlon = 50
; Maxlon = 160
Minlon    = 100-3-20-5
Maxlon    = 150-3+20
Minlat    = 15-20-5
Maxlat    = 45+20

;era5
;;time 0907_12:00 - 0908_03:00 UTC
Mintime = 24+24+12
Maxtime = 24+24+27
f1     = addfile ("/data/ess-liuzj/0907case/era5/SLP.nc", "r") 
f3     = addfile ("/data/ess-liuzj/0907case/era5/specific_humidity.nc", "r") 
f2     = addfile ("/data/ess-liuzj/0907case/era5/wind.nc", "r") 
slp   = short2flt(f1->msl(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}))
u850  = short2flt(f2->u(Mintime:Maxtime,{850},{Minlat:Maxlat},{Minlon:Maxlon}))
v850  = short2flt(f2->v(Mintime:Maxtime,{850},{Minlat:Maxlat},{Minlon:Maxlon}))
q850  = short2flt(f3->q(Mintime:Maxtime,{850},{Minlat:Maxlat},{Minlon:Maxlon}))
lat   = f1->latitude({Minlat:Maxlat})
lon   = f1->longitude({Minlon:Maxlon})
moisture_flux_u = 1.0/9.8*q850*u850*1000.0
moisture_flux_v = 1.0/9.8*q850*v850*1000.0
slp   = slp/100.0
ERA5_slp = slp
ERA5_moisture_flux_u = moisture_flux_u
ERA5_moisture_flux_v = moisture_flux_v
ERA5_avg_slp = dim_avg_n_Wrap(slp,0)
ERA5_avg_moisture_flux_u = dim_avg_n_Wrap(moisture_flux_u,0)
ERA5_avg_moisture_flux_v = dim_avg_n_Wrap(moisture_flux_v,0)
copy_VarMeta(slp,ERA5_moisture_flux_u)
copy_VarMeta(slp,ERA5_moisture_flux_v)
copy_VarMeta(slp(0,:,:),ERA5_avg_moisture_flux_u)
copy_VarMeta(slp(0,:,:),ERA5_avg_moisture_flux_v)
delete(f1)
delete(f2)
delete(f3)
delete(lon)
delete(lat)
delete(slp)
delete(q850)
delete(u850)
delete(v850)
delete(moisture_flux_u)
delete(moisture_flux_v)
;;era5

;merra2
;;time 0907_12:00 - 0908_03:00 UTC
Mintime = 12
Maxtime = 27
Time = Maxtime - Mintime
f1 = addfile ("/data/ess-liuzj/0907case/mirra2/MERRA2_400.tavg1_2d_slv_Nx.20230907.nc4", "r")
f2 = addfile ("/data/ess-liuzj/0907case/mirra2/MERRA2_400.tavg1_2d_slv_Nx.20230908.nc4", "r")
lat  = f1->lat({Minlat:Maxlat})
lon  = f1->lon({Minlon:Maxlon})
slp = new((/24*2,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
slp(0+24*0:23+24*0,:,:) = f1->SLP(:,{Minlat:Maxlat},{Minlon:Maxlon})
slp(0+24*1:23+24*1,:,:) = f2->SLP(:,{Minlat:Maxlat},{Minlon:Maxlon})
slp!0    = "time"
slp!1    = "lat"
slp&lat  = lat
slp!2    = "lon"
slp&lon  = lon
slp      = slp/100.
u850 = slp
v850 = slp
q850 = slp
u850(0+24*0:23+24*0,:,:) = f1->U850(:,{Minlat:Maxlat},{Minlon:Maxlon})
u850(0+24*1:23+24*1,:,:) = f2->U850(:,{Minlat:Maxlat},{Minlon:Maxlon})
v850(0+24*0:23+24*0,:,:) = f1->V850(:,{Minlat:Maxlat},{Minlon:Maxlon})
v850(0+24*1:23+24*1,:,:) = f2->V850(:,{Minlat:Maxlat},{Minlon:Maxlon})
q850(0+24*0:23+24*0,:,:) = f1->Q850(:,{Minlat:Maxlat},{Minlon:Maxlon})
q850(0+24*1:23+24*1,:,:) = f2->Q850(:,{Minlat:Maxlat},{Minlon:Maxlon})
MERRA2_slp     = slp(Mintime:Maxtime,:,:)
MERRA2_u850    = u850(Mintime:Maxtime,:,:)
MERRA2_v850    = v850(Mintime:Maxtime,:,:)
MERRA2_q850    = q850(Mintime:Maxtime,:,:)
MERRA2_moisture_flux_u = 1.0/9.8*MERRA2_q850*MERRA2_u850*1000.0
MERRA2_moisture_flux_v = 1.0/9.8*MERRA2_q850*MERRA2_v850*1000.0
MERRA2_avg_slp             = dim_avg_n_Wrap(MERRA2_slp, 0)
MERRA2_avg_moisture_flux_u = dim_avg_n_Wrap(MERRA2_moisture_flux_u,0)
MERRA2_avg_moisture_flux_v = dim_avg_n_Wrap(MERRA2_moisture_flux_v,0)
copy_VarMeta(slp(0,:,:), MERRA2_avg_slp)
copy_VarMeta(MERRA2_slp,MERRA2_moisture_flux_u)
copy_VarMeta(MERRA2_slp,MERRA2_moisture_flux_v)
copy_VarMeta(MERRA2_slp(0,:,:),MERRA2_avg_moisture_flux_u)
copy_VarMeta(MERRA2_slp(0,:,:),MERRA2_avg_moisture_flux_v)
delete(f1)
delete(f2)
delete(lon)
delete(lat)
delete(slp)
delete(u850)
delete(v850)
delete(q850)
;;merra2

;60-3km
;;time 0907_12:00 - 0908_03:00 UTC
Mintime    = 9
Maxtime    = 24
Time  = Maxtime - Mintime
f1     = addfile("/data/ess-liuzj/0907case/test/60-3km/data/main.nc", "r")
lat  = f1->latitude({Minlat:Maxlat})
lon  = f1->longitude({Minlon:Maxlon})
slp  = f1->mslp(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
u850  = f1->uzonal_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
v850  = f1->umeridional_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
rh850 = f1->relhum_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
t850  = f1->temperature_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
lev   = t850
lev   = 850.0
q850  = mixhum_ptrh(lev, t850, rh850, 1)
slp  = slp/100.0
slp!0    = "time"
slp!1    = "lat"
slp&lat  = lat
slp!2    = "lon"
slp&lon  = lon
g60_3_slp     = slp
g60_3_moisture_flux_u = 1.0/9.8*q850*u850*1000.0
g60_3_moisture_flux_v = 1.0/9.8*q850*v850*1000.0
g60_3_avg_slp = dim_avg_n_Wrap(slp,0)
g60_3_avg_moisture_flux_u = dim_avg_n(g60_3_moisture_flux_u, 0)
g60_3_avg_moisture_flux_v = dim_avg_n(g60_3_moisture_flux_v, 0)
copy_VarMeta(slp(0,:,:),g60_3_avg_slp)
copy_VarMeta(g60_3_slp,g60_3_moisture_flux_u)
copy_VarMeta(g60_3_slp,g60_3_moisture_flux_v)
copy_VarMeta(g60_3_slp(0,:,:),g60_3_avg_moisture_flux_u)
copy_VarMeta(g60_3_slp(0,:,:),g60_3_avg_moisture_flux_v)
delete(f1)
delete(slp)
delete(lon)
delete(lat)
delete(lev)
;;60-3km


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
r3small_slp1 = f1->mslp(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})/100.0
r3vari_slp1  = f2->mslp(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})/100.0
r3big_slp1   = f3->mslp(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})/100.0
r3small_t850 = f1->temperature_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_t850  = f2->temperature_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_t850   = f3->temperature_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_u850 = f1->uzonal_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_u850  = f2->uzonal_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_u850   = f3->uzonal_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_v850 = f1->umeridional_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_v850  = f2->umeridional_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_v850   = f3->umeridional_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_rh850 = f1->relhum_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_rh850  = f2->relhum_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_rh850   = f3->relhum_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_slp1!0    = "time"
r3small_slp1!1    = "lat"
r3small_slp1&lat  = lat
r3small_slp1!2    = "lon"
r3small_slp1&lon  = lon
copy_VarMeta(r3small_slp1,r3vari_slp1)
copy_VarMeta(r3small_slp1,r3big_slp1)
lev = r3big_t850
lev = 850.0
r3small_q850  = mixhum_ptrh(lev, r3small_t850, r3small_rh850, 1)
r3vari_q850  = mixhum_ptrh(lev, r3vari_t850, r3vari_rh850, 1)
r3big_q850  = mixhum_ptrh(lev, r3big_t850, r3big_rh850, 1)
r3small_moisture_flux_u = 1.0/9.8*r3small_q850*r3small_u850*1000.0
r3small_moisture_flux_v = 1.0/9.8*r3small_q850*r3small_v850*1000.0
r3vari_moisture_flux_u = 1.0/9.8*r3vari_q850*r3vari_u850*1000.0
r3vari_moisture_flux_v = 1.0/9.8*r3vari_q850*r3vari_v850*1000.0
r3big_moisture_flux_u = 1.0/9.8*r3big_q850*r3big_u850*1000.0
r3big_moisture_flux_v = 1.0/9.8*r3big_q850*r3big_v850*1000.0
r3small_slp = r3small_slp1
r3vari_slp  = r3vari_slp1
r3big_slp   = r3big_slp1
do i = 0, 15
r3small_slp(i,:,:) = r3small_slp1(2*i,:,:)
r3vari_slp(i,:,:) = r3vari_slp1(2*i,:,:)
r3big_slp(i,:,:) = r3big_slp1(2*i,:,:)
r3small_moisture_flux_u(i,:,:) = r3small_moisture_flux_u(2*i,:,:)
r3vari_moisture_flux_u(i,:,:) = r3vari_moisture_flux_u(2*i,:,:)
r3big_moisture_flux_u(i,:,:) = r3big_moisture_flux_u(2*i,:,:)
r3small_moisture_flux_v(i,:,:) = r3small_moisture_flux_v(2*i,:,:)
r3vari_moisture_flux_v(i,:,:) = r3vari_moisture_flux_v(2*i,:,:)
r3big_moisture_flux_v(i,:,:) = r3big_moisture_flux_v(2*i,:,:)
end do
r3small_avg_slp = dim_avg_n_Wrap(r3small_slp(0:15,:,:),0)
r3vari_avg_slp = dim_avg_n_Wrap(r3vari_slp(0:15,:,:),0)
r3big_avg_slp = dim_avg_n_Wrap(r3big_slp(0:15,:,:),0)
r3small_avg_moisture_flux_u = dim_avg_n_Wrap(r3small_moisture_flux_u(0:15,:,:),0)
r3vari_avg_moisture_flux_u = dim_avg_n_Wrap(r3vari_moisture_flux_u(0:15,:,:),0)
r3big_avg_moisture_flux_u = dim_avg_n_Wrap(r3big_moisture_flux_u(0:15,:,:),0)
r3small_avg_moisture_flux_v = dim_avg_n_Wrap(r3small_moisture_flux_v(0:15,:,:),0)
r3vari_avg_moisture_flux_v = dim_avg_n_Wrap(r3vari_moisture_flux_v(0:15,:,:),0)
r3big_avg_moisture_flux_v = dim_avg_n_Wrap(r3big_moisture_flux_v(0:15,:,:),0)
copy_VarMeta(r3small_slp(0,:,:),r3small_avg_slp)
copy_VarMeta(r3small_slp(0,:,:),r3vari_avg_slp)
copy_VarMeta(r3small_slp(0,:,:),r3big_avg_slp)
copy_VarMeta(r3small_slp,r3small_moisture_flux_u)
copy_VarMeta(r3small_slp,r3vari_moisture_flux_u)
copy_VarMeta(r3small_slp,r3big_moisture_flux_u)
copy_VarMeta(r3small_slp,r3small_moisture_flux_v)
copy_VarMeta(r3small_slp,r3vari_moisture_flux_v)
copy_VarMeta(r3small_slp,r3big_moisture_flux_v)
copy_VarMeta(r3small_slp(0,:,:),r3small_avg_moisture_flux_u)
copy_VarMeta(r3small_slp(0,:,:),r3vari_avg_moisture_flux_u)
copy_VarMeta(r3small_slp(0,:,:),r3big_avg_moisture_flux_u)
copy_VarMeta(r3small_slp(0,:,:),r3small_avg_moisture_flux_v)
copy_VarMeta(r3small_slp(0,:,:),r3vari_avg_moisture_flux_v)
copy_VarMeta(r3small_slp(0,:,:),r3big_avg_moisture_flux_v)
delete(f1)
delete(f2)
delete(f3)
delete(lat)
delete(lon)

;;regional SIM
if zoomin.eq.1 then
wks   = gsn_open_wks ("pdf", "moisture_hourly_zoomin" )  ; send graphics to PNG file
end if
if zoomin.eq.0 then
wks   = gsn_open_wks ("pdf", "moisture_hourly_zoomout" )  ; send graphics to PNG file
end if
plot  = new(6,graphic)
cn1plot  = new(6,graphic)
vcplot  = new(6,graphic)

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
if zoomin.eq.1 then
res@cnMinLevelValF = 1006.
res@cnMaxLevelValF = 1014.
res@cnLevelSpacingF = 0.5
end if
if zoomin.eq.0 then
res@cnMinLevelValF = 996.
res@cnMaxLevelValF = 1020.
res@cnLevelSpacingF = 0.5
end if

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
if zoomin.eq.1 then
leftAngle   = 35.0-20.0-3.0
rightAngle  = 35.0-20.0-3.0
bottomAngle = 30.0-20.0-2.0
topAngle    = 30.0-20.0-2.0
end if
if zoomin.eq.0 then
leftAngle   = 35.0-5.0
rightAngle  = 35.0-5.0
bottomAngle = 30.0-5.0
topAngle    = 30.0-5.0
end if
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

 vcres                          =True
 vcres@lbLabelStride            = 2 
 vcres@vcGlyphStyle             ="LineArrow"     ;; "PostDraw"
 vcres@vcLineArrowThicknessF    = 2.0            ;;;;;;;jian tou uc xi 
 vcres@vcMonoLineArrowColor     = True
 vcres@vcLineArrowColor         = "darkgreen"
 vcres@gsnLeftString            = ""
 vcres@gsnRightString           = ""
 
 vcres@vcMinMagnitudeF          = 0.4
 vcres@vcRefMagnitudeF          = 20.0
 vcres@vcRefLengthF             = 0.05
 vcres@vcMinDistanceF           = 0.02
 vcres@vcRefAnnoOn              = True
 vcres@vcRefAnnoOrthogonalPosF  = -1.
 vcres@vcRefAnnoFontHeightF     = 0.01
 vcres@vcRefAnnoString1On       = True   ;cankaojiantou shang zi
 vcres@vcRefAnnoString2On       = True   ;cankaojiantou xia zi
 vcres@gsnAddCyclic             = False
 vcres@vcRefAnnoFontHeightF     = 0.01
 vcres@vcRefAnnoString1         = "20 g s~S~-1~N~cm~S~-1~N~hPa~S~-1~N~"
 vcres@vcRefAnnoString2On       = False
 ;vcres@vcRefAnnoParallelPosF   = 0.1     ;;;;;;;left and right vector
 vcres@vcRefAnnoOrthogonalPosF  = -1.0     ;;;;;;;up and down vector   fu xiangshang  -1.095

 
 
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
res1@gsnDraw         = False
res1@gsnFrame        = False
if zoomin.eq.1 then
res1@cnLevels     =(/3.3/)
end if
if zoomin.eq.0 then
res1@cnLevels     =(/3.3,14.3/)
end if
res1@cnLineThicknessF = 1.0
res@gsnDraw = False
res1@gsnDraw = False
vcres@gsnDraw = False
res@gsnFrame = False
res1@gsnFrame = False
vcres@gsnFrame = False

res@lgOrientation      = "Horizontal"   ;;qiangzhi hengxiang baifang
res1@lgOrientation     = "Horizontal"

do ii = 0,15
 res@gsnCenterString = "ERA5"
 res@gsnLeftString   = "(a)"
 res@gsnRightString  = ""
 plot(0)             = gsn_csm_contour_map(wks,ERA5_slp(ii,:,:),res) 
 cn1plot(0)          = gsn_csm_contour(wks, fld ,res1) 
 vcplot(0)           = gsn_csm_vector(wks, ERA5_moisture_flux_u(ii,:,:), ERA5_moisture_flux_v(ii,:,:), vcres) 
 overlay(plot(0),vcplot(0))
 overlay(plot(0), cn1plot(0))
 res@gsnCenterString = "MERRA2"
 res@gsnLeftString   = "(b)"
 ;res@gsnRightString  = "0907_16:00"
 plot(1)             = gsn_csm_contour_map(wks,MERRA2_slp(ii,:,:),res) 
cn1plot(1)     = gsn_csm_contour(wks, fld,res1) 
vcplot(1)      = gsn_csm_vector(wks, MERRA2_moisture_flux_u(ii,:,:),MERRA2_moisture_flux_v(ii,:,:),vcres)
overlay(plot(1), cn1plot(1))
overlay(plot(1),vcplot(1))
 res@gsnCenterString = "MPAS gloabl 60-3km"
 res@gsnLeftString   = "(c)"
 ;res@gsnRightString  = "0907_20:00"
 plot(2)             = gsn_csm_contour_map(wks,g60_3_slp(ii,:,:),res) 
  cn1plot(2)           = gsn_csm_contour(wks, fld ,res1) 
  vcplot(2)           = gsn_csm_vector(wks, g60_3_moisture_flux_u(ii,:,:), g60_3_moisture_flux_v(ii,:,:), vcres) 
  overlay(plot(2),vcplot(2))
overlay(plot(2), cn1plot(2))
 res@gsnCenterString = "MPAS regional 3km small"
 res@gsnLeftString   = "(d)"
 ;res@gsnRightString  = "0908_00:00"
 plot(3)             = gsn_csm_contour_map(wks,r3small_slp(ii,:,:),res) 
  cn1plot(3)           = gsn_csm_contour(wks, fld ,res1) 
  vcplot(3)           = gsn_csm_vector(wks, r3small_moisture_flux_u(ii,:,:), r3small_moisture_flux_v(ii,:,:), vcres) 
  overlay(plot(3),vcplot(3))
overlay(plot(3), cn1plot(3))
 res@gsnCenterString = "MPAS regional 15-3km big"
 res@gsnLeftString   = "(e)"
 ;res@gsnRightString  = "0908_04:00"
 plot(4)             = gsn_csm_contour_map(wks,r3vari_slp(ii,:,:),res) 
  cn1plot(4)           = gsn_csm_contour(wks, fld ,res1) 
  vcplot(4)           = gsn_csm_vector(wks, r3vari_moisture_flux_u(ii,:,:), r3vari_moisture_flux_v(ii,:,:), vcres) 
  overlay(plot(4),vcplot(4))
overlay(plot(4), cn1plot(4))
 res@gsnCenterString = "MPAS regional 3km big"
 res@gsnLeftString   = "(f)"
 ;res@gsnRightString  = ""
 plot(5)             = gsn_csm_contour_map(wks,r3big_slp(ii,:,:),res) 
 cn1plot(5)           = gsn_csm_contour(wks, fld ,res1) 
 vcplot(5)           = gsn_csm_vector(wks, r3big_moisture_flux_u(ii,:,:), r3big_moisture_flux_v(ii,:,:), vcres) 
 overlay(plot(5),vcplot(5))
overlay(plot(5), cn1plot(5))

timechar =  (/"09-07_20:00 (LST)",\
"09-07_21:00 (LST)",\
"09-07_22:00 (LST)",\
"09-07_23:00 (LST)",\
"09-08_00:00 (LST)",\
"09-08_01:00 (LST)",\
"09-08_02:00 (LST)",\
"09-08_03:00 (LST)",\
"09-08_04:00 (LST)",\
"09-08_05:00 (LST)",\
"09-08_06:00 (LST)",\
"09-08_07:00 (LST)",\
"09-08_08:00 (LST)",\
"09-08_09:00 (LST)",\
"09-08_10:00 (LST)",\
"09-08_11:00 (LST)"/)

resP                         = True                 ; modify the panel plot
resP@gsnFrame                = False                ; don't advance panel plot
resP@lgOrientation     = "Horizontal"
resP@gsnMaximize             = False                ; shifou zuidahua
resP@gsnPanelLabelBar        = True                 ; common colorbar kaiguan
resP@lbLabelFontHeightF      = 0.015                 ; common color bar ziti daxiao
resP@pmLabelBarOrthogonalPosF= -0.02                   ; common color bar shangxia yidong     fu xiang xia 
; resP@pmLabelBarWidthF      = 0.8                  ; common color bar zengjia kuandu
; resP@pmLabelBarHeightF     = 0.06                 ; common color bar zengjia gaodu
resP@lbBoxLinesOn            = True                 ; common color bar biankuangxian kaiguan 
resP@gsnteSPanelXWhipacePercent  = 1.3                ; X fangxiang jianxi
resP@gsnPanelYWhiteSpacePercent  = 1.5               ; Y fangxiang jianxi
;resP@gsnPanelBottom          = 0.15 
resP@gsnLeftString            = ""
resP@gsnRightString           = ""
resP@txString          = "Time:   "+timechar(ii)+"  "
resP@lbTitleString            = "Sea level pressure [hPa]"
resP@lbTitlePosition          = "Bottom"
resP@lbTitleFontHeightF       = 0.015
; resP@gsnPanelMainString     = ""               ; set main title
; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
;resP@gsnPanelFigureStrings  = (/"(a)","(b)","(c)","(d)","(e)","(f)","(h)","(i)","(j)"/)
;resP@gsnPanelFiguvcrestringsFontHeightF   = 0.01             ;;;;;"(a)","(b)","(c)"的大小
;resP@amJust                               = "TopLeft"           ;;;;;"(a)","(b)","(c)"的位置
  resP@gsnPanelRowSpec      = True
  gsn_panel(wks, plot, (/3,3/), resP)
  ;draw(plot)
  frame(wks)
  end do
 end