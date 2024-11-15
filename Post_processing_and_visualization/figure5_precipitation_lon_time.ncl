
begin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;OBS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
regrid_on    = True

char         = (/"20210719000000/SURFACE/rain3-p/21071908","20210719000000/SURFACE/rain3-p/21071911",\
                "20210719000000/SURFACE/rain3-p/21071914","20210719000000/SURFACE/rain3-p/21071917",\
                "20210719000000/SURFACE/rain3-p/21071920","20210719000000/SURFACE/rain3-p/21071923",\
                "20210720000000/SURFACE/rain3-p/21072002","20210720000000/SURFACE/rain3-p/21072005",\
                "20210720000000/SURFACE/rain3-p/21072008","20210720000000/SURFACE/rain3-p/21072011",\
                "20210720000000/SURFACE/rain3-p/21072014","20210720000000/SURFACE/rain3-p/21072017",\
                "20210720000000/SURFACE/rain3-p/21072020","20210720000000/SURFACE/rain3-p/21072023",\
                "20210721000000/SURFACE/rain3-p/21072102","20210721000000/SURFACE/rain3-p/21072105",\
                "20210721000000/SURFACE/rain3-p/21072108","20210721000000/SURFACE/rain3-p/21072111",\
                "20210721000000/SURFACE/rain3-p/21072114","20210721000000/SURFACE/rain3-p/21072117",\
                "20210721000000/SURFACE/rain3-p/21072120","20210721000000/SURFACE/rain3-p/21072123",\
                "20210722000000/SURFACE/rain3-p/21072202","20210722000000/SURFACE/rain3-p/21072205",\
                "20210722000000/SURFACE/rain3-p/21072208","20210722000000/SURFACE/rain3-p/21072211",\
                "20210722000000/SURFACE/rain3-p/21072214","20210722000000/SURFACE/rain3-p/21072217",\
                "20210722000000/SURFACE/rain3-p/21072220","20210722000000/SURFACE/rain3-p/21072223",\
                "20210723000000/SURFACE/rain3-p/21072302","20210723000000/SURFACE/rain3-p/21072305",\
                "20210723000000/SURFACE/rain3-p/21072308"/)
data_q       = new((/dimsizes(char),101,101/),"float","No_FillValue")
do i = 0, dimsizes(char)-1
    data1    = asciiread("/data/ess-liuzj/station_data/2021-07-21/MICAPS_"+char(i)+".000", -1 ,"float")
    pre1     = reshape(data1(17:), (/(dimsizes(data1)-17)/5,5/))
    pre_ave1 = pre1(:,4)
    lon      = pre1(:,1)
    lat      = pre1(:,2)
    if (regrid_on) then
    ; minlat   = min(lat)
    ; minlon   = min(lon)
    ; maxlat   = max(lat)
    ; maxlon   = max(lon)
    ; minlat    = 32
    ; maxlat    = 37
    ; minlon    = 110
    ; maxlon    = 117
minlon     = 110
maxlon     = 120
minlat     = 30
maxlat     = 40
    Opt                     = True
    Opt@SrcGridLon          = lon
    Opt@SrcGridLat          = lat
    ;Opt@DstLLCorner         = (/floor(minlat)-0.1,floor(minlon)+0.1/)
    Opt@DstLLCorner         = (/floor(minlat),floor(minlon)/)
    ;Opt@DstURCorner         = (/ceil(maxlat)-0.1,ceil(maxlon)+0.1/)
    Opt@DstURCorner         = (/ceil(maxlat),ceil(maxlon)/)
    Opt@DstGridType         = "0.1deg"
    Opt@ForceOverwrite      = True
    Opt@Debug               = True
    Opt@InterMethod         = "patch"
    pre_ave1                := ESMF_regrid(pre_ave1,Opt)
end if
printVarSummary(pre_ave1)
data_q(i,:,:)    = pre_ave1
printVarSummary(data_q)
delete(data1)
delete(pre1)
delete(pre_ave1)
delete(lon)
delete(lat)
delete(Opt)
end do

printVarSummary(data_q)
data_q!0    = "time"
data_q!1    = "lat"
data_q!2    = "lon"
;;;;;;;113-115
data_obs1  = data_q(lat|:,lon|:,time|:)
data_obs   = dim_avg_n_Wrap(data_obs1(40:60,:,:), 0)
data_obs   = data_obs/4.
lon        = ispan(1100,1200,1)
data_obs&lon = lon
delete(lon)


Minlon     = 110
Maxlon     = 120
Minlat     = 30
Maxlat     = 40

 f = addfile ("/data/ess-liuzj/era5/2021-07-19-23/rain.nc", "r")      ; add file
 lat    = f->latitude
 lon    = ispan(11000,12000,25)
 time = ispan(0, 95, 1)
 lat1 =  ispan(0, 40, 1)
 rainn    = short2flt(f->tp(121:216,:,:))
 rainn    = rainn*1000.
 rain     = new((/96,41/),"float","No_FillValue")
 rain     = dim_avg_n_Wrap(rainn(:,{34:36},{Minlon:Maxlon}),1)
 rain!0   = "time"
 rain&time = time
 rain!1   = "lon"
 rain&lon = lon
 rain1 = rain(lon|:,time|:)

 printVarSummary(rain1)
 delete(lat)
 delete(lon)
 delete(time)
 print("ok1")
 

 f1     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60km_uniform_global_mesoscale/data/main.nc", "r")      ; add file
 f2     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-15km_global_mesoscale/data/main.nc", "r")      ; add file
 f3     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-15km_global_convection/data/main.nc", "r")      ; add file
 ; f4     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-15km_global_convection/data/main.nc", "r")      ; add file
 ; f5     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-15km_global_convection/data/main.nc", "r")      ; add file
 f4     = addfile ("/data/ess-liuzj/test/zhengzhou_721/15km_global_mesoscale/data/main.nc", "r")      ; add file
 f5     = addfile ("/data/ess-liuzj/test/zhengzhou_721/15km_global_convection/data/main.nc", "r")      ; add file
 f6     = addfile ("/data/ess-liuzj/test/zhengzhou_721/60-3km_global_convection/data/main.nc", "r")      ; add file
 lat    = f1->latitude
 lon    = f1->longitude 
 time   = 193
 data1  = new((/6,time,dimsizes(lat),dimsizes(lon)/),"float","No_FillValue")
 data2  = new((/6,time,dimsizes(lon)/),"float","No_FillValue")
 data3  = new((/6,96,101/),"float","No_FillValue")
 rainc  = f1->rainc
 rainnc = f1->rainnc
 data1(0,:,:,:)  = rainc + rainnc
 delete(rainc)
 delete(rainnc)
 rainc  = f2->rainc
 rainnc = f2->rainnc
 data1(1,:,:,:)  = rainc + rainnc
 delete(rainc)
 delete(rainnc)
 rainc  = f3->rainc
 rainnc = f3->rainnc
 data1(2,:,:,:)  = rainc + rainnc
 delete(rainc)
 delete(rainnc)
 rainc  = f4->rainc
 rainnc = f4->rainnc
 data1(3,:,:,:)  = rainc + rainnc
 delete(rainc)
 delete(rainnc)
 rainc  = f5->rainc
 rainnc = f5->rainnc
 data1(4,:,:,:)  = rainc + rainnc
 delete(rainc)
 delete(rainnc)
 rainc  = f6->rainc
 rainnc = f6->rainnc
 data1(5,:,:,:)  = rainc + rainnc
 delete(rainc)
 delete(rainnc)

 data1!0   = "mod1"
 data1!1   = "time"
 data1!2   = "lat"
 data1!3   = "lon"
 data1&lat = lat
 data1&lon = lon

 data2!0   = "mod1"
 data2!1   = "time"
 data2!2   = "lon"
 data2&lon = lon
delete(lon)

 data2  = dim_avg_n_Wrap(data1(:,:,{34:36},:),2)

 do i = 0, 95
   data3(:,i,:) = data2(:,2*i+2,{Minlon:Maxlon}) - data2(:,i*2,{Minlon:Maxlon})
 end do
 data3!0   = "mod1"
 data3!1   = "time"
 data3!2   = "lon"
data4 = data3(mod1|:,lon|:,time|:)
lon  =  ispan(1100,1200,1)
data4&lon  = lon
delete(lon)
 print("ok2")



 wks   = gsn_open_wks ("eps", "test" )  ; send graphics to PNG file
 plot  = new(9,graphic)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;OBS plot;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ERA5 plot;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    cmap = read_colormap_file("WhiteBlueGreenYellowRed")
    res                      = True              ; Plot mods desired.
    res@gsnMaximize          = False              ; Maximize plot
    res@cnFillOn             = True              ; color plot desired
    res@lbLabelBarOn         = False
    res@cnFillMode           = "RasterFill"      ; turn raster on      
    colors = (/"WhiteBlueGreenYellowRed"/)
    res@cnFillPalette       = colors
   ; res@cnFillPalette        = cmap(48:208,:)       ; Don't use white
    res@cnLinesOn            = False            ; turn off contour lines
    res@cnMinLevelValF        = 0.1
    res@cnLineLabelsOn       = False             ; turn off contour labels
    res@trGridType           = "TriangularMesh"  ; This is required to allow
                                               ; missing coordinates
 res@cnLevelSelectionMode = "ManualLevels"     ; manual contour levels
  res@cnMinLevelValF       = 0.2              ; min level
  res@cnMaxLevelValF       =  4.             ; max level
  res@cnLevelSpacingF      =  0.2             ; contour level spacing
    res@mpFillOn             = False
    res@gsnAddCyclic         = False
    res@gsnAddCyclic         = False
res@cnInfoLabelOn            = False
    res@gsnLeftString   =""
    res@gsnRightString  =""

  res@tmXBMode="Explicit"
 ; res@tmXBValues         = (/0,12,24,36,48,60,72,84,95/)
;  res@tmXBLabels         = (/"1900","1912","2000","2012","2100","2112","2200","2212","2300"/)
res@tmXBValues         = (/12,36,60,84/)
res@tmXBLabels         = (/"19 July ~C~ 12:00","20 July ~C~ 12:00","21 July ~C~ 12:00","22 July ~C~ 12:00"/)
  res@tmYLMode="Explicit"
  res@tmYLValues           = (/1110,1130,1150,1170,1190/)
   res@tmYLLabels           = (/"111~S~o~N~E","113~S~o~N~E","115~S~o~N~E","117~S~o~N~E","119~S~o~N~E"/)
res@gsnCenterString = ""
res@gsnRightString  = ""
res@gsnLeftString   = ""
res@tiMainString    = ""
res@tiMainString            = ""         
res@tiMainFontHeightF       = 0.0001         
res@vpHeightF               = 0.25
res@vpWidthF                = 0.5
res@tmXTOn            = False
res@tmYROn            = False
res@pmTickMarkDisplayMode   = "Always"                         ; XYzhou jia du 
res@tmXBMajorLengthF        = -0.005                            ; XYzhou zhixianglimian
res@tmYLMajorLengthF        = -0.005                           ; XYzhou zhixianglimian
res@tmXBLabelFontThicknessF = 0.4                              ; X zhou ziti lonlat cuxi
res@tmYLLabelFontThicknessF = 0.4                              ; Y zhou ziti lonlat cuxi
res@tmXBLabelFontHeightF    = 0.02                             ; X zhou ziti daxiao
res@tmYLLabelFontHeightF    = 0.02                             ; Y zhou ziti daxiao
res@tmXBLabelDeltaF         = -0.5                             ; X zhou ziti xiang X zhou kaojin
res@tmYLLabelDeltaF         = -0.5                             ; Y zhou ziti xiang Y zhou kaojin

res@gsnAddCyclic            = False                            ; quanqiu dakai, fouze guanbi
res@gsnLeftString           = ""                               ; zuo biaoti
res@gsnRightString          = ""                               ; you biaoti
;res@gsnStringFont          = 22                               ; gsn biaoti ziti
res@gsnLeftStringFontHeightF    = 0.025                       ; center biaoti zi daxiao
res@gsnCenterStringFontHeightF    = 0.025                       ; center biaoti zi daxiao
res@gsnCenterStringOrthogonalPosF = 0.02                     ; center biaoti shangxia yidong  "fu xiang xia"
res@gsnRightStringFontHeightF     = 0.000001                       ; right biaoti zi daxiao
;res@gsnRightStringOrthogonalPosF  = -0.004                     ; right biaoti shangxia yidong

; res@tmXBMajorLengthF        = 0 
; res@tmXTMajorLengthF        = 0 
; res@tmYLMajorLengthF        = 0 
; res@tmYRMajorLengthF        = 0 
res@gsnDraw         = False
res@gsnFrame        = False

 res@gsnLeftString   = "(c)"
 res@gsnCenterString  = "QU60km.MS" 
    plot(3)     = gsn_csm_hov(wks,data4(0,:,:),res) 
 res@gsnLeftString   = "(f)"
 res@gsnCenterString  = "V15km.MS" 
    plot(6)     = gsn_csm_hov(wks,data4(1,:,:),res) 
 res@gsnLeftString   = "(g)"
 res@gsnCenterString  = "V15km.CP" 
    plot(7)     = gsn_csm_hov(wks,data4(2,:,:),res) 
  res@gsnLeftString   = "(d)"
  res@gsnCenterString  = "QU15km.MS" 
    plot(4)     = gsn_csm_hov(wks,data4(3,:,:),res) 
  res@gsnLeftString   = "(e)"
  res@gsnCenterString  = "QU15km.CP" 
    plot(5)     = gsn_csm_hov(wks,data4(4,:,:),res) 
  res@gsnLeftString   = "(h)"
  res@gsnCenterString  = "V3km.CP"
    plot(8)     = gsn_csm_hov(wks,data4(5,:,:),res) 


delete(res@tmXBValues)
delete(res@tmXBLabels)
delete(res@tmYLValues)
delete(res@tmYLLabels)
res@tmXBMode="Explicit"
  ;res@tmXBValues         = (/0,12,24,36,48,60,72,84,95/)
  ;res@tmXBLabels         = (/"1900","1912","2000","2012","2100","2112","2200","2212","2300"/)
  res@tmXBValues         = (/12/3,36/3,60/3,84/3/)
  res@tmXBLabels         = (/"19 July ~C~ 12:00","20 July ~C~ 12:00","21 July ~C~ 12:00","22 July ~C~ 12:00"/)
  ;res@tmXBValues         = (/0,24,48,72,95/)
  ;res@tmXBLabels         = (/"19 July ~C~ 12:00","20 July ~C~ 12:00","21 July ~C~ 12:00","22 July ~C~ 12:00"/)
  res@tmYLMode="Explicit"
  res@tmYLValues           = (/1110,1130,1150,1170,1190/)
   res@tmYLLabels           = (/"111~S~o~N~E","113~S~o~N~E","115~S~o~N~E","117~S~o~N~E","119~S~o~N~E"/)
 res@gsnCenterString  = "OBS"
res@gsnDraw         = False
res@gsnFrame        = False
res@gsnLeftString   = "(a)"
    plot(0)     = gsn_csm_hov(wks,data_obs(:,:),res)

  
delete(res@tmXBValues)
delete(res@tmXBLabels)
delete(res@tmYLValues)
delete(res@tmYLLabels)
res@gsnLeftString   = "(b)"
res@gsnCenterString   = "ERA5"
  res@tmXBMode="Explicit"
  ;res@tmXBValues         = (/0,12,24,36,48,60,72,84,95/)
  ;res@tmXBLabels         = (/"1900","1912","2000","2012","2100","2112","2200","2212","2300"/)
  res@tmXBValues         = (/12,36,60,84/)
  res@tmXBLabels         = (/"19 July ~C~ 12:00","20 July ~C~ 12:00","21 July ~C~ 12:00","22 July ~C~ 12:00"/)
  ;res@tmXBValues         = (/0,24,48,72,95/)
  ;res@tmXBLabels         = (/"19 July ~C~ 12:00","20 July ~C~ 12:00","21 July ~C~ 12:00","22 July ~C~ 12:00"/)
  res@tmYLMode="Explicit"
  res@tmYLValues           = (/11100,11300,11500,11700,11900/)
   res@tmYLLabels           = (/"111~S~o~N~E","113~S~o~N~E","115~S~o~N~E","117~S~o~N~E","119~S~o~N~E"/)
plot(1)     = gsn_csm_hov(wks,rain1(:,:),res) 

;;;; test is end 
delete(cmap)
delete(res)

printVarSummary(data_q)
printVarSummary(data4)


resP                         = True                 ; modify the panel plot
resP@gsnFrame                = False                ; don't advance panel plot
resP@gsnMaximize             = False                ; shifou zuidahua
resP@gsnPanelLabelBar        = True                 ; common colorbar kaiguan
resP@lbLabelFontHeightF      = 0.015                 ; common color bar ziti daxiao
resP@pmLabelBarOrthogonalPosF= -0.02                   ; common color bar shangxia yidong     fu xiang xia 
; resP@pmLabelBarWidthF      = 0.8                  ; common color bar zengjia kuandu
; resP@pmLabelBarHeightF     = 0.06                 ; common color bar zengjia gaodu
resP@lbBoxLinesOn            = True                 ; common color bar biankuangxian kaiguan 
resP@gsnPanelXWhiteSpacePercent  = 0.                ; X fangxiang jianxi
resP@gsnPanelYWhiteSpacePercent  = 0               ; Y fangxiang jianxi
;resP@gsnPanelBottom          = 0.15 
resP@gsnLeftString            = ""
resP@gsnRightString           = ""
resP@gsnCenterString          = ""
resP@lbTitleString            = "Precipitation [mm h~S~-1~N~]"
resP@lbTitlePosition          = "Bottom"
resP@lbTitleFontHeightF       = 0.015
; resP@gsnPanelMainString     = ""               ; set main title
; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
; resP@gsnPanelXF             = (/5.0,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.10,0.535,0.1/)
; resP@gsnPanelFigureStrings  = (/"0716_00:00-06:00","0716_06:00-12:00","0716_12:00-18:00","0716_18:00-24:00","0717_00:00-06:00","0717_06:00-12:00","0717_12:00-18:00"/)
; resP@gsnPanelFigureStringsFontHeightF     = 0.014
; resP@gsnPanelFiguvcrestringsFontHeightF   = 0.014             ;;;;;"(a)","(b)","(c)"的大小
; resP@amJust                               = "TopLeft"           ;;;;;"(a)","(b)","(c)"的位置

  resP@gsnPanelRowSpec      = True
  gsn_panel(wks, plot, (/3,3,3/), resP)
    data4!0   = "dim0"
    data4!1   = "dim1"
    data4!2   = "dim2"
fout        = addfile("./data/lon_time.nc", "c")
fout->data_obs  = data_obs
fout->data      = data4

end