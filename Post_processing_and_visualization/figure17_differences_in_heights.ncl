load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
; zoomin = systemfunc("echo $zoomin") ;0=zoomout 1=zoomin
; level1  = systemfunc("echo $level")  ;850 500 925
; level  = stringtoint(level1)

zoomin = 1
level  = 500

Minlon    = 100-3-20-5
Maxlon    = 150-3+20
Minlat    = 15-20-5
Maxlat    = 45+20


;era5
;;time 0907_12:00 - 0908_03:00 UTC
Mintime = 24+24+12
Maxtime = 24+24+27
f1  = addfile ("/data/ess-liuzj/0907case/era5/wind_850_500.nc", "r") 
ERA5_u = short2flt(f1->u(Mintime:Maxtime,{level},{Minlat:Maxlat},{Minlon:Maxlon}))
ERA5_v = short2flt(f1->v(Mintime:Maxtime,{level},{Minlat:Maxlat},{Minlon:Maxlon}))
ERA5_lat = f1->latitude({Minlat:Maxlat})
ERA5_lon = f1->longitude({Minlon:Maxlon})
ERA5_h = short2flt(f1->z(Mintime:Maxtime,{level},{Minlat:Maxlat},{Minlon:Maxlon}))
ERA5_h = ERA5_h/9.8/10.0
ERA5_avg_u = dim_avg_n_Wrap(ERA5_u,0)
ERA5_avg_v = dim_avg_n_Wrap(ERA5_v,0)
ERA5_avg_h = dim_avg_n_Wrap(ERA5_h,0)
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
u = new((/24*2,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
v = new((/24*2,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
h = new((/24*2,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
if level.eq.850 then
u(0+24*0:23+24*0,:,:) = f1->U850(:,{Minlat:Maxlat},{Minlon:Maxlon})
u(0+24*1:23+24*1,:,:) = f2->U850(:,{Minlat:Maxlat},{Minlon:Maxlon})
v(0+24*0:23+24*0,:,:) = f1->V850(:,{Minlat:Maxlat},{Minlon:Maxlon})
v(0+24*1:23+24*1,:,:) = f2->V850(:,{Minlat:Maxlat},{Minlon:Maxlon})
h(0+24*0:23+24*0,:,:) = f1->H850(:,{Minlat:Maxlat},{Minlon:Maxlon})
h(0+24*1:23+24*1,:,:) = f2->H850(:,{Minlat:Maxlat},{Minlon:Maxlon})
end if 
if level.eq.500 then
u(0+24*0:23+24*0,:,:) = f1->U500(:,{Minlat:Maxlat},{Minlon:Maxlon})
u(0+24*1:23+24*1,:,:) = f2->U500(:,{Minlat:Maxlat},{Minlon:Maxlon})
v(0+24*0:23+24*0,:,:) = f1->V500(:,{Minlat:Maxlat},{Minlon:Maxlon})
v(0+24*1:23+24*1,:,:) = f2->V500(:,{Minlat:Maxlat},{Minlon:Maxlon})
h(0+24*0:23+24*0,:,:) = f1->H500(:,{Minlat:Maxlat},{Minlon:Maxlon})
h(0+24*1:23+24*1,:,:) = f2->H500(:,{Minlat:Maxlat},{Minlon:Maxlon})
end if 
if level.eq.925 then
u(0+24*0:23+24*0,:,:) = f1->U925(:,{Minlat:Maxlat},{Minlon:Maxlon})
u(0+24*1:23+24*1,:,:) = f2->U925(:,{Minlat:Maxlat},{Minlon:Maxlon})
v(0+24*0:23+24*0,:,:) = f1->V925(:,{Minlat:Maxlat},{Minlon:Maxlon})
v(0+24*1:23+24*1,:,:) = f2->V925(:,{Minlat:Maxlat},{Minlon:Maxlon})
h(0+24*0:23+24*0,:,:) = f1->H925(:,{Minlat:Maxlat},{Minlon:Maxlon})
h(0+24*1:23+24*1,:,:) = f2->H925(:,{Minlat:Maxlat},{Minlon:Maxlon})
end if 
h = h/10.0
u!0    = "time"
u!1    = "lat"
u&lat  = lat
u!2    = "lon"
u&lon  = lon
copy_VarMeta(u,v)
copy_VarMeta(u,h)
MERRA2_u = u(Mintime:Maxtime,:,:)
MERRA2_v = v(Mintime:Maxtime,:,:)
MERRA2_h = h(Mintime:Maxtime,:,:)
MERRA2_avg_u = dim_avg_n_Wrap(MERRA2_u,0)
MERRA2_avg_v = dim_avg_n_Wrap(MERRA2_v,0)
MERRA2_avg_h = dim_avg_n_Wrap(MERRA2_h,0)
delete(lon)
delete(lat)
delete(u)
delete(v)
delete(h)
;;merra2

;60-3km
;;time 0907_12:00 - 0908_03:00 UTC
Mintime    = 9
Maxtime    = 24
f1   = addfile("/data/ess-liuzj/0907case/test/60-3km/data/main.nc", "r")
g60_3_lat  = f1->latitude({Minlat:Maxlat})
g60_3_lon  = f1->longitude({Minlon:Maxlon})
if level.eq.850 then
g60_3_u  = f1->uzonal_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
g60_3_v  = f1->umeridional_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
g60_3_h  = f1->height_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
end if
if level.eq.500 then
g60_3_u  = f1->uzonal_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
g60_3_v  = f1->umeridional_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
g60_3_h  = f1->height_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
end if
if level.eq.925 then
g60_3_u  = f1->uzonal_925hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
g60_3_v  = f1->umeridional_925hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
g60_3_h  = f1->height_925hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
end if
g60_3_h = g60_3_h/10.0
g60_3_avg_u = dim_avg_n_Wrap(g60_3_u,0)
g60_3_avg_v = dim_avg_n_Wrap(g60_3_v,0)
g60_3_avg_h = dim_avg_n_Wrap(g60_3_h,0)
;;60-3km


;regional SIM
;;time 0907_12:00 - 0908_03:00 UTC
Mintime    = 18
Maxtime    = 48
id = (/18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48/)
Time = Maxtime - Mintime
f1     = addfile ("/data/ess-liuzj/0907case/test/regional_GFS_3km_small/data/main.nc", "r")
f2     = addfile ("/data/ess-liuzj/0907case/test/regional_GFS_3km_vari/data/main.nc", "r")
f3     = addfile ("/data/ess-liuzj/0907case/test/regional_GFS_3km_big/data/main.nc", "r")
r3small_lat  = f1->latitude({Minlat:Maxlat})
r3small_lon  = f1->longitude({Minlon:Maxlon})
if level.eq.850 then
r3small_h = f1->height_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_h  = f2->height_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_h   = f3->height_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_u = f1->uzonal_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_u  = f2->uzonal_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_u   = f3->uzonal_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_v = f1->umeridional_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_v  = f2->umeridional_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_v   = f3->umeridional_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
end if
if level.eq.925 then
r3small_h = f1->height_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_h  = f2->height_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_h   = f3->height_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_u = f1->uzonal_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_u  = f2->uzonal_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_u   = f3->uzonal_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_v = f1->umeridional_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_v  = f2->umeridional_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_v   = f3->umeridional_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
end if
if level.eq.500 then
r3small_h = f1->height_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_h  = f2->height_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_h   = f3->height_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_u = f1->uzonal_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_u  = f2->uzonal_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_u   = f3->uzonal_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_v = f1->umeridional_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_v  = f2->umeridional_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_v   = f3->umeridional_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
end if
r3small_h = r3small_h/10.0
r3vari_h = r3vari_h/10.0
r3big_h = r3big_h/10.0
r3small_avg_h = dim_avg_n_Wrap(r3small_h,0)
r3small_avg_v = dim_avg_n_Wrap(r3small_v,0)
r3small_avg_u = dim_avg_n_Wrap(r3small_u,0)
r3big_avg_h = dim_avg_n_Wrap(r3big_h,0)
r3big_avg_v = dim_avg_n_Wrap(r3big_v,0)
r3big_avg_u = dim_avg_n_Wrap(r3big_u,0)
r3vari_avg_h = dim_avg_n_Wrap(r3vari_h,0)
r3vari_avg_v = dim_avg_n_Wrap(r3vari_v,0)
r3vari_avg_u = dim_avg_n_Wrap(r3vari_u,0)
delete(f1)
delete(f2)
delete(f3)

;;regional SIM
if zoomin.eq.1 then
wks   = gsn_open_wks ("pdf", "diff_height_hourly_"+level+"hPa_zoomin" )
end if
if zoomin.eq.0 then
wks   = gsn_open_wks ("pdf", "diff_height_hourly_"+level+"hPa_zoomout" )  ; send graphics to PNG file
end if
plot  = new(8,graphic)
cn1plot  = new(8,graphic)
vcplot  = new(8,graphic)
cmap = read_colormap_file("CBR_coldhot")
res                         = True
res@gsnMaximize             = False                            ; Maximize plot
res@cnFillOn                = True                             ; tainse
res@cnLinesOn               = False                            ; dengzhixian
res@lbLabelBarOn            = False                            ; xiaotu de bar
res@cnLineLabelsOn          = False                            ; line de biaoqian
res@cnInfoLabelOn           = False                            ; line de infomation
res@cnLineLabelFontHeightF  = 0.015                            ; line de biaoqian ziti daxiao

res@cnFillMode              = "RasterFill"                     ; turn raster on      
colors                      = (/"CBR_coldhot"/)    ; none
res@cnFillPalette           = colors                           ; none
res@cnLineLabelsOn          = False                            ; dengzhixian shuoming
res@cnLevelSelectionMode = "ManualLevels"
if level.eq.850 then
res@cnMinLevelValF = -1.4
res@cnMaxLevelValF = 1.4
res@cnLevelSpacingF = 0.2
end if
if level.eq.925 then
res@cnMinLevelValF = -1.4
res@cnMaxLevelValF = 1.4
res@cnLevelSpacingF = 0.2
end if
if level.eq.500 then
res@cnMinLevelValF = -1.4
res@cnMaxLevelValF = 1.4
res@cnLevelSpacingF = 0.2
end if

res@mpFillOn                = False                            ; ditu tianse
res@gsnAddCyclic            = False                            ; quanqiu dakai, fouze guanbi
res@gsnCenterStringFontHeightF    = 0.03                       ; center biaoti zi daxiao
res@gsnCenterStringOrthogonalPosF = 0.02                     ; center biaoti shangxia yidong  "fu xiang xia"
res@gsnRightStringFontHeightF     = 0.03                       ; right biaoti zi daxiao
res@gsnRightStringOrthogonalPosF  = 0.02                     ; right biaoti shangxia yidong
res@gsnLeftStringFontHeightF      = 0.03                       ; Left biaoti zi daxiao
res@gsnLeftStringOrthogonalPosF   = 0.02                     ; Left biaoti shangxia yidong

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
res@mpLimitMode       = "Angles"
res@mpCenterLonF      = (Minlon + Maxlon) / 2.              ; center lon
res@mpCenterLatF      = (Minlat + Maxlat) / 2.              ; center lon
res@mpCenterLonF      = 114              ; center lon
res@mpCenterLatF      = 22             ; center lon
res@mpLeftAngleF      = leftAngle
res@mpRightAngleF     = rightAngle
res@mpBottomAngleF    = bottomAngle
res@mpTopAngleF       = topAngle



res@tmXTOn          = False
res@tmYROn          = False
res@pmTickMarkDisplayMode   = "Always"
res@tmXBLabelFontThicknessF = 0.4                              ; X zhou ziti lonlat cuxi
res@tmYLLabelFontThicknessF = 0.4                              ; Y zhou ziti lonlat cuxi
res@tmXBLabelFontHeightF    = 0.02                             ; X zhou ziti daxiao
res@tmYLLabelFontHeightF    = 0.02                             ; Y zhou ziti daxiao
res@tmXBLabelDeltaF         = -0.5                             ; X zhou ziti xiang X zhou kaojin
res@tmYLLabelDeltaF         = -0.5                             ; Y zhou ziti xiang Y zhou kaojin
res@tmYLMajorLengthF        = -0.006                              ; XYzhou zhuyao changdu
res@tmXBMajorLengthF        = -0.006                              ; XYzhou zhuyao changdu
res@tmXBMinorLengthF        = 0.0                              ; XYzhou ciyao changdu
res@tmYLMinorLengthF        = 0.0                              ; XYzhou ciyao changdu
res@tmXBLabelFontThicknessF = 0.4                              ; X zhou ziti lonlat cuxi
res@tmYLLabelFontThicknessF = 0.4                              ; Y zhou ziti lonlat cuxi
res@tmXBLabelFontHeightF    = 0.025                             ; X zhou ziti daxiao
res@tmYLLabelFontHeightF    = 0.025                             ; Y zhou ziti daxiao
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
 vcres@vcLineArrowThicknessF    = 1.0            ;;;;;;;jian tou uc xi 
 vcres@vcMonoLineArrowColor     = True
 ;vcres@vcLineArrowColor         = "darkgreen"
 vcres@vcLineArrowColor         = "black"
 vcres@gsnLeftString            = ""
 vcres@gsnRightString           = ""
 
 vcres@vcMinMagnitudeF          = 0.4
 vcres@vcRefMagnitudeF          = 10.0
 vcres@vcRefLengthF             = 0.05
 vcres@vcMinDistanceF           = 0.02
 vcres@vcRefAnnoOn              = True
 vcres@vcRefAnnoOrthogonalPosF  = -1.
 vcres@vcRefAnnoString1On       = True   ;cankaojiantou shang zi
 vcres@vcRefAnnoString2On       = True   ;cankaojiantou xia zi
 vcres@gsnAddCyclic             = False
 vcres@vcRefAnnoFontHeightF     = 0.022
 vcres@vcRefAnnoString1         = "10 m/s"
;  vcres@vcRefAnnoString1         = "20 g s~S~-1~N~cm~S~-1~N~hPa~S~-1~N~"
 vcres@vcRefAnnoString2On       = False

 ;vcres@vcRefAnnoParallelPosF   = 0.1     ;;;;;;;left and right vector
 vcres@vcRefAnnoOrthogonalPosF  = -1.136     ;;;;;;;up and down vector   fu xiangshang  -1.095

 
 
 res@pmLabelBarWidthF      = 0.65                  ;  color bar zengjia kuandu
 res@pmLabelBarHeightF     = 0.07                 ;  color bar zengjia gaodu
 res@pmLabelBarOrthogonalPosF= 0.12                  ; common color bar shangxia yidong     fu xiang xia 
 
 
 f1     = addfile ("/data/ess-liuzj/0907case/test/60-3km/data/static1.nc", "r")
 lat  = f1->latitude
 lon  = f1->longitude
 ter  = f1->ter({Minlat:Maxlat},{Minlon:Maxlon})
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

ERA5_avg_h_cha  = linint2_Wrap(ERA5_lon,ERA5_lat,ERA5_avg_h,False,r3small_lon,r3small_lat,0)
delete(ERA5_avg_h)
ERA5_avg_h = ERA5_avg_h_cha
;g60_3_avg_h_cha = g60_3_avg_h
g60_3_avg_h_cha  = linint2_Wrap(g60_3_lon,g60_3_lat,g60_3_avg_h,False,r3small_lon,r3small_lat,0)
delete(g60_3_avg_h)
g60_3_avg_h = g60_3_avg_h_cha
diff_g60_3_avg_h = g60_3_avg_h - ERA5_avg_h
diff_r3small_avg_h = r3small_avg_h - ERA5_avg_h
diff_r3vari_avg_h  = r3vari_avg_h - ERA5_avg_h
diff_r3big_avg_h  = r3big_avg_h - ERA5_avg_h
copy_VarMeta(g60_3_avg_h,diff_g60_3_avg_h)
copy_VarMeta(g60_3_avg_h,diff_r3small_avg_h)
copy_VarMeta(g60_3_avg_h,diff_r3vari_avg_h)
copy_VarMeta(g60_3_avg_h,diff_r3big_avg_h)
diff_g60_3_avg_h   = mask(diff_g60_3_avg_h, ter.gt.1000, False)
diff_r3small_avg_h   = mask(diff_r3small_avg_h, ter.gt.1000, False)
diff_r3vari_avg_h   = mask(diff_r3vari_avg_h, ter.gt.1000, False)
diff_r3big_avg_h   = mask(diff_r3big_avg_h, ter.gt.1000, False)

ERA5_avg_u_cha  = linint2_Wrap(ERA5_lon,ERA5_lat,ERA5_avg_u,False,r3small_lon,r3small_lat,0)
delete(ERA5_avg_u)
ERA5_avg_u = ERA5_avg_u_cha
;g60_3_avg_u_cha = g60_3_avg_u
g60_3_avg_u_cha  = linint2_Wrap(g60_3_lon,g60_3_lat,g60_3_avg_u,False,r3small_lon,r3small_lat,0)
delete(g60_3_avg_u)
g60_3_avg_u = g60_3_avg_u_cha
diff_g60_3_avg_u = g60_3_avg_u - ERA5_avg_u
diff_r3small_avg_u = r3small_avg_u - ERA5_avg_u
diff_r3vari_avg_u  = r3vari_avg_u - ERA5_avg_u
diff_r3big_avg_u  = r3big_avg_u - ERA5_avg_u
copy_VarMeta(g60_3_avg_u,diff_g60_3_avg_u)
copy_VarMeta(g60_3_avg_u,diff_r3small_avg_u)
copy_VarMeta(g60_3_avg_u,diff_r3vari_avg_u)
copy_VarMeta(g60_3_avg_u,diff_r3big_avg_u)
diff_g60_3_avg_u   = mask(diff_g60_3_avg_u, ter.gt.1000, False)
diff_r3small_avg_u   = mask(diff_r3small_avg_u, ter.gt.1000, False)
diff_r3vari_avg_u   = mask(diff_r3vari_avg_u, ter.gt.1000, False)
diff_r3big_avg_u   = mask(diff_r3big_avg_u, ter.gt.1000, False)

ERA5_avg_v_cha  = linint2_Wrap(ERA5_lon,ERA5_lat,ERA5_avg_v,False,r3small_lon,r3small_lat,0)
delete(ERA5_avg_v)
ERA5_avg_v = ERA5_avg_v_cha
;g60_3_avg_v_cha = g60_3_avg_v
g60_3_avg_v_cha  = linint2_Wrap(g60_3_lon,g60_3_lat,g60_3_avg_v,False,r3small_lon,r3small_lat,0)
delete(g60_3_avg_v)
g60_3_avg_v = g60_3_avg_v_cha
diff_g60_3_avg_v = g60_3_avg_v - ERA5_avg_v
diff_r3small_avg_v = r3small_avg_v - ERA5_avg_v
diff_r3vari_avg_v  = r3vari_avg_v - ERA5_avg_v
diff_r3big_avg_v  = r3big_avg_v - ERA5_avg_v
copy_VarMeta(g60_3_avg_v,diff_g60_3_avg_v)
copy_VarMeta(g60_3_avg_v,diff_r3small_avg_v)
copy_VarMeta(g60_3_avg_v,diff_r3vari_avg_v)
copy_VarMeta(g60_3_avg_v,diff_r3big_avg_v)
diff_g60_3_avg_v   = mask(diff_g60_3_avg_v, ter.gt.1000, False)
diff_r3small_avg_v   = mask(diff_r3small_avg_v, ter.gt.1000, False)
diff_r3vari_avg_v   = mask(diff_r3vari_avg_v, ter.gt.1000, False)
diff_r3big_avg_v   = mask(diff_r3big_avg_v, ter.gt.1000, False)


res@tmYLOn = True
res@tmXBOn = True
res@tmXBLabelFontHeightF    = 0.035                             ; X zhou ziti daxiao
res@tmYLLabelFontHeightF    = 0.035                             ; Y zhou ziti daxiao
res@gsnCenterStringFontHeightF    = 0.035                       ; center biaoti zi daxiao
res@gsnCenterStringOrthogonalPosF = 0.02                     ; center biaoti shangxia yidong  "fu xiang xia"
res@gsnRightStringFontHeightF     = 0.035                       ; right biaoti zi daxiao
res@gsnRightStringOrthogonalPosF  = 0.02                     ; right biaoti shangxia yidong
res@gsnLeftStringFontHeightF      = 0.035                       ; Left biaoti zi daxiao
res@gsnLeftStringOrthogonalPosF   = 0.02                     ; Left biaoti shangxia yidong
res@lbBoxEndCapStyle = "TriangleBothEnds"
res@gsnCenterString = "G60-3km - ERA5"
res@gsnLeftString   = "(a)"
 res@gsnRightString  = ""
 plot(0)             = gsn_csm_contour_map(wks,diff_g60_3_avg_h(:,:),res) 
 cn1plot(0)          = gsn_csm_contour(wks, fld ,res1) 
 vcplot(0)           = gsn_csm_vector(wks, diff_g60_3_avg_u(:,:), diff_g60_3_avg_v(:,:), vcres) 
 overlay(plot(0),vcplot(0))
 overlay(plot(0), cn1plot(0))

 res@gsnCenterString = "R3km.small - ERA5"
 res@gsnLeftString   = "(b)"
 ;res@gsnRightString  = "0907_16:00"
 plot(1)             = gsn_csm_contour_map(wks,diff_r3small_avg_h(:,:),res) 
cn1plot(1)     = gsn_csm_contour(wks, fld,res1) 
vcplot(1)      = gsn_csm_vector(wks, diff_r3small_avg_u(:,:),diff_r3small_avg_v(:,:),vcres)
overlay(plot(1), cn1plot(1))
overlay(plot(1),vcplot(1))

res@gsnCenterString = "R15-3km.large - ERA5"
res@gsnLeftString   = "(c)"
 plot(2)             = gsn_csm_contour_map(wks,diff_r3vari_avg_h(:,:),res) 
  cn1plot(2)           = gsn_csm_contour(wks, fld ,res1) 
  vcplot(2)           = gsn_csm_vector(wks, diff_r3vari_avg_u(:,:), diff_r3vari_avg_v(:,:), vcres) 
  overlay(plot(2),vcplot(2))
overlay(plot(2), cn1plot(2))

res@gsnCenterString = "R3km.large - ERA5"
res@gsnLeftString   = "(d)"
 plot(3)             = gsn_csm_contour_map(wks,diff_r3big_avg_h(:,:),res) 
  cn1plot(3)           = gsn_csm_contour(wks, fld ,res1) 
  vcplot(3)           = gsn_csm_vector(wks, diff_r3big_avg_u(:,:), diff_r3big_avg_v(:,:), vcres) 
  overlay(plot(3),vcplot(3))
overlay(plot(3), cn1plot(3))

delete(ERA5_u)
delete(ERA5_v)
delete(ERA5_h)
delete(ERA5_avg_u)
delete(ERA5_avg_v)
delete(ERA5_avg_h)
delete(lat)
delete(lon)
delete(g60_3_u)
delete(g60_3_v)
delete(g60_3_h)
delete(g60_3_avg_u)
delete(g60_3_avg_h)
delete(g60_3_avg_v)

delete(r3small_u)
delete(r3small_v)
delete(r3small_h)
delete(r3small_avg_u)
delete(r3small_avg_h)
delete(r3small_avg_v)

delete(r3vari_u)
delete(r3vari_v)
delete(r3vari_h)
delete(r3vari_avg_u)
delete(r3vari_avg_h)
delete(r3vari_avg_v)

delete(r3big_u)
delete(r3big_v)
delete(r3big_h)
delete(r3big_avg_u)
delete(r3big_avg_h)
delete(r3big_avg_v)

zoomin = 1
level  = 850
Minlon    = 100-3-20-5
Maxlon    = 150-3+20
Minlat    = 15-20-5
Maxlat    = 45+20
;era5
;;time 0907_12:00 - 0908_03:00 UTC
Mintime = 24+24+12
Maxtime = 24+24+27
f1  = addfile ("/data/ess-liuzj/0907case/era5/wind_850_500.nc", "r") 
ERA5_u = short2flt(f1->u(Mintime:Maxtime,{level},{Minlat:Maxlat},{Minlon:Maxlon}))
ERA5_v = short2flt(f1->v(Mintime:Maxtime,{level},{Minlat:Maxlat},{Minlon:Maxlon}))
ERA5_lat = f1->latitude({Minlat:Maxlat})
ERA5_lon = f1->longitude({Minlon:Maxlon})
ERA5_h = short2flt(f1->z(Mintime:Maxtime,{level},{Minlat:Maxlat},{Minlon:Maxlon}))
ERA5_h = ERA5_h/9.8/10.0
ERA5_avg_u = dim_avg_n_Wrap(ERA5_u,0)
ERA5_avg_v = dim_avg_n_Wrap(ERA5_v,0)
ERA5_avg_h = dim_avg_n_Wrap(ERA5_h,0)
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
u = new((/24*2,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
v = new((/24*2,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
h = new((/24*2,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
if level.eq.850 then
u(0+24*0:23+24*0,:,:) = f1->U850(:,{Minlat:Maxlat},{Minlon:Maxlon})
u(0+24*1:23+24*1,:,:) = f2->U850(:,{Minlat:Maxlat},{Minlon:Maxlon})
v(0+24*0:23+24*0,:,:) = f1->V850(:,{Minlat:Maxlat},{Minlon:Maxlon})
v(0+24*1:23+24*1,:,:) = f2->V850(:,{Minlat:Maxlat},{Minlon:Maxlon})
h(0+24*0:23+24*0,:,:) = f1->H850(:,{Minlat:Maxlat},{Minlon:Maxlon})
h(0+24*1:23+24*1,:,:) = f2->H850(:,{Minlat:Maxlat},{Minlon:Maxlon})
end if 
if level.eq.500 then
u(0+24*0:23+24*0,:,:) = f1->U500(:,{Minlat:Maxlat},{Minlon:Maxlon})
u(0+24*1:23+24*1,:,:) = f2->U500(:,{Minlat:Maxlat},{Minlon:Maxlon})
v(0+24*0:23+24*0,:,:) = f1->V500(:,{Minlat:Maxlat},{Minlon:Maxlon})
v(0+24*1:23+24*1,:,:) = f2->V500(:,{Minlat:Maxlat},{Minlon:Maxlon})
h(0+24*0:23+24*0,:,:) = f1->H500(:,{Minlat:Maxlat},{Minlon:Maxlon})
h(0+24*1:23+24*1,:,:) = f2->H500(:,{Minlat:Maxlat},{Minlon:Maxlon})
end if 
if level.eq.925 then
u(0+24*0:23+24*0,:,:) = f1->U925(:,{Minlat:Maxlat},{Minlon:Maxlon})
u(0+24*1:23+24*1,:,:) = f2->U925(:,{Minlat:Maxlat},{Minlon:Maxlon})
v(0+24*0:23+24*0,:,:) = f1->V925(:,{Minlat:Maxlat},{Minlon:Maxlon})
v(0+24*1:23+24*1,:,:) = f2->V925(:,{Minlat:Maxlat},{Minlon:Maxlon})
h(0+24*0:23+24*0,:,:) = f1->H925(:,{Minlat:Maxlat},{Minlon:Maxlon})
h(0+24*1:23+24*1,:,:) = f2->H925(:,{Minlat:Maxlat},{Minlon:Maxlon})
end if 
h = h/10.0
u!0    = "time"
u!1    = "lat"
u&lat  = lat
u!2    = "lon"
u&lon  = lon
copy_VarMeta(u,v)
copy_VarMeta(u,h)
MERRA2_u = u(Mintime:Maxtime,:,:)
MERRA2_v = v(Mintime:Maxtime,:,:)
MERRA2_h = h(Mintime:Maxtime,:,:)
MERRA2_avg_u = dim_avg_n_Wrap(MERRA2_u,0)
MERRA2_avg_v = dim_avg_n_Wrap(MERRA2_v,0)
MERRA2_avg_h = dim_avg_n_Wrap(MERRA2_h,0)
delete(lon)
delete(lat)
delete(u)
delete(v)
delete(h)
;;merra2

;60-3km
;;time 0907_12:00 - 0908_03:00 UTC
Mintime    = 9
Maxtime    = 24
f1   = addfile("/data/ess-liuzj/0907case/test/60-3km/data/main.nc", "r")
g60_3_lat  = f1->latitude({Minlat:Maxlat})
g60_3_lon  = f1->longitude({Minlon:Maxlon})
if level.eq.850 then
g60_3_u  = f1->uzonal_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
g60_3_v  = f1->umeridional_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
g60_3_h  = f1->height_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
end if
if level.eq.500 then
g60_3_u  = f1->uzonal_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
g60_3_v  = f1->umeridional_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
g60_3_h  = f1->height_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
end if
if level.eq.925 then
g60_3_u  = f1->uzonal_925hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
g60_3_v  = f1->umeridional_925hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
g60_3_h  = f1->height_925hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon})
end if
g60_3_h = g60_3_h/10.0
g60_3_avg_u = dim_avg_n_Wrap(g60_3_u,0)
g60_3_avg_v = dim_avg_n_Wrap(g60_3_v,0)
g60_3_avg_h = dim_avg_n_Wrap(g60_3_h,0)
;;60-3km


;regional SIM
;;time 0907_12:00 - 0908_03:00 UTC
Mintime    = 18
Maxtime    = 48
id = (/18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48/)
Time = Maxtime - Mintime
f1     = addfile ("/data/ess-liuzj/0907case/test/regional_GFS_3km_small/data/main.nc", "r")
f2     = addfile ("/data/ess-liuzj/0907case/test/regional_GFS_3km_vari/data/main.nc", "r")
f3     = addfile ("/data/ess-liuzj/0907case/test/regional_GFS_3km_big/data/main.nc", "r")
r3small_lat  = f1->latitude({Minlat:Maxlat})
r3small_lon  = f1->longitude({Minlon:Maxlon})
if level.eq.850 then
r3small_h = f1->height_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_h  = f2->height_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_h   = f3->height_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_u = f1->uzonal_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_u  = f2->uzonal_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_u   = f3->uzonal_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_v = f1->umeridional_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_v  = f2->umeridional_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_v   = f3->umeridional_850hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
end if
if level.eq.925 then
r3small_h = f1->height_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_h  = f2->height_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_h   = f3->height_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_u = f1->uzonal_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_u  = f2->uzonal_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_u   = f3->uzonal_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_v = f1->umeridional_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_v  = f2->umeridional_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_v   = f3->umeridional_925hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
end if
if level.eq.500 then
r3small_h = f1->height_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_h  = f2->height_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_h   = f3->height_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_u = f1->uzonal_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_u  = f2->uzonal_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_u   = f3->uzonal_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3small_v = f1->umeridional_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3vari_v  = f2->umeridional_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
r3big_v   = f3->umeridional_500hPa(id,{Minlat:Maxlat},{Minlon:Maxlon})
end if
r3small_h = r3small_h/10.0
r3vari_h = r3vari_h/10.0
r3big_h = r3big_h/10.0
r3small_avg_h = dim_avg_n_Wrap(r3small_h,0)
r3small_avg_v = dim_avg_n_Wrap(r3small_v,0)
r3small_avg_u = dim_avg_n_Wrap(r3small_u,0)
r3big_avg_h = dim_avg_n_Wrap(r3big_h,0)
r3big_avg_v = dim_avg_n_Wrap(r3big_v,0)
r3big_avg_u = dim_avg_n_Wrap(r3big_u,0)
r3vari_avg_h = dim_avg_n_Wrap(r3vari_h,0)
r3vari_avg_v = dim_avg_n_Wrap(r3vari_v,0)
r3vari_avg_u = dim_avg_n_Wrap(r3vari_u,0)
delete(f1)
delete(f2)
delete(f3)
ERA5_avg_h_cha  = linint2_Wrap(ERA5_lon,ERA5_lat,ERA5_avg_h,False,r3small_lon,r3small_lat,0)
delete(ERA5_avg_h)
ERA5_avg_h = ERA5_avg_h_cha
;g60_3_avg_h_cha = g60_3_avg_h
g60_3_avg_h_cha  = linint2_Wrap(g60_3_lon,g60_3_lat,g60_3_avg_h,False,r3small_lon,r3small_lat,0)
delete(g60_3_avg_h)
g60_3_avg_h = g60_3_avg_h_cha
diff_g60_3_avg_h = g60_3_avg_h - ERA5_avg_h
diff_r3small_avg_h = r3small_avg_h - ERA5_avg_h
diff_r3vari_avg_h  = r3vari_avg_h - ERA5_avg_h
diff_r3big_avg_h  = r3big_avg_h - ERA5_avg_h
copy_VarMeta(g60_3_avg_h,diff_g60_3_avg_h)
copy_VarMeta(g60_3_avg_h,diff_r3small_avg_h)
copy_VarMeta(g60_3_avg_h,diff_r3vari_avg_h)
copy_VarMeta(g60_3_avg_h,diff_r3big_avg_h)
diff_g60_3_avg_h   = mask(diff_g60_3_avg_h, ter.gt.1000, False)
diff_r3small_avg_h   = mask(diff_r3small_avg_h, ter.gt.1000, False)
diff_r3vari_avg_h   = mask(diff_r3vari_avg_h, ter.gt.1000, False)
diff_r3big_avg_h   = mask(diff_r3big_avg_h, ter.gt.1000, False)

ERA5_avg_u_cha  = linint2_Wrap(ERA5_lon,ERA5_lat,ERA5_avg_u,False,r3small_lon,r3small_lat,0)
delete(ERA5_avg_u)
ERA5_avg_u = ERA5_avg_u_cha
;g60_3_avg_u_cha = g60_3_avg_u
g60_3_avg_u_cha  = linint2_Wrap(g60_3_lon,g60_3_lat,g60_3_avg_u,False,r3small_lon,r3small_lat,0)
delete(g60_3_avg_u)
g60_3_avg_u = g60_3_avg_u_cha
diff_g60_3_avg_u = g60_3_avg_u - ERA5_avg_u
diff_r3small_avg_u = r3small_avg_u - ERA5_avg_u
diff_r3vari_avg_u  = r3vari_avg_u - ERA5_avg_u
diff_r3big_avg_u  = r3big_avg_u - ERA5_avg_u
copy_VarMeta(g60_3_avg_u,diff_g60_3_avg_u)
copy_VarMeta(g60_3_avg_u,diff_r3small_avg_u)
copy_VarMeta(g60_3_avg_u,diff_r3vari_avg_u)
copy_VarMeta(g60_3_avg_u,diff_r3big_avg_u)
diff_g60_3_avg_u   = mask(diff_g60_3_avg_u, ter.gt.1000, False)
diff_r3small_avg_u   = mask(diff_r3small_avg_u, ter.gt.1000, False)
diff_r3vari_avg_u   = mask(diff_r3vari_avg_u, ter.gt.1000, False)
diff_r3big_avg_u   = mask(diff_r3big_avg_u, ter.gt.1000, False)

ERA5_avg_v_cha  = linint2_Wrap(ERA5_lon,ERA5_lat,ERA5_avg_v,False,r3small_lon,r3small_lat,0)
delete(ERA5_avg_v)
ERA5_avg_v = ERA5_avg_v_cha
;g60_3_avg_v_cha = g60_3_avg_v
g60_3_avg_v_cha  = linint2_Wrap(g60_3_lon,g60_3_lat,g60_3_avg_v,False,r3small_lon,r3small_lat,0)
delete(g60_3_avg_v)
g60_3_avg_v = g60_3_avg_v_cha
diff_g60_3_avg_v = g60_3_avg_v - ERA5_avg_v
diff_r3small_avg_v = r3small_avg_v - ERA5_avg_v
diff_r3vari_avg_v  = r3vari_avg_v - ERA5_avg_v
diff_r3big_avg_v  = r3big_avg_v - ERA5_avg_v
copy_VarMeta(g60_3_avg_v,diff_g60_3_avg_v)
copy_VarMeta(g60_3_avg_v,diff_r3small_avg_v)
copy_VarMeta(g60_3_avg_v,diff_r3vari_avg_v)
copy_VarMeta(g60_3_avg_v,diff_r3big_avg_v)
diff_g60_3_avg_v   = mask(diff_g60_3_avg_v, ter.gt.1000, False)
diff_r3small_avg_v   = mask(diff_r3small_avg_v, ter.gt.1000, False)
diff_r3vari_avg_v   = mask(diff_r3vari_avg_v, ter.gt.1000, False)
diff_r3big_avg_v   = mask(diff_r3big_avg_v, ter.gt.1000, False)


res@gsnCenterString = "G60-3km - ERA5"
res@gsnLeftString   = "(e)"
 res@gsnRightString  = ""
 plot(4)             = gsn_csm_contour_map(wks,diff_g60_3_avg_h(:,:),res) 
 cn1plot(4)          = gsn_csm_contour(wks, fld ,res1) 
 vcplot(4)           = gsn_csm_vector(wks, diff_g60_3_avg_u(:,:), diff_g60_3_avg_v(:,:), vcres) 
 overlay(plot(4),vcplot(4))
 overlay(plot(4), cn1plot(4))

 res@gsnCenterString = "R3km.small - ERA5"
 res@gsnLeftString   = "(f)"
 ;res@gsnRightString  = "0907_16:00"
 plot(5)             = gsn_csm_contour_map(wks,diff_r3small_avg_h(:,:),res) 
cn1plot(5)     = gsn_csm_contour(wks, fld,res1) 
vcplot(5)      = gsn_csm_vector(wks, diff_r3small_avg_u(:,:),diff_r3small_avg_v(:,:),vcres)
overlay(plot(5), cn1plot(5))
overlay(plot(5),vcplot(5))

res@gsnCenterString = "R15-3km.large - ERA5"
res@gsnLeftString   = "(g)"
 plot(6)             = gsn_csm_contour_map(wks,diff_r3vari_avg_h(:,:),res) 
  cn1plot(6)           = gsn_csm_contour(wks, fld ,res1) 
  vcplot(6)           = gsn_csm_vector(wks, diff_r3vari_avg_u(:,:), diff_r3vari_avg_v(:,:), vcres) 
  overlay(plot(6),vcplot(6))
overlay(plot(6), cn1plot(6))

res@gsnCenterString = "R3km.large - ERA5"
res@gsnLeftString   = "(h)"
 plot(7)             = gsn_csm_contour_map(wks,diff_r3big_avg_h(:,:),res) 
  cn1plot(7)           = gsn_csm_contour(wks, fld ,res1) 
  vcplot(7)           = gsn_csm_vector(wks, diff_r3big_avg_u(:,:), diff_r3big_avg_v(:,:), vcres) 
  overlay(plot(7),vcplot(7))
overlay(plot(7), cn1plot(7))

resP                         = True                 ; modify the panel plot
resP@gsnFrame                = False                ; don't advance panel plot
resP@lgOrientation     = "Horizontal"
resP@gsnMaximize             = False                ; shifou zuidahua
resP@gsnPanelLabelBar        = True                 ; common colorbar kaiguan
resP@pmLabelBarWidthF = 0.8
resP@pmLabelBarHeightF = 0.06
resP@lbLabelFontHeightF      = 0.015                 ; common color bar ziti daxiao
resP@pmLabelBarOrthogonalPosF= -0.02                   ; common color bar shangxia yidong     fu xiang xia 
; resP@pmLabelBarWidthF      = 0.8                  ; common color bar zengjia kuandu
; resP@pmLabelBarHeightF     = 0.06                 ; common color bar zengjia gaodu
resP@lbBoxLinesOn            = True                 ; common color bar biankuangxian kaiguan 
resP@gsnPanelXWhiteSpacePercent  = 2.0                ; X fangxiang jianxi
resP@gsnPanelYWhiteSpacePercent  = 0.0               ; Y fangxiang jianxi
;resP@gsnPanelBottom          = 0.15 
resP@gsnLeftString            = ""
resP@gsnRightString           = ""

;resP@lbTitleString            = "Accumulated precipitation [mm]"
resP@lbTitlePosition          = "Bottom"
resP@lbTitleFontHeightF       = 0.015
resP@pmLabelBarWidthF      = 0.6                  ;  color bar zengjia kuandu
resP@pmLabelBarHeightF     = 0.043                 ;  color bar zengjia gaodu
resP@pmLabelBarOrthogonalPosF= -0.00                  ; common color bar shangxia yidong     jian xiang xia 



  resP@gsnPanelRowSpec      = True
  gsn_panel(wks, plot, (/4,4/), resP)
  ;draw(plot)
  frame(wks)

end