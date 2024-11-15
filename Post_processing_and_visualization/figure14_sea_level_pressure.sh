#! /bin/bash
    # export zoomin=0
    # ncl slp_hourly.ncl
    # export zoomin=1
    # ncl slp_hourly.ncl
    convert -delay 50 slp_hourly_zoomin.pdf slp_hourly_zoomin.gif
    convert -delay 50 slp_hourly_zoomout.pdf slp_hourly_zoomout.gif
exit 0