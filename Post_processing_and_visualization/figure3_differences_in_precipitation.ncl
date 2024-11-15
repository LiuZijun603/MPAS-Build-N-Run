begin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;OBS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
regrid_on    = True
data1   = asciiread("/data/ess-liuzj/station_data/2021-07-21/MICAPS_20210721000000/SURFACE/rain24-p/21072108.000", -1 ,"double")
;data_u1 = asciiread("/data/ess-liuzj/station_data/2021-07-21/MICAPS_20210721000000/HIGH/uv/850", -1 ,"double")

pre1     = reshape(data1(17:), (/(dimsizes(data1)-17)/5,5/))
pre_ave1 = pre1(:,4)
;;;;;;;;data1
lon      = pre1(:,1)
lat      = pre1(:,2)
if (regrid_on) then
    ; minlat   = min(lat)
    ; minlon   = min(lon)
    ; maxlat   = max(lat)
    ; maxlon   = max(lon)
    minlat    = 32
    maxlat    = 37
    minlon    = 110
    maxlon    = 117
    Opt                     = True
    Opt@SrcGridLon          = lon
    Opt@SrcGridLat          = lat
    Opt@DstLLCorner         = (/floor(minlat)-0.1,floor(minlon)+0.1/)
    Opt@DstURCorner         = (/ceil(maxlat)-0.1,ceil(maxlon)+0.1/)
    Opt@DstGridType         = "0.1deg"
    Opt@ForceOverwrite      = True
    Opt@Debug               = True
    Opt@InterMethod         = "patch"
    pre_ave1                := ESMF_regrid(pre_ave1,Opt)
end if

; pre_ave1!0    = "lat"
; pre_ave1&lat  = lat
; pre_ave1!1    = "lon"
; pre_ave1&lon  = lon
delete(lon)
delete(lat)
delete(pre1)
delete(data1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;OBS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GFS  0.25;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Minlon    = 110
Maxlon    = 117
Minlat    = 32
Maxlat    = 37
Mintime   = 8
Maxtime   = 16

diri_gfs  = "/data/ess-liuzj/gfs/2021-07-19_22/"
files_gfs = systemfunc("ls " + diri_gfs + "gfs.0p*" )
f_gfs     = addfiles(files_gfs, "r")
ListSetType (f_gfs, "cat")
lat = f_gfs[1]->lat_0({Minlat:Maxlat})
lon = f_gfs[1]->lon_0({Minlon:Maxlon})
pre1  = new((/dimsizes(files_gfs),dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
pre2  = new((/dimsizes(files_gfs),dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
;pre   = new((/dimsizes(files_gfs),dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
do i = 0,dimsizes(files_gfs)-1
pre1(i,:,:)= f_gfs[i]->CRAIN_P0_L1_GLL0({Minlat:Maxlat},{Minlon:Maxlon})
pre2(i,:,:)= f_gfs[i]->CFRZR_P0_L1_GLL0({Minlat:Maxlat},{Minlon:Maxlon})
end do
pre      = pre1(:,{Minlat:Maxlat},{Minlon:Maxlon}) + pre2(:,{Minlat:Maxlat},{Minlon:Maxlon})
pre_gfs  = dim_sum_n_Wrap(pre(Mintime:Maxtime,:,:),0)
pre_gfs!0    = "lat"
pre_gfs&lat  = lat
pre_gfs!1    = "lon"
pre_gfs&lon  = lon

print(pre_gfs(13,:))
delete(lat)
delete(lon)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GFS  0.25;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ERA5  0.25;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Mintime   = 24
Maxtime   = 47
f         = addfile ("/data/ess-liuzj/era5/2021-07-19-23/rain.nc", "r")      ; add file
ff        = addfile ("/data/ess-liuzj/era5/2021-07-19-23/20_22_wind.nc", "r")       ; add file
lat       = f->latitude({Minlat:Maxlat})
lon       = f->longitude({Minlon:Maxlon})
time      = f->time(120:239)
rainn     = short2flt(f->tp(120:239,{Minlat:Maxlat},{Minlon:Maxlon}))
rainn     = rainn*1000.
OBS_u8500 = short2flt(ff->u(:,{850},{Minlat:Maxlat},{Minlon:Maxlon}))
OBS_v8500 = short2flt(ff->v(:,{850},{Minlat:Maxlat},{Minlon:Maxlon}))
rain      = dim_sum_n_Wrap(rainn(Mintime:Maxtime,:,:),0)
OBS_u850  = dim_avg_n_Wrap(OBS_u8500(Mintime:Maxtime,:,:), 0)
OBS_v850  = dim_avg_n_Wrap(OBS_v8500(Mintime:Maxtime,:,:), 0)
rain!0    = "lat"
rain&lat  = lat
rain!1    = "lon"
rain&lon  = lon
copy_VarMeta(rain, OBS_u850)
copy_VarMeta(rain, OBS_v850)
delete(Mintime)
delete(Maxtime)
delete(lat)
delete(lon)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ERA5  0.25;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Mintime    = 48
Maxtime    = 95
 f1     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60km_uniform_global_mesoscale/data/main.nc", "r")      ; add file
 f2     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-15km_global_mesoscale/data/main.nc", "r")      ; add file
 f3     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-15km_global_convection/data/main.nc", "r")      ; add file
 f4     = addfile ("/data/ess-liuzj/test/zhengzhou_721/15km_global_mesoscale/data/main.nc", "r")      ; add file
 f5     = addfile ("/data/ess-liuzj/test/zhengzhou_721/15km_global_convection/data/main.nc", "r")      ; add file
 f6     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-3km_global_convection/data/main.nc", "r")      ; add file
 lat    = f1->latitude({Minlat:Maxlat})
 lon    = f1->longitude({Minlon:Maxlon})
pre_ave1!0    = "lat"
pre_ave1&lat  = lat
pre_ave1!1    = "lon"
pre_ave1&lon  = lon
 data   = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 u850data   = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 v850data   = new((/6,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 data1  = new((/6,193,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 rainc  = f1->rainc(:,{Minlat:Maxlat},{Minlon:Maxlon})
 rainnc = f1->rainnc(:,{Minlat:Maxlat},{Minlon:Maxlon})
 data1(0,:,:,:)  = rainc + rainnc
 delete(rainc)
 delete(rainnc)

 rainc  = f2->rainc(:,{Minlat:Maxlat},{Minlon:Maxlon})
 rainnc = f2->rainnc(:,{Minlat:Maxlat},{Minlon:Maxlon})
 data1(1,:,:,:)  = rainc + rainnc
 delete(rainc)
 delete(rainnc)

 rainc  = f3->rainc(:,{Minlat:Maxlat},{Minlon:Maxlon})
 rainnc = f3->rainnc(:,{Minlat:Maxlat},{Minlon:Maxlon})
 data1(2,:,:,:)  = rainc + rainnc
 delete(rainc)
 delete(rainnc)

 rainc  = f4->rainc(:,{Minlat:Maxlat},{Minlon:Maxlon})
 rainnc = f4->rainnc(:,{Minlat:Maxlat},{Minlon:Maxlon})
 data1(3,:,:,:)  = rainc + rainnc
 delete(rainc)
 delete(rainnc)

 rainc  = f5->rainc(:,{Minlat:Maxlat},{Minlon:Maxlon})
 rainnc = f5->rainnc(:,{Minlat:Maxlat},{Minlon:Maxlon})
 data1(4,:,:,:)  = rainc + rainnc
 delete(rainc)
 delete(rainnc)

 rainc  = f6->rainc(:,{Minlat:Maxlat},{Minlon:Maxlon})
 rainnc = f6->rainnc(:,{Minlat:Maxlat},{Minlon:Maxlon})
 data1(5,:,:,:)  = rainc + rainnc
 delete(rainc)
 delete(rainnc)

 data(:,:,:)  = (data1(:,Maxtime,:,:) - data1(:,Mintime,:,:))

 u850data(0,:,:) = dim_avg_n_Wrap(f1->uzonal_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u850data(1,:,:) = dim_avg_n_Wrap(f2->uzonal_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u850data(2,:,:) = dim_avg_n_Wrap(f3->uzonal_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u850data(3,:,:) = dim_avg_n_Wrap(f4->uzonal_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u850data(4,:,:) = dim_avg_n_Wrap(f5->uzonal_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 u850data(5,:,:) = dim_avg_n_Wrap(f6->uzonal_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 
 v850data(0,:,:) = dim_avg_n_Wrap(f1->umeridional_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v850data(1,:,:) = dim_avg_n_Wrap(f2->umeridional_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v850data(2,:,:) = dim_avg_n_Wrap(f3->umeridional_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v850data(3,:,:) = dim_avg_n_Wrap(f4->umeridional_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v850data(4,:,:) = dim_avg_n_Wrap(f5->umeridional_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)
 v850data(5,:,:) = dim_avg_n_Wrap(f6->umeridional_850hPa(Mintime:Maxtime,{Minlat:Maxlat},{Minlon:Maxlon}), 0)

 u850data!1       = "lat"
 u850data&lat     = lat
 u850data!2       = "lon"
 u850data&lon     = lon
 copy_VarMeta(u850data, v850data)
 copy_VarMeta(u850data, data)

 wks   = gsn_open_wks ("eps", "./eps/day1_pre_diff" )  ; send graphics to PNG file
 plot  = new(9,graphic)
 vcplot  = new(9,graphic)

cmap = read_colormap_file("MPL_BrBG")
res                         = True                             ; Plot mods desired.
res@gsnMaximize             = False                            ; Maximize plot
res@cnFillOn                = True                             ; tainse
res@cnLinesOn               = False                            ; dengzhixian
res@lbLabelBarOn            = False                            ; xiaotu de bar
res@cnLineLabelsOn          = False                            ; line de biaoqian
res@cnLineLabelFontHeightF  = 0.015                            ; line de biaoqian ziti daxiao

res@cnFillMode              = "RasterFill"                     ; turn raster on      
colors                      = (/"MPL_BrBG"/)    ; none
res@cnFillPalette           = colors                           ; none
res@cnMinLevelValF          = 0.1                              ; zuixiaozhi
res@cnLineLabelsOn          = False                            ; dengzhixian shuoming
res@trGridType              = "TriangularMesh"                 ; none
res@cnLevelSelectionMode    = "ManualLevels"                   ; dengzhixian fanwei
res@cnMinLevelValF          = -80                              ; min
res@cnMaxLevelValF          = 80                             ; max
res@cnLevelSpacingF         = 20                              ; jianju

res@mpFillOn                = False                            ; ditu tianse

res@gsnAddCyclic            = False                            ; quanqiu dakai, fouze guanbi
res@gsnLeftString           = ""                               ; zuo biaoti
res@gsnRightString          = ""                               ; you biaoti
;res@gsnStringFont          = 22                               ; gsn biaoti ziti
res@gsnCenterStringFontHeightF    = 0.025                       ; center biaoti zi daxiao
res@gsnCenterStringOrthogonalPosF = -0.004                     ; center biaoti shangxia yidong  "fu xiang xia"
res@gsnRightStringFontHeightF     = 0.025                       ; right biaoti zi daxiao
res@gsnRightStringOrthogonalPosF  = -0.004                     ; right biaoti shangxia yidong
res@gsnLeftStringFontHeightF      = 0.025                       ; Left biaoti zi daxiao
res@gsnLeftStringOrthogonalPosF   = -0.004                     ; Left biaoti shangxia yidong

res@mpProjection            = "CylindricalEquidistant"         ; none
res@mpMinLatF               = 32                               ; min lat
res@mpMaxLatF               = 37                               ; max lat
res@mpMinLonF               = 110                              ; min lon
res@mpMaxLonF               = 117                              ; max lat
res@mpCenterLonF            = 113.5                            ; center lon
res@mpGridLonSpacingF       = 2                                ; lon jiange
res@mpGridLatSpacingF       = 2                                ; lat jiange

print("test1")
res@tmXTOn          = False
res@tmXBon          = False
res@tmYROn          = False
print("test2")
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
res@mpProvincialLineThicknessF  = 3.0 
res@mpGeophysicalLineThicknessF = 3.0
res@mpCountyLineThicknessF      = 3.0
res@mpProvincialLineColor       = "black"  
res@mpCountyLineColor           = "black" 
;res@mpLandFillColor            = "white"


vcres                          =True
vcres@lbLabelStride            = 2 
vcres@vcGlyphStyle             ="LineArrow"     ;; "PostDraw"
vcres@vcLineArrowThicknessF    = 2.0            ;;;;;;;jian tou uc xi 
vcres@vcMonoLineArrowColor     = True
vcres@vcLineArrowColor         = "black"
vcres@gsnLeftString            = ""
vcres@gsnRightString           = ""
; vcres@gsnCenterStringFontHeightF = 0.001                       ; center biaoti zi daxiao
; vcres@gsnRightStringFontHeightF  = 0.001                       ; right  biaoti zi daxiao
vcres@vcMinMagnitudeF          = 0.5
vcres@vcRefMagnitudeF          = 10.0
vcres@vcRefLengthF             = 0.05
vcres@vcMinDistanceF           = 0.042
vcres@vcRefAnnoOn              = True
vcres@vcRefAnnoOrthogonalPosF  = -1.
vcres@vcRefAnnoFontHeightF     = 0.01
vcres@vcRefAnnoString1On       = True   ;cankaojiantou shang zi
vcres@vcRefAnnoString2On       = True   ;cankaojiantou xia zi
vcres@gsnAddCyclic             = False
vcres@vcRefAnnoFontHeightF     = 0.02
vcres@vcRefAnnoString1         = "10 m/s"
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



test               = data(0,:,:)-pre_ave1
test!0       = "lat"
test&lat     = lat
test!1       = "lon"
test&lon     = lon
res@tmYLon          = True
res@gsnCenterString = "QU60km.MS - OBS"
res@gsnLeftString   = "(a)"
plot(3)             = gsn_csm_contour_map(wks,test,res) 
;vcplot(3)           = gsn_csm_vector(wks, u850data(0,:,:), v850data(0,:,:), vcres) 
;overlay(plot(3), vcplot(3))
delete(test)


test                = data(1,:,:)-pre_ave1
test!0       = "lat"
test&lat     = lat
test!1       = "lon"
test&lon     = lon

res@tmYLon          = False
res@gsnCenterString = "V15km.MS - OBS"
res@gsnLeftString   = "(d)"
plot(6)             = gsn_csm_contour_map(wks,test,res) 
;vcplot(4)           = gsn_csm_vector(wks, u850data(1,:,:), v850data(1,:,:), vcres) 
;overlay(plot(4), vcplot(4))
print("ok _ _ _")
print(test(10,:))
print("ok _ _ _")
delete(test)

test                = data(2,:,:)-pre_ave1
test!0       = "lat"
test&lat     = lat
test!1       = "lon"
test&lon     = lon
res@gsnCenterString = "V15km.CP - OBS"
res@gsnLeftString   = "(e)"
plot(7)             = gsn_csm_contour_map(wks,test,res) 
;vcplot(5)           = gsn_csm_vector(wks, u850data(2,:,:), v850data(2,:,:), vcres) 
;overlay(plot(5), vcplot(5))
delete(test)

res@tmYLon          = True

test                = data(3,:,:)-pre_ave1
test!0       = "lat"
test&lat     = lat
test!1       = "lon"
test&lon     = lon
printVarSummary(test)
print(test(10,:))
res@tmXBon          = True
res@gsnCenterString = "QU15km.MS - OBS"
res@gsnLeftString   = "(b)"
plot(4)             = gsn_csm_contour_map(wks,test,res) 
;vcplot(6)           = gsn_csm_vector(wks, u850data(3,:,:), v850data(3,:,:), vcres) 
;overlay(plot(6), vcplot(6))
delete(test)

test                = data(4,:,:)-pre_ave1
test!0       = "lat"
test&lat     = lat
test!1       = "lon"
test&lon     = lon
res@gsnCenterString = "QU15km.CP - OBS"
res@gsnLeftString   = "(c)"
plot(5)             = gsn_csm_contour_map(wks,test,res) 
;vcplot(7)           = gsn_csm_vector(wks, u850data(4,:,:), v850data(4,:,:), vcres) 
;overlay(plot(7), vcplot(7))
delete(test)

test                = data(5,:,:)-pre_ave1
test!0       = "lat"
test&lat     = lat
test!1       = "lon"
test&lon     = lon
res@gsnCenterString = "V3km.CP - OBS"
res@gsnLeftString   = "(f)"
plot(8)             = gsn_csm_contour_map(wks,test,res) 
;vcplot(8)           = gsn_csm_vector(wks, u850data(5,:,:), v850data(5,:,:), vcres) 
;overlay(plot(8), vcplot(8))
delete(test)

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
resP@lbTitleString            = "Precipitation [mm d~S~-1~N~]"
resP@lbTitlePosition          = "Bottom"
resP@lbTitleFontHeightF       = 0.015
; resP@gsnPanelMainString     = ""               ; set main title
; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
;resP@gsnPanelFigureStrings  = (/"(a)","(b)","(c)","(d)","(e)","(f)","(h)","(i)","(j)"/)
;resP@gsnPanelFiguvcrestringsFontHeightF   = 0.01             ;;;;;"(a)","(b)","(c)"的大小
;resP@amJust                               = "TopLeft"           ;;;;;"(a)","(b)","(c)"的位置
  resP@gsnPanelRowSpec      = True
  gsn_panel(wks, plot(3:8), (/3,3/), resP)
  ;draw(plot)
end