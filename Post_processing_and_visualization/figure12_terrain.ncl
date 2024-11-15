begin
f1     = addfile ("./../../regional_GFS_3km_big/ter.nc", "r")

ter    = f1->ter

cenlat = 22
cenlon = 114
leftAngle   = 40.0-10.0
rightAngle  = 40.0-10.0
bottomAngle = 35.0-10.0
topAngle    = 35.0-10.0
delete(f1)

 wks   = gsn_open_wks ("pdf", "terrain_big" )  ; send graphics to PNG file
 plot  = new(1,graphic)
 cplot = new(1,graphic)
 cmap  = read_colormap_file("OceanLakeLandSnow")

 res                      = True
 res@gsnPaperOrientation  = "portrait"
;   res@cnFillDrawOrder = "PreDraw"
;   res@cnLineDrawOrder = "PostDraw"
 res@cnFillOn             = True
 res@cnFillMode           = "RasterFill"
 res@cnLinesOn            = False
 res@cnLineLabelsOn       = False
 res@cnInfoLabelOn        = False
 res@gsnAddCyclic    = False

 colors                      = (/"OceanLakeLandSnow"/)    ; none
 res@cnFillPalette           = cmap                        ; none

 res@lbLabelAutoStride    = True
 res@lbBoxLinesOn         = True       ;LabelBar shifou you line
 res@lbBoxLineColor       = "black"
 res@lbBoxLineThicknessF  = 1.0
 res@lbLabelBarOn            = True

 res@pmTickMarkDisplayMode   = "Always"                         ; XYzhou jia du  ;bian kuang shi fou
 res@tmXBMajorLengthF        = 0.0                              ; XYzhou zhixianglimian
 res@tmXBLabelFontThicknessF = 0.4                              ; X zhou ziti lonlat cuxi
 res@tmYLLabelFontThicknessF = 0.4                              ; Y zhou ziti lonlat cuxi
 res@tmXBLabelFontHeightF    = 0.02                             ; X zhou ziti daxiao
 res@tmYLLabelFontHeightF    = 0.02                             ; Y zhou ziti daxiao
 res@tmXBLabelDeltaF         = -0.5                             ; X zhou ziti xiang X zhou kaojin
 res@tmYLLabelDeltaF         = -0.5                             ; Y zhou ziti xiang Y zhou kaojin
 res@tmYROn = False
 res@tmXTOn = False

res@gsnMajorLatSpacing = 10.0

 res@mpProjection      = "Orthographic"
 res@mpDataBaseVersion = "MediumRes"
 res@mpCenterLatF      = cenlat
 res@mpCenterLonF      = cenlon
;  res@mpMinLatF         = cenlat-20
;  res@mpMaxLatF         = cenlat+20
;  res@mpMinLonF         = cenlon-20
;  res@mpMaxLonF         = cenlon+20

res@cnConstFEnableFill = True
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF = 0.0
res@cnMaxLevelValF = 5200.-800.
res@cnLevelSpacingF = 400.
res@cnMissingValFillColor = "white"
 res@mpGridAndLimbOn   = True    ; shifou lat-lon line
 res@mpOutlineOn       = True
 res@mpFillOn          = True
 res@mpFillColor = 0
 res@mpPerimOn         = False
 res@mpLimitMode       = "Angles"
 res@mpLeftAngleF      = leftAngle
 res@mpRightAngleF     = rightAngle
 res@mpBottomAngleF    = bottomAngle
 res@mpTopAngleF       = topAngle
 ;res@mpOceanFillColor  = 2
 res@mpInlandWaterFillColor  = 2
 ;res@mpLandFillColor  = 3

res@pmLabelBarWidthF  = 0.65
res@pmLabelBarHeightF = 0.07
res@pmLabelBarOrthogonalPosF = 0.01
res@lbBoxLinesOn = True
res@lbLabelFontHeightF = 0.02


; cres = True
; cres@cnLinesOn = True
; cres@cnLevelSelectionMode= "ExplicitLevels"
; cres@cnLevels =(/3,4,5,7,10/)
; cres@cnMonoLineColor=False;;;; add this command with cres@cnLineColors;;;;
; cres@cnLineColors =(/"red","black","black","black","blue"/)
; cres@cnFillOn             = False
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
  res@mpAreaMaskingOn            = False
  res@mpMaskAreaSpecifiers       = (/"China","Japan"/)
  res@mpOutlineSpecifiers        = (/"China","China:Provinces"/)
;res@mpOutlineSpecifiers=(/"China","Henan"/)
;res@mpProvincialLineThicknessF  = 0.0 
res@mpGeophysicalLineThicknessF = 1.8
res@mpNationalLineThicknessF  = 1.8
res@mpCountyLineThicknessF      = 1.8
;res@mpProvincialLineColor       = "black"  
res@mpCountyLineColor           = "black" 

res@mpOceanFillColor = 0


 ;
 ; Set field name and units
 ;
 res@gsnCenterString   = "Terrain height"
 res@gsnLeftString   = ""
 res@gsnRightString  = "[m]"
 res@gsnCenterStringFontHeightF = 0.023
 res@gsnRightStringFontHeightF = 0.023
 ;res@tiMainString    = gname

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
res1@cnLineThicknessF = 4.0
res1@cnLineColor = "red"
 res@gsnDraw = False
 res1@gsnDraw = False
 res@gsnFrame = False
 res1@gsnFrame = False
 ter = where(ter.gt.0.5, ter, -10.0)
 plot(0)             = gsn_csm_contour_map(wks,ter,res) 
  cplot(0) = gsn_csm_contour(wks,fld,res1)
  overlay(plot,cplot)
 ; cres = res
 ; cres@cnFillOn = False
 ; cres@cnLinesOn = True
 ;  cres@sfXArray             = lonCell
 ;  cres@sfYArray             = latCell

 ;  cres@cnFillMode           = "AreaFill"
 ;  cplot              = gsn_csm_contour(wks,fld,cres)
 ;  overlay(plot,cplot)
 ;  draw(plot)
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
 resP@lbTitlePosition          = "Bottom"
 resP@lbTitleFontHeightF       = 0.015
 ; resP@gsnPanelMainString     = ""               ; set main title
 ; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
 ; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
 ;resP@gsnPanelFigureStrings  = (/"(a)","(b)","(c)","(d)","(e)","(f)","(h)","(i)","(j)"/)
 ;resP@gsnPanelFiguvcrestringsFontHeightF   = 0.01             ;;;;;"(a)","(b)","(c)"的大小
 ;resP@amJust                               = "TopLeft"           ;;;;;"(a)","(b)","(c)"的位置
   resP@gsnPanelRowSpec      = True
   gsn_panel(wks, plot, (/1/), resP)
   ;draw(plot)
end