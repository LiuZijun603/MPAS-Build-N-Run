#! /bin/bash
    export zoomin=0
    ncl moisture_hourly.ncl
    ncl moisture.ncl
    export zoomin=1
    ncl moisture_hourly.ncl
    ncl moisture.ncl
    module load imagemagick/7.0.11
    convert -delay 50 moisture_hourly_zoomin.pdf moisture_hourly_zoomin.gif
    convert -delay 50 moisture_hourly_zoomout.pdf moisture_hourly_zoomout.gif
exit 0