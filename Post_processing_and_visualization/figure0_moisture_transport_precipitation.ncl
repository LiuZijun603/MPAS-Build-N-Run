
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

Minlon    = 100-3
Maxlon    = 150-3
Minlat    = 15
Maxlat    = 45
Mintime   = 24
Maxtime   = 47+24

f1        = addfile ("/data/ess-liuzj/era5/2021-07-19-23/rain.nc", "r")      ; add file
rainn     = short2flt(f1->tp(120:239,:,:))
test      = short2flt(f1->tp(238,:,:))
rainn     = rainn*1000.
rain      = dim_sum_n_Wrap(rainn(Mintime:Maxtime,:,:),0)
f         = addfile ("/data/ess-liuzj/era5/2021-07-19-23/q_specific_humity_20_23.nc", "r")      ; add file
ff        = addfile ("/data/ess-liuzj/era5/2021-07-19-23/19_22_atm.nc", "r")       ; add file
lat       = f->latitude(:)
lon       = f->longitude(:)
qq        = short2flt(f->q(Mintime:Maxtime,{850},:,:))
OBS_u8500 = short2flt(ff->u(:,{850},:,:))
OBS_v8500 = short2flt(ff->v(:,{850},:,:))
q         = dim_avg_n_Wrap(qq,0)
OBS_u850  = dim_avg_n_Wrap(OBS_u8500(Mintime:Maxtime,:,:), 0)
OBS_v850  = dim_avg_n_Wrap(OBS_v8500(Mintime:Maxtime,:,:), 0)
q!0    = "lat"
q&lat  = lat
q!1    = "lon"
q&lon  = lon
copy_VarMeta(q, OBS_u850)
copy_VarMeta(q, OBS_v850)
copy_VarMeta(q, rain)
flux_u    = 1.0/9.8*q*OBS_u850*1000.
flux_v    = 1.0/9.8*q*OBS_v850*1000.
copy_VarMeta(q, flux_u)
copy_VarMeta(q, flux_v)
flux      = sqrt( flux_v * flux_v + flux_u * flux_u)
copy_VarMeta(q, flux)
delete(Mintime)
delete(Maxtime)
delete(lat)
delete(lon)

wks   = gsn_open_wks ("pdf", "./eps/moisture_transport_day1-2" )  ; send graphics to PNG file
plot  = new(2,graphic)
vcplot  = new(2,graphic)

cmap = read_colormap_file("MPL_Blues")
res                         = True                             ; Plot mods desired.
res@gsnMaximize             = True                            ; Maximize plot
res@cnFillOn                = True                             ; tainse
res@cnLinesOn               = False                            ; dengzhixian
res@lbLabelBarOn            = True                            ; xiaotu de bar
res@cnLineLabelsOn          = False                            ; line de biaoqian
res@cnLineLabelFontHeightF  = 0.015                            ; line de biaoqian ziti daxiao

res@cnFillMode              = "RasterFill"                     ; turn raster on      
colors                      = (/"MPL_Blues"/)    ; none
res@cnFillPalette           = colors                           ; none
res@cnMinLevelValF          = 0.1                              ; zuixiaozhi
res@cnLineLabelsOn          = False                            ; dengzhixian shuoming
res@trGridType              = "TriangularMesh"                 ; none
res@cnLevelSelectionMode    = "ManualLevels"                   ; dengzhixian fanwei
res@cnMinLevelValF          = 5.0                              ; min
res@cnMaxLevelValF          = 40.                             ; max
res@cnLevelSpacingF         = 5.                              ; jianju

res@mpFillOn                = False                            ; ditu tianse

res@gsnAddCyclic            = False                            ; quanqiu dakai, fouze guanbi
res@gsnLeftString           = ""                               ; zuo biaoti
res@gsnRightString          = ""                               ; you biaoti
;res@gsnStringFont          = 22                               ; gsn biaoti ziti
; res@gsnCenterStringFontHeightF    = 0.025                       ; center biaoti zi daxiao
; res@gsnCenterStringOrthogonalPosF = -0.004                     ; center biaoti shangxia yidong  "fu xiang xia"
; res@gsnRightStringFontHeightF     = 0.025                       ; right biaoti zi daxiao
; res@gsnRightStringOrthogonalPosF  = -0.004                     ; right biaoti shangxia yidong
; res@gsnLeftStringFontHeightF      = 0.025                       ; Left biaoti zi daxiao
; res@gsnLeftStringOrthogonalPosF   = -0.004                     ; Left biaoti shangxia yidong

res@gsnCenterStringFontHeightF    = 0.025                       ; center biaoti zi daxiao
res@gsnCenterStringOrthogonalPosF = 0.02                     ; center biaoti shangxia yidong  "fu xiang xia"
res@gsnRightStringFontHeightF     = 0.02                       ; right biaoti zi daxiao
res@gsnRightStringOrthogonalPosF  = 0.02                     ; right biaoti shangxia yidong
res@gsnLeftStringFontHeightF      = 0.025                       ; Left biaoti zi daxiao
res@gsnLeftStringOrthogonalPosF   = 0.02                     ; Left biaoti shangxia yidong

res@mpProjection            = "CylindricalEquidistant"         ; none
res@mpMinLatF               = Minlat                               ; min lat
res@mpMaxLatF               = Maxlat                               ; max lat
res@mpMinLonF               = Minlon                              ; min lon
res@mpMaxLonF               = Maxlon                              ; max lat
res@mpCenterLonF            = (Minlon + Maxlon) / 2.              ; center lon
res@mpGridLonSpacingF       = 2                                ; lon jiange
res@mpGridLatSpacingF       = 2                                ; lat jiange

print("test1")
res@tmXTOn          = False
res@tmYROn          = False
print("test2")
;res@pmTickMarkDisplayMode   = "Always"                         ; XYzhou jia du 
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
res@vpHeightF               = 0.5
res@vpWidthF                = 0.65

res@tmYLMode                = "Explicit"
res@tmYLValues              =(/20,25,30,35,40/)
res@tmYLLabels              =(/"20~S~o~N~N","25~S~o~N~N","30~S~o~N~N","35~S~o~N~N","40~S~o~N~N"/)
res@tmXBMode                ="Explicit"
res@tmXBValues              =(/100,110,120,130,140/)
res@tmXBLabels              =(/"100~S~o~N~E","110~S~o~N~E","120~S~o~N~E","130~S~o~N~E","140~S~o~N~E"/)


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
  res@mpOutlineSpecifiers        = (/"China","China:Henan"/)
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



vcres                          =True
vcres@lbLabelStride            = 2 
vcres@vcGlyphStyle             ="LineArrow"     ;; "PostDraw"
vcres@vcLineArrowThicknessF    = 2.0            ;;;;;;;jian tou uc xi 
vcres@vcMonoLineArrowColor     = True
vcres@vcLineArrowColor         = "darkgreen"
vcres@gsnLeftString            = ""
vcres@gsnRightString           = ""

vcres@vcMinMagnitudeF          = 0.5
vcres@vcRefMagnitudeF          = 20.0
vcres@vcRefLengthF             = 0.05
vcres@vcMinDistanceF           = 0.04
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
vcres@vcRefAnnoOrthogonalPosF  = -1.3     ;;;;;;;up and down vector   fu xiangshang  -1.095


res@gsnCenterString = ""
res@gsnRightString  = ""
res@gsnLeftString   = ""
res@tiMainString    = ""
res@gsnDraw         = False
res@gsnFrame        = False
vcres@gsnDraw       = False
vcres@gsnFrame      = False
  vcres@cnFillDrawOrder            = "PreDraw"



res@pmLabelBarWidthF      = 0.65                  ;  color bar zengjia kuandu
res@pmLabelBarHeightF     = 0.07                 ;  color bar zengjia gaodu
res@pmLabelBarOrthogonalPosF= 0.12                  ; common color bar shangxia yidong     fu xiang xia 

maxlat_region = 38
minlat_region = 32
maxlon_region = 117
minlon_region = 110

boxlat  = (/ maxlat_region,maxlat_region,minlat_region,minlat_region,maxlat_region /)
boxlon  = (/ minlon_region,maxlon_region,maxlon_region,minlon_region,minlon_region /)

; boxlat  = (/ 37,37,32,32 /)
; boxlon  = (/ 117,117,110,110 /)




res@gsnLeftString   = "(a)"
res@gsnRightString  = "[g s~S~-1~N~cm~S~-1~N~hPa~S~-1~N~]"

res@gsnCenterString = "Moisture flux"




plot(0)             = gsn_csm_contour_map(wks,flux,res) 
vcplot(0)           = gsn_csm_vector(wks, flux_u, flux_v, vcres) 
overlay(plot(0), vcplot(0))

delete(cmap)
delete(colors)
delete(res@cnFillPalette)
cmap                        = read_colormap_file("WhiteBlueGreenYellowRed")
colors                      = (/"WhiteBlueGreenYellowRed"/)    ; none
res@cnFillPalette           = colors                           ; none
res@cnMinLevelValF          = 10.0                              ; min
res@cnMaxLevelValF          = 150.                             ; max
res@cnLevelSpacingF         = 10.                              ; jianju



res@gsnCenterString = ""
res@gsnLeftString = ""
res@gsnRightString = ""


; res@gsnCenterStringFontHeightF    = 0.025                       ; center biaoti zi daxiao
; res@gsnCenterStringOrthogonalPosF = 0                     ; center biaoti shangxia yidong  "fu xiang xia"
; res@gsnRightStringFontHeightF     = 0.025                       ; right biaoti zi daxiao
; res@gsnRightStringOrthogonalPosF  = 0                     ; right biaoti shangxia yidong
; res@gsnLeftStringFontHeightF      = 0.025                       ; Left biaoti zi daxiao
; res@gsnLeftStringOrthogonalPosF   = 0                     ; Left biaoti shangxia yidong

res@gsnCenterString            = "Precipitation"
res@gsnLeftString  = "(b)"
res@gsnRightString  = "[mm d~S~-1~N~]"
res@gsnRightStringFontHeightF     = 0.023                       ; right biaoti zi daxiao

plot(1)             = gsn_csm_contour_map(wks,rain,res) 

gonres                  = True
gonres@gsLineColor       = "red"
gonres@gsLineThicknessF       = 4.
dum  = gsn_add_polyline(wks, plot(0), boxlon, boxlat, gonres)
dum1 = gsn_add_polyline(wks, plot(1), boxlon, boxlat, gonres)

  nhres                          = res
  nhres@gsnMaximize              = False
  nhres@gsnFrame                 = False
  nhres@gsnDraw                  = False
  nhres@vpHeightF                = 0.13    
  nhres@vpWidthF                 = 0.13
  nhres@mpMinLatF                =   2   
  nhres@mpMaxLatF                =  23
  nhres@mpMinLonF                = 105
  nhres@mpMaxLonF                = 123
  nhres@lbLabelBarOn             = False
  nhres@tmXBOn                   = False 
  nhres@tmXTOn                   = False
  nhres@tmYLOn                   = False
  nhres@tmYROn                   = False
  nhres@gsnLeftString            = ""
  nhres@gsnRightString           = ""
  nhres@gsnCenterString = ""
  nhres@cnFillDrawOrder            = "PreDraw"
  nhres@mpGeophysicalLineThicknessF = 1.3
nhres@mpNationalLineThicknessF  = 1.3
nhres@mpCountyLineThicknessF      = 1.3
;nhres@mpOutlineBoundarySets   = "China"
  rain_0 = rain
  flux_0 = flux
  test = 0.0
  test({10},:) =1
  map_nanhai = gsn_csm_contour_map(wks,flux,nhres)
  map_nanhai2 = gsn_csm_contour_map(wks,rain,nhres)
adres                          = True
  adres@amParallelPosF           = -0.325   ;0.495 ; -0.5 is the left edge of the plot.
  adres@amOrthogonalPosF         = 0.49  ; -0.5 is the top edge of the plot.
  adres@amJust                   = "BottomRight"
plotnh = gsn_add_annotation(plot(0),map_nanhai,adres)
plotn1 = gsn_add_annotation(plot(1),map_nanhai2,adres)


resP                         = True                 ; modify the panel plot
resP@gsnFrame                = False                ; don't advance panel plot
resP@gsnMaximize             = False                ; shifou zuidahua
resP@gsnPanelLabelBar        = False                 ; common colorbar kaiguan
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
resP@lbTitleString            = ""
resP@lbTitlePosition          = ""
resP@lbTitleFontHeightF       = 0.015
; resP@gsnPanelMainString     = ""               ; set main title
; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
;resP@gsnPanelFigureStrings  = (/"(a)","(b)","(c)","(d)","(e)","(f)","(h)","(i)","(j)"/)
;resP@gsnPanelFiguvcrestringsFontHeightF   = 0.01             ;;;;;"(a)","(b)","(c)"的大小
;resP@amJust                               = "TopLeft"           ;;;;;"(a)","(b)","(c)"的位置
  ;resP@gsnPanelRowSpec      = True
  gsn_panel(wks, plot, (/1,2/), resP)
  ;draw(plot)

printVarSummary(flux_u)

end
