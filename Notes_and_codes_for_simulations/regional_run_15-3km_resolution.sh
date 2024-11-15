cd /data/ess-liuzj/0907case/test/
rm -rf regional_GFS_3km_vari
mkdir regional_GFS_3km_vari
cd regional_GFS_3km_vari
#This command do not need change
ln -s /work/ess-liuzj/MPAS-Model-7.0/init_atmosphere_model .
ln -s /work/ess-liuzj/MPAS-Model-7.0/atmosphere_model .
ln -s ../60-3km/shenzhen.static.nc .
ln -s /data/ess-liuzj/gfs/2023_09-07_08/GFS\:2023-09-0* .
cp /work/ess-liuzj/MPAS-Model-7.3/stream_list.atmosphere.* .
ln -s /work/ess-liuzj/MPAS-Model-7.3/src/core_atmosphere/physics/physics_wrf/files/* .
ln -s ~/apps/MPAS-Limited-Area/create_region .


echo "
Name: shenzhenvari
Type: circle
Point: 22.0, 114.0
radius: 2400000.0   # Meters
" > shenzhen.pts

source activate
conda activate python_3.8

./create_region shenzhen.pts shenzhen.static.nc
gpmetis -minconn -contig -niter=200 shenzhenvari.graph.info 40
gpmetis -minconn -contig -niter=200 shenzhenvari.graph.info 240

ulimit -s unlimited
################first init_atmosphere################
echo "
&nhyd_model
    config_init_case = 7
    config_start_time = '2023-09-07_03:00:00'
    config_stop_time = '2023-09-08_03:00:00'
    config_theta_adv_order = 3
    config_coef_3rd_order  = 0.25
/
&dimensions
    config_nvertlevels = 55
    config_nsoillevels = 4
    config_nfglevels = 38
    config_nfgsoillevels = 4
/
&data_sources
    config_geog_data_path = '/data/ess-liuzj/geog/WPS_GEOG/'
    config_met_prefix = 'GFS'
    config_fg_interval = 10800
    config_landuse_data = 'MODIFIED_IGBP_MODIS_NOAH'
    config_topo_data = 'GMTED2010'
    config_vegfrac_data = 'MODIS'
    config_albedo_data = 'MODIS'
    config_maxsnowalbedo_data = 'MODIS'
    config_supersample_factor = 3
    config_use_spechumd = false
/
&vertical_grid
    config_ztop = 30000.0
    config_nsmterrain = 1
    config_smooth_surfaces = true
    config_dzmin = 0.3
    config_nsm = 30
    config_tc_vertical_grid = true
    config_blend_bdy_terrain = false
/

&decomposition
    config_block_decomp_file_prefix = 'shenzhenvari.graph.info.part.'
/


&interpolation_control
    config_extrap_airtemp = 'linear'
/
&preproc_stages
    config_static_interp = false
    config_native_gwd_static = false
    config_vertical_grid = true
    config_met_interp = true
    config_input_sst = false
    config_frac_seaice = true
/
" > namelist.init_atmosphere
################first init_atmosphere################
echo '
<streams>
<immutable_stream name="input"
                  type="input"
                  filename_template="shenzhenvari.static.nc"
                  io_type="pnetcdf,cdf5"
                  input_interval="initial_only" />

<immutable_stream name="output"
                  type="output"
                  filename_template="shenzhenvari.init.nc"
                  io_type="pnetcdf,cdf5"
                  packages="initial_conds"
                  output_interval="initial_only" />


<immutable_stream name="lbc"
                  type="output"
                  filename_template="lbc.$Y-$M-$D_$h.$m.$s.nc"
                  filename_interval="output_interval"
                  io_type="pnetcdf,cdf5"
                  packages="lbcs"
                  output_interval="3:00:00" />

</streams>
' > streams.init_atmosphere
./init_atmosphere_model
################first init_atmosphere################
#                       ||
#                       ||
#                       \/
################Second init_atmosphere################
echo "
&nhyd_model
    config_init_case = 9
    config_start_time = '2023-09-07_03:00:00'
    config_stop_time = '2023-09-08_03:00:00'
    config_theta_adv_order = 3
    config_coef_3rd_order  = 0.25
/
&dimensions
    config_nvertlevels = 55
    config_nsoillevels = 4
    config_nfglevels = 38
    config_nfgsoillevels = 4
/
&data_sources
    config_geog_data_path = '/data/ess-liuzj/geog/WPS_GEOG/'
    config_met_prefix = 'GFS'
    config_fg_interval = 10800
    config_landuse_data = 'MODIFIED_IGBP_MODIS_NOAH'
    config_topo_data = 'GMTED2010'
    config_vegfrac_data = 'MODIS'
    config_albedo_data = 'MODIS'
    config_maxsnowalbedo_data = 'MODIS'
    config_supersample_factor = 3
    config_use_spechumd = false
/
&vertical_grid
    config_ztop = 30000.0
    config_nsmterrain = 1
    config_smooth_surfaces = true
    config_dzmin = 0.3
    config_nsm = 30
    config_tc_vertical_grid = true
    config_blend_bdy_terrain = false
/

&decomposition
    config_block_decomp_file_prefix = 'shenzhenvari.graph.info.part.'
/
&interpolation_control
    config_extrap_airtemp = 'linear'
/
&preproc_stages
    config_static_interp = false
    config_native_gwd_static = false
    config_vertical_grid = true
    config_met_interp = true
    config_input_sst = false
    config_frac_seaice = true
/
" > namelist.init_atmosphere
################first init_atmosphere################
echo '
<streams>
<immutable_stream name="input"
                  type="input"
                  filename_template="shenzhenvari.init.nc"
                  io_type="pnetcdf,cdf5"
                  input_interval="initial_only" />

<immutable_stream name="output"
                  type="output"
                  filename_template="foo.nc"
                  io_type="pnetcdf,cdf5"
                  packages="initial_conds"
                  output_interval="initial_only" />


<immutable_stream name="lbc"
                  type="output"
                  filename_template="lbc.$Y-$M-$D_$h.$m.$s.nc"
                  filename_interval="output_interval"
                  io_type="pnetcdf,cdf5"
                  packages="lbcs"
                  output_interval="3:00:00" />

</streams>
' > streams.init_atmosphere
./init_atmosphere_model
################first init_atmosphere################




################      atmosphere      ################
echo "
&nhyd_model
    config_time_integration_order = 2
    config_dt = 15.0
    config_start_time = '2023-09-07_03:00:00'
    config_run_duration = '1_00:00:00'
    config_split_dynamics_transport = true
    config_number_of_sub_steps = 2
    config_dynamics_split_steps = 3
    config_h_mom_eddy_visc2 = 0.0
    config_h_mom_eddy_visc4 = 0.0
    config_v_mom_eddy_visc2 = 0.0
    config_h_theta_eddy_visc2 = 0.0
    config_h_theta_eddy_visc4 = 0.0
    config_v_theta_eddy_visc2 = 0.0
    config_horiz_mixing = '2d_smagorinsky'
    config_len_disp = 3000.0
    config_visc4_2dsmag = 0.05
    config_w_adv_order = 3
    config_theta_adv_order = 3
    config_scalar_adv_order = 3
    config_u_vadv_order = 3
    config_w_vadv_order = 3
    config_theta_vadv_order = 3
    config_scalar_vadv_order = 3
    config_scalar_advection = true
    config_positive_definite = false
    config_monotonic = true
    config_coef_3rd_order = 0.25
    config_epssm = 0.1
    config_smdiv = 0.1
/
&damping
    config_zd = 22000.0
    config_xnutr = 0.2
/
&limited_area
    config_apply_lbcs = true
/
&io
    config_pio_num_iotasks = 0
    config_pio_stride = 1
/
&decomposition
    config_block_decomp_file_prefix = 'shenzhenvari.graph.info.part.'
/
&restart
    config_do_restart = false
/
&printout
    config_print_global_minmax_vel = true
    config_print_detailed_minmax_vel = false
/
&IAU
    config_IAU_option = 'off'
    config_IAU_window_length_s = 21600.
/
&physics
    config_sst_update = false
    config_sstdiurn_update = false
    config_deepsoiltemp_update = false
    config_radtlw_interval = '00:30:00'
    config_radtsw_interval = '00:30:00'
    config_bucket_update = 'none'
    config_physics_suite = 'convection_permitting'
/
&soundings
    config_sounding_interval = 'none'
/

"> namelist.atmosphere


################      atmosphere      ################
echo '
<streams>
<immutable_stream name="input"
                  type="input"
                  filename_template="shenzhenvari.init.nc"
                  io_type="pnetcdf,cdf5"
                  input_interval="initial_only" />

<immutable_stream name="restart"
                  type="input;output"
                  filename_template="restart.$Y-$M-$D_$h.$m.$s.nc"
                  io_type="pnetcdf,cdf5"
                  input_interval="initial_only"
                  output_interval="1_00:00:00" />

<stream name="output"
        type="output"
        io_type="pnetcdf,cdf5"
        filename_template="history.$Y-$M-$D_$h.$m.$s.nc"
        output_interval="6:00:00" >

  <file name="stream_list.atmosphere.output"/>
</stream>

<stream name="diagnostics"
        type="output"
        io_type="pnetcdf,cdf5"
        filename_template="diag.$Y-$M-$D_$h.$m.$s.nc"
        output_interval="3:00:00" >

    <file name="stream_list.atmosphere.diagnostics"/>
</stream>

<stream name="main"
        type="output"
        io_type="pnetcdf,cdf5"
        filename_template="main.$Y-$M-$D_$h.$m.$s.nc"
        output_interval="00:30:00" >

        <file name="stream_list.atmosphere.main"/>
</stream>

<immutable_stream name="lbc_in"
                  type="input"
                  filename_template="lbc.$Y-$M-$D_$h.$m.$s.nc"
                  filename_interval="input_interval"
                  io_type="pnetcdf,cdf5"
                  packages="limited_area"
                  input_interval="3:00:00" />

</streams>

' > streams.atmosphere
################      atmosphere      ################


echo '
#!/bin/bash
#BSUB -q medium
#BSUB -J atmosphere_model
#BSUB -n 240
#BSUB -e %J.err
#BSUB -o %J.out
#BSUB -R "span[ptile=40]"

mpirun -n 240 ./atmosphere_model
' > test.rsl

bsub < test.rsl
