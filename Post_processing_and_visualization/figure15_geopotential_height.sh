#! /bin/bash
    # export zoomin=0
    # export level=850
    # ncl height_hourly.ncl
    # export level=500
    # ncl height_hourly.ncl
    # export level=925
    # ncl height_hourly.ncl
    export zoomin=1
    # export level=850
    # ncl height_hourly.ncl
    export level=500
    ncl height_hourly.ncl
        export level=850
    ncl height_hourly.ncl
    # export level=925
    # ncl height_hourly.ncl
    # export level=850
    # ncl height_hourly.ncl

    # module load imagemagick/7.0.11
    # convert -delay 50 height_hourly_500hPa_zoomin.pdf height_hourly_500hPa_zoomin.gif
    # convert -delay 50 height_hourly_500hPa_zoomout.pdf height_hourly_500hPa_zoomout.gif
    # convert -delay 50 height_hourly_850hPa_zoomin.pdf height_hourly_850hPa_zoomin.gif
    # convert -delay 50 height_hourly_850hPa_zoomout.pdf height_hourly_850hPa_zoomout.gif
exit 0