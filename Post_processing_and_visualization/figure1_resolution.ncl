load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  ;
  ; Whether to do color-filled plot (filled=True) or
  ;   to plot contours of height field (filled=False)
  ;
  filled   = True
;  filled   = False

  ;
  ; The (lat,lon) the plot is to be centered over
  ;
  cenLat   = 34.0
  cenLon   = 113.0

  ;
  ; Projection to use for plot
  ;
;  projection = "Orthographic"
  projection = "CylindricalEquidistant"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


  r2d = 57.2957795             ; radians to degrees

  wks = gsn_open_wks("pdf","mesh_resolution_v3")
  colors = (/"WhBlGrYeRe"/)
 
  gsn_define_colormap(wks,colors)

;  fname = getenv("FNAME")
  ;f = addfile("/data/ess-liuzj/test/zhengzhou_721/60-3km_global_convection/zhengzhou.grid.nc","r")
  f = addfile("/data/ess-liuzj/test/zhengzhou_721/60-3km_global_convection/data/history.2021-07-20_00.00.00.nc","r")
  lonCell   = f->lonCell(:) * r2d
  latCell   = f->latCell(:) * r2d
  lonVertex = f->lonVertex(:) * r2d
  latVertex = f->latVertex(:) * r2d
  lonEdge = f->lonEdge(:) * r2d
  latEdge = f->latEdge(:) * r2d
  verticesOnCell = f->verticesOnCell(:,:)
  alpha = f->angleEdge(:)

  res                      = True
  res@gsnMaximize          = True
  res@gsnSpreadColors      = True

  res@sfXArray             = lonCell
  res@sfYArray             = latCell

  res@cnFillMode           = "AreaFill"

  if (filled) then
     res@cnFillOn             = True
     res@cnLinesOn            = False
     res@cnLineLabelsOn       = False
     ;res@gsnSpreadColorStart   = 2   
     res@gsnSpreadColorEnd    = -5
  else
     res@cnFillOn             = False
     res@cnLinesOn            = True
     res@cnLineLabelsOn       = True
  end if

  res@cnLevelSpacingF      = 3.0
  res@cnInfoLabelOn        = False
  res@lbLabelAutoStride    = True
  res@lbBoxLinesOn         = False
  res@cnLineLabelsOn       = False                            ; dengzhixian shuoming

  res@mpProjection      = projection
  res@mpProjection          = "Orthographic"
  res@mpDataBaseVersion = "MediumRes"
  res@mpCenterLatF      = cenLat
  res@mpCenterLonF      = cenLon
  res@mpGridAndLimbOn   = True
  res@mpGridAndLimbDrawOrder = "PreDraw"
  res@mpGridLineColor   = "Background"
  res@mpOutlineOn       = True
  res@mpDataBaseVersion = "Ncarg4_1"
  res@mpDataSetName     = "Earth..3"
  res@mpOutlineBoundarySets = "Geophysical"
  res@mpFillOn          = True
  res@mpPerimOn         = True
  res@gsnFrame          = False
  res@cnLineThicknessF  = 2.0

  res@cnLineColor       = "NavyBlue"
  res@mpOceanFillColor  = 3
  res@mpInlandWaterFillColor  = 3
  res@mpLandFillColor  = 4
  ;res@tiMainString = "Approximate mesh resolution (km)"

  res@lbBoxLinesOn            = True                             ; color bar biankuangxian kaiguan 
res@lbLabelFontHeightF      = 0.012                             ; color bar ziti daxiao
res@pmLabelBarOrthogonalPosF= -0.002                             ; color bar shangxia yidong 
res@pmLabelBarWidthF        = 0.5                              ; color bar zengjia kuandu
res@pmLabelBarHeightF       = 0.06                             ; color bar zengjia gaodu
res@lbBoxLinesOn            = True                             ; color bar biankuangxian kaiguan 
res@lbBoxLineThicknessF     = 0.2                              ; color bar biankuangxian cuxi 
res@lbTitleString            = "Mesh resolution [km]"
res@lbTitlePosition          = "Bottom"
res@lbTitleFontHeightF       = 0.015
  res@tiMainString = ""

  res@cnLineLabelsOn       = False                            ; dengzhixian shuoming


  minSpacingKm = sqrt(min(f->areaCell(:))*2.0/sqrt(3.0))*6371.229
  ;print("Approx. min grid distance is "+minSpacingKm)

  t = stringtointeger(getenv("T"))
  fld = minSpacingKm / (f->meshDensity(:)^0.25)
  res@cnLineDashPattern = 0
  printVarSummary(fld)
  map = gsn_csm_contour_map(wks,fld,res)

  frame(wks)

end

