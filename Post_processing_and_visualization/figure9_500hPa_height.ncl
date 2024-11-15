begin

;;;;;;; 20 00 ---- 22 00 avg ;;;;;;;
; Minlon    = 110
; Maxlon    = 118
; Minlat    = 32
; Maxlat    = 37

Minlon    = 80
Maxlon    = 145
Minlat    = 10
Maxlat    = 55

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ERA5  0.25;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Mintime   = 24+24
Maxtime   = 47+24
f         = addfile ("/data/ess-liuzj/era5/2021-07-19-23/19_21_data.nc", "r")      ; add file
ff         = addfile ("/data/ess-liuzj/era5/2021-07-19-23/19_21_data.nc", "r")      ; add file
lat       = f->latitude({Minlat:Maxlat})
lon       = f->longitude({Minlon:Maxlon})
time      = f->time
zz         = short2flt(f->z(Mintime:Maxtime,{500},{Minlat:Maxlat},{Minlon:Maxlon}))
ERA5_h5000 = zz/9.8/10.0

ERA5_u5000 = short2flt(ff->u(Mintime:Maxtime,{500},{Minlat:Maxlat},{Minlon:Maxlon}))
ERA5_v5000 = short2flt(ff->v(Mintime:Maxtime,{500},{Minlat:Maxlat},{Minlon:Maxlon}))

ERA5_h500  = dim_avg_n_Wrap(ERA5_h5000, 0)
ERA5_u500  = dim_avg_n_Wrap(ERA5_u5000, 0)
ERA5_v500  = dim_avg_n_Wrap(ERA5_v5000, 0)
ERA5_h500!0    = "lat"
ERA5_h500&lat  = lat
ERA5_h500!1    = "lon"
ERA5_h500&lon  = lon
copy_VarMeta(ERA5_h500, ERA5_u500)
copy_VarMeta(ERA5_h500, ERA5_v500)
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

 data       = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 u500data   = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 v500data   = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 data_mask   = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 v500data_mask   = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 u500data_mask   = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")

 data(0,:,:)  = dim_avg_n_Wrap(f1->height_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)   /10.0
 data(1,:,:)  = dim_avg_n_Wrap(f2->height_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)   /10.0
 data(2,:,:)  = dim_avg_n_Wrap(f3->height_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)   /10.0
 data(3,:,:)  = dim_avg_n_Wrap(f4->height_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)   /10.0
 data(4,:,:)  = dim_avg_n_Wrap(f5->height_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)   /10.0
 data(5,:,:)  = dim_avg_n_Wrap(f6->height_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)   /10.0

 u500data(0,:,:) = dim_avg_n_Wrap(f1->uzonal_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u500data(1,:,:) = dim_avg_n_Wrap(f2->uzonal_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u500data(2,:,:) = dim_avg_n_Wrap(f3->uzonal_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u500data(3,:,:) = dim_avg_n_Wrap(f4->uzonal_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u500data(4,:,:) = dim_avg_n_Wrap(f5->uzonal_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u500data(5,:,:) = dim_avg_n_Wrap(f6->uzonal_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 
 v500data(0,:,:) = dim_avg_n_Wrap(f1->umeridional_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v500data(1,:,:) = dim_avg_n_Wrap(f2->umeridional_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v500data(2,:,:) = dim_avg_n_Wrap(f3->umeridional_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v500data(3,:,:) = dim_avg_n_Wrap(f4->umeridional_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v500data(4,:,:) = dim_avg_n_Wrap(f5->umeridional_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v500data(5,:,:) = dim_avg_n_Wrap(f6->umeridional_500hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)

 u500data!1       = "lat"
 u500data&lat     = lat
 u500data!2       = "lon"
 u500data&lon     = lon
 copy_VarMeta(u500data, v500data)
 copy_VarMeta(u500data, data)

 wks   = gsn_open_wks ("pdf", "2_24hr_500hPa_height" )  ; send graphics to PNG file
 plot  = new(9,graphic)
 vcplot  = new(9,graphic)

cmap = read_colormap_file("WhiteBlueGreenYellowRed")
res                         = True                             ; Plot mods desired.
res@gsnMaximize             = False                            ; Maximize plot
res@cnFillOn                = True                             ; tainse
res@cnLinesOn               = False                            ; dengzhixian
res@lbLabelBarOn            = False                            ; xiaotu de bar
res@cnLineLabelsOn          = False                            ; line de biaoqian
res@cnLineLabelFontHeightF  = 0.015                            ; line de biaoqian ziti daxiao

res@cnFillMode              = "RasterFill"                     ; turn raster on      
colors                      = (/"WhiteBlueGreenYellowRed"/)    ; none
res@cnFillPalette           = colors                           ; none
res@cnMinLevelValF          = 0.1                              ; zuixiaozhi
res@cnLineLabelsOn          = False                            ; dengzhixian shuoming
res@trGridType              = "TriangularMesh"                 ; none
res@cnLevelSelectionMode    = "ManualLevels"                   ; dengzhixian fanwei
res@cnMinLevelValF          = 570                              ; min
res@cnMaxLevelValF          = 595                            ; max
res@cnLevelSpacingF         = 2.                              ; jianju

res@mpFillOn                = False                            ; ditu tianse

res@gsnAddCyclic            = False                            ; quanqiu dakai, fouze guanbi
res@gsnLeftString           = ""                               ; zuo biaoti
res@gsnRightString          = ""                               ; you biaoti
;res@gsnStringFont          = 22                               ; gsn biaoti ziti
res@gsnCenterStringFontHeightF    = 0.025                       ; center biaoti zi daxiao
res@gsnCenterStringOrthogonalPosF = 0.02                    ; center biaoti shangxia yidong  "fu xiang xia"
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

res@tiMainString            = ""         
res@tiMainFontHeightF       = 0.0001         
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


res@gsnCenterString = ""
res@gsnRightString  = ""
res@gsnLeftString   = ""
res@tiMainString    = ""
res@gsnDraw         = False
res@gsnFrame        = False
vcres@gsnDraw       = False
vcres@gsnFrame      = False




; res@gsnCenterString = "OBS"
; res@gsnLeftString   = "(a)"
; plot(0)             = gsn_csm_contour_map(wks,pre_ave1,res) 
; vcplot(0)           = gsn_csm_vector(wks, OBS_u500, OBS_v500, vcres) 
; overlay(plot(0), vcplot(0))
; print("ok final")

ERA5_h500_cha   = linint2_Wrap(ERA5_lon,ERA5_lat,ERA5_h500,False,lon,lat,0)
ERA5_u500_cha   = linint2_Wrap(ERA5_lon,ERA5_lat,ERA5_u500,False,lon,lat,0)
ERA5_v500_cha   = linint2_Wrap(ERA5_lon,ERA5_lat,ERA5_v500,False,lon,lat,0)
delete(ERA5_h500)
delete(ERA5_u500)
delete(ERA5_v500)
ERA5_h500 = ERA5_h500_cha
ERA5_u500 = ERA5_u500_cha
ERA5_v500 = ERA5_v500_cha


ERA5_h500_mask = mask(ERA5_h500, data(5,:,:).gt.620, False)
ERA5_u500_mask = mask(ERA5_u500, data(5,:,:).gt.620, False)
ERA5_v500_mask = mask(ERA5_v500, data(5,:,:).gt.620, False)


do i = 0,5
data_mask(i,:,:) = mask(data(i,:,:), data(5,:,:).gt.620, False)
u500data_mask(i,:,:) = mask(u500data(i,:,:), data(5,:,:).gt.620, False)
v500data_mask(i,:,:) = mask(v500data(i,:,:), data(5,:,:).gt.620, False)
end do
delete(data)
delete(u500data)
delete(v500data)

data = data_mask
u500data = u500data_mask
v500data = v500data_mask

u500data!1       = "lat"
 u500data&lat     = lat
 u500data!2       = "lon"
 u500data&lon     = lon
 copy_VarMeta(u500data, v500data)
 copy_VarMeta(u500data, data)

 ERA5_h500!0       = "lat"
 ERA5_h500&lat     = lat
 ERA5_h500!1       = "lon"
 ERA5_h500&lon     = lon
 copy_VarMeta(ERA5_h500, ERA5_u500)
 copy_VarMeta(ERA5_h500, ERA5_v500)

data_bias = data
u500data_bias = u500data
v500data_bias = v500data


do i = 0, 5
    data_bias(i,:,:) = data(i,:,:) - ERA5_h500
    u500data_bias(i,:,:) = u500data(i,:,:) - ERA5_u500
    v500data_bias(i,:,:) = v500data(i,:,:) - ERA5_v500
end do





res@gsnCenterString = "ERA5"
res@gsnLeftString   = "(a)"
plot(1)             = gsn_csm_contour_map(wks,ERA5_h500,res) 
vcplot(1)           = gsn_csm_vector(wks, ERA5_u500, ERA5_v500, vcres) 
overlay(plot(1), vcplot(1))


res@gsnCenterString = "U60km.MS"
res@gsnLeftString   = "(b)"
plot(3)             = gsn_csm_contour_map(wks,data(0,:,:),res) 
vcplot(3)           = gsn_csm_vector(wks, u500data(0,:,:), v500data(0,:,:), vcres) 
overlay(plot(3), vcplot(3))


res@gsnCenterString = "V15km.MS"
res@gsnLeftString   = "(e)"
plot(6)             = gsn_csm_contour_map(wks,data(1,:,:),res) 
vcplot(6)           = gsn_csm_vector(wks, u500data(1,:,:), v500data(1,:,:), vcres) 
overlay(plot(6), vcplot(6))

res@gsnCenterString = "V15km.CP"
res@gsnLeftString   = "(f)"
plot(7)             = gsn_csm_contour_map(wks,data(2,:,:),res) 
vcplot(7)           = gsn_csm_vector(wks, u500data(2,:,:), v500data(2,:,:), vcres) 
overlay(plot(7), vcplot(7))

res@gsnCenterString = "U15km.MS"
res@gsnLeftString   = "(c)"
plot(4)             = gsn_csm_contour_map(wks,data(3,:,:),res) 
vcplot(4)           = gsn_csm_vector(wks, u500data(3,:,:), v500data(3,:,:), vcres) 
overlay(plot(4), vcplot(4))

res@gsnCenterString = "U15km.CP"
res@gsnLeftString   = "(d)"
plot(5)             = gsn_csm_contour_map(wks,data(4,:,:),res) 
vcplot(5)           = gsn_csm_vector(wks, u500data(4,:,:), v500data(4,:,:), vcres) 
overlay(plot(5), vcplot(5))

res@gsnCenterString = "V3km.CP"
res@gsnLeftString   = "(g)"
plot(8)             = gsn_csm_contour_map(wks,data(5,:,:),res) 
vcplot(8)           = gsn_csm_vector(wks, u500data(5,:,:), v500data(5,:,:), vcres) 
overlay(plot(8), vcplot(8))


maxlat_region = 38-1
minlat_region = 32-1
maxlon_region = 117
minlon_region = 110
boxlat  = (/ maxlat_region,maxlat_region,minlat_region,minlat_region,maxlat_region /)
boxlon  = (/ minlon_region,maxlon_region,maxlon_region,minlon_region,minlon_region /)
gonres                  = True
gonres@gsLineColor       = "red"
gonres@gsLineThicknessF       = 4.
dum1 = gsn_add_polyline(wks, plot(1), boxlon, boxlat, gonres)
dum3 = gsn_add_polyline(wks, plot(3), boxlon, boxlat, gonres)
dum4 = gsn_add_polyline(wks, plot(4), boxlon, boxlat, gonres)
dum5 = gsn_add_polyline(wks, plot(5), boxlon, boxlat, gonres)
dum6 = gsn_add_polyline(wks, plot(6), boxlon, boxlat, gonres)
dum7 = gsn_add_polyline(wks, plot(7), boxlon, boxlat, gonres)
dum8 = gsn_add_polyline(wks, plot(8), boxlon, boxlat, gonres)


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
resP@gsnLeftString            = ""
resP@gsnRightString           = ""
resP@gsnCenterString          = ""
resP@lbTitleString            = "Height at 500-mb [dagpm]"
resP@lbTitlePosition          = "Bottom"
resP@lbTitleFontHeightF       = 0.015
; resP@gsnPanelMainString     = ""               ; set main title
; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
;resP@gsnPanelFigureStrings  = (/"(a)","(b)","(c)","(d)","(e)","(f)","(h)","(i)","(j)"/)
;resP@gsnPanelFiguvcrestringsFontHeightF   = 0.01             ;;;;;"(a)","(b)","(c)"的大小
;resP@amJust                               = "TopLeft"           ;;;;;"(a)","(b)","(c)"的位置
  resP@gsnPanelRowSpec      = True
  gsn_panel(wks, plot, (/3,3,3/), resP)
  ;draw(plot)

end