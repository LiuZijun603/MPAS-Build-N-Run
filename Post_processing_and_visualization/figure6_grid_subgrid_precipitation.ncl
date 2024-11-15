begin

Minlon     = 110
Maxlon     = 115
Minlat     = 33
Maxlat     = 36


 

Mintime    = 48
Maxtime    = 95+48
day        = 2.
 f1     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60km_uniform_global_mesoscale/data/main.nc", "r")      ; add file
 f2     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-15km_global_mesoscale/data/main.nc", "r")      ; add file
 f3     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-15km_global_convection/data/main.nc", "r")      ; add file
 f4     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-3km_global_convection/data/main.nc", "r")      ; add file
 lat    = f1->latitude
 lon    = f1->longitude 
 data1   = new((/4,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 data2   = new((/4,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 data    = new((/4,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")

 data1(0,:,:)  = (f1->rainc(Maxtime,:,:)) - (f1->rainc(Mintime,:,:))
 data2(0,:,:)   = (f1->rainnc(Maxtime,:,:)) - (f1->rainnc(Mintime,:,:))
 data1(1,:,:)  = (f2->rainc(Maxtime,:,:)) - (f2->rainc(Mintime,:,:))
 data2(1,:,:)   = (f2->rainnc(Maxtime,:,:)) - (f2->rainnc(Mintime,:,:))
 data1(2,:,:)  = (f3->rainc(Maxtime,:,:)) - (f3->rainc(Mintime,:,:))
 data2(2,:,:)   = (f3->rainnc(Maxtime,:,:)) - (f3->rainnc(Mintime,:,:))
 data1(3,:,:)  = (f4->rainc(Maxtime,:,:)) - (f4->rainc(Mintime,:,:))
 data2(3,:,:)   = (f4->rainnc(Maxtime,:,:)) - (f4->rainnc(Mintime,:,:))
data(0,:,:) = data1(0,:,:) + data2(0,:,:)
data(1,:,:) = data1(1,:,:) + data2(1,:,:)
data(2,:,:) = data1(2,:,:) + data2(2,:,:)
data(3,:,:) = data1(3,:,:) + data2(3,:,:)

data1 = data1/2.
data2 = data2/2.
data  = data/2.
 data1!1      = "lat"
 data1!2      = "lon"
 data1&lat    = lat 
 data1&lon    = lon
 copy_VarMeta(data1, data2) 
 copy_VarMeta(data1, data) 
 print("ok1")




 wks   = gsn_open_wks ("eps", "test2" )  ; send graphics to PNG file
 plot  = new(12,graphic)
 vcplot  = new(12,graphic)

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
res@cnMinLevelValF          = 0.0                              ; min
res@cnMaxLevelValF          = 1.                             ; max
res@cnLevelSpacingF         = .1                              ; jianju

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
res@mpMinLatF               = 32                                ; min lat
res@mpMaxLatF               = 37                                ; max lat
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
res@gsnCenterString = ""
res@gsnRightString  = ""
res@gsnLeftString   = ""
res@tiMainString    = ""
res@gsnDraw         = False
res@gsnFrame        = False


 res@gsnCenterString  = "U60km.MS"
 res@gsnRightString   = ""
 res@gsnLeftString    = "(a)"
 ;res@gsnXYBarChart = True            ; Create bar plot

    plot(0)     = gsn_csm_contour_map(wks,data1(0,:,:)/data(0,:,:),res) 
 res@gsnCenterString  = "V15km.MS"
 res@gsnLeftString    = "(b)"
    plot(1)     = gsn_csm_contour_map(wks,data1(1,:,:)/data(1,:,:),res)
 res@gsnCenterString  = "V15km.CP"
 res@gsnLeftString    = "(c)"
    plot(2)     = gsn_csm_contour_map(wks,data1(2,:,:)/data(2,:,:),res) 
 res@gsnCenterString  = "V3km.CP"
 res@gsnLeftString    = "(d)"
    plot(3)     = gsn_csm_contour_map(wks,data1(3,:,:)/data(3,:,:),res)  
 res@gsnCenterString  = "U60km.MS"

 res@gsnLeftString    = "(e)"
    plot(4)     = gsn_csm_contour_map(wks,data2(0,:,:)/data(0,:,:),res) 
 res@gsnCenterString  = "V15km.MS"

 res@gsnLeftString    = "(f)"
    plot(5)     = gsn_csm_contour_map(wks,data2(1,:,:)/data(1,:,:),res) 
 res@gsnCenterString  = "V15km.CP"

 res@gsnLeftString    = "(g)"
    plot(6)     = gsn_csm_contour_map(wks,data2(2,:,:)/data(2,:,:),res) 
 res@gsnCenterString  = "V3km.CP"

 res@gsnLeftString    = "(h)"
    plot(7)     = gsn_csm_contour_map(wks,data2(3,:,:)/data(3,:,:),res) 



   res@gsnCenterString  = "U60km.MS"
 res@gsnLeftString    = "(i)"
 ;res@gsnXYBarChart = True            ; Create bar plot
    plot(8)     = gsn_csm_contour_map(wks,data(0,:,:),res) 
 res@gsnCenterString  = "V15km.MS"
 res@gsnLeftString    = "(j)"
    plot(9)     = gsn_csm_contour_map(wks,data(1,:,:),res)
 res@gsnCenterString  = "V15km.CP"
 res@gsnLeftString    = "(k)"
    plot(10)     = gsn_csm_contour_map(wks,data(2,:,:),res) 
 res@gsnCenterString  = "V3km.CP"
 res@gsnLeftString    = "(l)"
    plot(11)     = gsn_csm_contour_map(wks,data(3,:,:),res)  


resP                         = True                 ; modify the panel plot
resP@gsnFrame                = False                ; don't advance panel plot
resP@gsnMaximize             = False                ; shifou zuidahua
resP@gsnPanelLabelBar        = True                 ; common colorbar kaiguan
resP@lbLabelFontHeightF      = 0.015                 ; common color bar ziti daxiao
resP@pmLabelBarOrthogonalPosF= -0.025                   ; common color bar shangxia yidong     fu xiang xia 
; resP@pmLabelBarWidthF      = 0.8                  ; common color bar zengjia kuandu
;resP@pmLabelBarHeightF      = -0.02                 ; common color bar zengjia gaodu
resP@lbBoxLinesOn            = True                 ; common color bar biankuangxian kaiguan 
resP@gsnPanelXWhiteSpacePercent  = 2                ; X fangxiang jianxi
resP@gsnPanelYWhiteSpacePercent  = 2               ; Y fangxiang jianxi
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
; resP@gsnPanelFigureStrings  = (/"0716_00:00-06:00","0716_06:00-12:00","0716_12:00-18:00","0716_18:00-24:00","0717_00:00-06:00","0717_06:00-12:00","0717_12:00-18:00"/)
; resP@gsnPanelFigureStringsFontHeightF     = 0.014
; resP@gsnPanelFiguvcrestringsFontHeightF   = 0.014             ;;;;;"(a)","(b)","(c)"的大小
; resP@amJust                               = "TopLeft"           ;;;;;"(a)","(b)","(c)"的位置
  ;resP@gsnPanelRowSpec      = True
  gsn_panel(wks, plot, (/3,4/), resP)
end