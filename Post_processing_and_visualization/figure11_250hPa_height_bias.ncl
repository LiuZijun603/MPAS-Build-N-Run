begin

;;;;;;; 20 00 ---- 22 00 avg ;;;;;;;
; Minlon    = 110
; Maxlon    = 118
; Minlat    = 32
; Maxlat    = 37

Minlon    = 110-4
Maxlon    = 118+4
Minlat    = 32-2.5
Maxlat    = 37+2.5

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ERA5  0.25;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Mintime   = 24+24
Maxtime   = 47+24
f         = addfile ("/data/ess-liuzj/era5/2021-07-19-23/19_21_data.nc", "r")      ; add file
ff         = addfile ("/data/ess-liuzj/era5/2021-07-19-23/19_21_data.nc", "r")      ; add file
lat       = f->latitude({Minlat:Maxlat})
lon       = f->longitude({Minlon:Maxlon})
time      = f->time
zz         = short2flt(f->z(Mintime:Maxtime,{250},{Minlat:Maxlat},{Minlon:Maxlon}))
ERA5_h2500 = zz/10.0/10.0

ERA5_u2500 = short2flt(ff->u(Mintime:Maxtime,{250},{Minlat:Maxlat},{Minlon:Maxlon}))
ERA5_v2500 = short2flt(ff->v(Mintime:Maxtime,{250},{Minlat:Maxlat},{Minlon:Maxlon}))

ERA5_h250  = dim_avg_n_Wrap(ERA5_h2500, 0)
ERA5_u250  = dim_avg_n_Wrap(ERA5_u2500, 0)
ERA5_v250  = dim_avg_n_Wrap(ERA5_v2500, 0)
ERA5_h250!0    = "lat"
ERA5_h250&lat  = lat
ERA5_h250!1    = "lon"
ERA5_h250&lon  = lon
copy_VarMeta(ERA5_h250, ERA5_u250)
copy_VarMeta(ERA5_h250, ERA5_v250)
delete(Mintime)
delete(Maxtime)
ERA5_lon = lon
ERA5_lat = lat
delete(lat)
delete(lon)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ERA5  0.25;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Mintime    = 8+8
Maxtime    = 15+8
 f1     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60km_uniform_global_mesoscale/data/diag.nc", "r")      ; add file
 f2     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-15km_global_mesoscale/data/diag.nc", "r")      ; add file
 f3     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-15km_global_convection/data/diag.nc", "r")      ; add file
 f4     = addfile ("/data/ess-liuzj/test/zhengzhou_721/15km_global_mesoscale/data/diag.nc", "r")      ; add file
 f5     = addfile ("/data/ess-liuzj/test/zhengzhou_721/15km_global_convection/data/diag.nc", "r")      ; add file
 f6     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-3km_global_convection/data/diag.nc", "r")      ; add file
 lat    = f1->latitude({Minlat:Maxlat})
 lon    = f1->longitude({Minlon:Maxlon})
 f_ter     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-3km_global_convection/data/terrain.nc", "r")      ; add file




 data       = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 u250data   = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 v250data   = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 data_mask   = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 v250data_mask   = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 u250data_mask   = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
ter = f_ter->ter({Minlat:Maxlat},{Minlon:Maxlon})

 data(0,:,:)  = dim_avg_n_Wrap(f1->height_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)   /10.0
 data(1,:,:)  = dim_avg_n_Wrap(f2->height_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)   /10.0
 data(2,:,:)  = dim_avg_n_Wrap(f3->height_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)   /10.0
 data(3,:,:)  = dim_avg_n_Wrap(f4->height_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)   /10.0
 data(4,:,:)  = dim_avg_n_Wrap(f5->height_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)   /10.0
 data(5,:,:)  = dim_avg_n_Wrap(f6->height_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)   /10.0

 u250data(0,:,:) = dim_avg_n_Wrap(f1->uzonal_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u250data(1,:,:) = dim_avg_n_Wrap(f2->uzonal_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u250data(2,:,:) = dim_avg_n_Wrap(f3->uzonal_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u250data(3,:,:) = dim_avg_n_Wrap(f4->uzonal_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u250data(4,:,:) = dim_avg_n_Wrap(f5->uzonal_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u250data(5,:,:) = dim_avg_n_Wrap(f6->uzonal_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 
 v250data(0,:,:) = dim_avg_n_Wrap(f1->umeridional_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v250data(1,:,:) = dim_avg_n_Wrap(f2->umeridional_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v250data(2,:,:) = dim_avg_n_Wrap(f3->umeridional_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v250data(3,:,:) = dim_avg_n_Wrap(f4->umeridional_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v250data(4,:,:) = dim_avg_n_Wrap(f5->umeridional_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v250data(5,:,:) = dim_avg_n_Wrap(f6->umeridional_250hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)

 u250data!1       = "lat"
 u250data&lat     = lat
 u250data!2       = "lon"
 u250data&lon     = lon
 copy_VarMeta(u250data, v250data)
 copy_VarMeta(u250data, data)
; data = data*(-1.)
; u250data = u250data*(-1.)
; v250data = v250data*(-1.)
 wks   = gsn_open_wks ("eps", "./eps/2_24hr_250hPa_height_bias" )  ; send graphics to PNG file
 plot  = new(6,graphic)
 vcplot  = new(6,graphic)

cmap = read_colormap_file("BlueWhiteOrangeRed")
res                         = True                             ; Plot mods desired.
res@gsnMaximize             = False                            ; Maximize plot
res@cnFillOn                = True                             ; tainse
res@cnLinesOn               = False                            ; dengzhixian
res@lbLabelBarOn            = False                            ; xiaotu de bar
res@cnLineLabelsOn          = False                            ; line de biaoqian
res@cnLineLabelFontHeightF  = 0.015                            ; line de biaoqian ziti daxiao

res@cnFillMode              = "RasterFill"                     ; turn raster on      
colors                      = (/"BlueWhiteOrangeRed"/)    ; none
res@cnFillPalette           = colors                           ; none
res@cnMinLevelValF          = 0.1                              ; zuixiaozhi
res@cnLineLabelsOn          = False                            ; dengzhixian shuoming
res@trGridType              = "TriangularMesh"                 ; none
res@cnLevelSelectionMode    = "ManualLevels"                   ; dengzhixian fanwei
res@cnMinLevelValF          = -26                              ; min
res@cnMaxLevelValF          = 26                            ; max
res@cnLevelSpacingF         = 2.0                              ; jianju

res@mpFillOn                = False                            ; ditu tianse

res@gsnAddCyclic            = False                            ; quanqiu dakai, fouze guanbi
res@gsnLeftString           = ""                               ; zuo biaoti
res@gsnRightString          = ""                               ; you biaoti
;res@gsnStringFont          = 22                               ; gsn biaoti ziti
res@gsnCenterStringFontHeightF    = 0.025                       ; center biaoti zi daxiao
res@gsnCenterStringOrthogonalPosF = 0.02                     ; center biaoti shangxia yidong  "fu xiang xia"
res@gsnRightStringFontHeightF     = 0.025                       ; right biaoti zi daxiao
res@gsnRightStringOrthogonalPosF  = 0.02                     ; right biaoti shangxia yidong
res@gsnLeftStringFontHeightF      = 0.025                       ; Left biaoti zi daxiao
res@gsnLeftStringOrthogonalPosF   = 0.02                     ; Left biaoti shangxia yidong

res@mpProjection            = "CylindricalEquidistant"         ; none
res@mpMinLatF               = Minlat                               ; min lat
res@mpMaxLatF               = Maxlat                               ; max lat
res@mpMinLonF               = Minlon                              ; min lon
res@mpMaxLonF               = Maxlon                              ; max lat
res@mpCenterLonF            = (Minlon + Maxlon)/2.                           ; center lon
res@mpGridLonSpacingF       = 2                                ; lon jiange
res@mpGridLatSpacingF       = 2                                ; lat jiange


res@pmTickMarkDisplayMode   = "Always"                         ; XYzhou jia du 
res@tmXBMajorLengthF        = -0.01                            ; XYzhou zhixianglimian
res@tmXBLabelFontThicknessF = 0.4                              ; X zhou ziti lonlat cuxi
res@tmYLLabelFontThicknessF = 0.4                              ; Y zhou ziti lonlat cuxi
res@tmXBLabelFontHeightF    = 0.02                             ; X zhou ziti daxiao
res@tmYLLabelFontHeightF    = 0.02                             ; Y zhou ziti daxiao
res@tmXBLabelDeltaF         = -0.5                             ; X zhou ziti xiang X zhou kaojin
res@tmYLLabelDeltaF         = -0.5                             ; Y zhou ziti xiang Y zhou kaojin

; res@lbLabelFontHeightF      = 0.01                             ; color bar ziti daxiao
; res@pmLabelBarOrthogonalPosF= 0.15                             ; color bar shangxia yidong 
; res@pmLabelBarWidthF        = 0.8                              ; color bar zengjia kuandu
; res@pmLabelBarHeightF       = 0.06                             ; color bar zengjia gaodu
; res@lbBoxLinesOn            = True                             ; color bar biankuangxian kaiguan 
; res@lbBoxLineThicknessF     = 0.2                              ; color bar biankuangxian cuxi 
;res@lbOrientation          = "Horizontal"                     ; color bar shuipin or chuizhi "vertical"
;res@lbOrientation          = "vertical"                       ; color bar shuipin or chuizhi "vertical"

;res@tiMainString            = ""         

res@vpHeightF               = 0.45
res@vpWidthF                = 0.5

;res@tmYLMode                = "Explicit"
;res@tmYLValues              =(/28,32,36,40/)
;res@tmYLLabels              =(/"28~S~o~N~N","32~S~o~N~N","36~S~o~N~N","40~S~o~N~N"/)
; res@tmXBMode                ="Explicit"
; res@tmXBValues              =(/112,114,116,118/)
; res@tmXBLabels              =(/"112~W~o~E~E","114~W~o~E~E","116~W~o~E~E","118~W~o~E~E"/)

res@mpGeophysicalLineColor  = "Black"
res@mpNationalLineColor     = "Black"
res@mpUSStateLineColor      = "Black"
res@mpGridLineColor         = "Black"
res@mpLimbLineColor         = "Black"
res@mpPerimLineColor        = "Black"
res@mpOutlineBoundarySets   = "AllBoundaries"
res@mpDataSetName           = "Earth..4"      ; Gives us provincial boundaries
;res@mpOutlineSpecifiers=(/"China","Henan"/)
res@mpProvincialLineThicknessF  = 1.0 
res@mpGeophysicalLineThicknessF = 1.0
res@mpCountyLineThicknessF      = 1.0
res@mpProvincialLineColor       = "black"  
res@mpCountyLineColor           = "black" 
;res@mpLandFillColor            = "white"


vcres                          =True
vcres@lbLabelStride            = 2 
vcres@vcGlyphStyle             ="LineArrow"     ;; "PostDraw"
vcres@vcLineArrowThicknessF    = 1.1            ;;;;;;;jian tou uc xi 
vcres@vcMonoLineArrowColor     = True
vcres@vcLineArrowColor         = "black"
vcres@gsnLeftString            = ""
vcres@gsnRightString           = ""
; vcres@gsnCenterStringFontHeightF = 0.001                       ; center biaoti zi daxiao
; vcres@gsnRightStringFontHeightF  = 0.001                       ; right  biaoti zi daxiao
vcres@vcMinMagnitudeF          = 0.5
vcres@vcRefMagnitudeF          = 12.0
vcres@vcRefLengthF             = 0.05
vcres@vcMinDistanceF           = 0.03
vcres@vcRefAnnoOn              = True
vcres@vcMinAnnoFontColor         = "green"
vcres@vcRefAnnoOrthogonalPosF  = -1.
vcres@vcRefAnnoFontHeightF     = 0.01
vcres@vcRefAnnoString1On       = True   ;cankaojiantou shang zi
vcres@vcRefAnnoString2On       = True   ;cankaojiantou xia zi
vcres@gsnAddCyclic             = False
vcres@vcRefAnnoFontHeightF     = 0.02
vcres@vcRefAnnoString1         = "12 m/s"
vcres@vcRefAnnoString2On       = False
;vcres@vcRefAnnoParallelPosF   = 0.1     ;;;;;;;left and right vector
vcres@vcRefAnnoOrthogonalPosF  = -1.086     ;;;;;;;up and down vector   fu xiangshang  -1.095
;vcres@tiMainString            = ""         



res@gsnCenterString = ""
res@gsnRightString  = ""
res@gsnLeftString   = ""
;res@tiMainString    = ""
res@gsnDraw         = False
res@gsnFrame        = False
vcres@gsnDraw       = False
vcres@gsnFrame      = False




; res@gsnCenterString = "OBS"
; res@gsnLeftString   = "(a)"
; plot(0)             = gsn_csm_contour_map(wks,pre_ave1,res) 
; vcplot(0)           = gsn_csm_vector(wks, OBS_u250, OBS_v250, vcres) 
; overlay(plot(0), vcplot(0))
; print("ok final")

ERA5_h250_cha   = linint2_Wrap(ERA5_lon,ERA5_lat,ERA5_h250,False,lon,lat,0)
ERA5_u250_cha   = linint2_Wrap(ERA5_lon,ERA5_lat,ERA5_u250,False,lon,lat,0)
ERA5_v250_cha   = linint2_Wrap(ERA5_lon,ERA5_lat,ERA5_v250,False,lon,lat,0)
delete(ERA5_h250)
delete(ERA5_u250)
delete(ERA5_v250)
ERA5_h250 = ERA5_h250_cha
ERA5_u250 = ERA5_u250_cha
ERA5_v250 = ERA5_v250_cha


ERA5_h250_mask = mask(ERA5_h250, ter.gt.140000, False)
ERA5_u250_mask = mask(ERA5_u250, ter.gt.140000, False)
ERA5_v250_mask = mask(ERA5_v250, ter.gt.140000, False)
delete(ERA5_h250)
delete(ERA5_v250)
delete(ERA5_u250)
ERA5_h250 = ERA5_h250_mask
ERA5_u250 = ERA5_u250_mask
ERA5_v250 = ERA5_v250_mask

do i = 0,5
data_mask(i,:,:)     = mask(data(i,:,:), ter.gt.140000, False)
u250data_mask(i,:,:) = mask(u250data(i,:,:), ter.gt.140000, False)
v250data_mask(i,:,:) = mask(v250data(i,:,:), ter.gt.140000, False)
end do
delete(data)
delete(u250data)
delete(v250data)

data = data_mask
u250data = u250data_mask
v250data = v250data_mask

u250data!1       = "lat"
 u250data&lat     = lat
 u250data!2       = "lon"
 u250data&lon     = lon
 copy_VarMeta(u250data, v250data)
 copy_VarMeta(u250data, data)

 ERA5_h250!0       = "lat"
 ERA5_h250&lat     = lat
 ERA5_h250!1       = "lon"
 ERA5_h250&lon     = lon
 copy_VarMeta(ERA5_h250, ERA5_u250)
 copy_VarMeta(ERA5_h250, ERA5_v250)

data_bias = data
u250data_bias = u250data
v250data_bias = v250data


; do i = 0, 5
;     data_bias(i,:,:)     =  ERA5_h250 - data(i,:,:)
;     u250data_bias(i,:,:) =  ERA5_u250 - u250data(i,:,:)
;     v250data_bias(i,:,:) =  ERA5_v250 - v250data(i,:,:) 
; end do

do i = 0, 5
    data_bias(i,:,:)     =   data(i,:,:) -ERA5_h250 
    u250data_bias(i,:,:) =   u250data(i,:,:) - ERA5_u250
    v250data_bias(i,:,:) =   v250data(i,:,:) - ERA5_v250 
end do

; data_bias = data_bias * (-1.0)
; u250data_bias = u250data_bias * (-1.0)
; v250data_bias = v250data_bias * (-1.0)

res@gsnCenterString = "QU60km.MS - ERA5"
res@gsnLeftString   = "(a)"
plot(0)             = gsn_csm_contour_map(wks,data_bias(0,:,:),res) 
vcplot(0)           = gsn_csm_vector(wks, u250data_bias(0,:,:), v250data_bias(0,:,:), vcres) 
overlay(plot(0), vcplot(0))
res@gsnCenterString = "QU15km.MS - ERA5"
res@gsnLeftString   = "(b)"
plot(1)             = gsn_csm_contour_map(wks,data_bias(3,:,:),res) 
vcplot(1)           = gsn_csm_vector(wks, u250data_bias(3,:,:), v250data_bias(3,:,:), vcres) 
overlay(plot(1), vcplot(1))
res@gsnCenterString = "QU15km.CP - ERA5"
res@gsnLeftString   = "(c)"
plot(2)             = gsn_csm_contour_map(wks,data_bias(4,:,:),res) 
vcplot(2)           = gsn_csm_vector(wks, u250data_bias(4,:,:), v250data_bias(4,:,:), vcres) 
overlay(plot(2), vcplot(2))
res@gsnCenterString = "V15km.MS - ERA5"
res@gsnLeftString   = "(d)"
plot(3)             = gsn_csm_contour_map(wks,data_bias(1,:,:),res) 
vcplot(3)           = gsn_csm_vector(wks, u250data_bias(1,:,:), v250data_bias(1,:,:), vcres) 
overlay(plot(3), vcplot(3))
res@gsnCenterString = "V15km.CP - ERA5"
res@gsnLeftString   = "(e)"
plot(4)             = gsn_csm_contour_map(wks,data_bias(2,:,:),res) 
vcplot(4)           = gsn_csm_vector(wks, u250data_bias(2,:,:), v250data_bias(2,:,:), vcres) 
overlay(plot(4), vcplot(4))
res@gsnCenterString = "V3km.CP - ERA5"
res@gsnLeftString   = "(f)"
plot(5)             = gsn_csm_contour_map(wks,data_bias(5,:,:),res) 
vcplot(5)           = gsn_csm_vector(wks, u250data_bias(5,:,:), v250data_bias(5,:,:), vcres) 
overlay(plot(5), vcplot(5))



maxlat_region = 38-1
minlat_region = 32
maxlon_region = 117
minlon_region = 110
boxlat  = (/ maxlat_region,maxlat_region,minlat_region,minlat_region,maxlat_region /)
boxlon  = (/ minlon_region,maxlon_region,maxlon_region,minlon_region,minlon_region /)
gonres                  = True
gonres@gsLineColor       = "red"
gonres@gsLineThicknessF       = 4.
dum3 = gsn_add_polyline(wks, plot(0), boxlon, boxlat, gonres)
dum4 = gsn_add_polyline(wks, plot(1), boxlon, boxlat, gonres)
dum5 = gsn_add_polyline(wks, plot(2), boxlon, boxlat, gonres)
dum6 = gsn_add_polyline(wks, plot(3), boxlon, boxlat, gonres)
dum7 = gsn_add_polyline(wks, plot(4), boxlon, boxlat, gonres)
dum8 = gsn_add_polyline(wks, plot(5), boxlon, boxlat, gonres)


resP                         = True                 ; modify the panel plot
resP@gsnFrame                = False                ; don't advance panel plot
resP@gsnMaximize             = False                ; shifou zuidahua
resP@gsnPanelLabelBar        = True                 ; common colorbar kaiguan
resP@lbLabelFontHeightF      = 0.015                 ; common color bar ziti daxiao
resP@pmLabelBarOrthogonalPosF= -0.02                   ; common color bar shangxia yidong     fu xiang xia 
; resP@pmLabelBarWidthF      = 0.8                  ; common color bar zengjia kuandu
; resP@pmLabelBarHeightF     = 0.06                 ; common color bar zengjia gaodu
resP@lbBoxLinesOn            = True                 ; common color bar biankuangxian kaiguan 
resP@gsnPanelXWhiteSpacePercent  = 1.3                ; X fangxiang jianxi
resP@gsnPanelYWhiteSpacePercent  = 1.5               ; Y fangxiang jianxi
;resP@gsnPanelBottom          = 0.15 
;resP@txString                 = " ~F25~ Difference between simulations and ERA5"
resP@lbTitleString            = "Height and wind bias at 250 mb [dagpm]"
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

end