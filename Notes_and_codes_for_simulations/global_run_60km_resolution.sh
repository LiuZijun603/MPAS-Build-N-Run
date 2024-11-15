#Your test dir
Test_dir="/data/ess-liuzj/0907case/test/"
mesh_dir="/data/ess-liuzj/mpas_tutorial/mesh/60km/"
mesh_file="x1.163842.grid.nc"

cd ${Test_dir}
rm -rf 60km
mkdir 60km
cd 60km

#This command do not need change
ln -s ${mesh_dir}${mesh_file} .
static_file_true=1 # 1: static.nc exist; 0: no static.nc 
if static_file_true==1;then
    ln -s ${mesh_dir}*static.nc .
fi
ln -s /work/ess-liuzj/MPAS-Model-7.3/init_atmosphere_model .
ln -s /work/ess-liuzj/MPAS-Model-7.3/atmosphere_model .
ln -s /data/ess-liuzj/gfs/2023_09-07_08/GFS\:2023-09-0* .
cp /work/ess-liuzj/MPAS-Model-7.3/stream_list.atmosphere.* .
ln -s /work/ess-liuzj/MPAS-Model-7.3/src/core_atmosphere/physics/physics_wrf/files/* .

#This echo does not need change
if static_file_true==0;then
echo "
&nhyd_model
    config_init_case = 7

/
&data_sources
    config_geog_data_path = '/data/ess-liuzj/geog/WPS_GEOG/'
    config_landuse_data = 'MODIFIED_IGBP_MODIS_NOAH'
    config_topo_data = 'GMTED2010'
    config_vegfrac_data = 'MODIS'
    config_albedo_data = 'MODIS'
    config_maxsnowalbedo_data = 'MODIS'
    config_supersample_factor = 3

/

&preproc_stages
    config_static_interp = true
    config_native_gwd_static = true
    config_vertical_grid = false
    config_met_interp = false
    config_input_sst = false
    config_frac_seaice = false
/
" > namelist.init_atmosphere


##########################You should change "/15km/x1.163842.grid.nc"
echo '
<streams>
<immutable_stream name="input"
                  type="input"
                  filename_template="/data/ess-liuzj/mpas_tutorial/mesh/60km/x1.163842.grid.nc"
                  input_interval="initial_only" />

<immutable_stream name="output"
                  type="output"
                  filename_template="x1.163842.static.nc"
                  packages="initial_conds"
                  output_interval="initial_only" />

</streams>
' > streams.init_atmosphere

#This command do not need change. Generate the static file
./init_atmosphere_model
fi

##########################(3)config_met_prefix, GFS as usual
echo "
&nhyd_model
    config_init_case = 7
    config_start_time = '2023-09-07_03:00:00'
/
&dimensions
    config_nvertlevels = 55
    config_nsoillevels = 4
    config_nfglevels = 38
    config_nfgsoillevels = 4
/
&data_sources
    config_met_prefix = 'GFS'
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
&interpolation_control
    config_extrap_airtemp = 'lapse-rate'
/
&preproc_stages
    config_static_interp = false
    config_native_gwd_static = false
    config_vertical_grid = true
    config_met_interp = true
    config_input_sst = false
    config_frac_seaice = true
/" > namelist.init_atmosphere

##########################You should change the file name
echo '
<streams>
<immutable_stream name="input"
                  type="input"
                  filename_template="x1.163842.static.nc"
                  input_interval="initial_only" />

<immutable_stream name="output"
                  type="output"
                  filename_template="x1.163842.init.nc"
                  io_type="pnetcdf,cdf5"
                  packages="initial_conds"
                  output_interval="initial_only" />

</streams>
' > streams.init_atmosphere

#This command do not need change. Generate the init file
./init_atmosphere_model


##########################You should change the (1)config_dt, (2)start_time
##########################(3)run_duration, (4)config_len_disp
##########################(5)'x1.163842.graph.info.part.'
echo "
&nhyd_model
    config_time_integration_order = 2
    config_dt = 300.0
    config_start_time = '2023-09-07_03:00:00'
    config_run_duration = '1_01:00:00'
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
    config_len_disp = 60000.0
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
    config_apply_lbcs = false
/
&io
    config_pio_num_iotasks = 0
    config_pio_stride = 1
/
&decomposition
    config_block_decomp_file_prefix = 'x1.163842.graph.info.part.'
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

##########################You should change the (1)"x1.163842.init.nc"
echo '
<streams>
<immutable_stream name="input"
                  type="input"
                  filename_template="x1.163842.init.nc"
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
        output_interval="01:00:00" >

  <file name="stream_list.atmosphere.main"/>
</stream>

</streams>
' > streams.atmosphere

cd ${mesh_dir}
##########################You should change the (1)"x1.163842.init.nc"
##########################(2) 40 is the num of cores
gpmetis -minconn -contig -niter=200 x1.163842.graph.info 40

cd -
##########################You should change the (1)"x1.163842.init.nc"
ln -s ${mesh_dir}"x1.163842.graph.info.part.40" .

echo '
#!/bin/bash
#BSUB -q debug
#BSUB -J atmosphere_model
#BSUB -n 40
#BSUB -e %J.err
#BSUB -o %J.out
#BSUB -R "span[ptile=40]"

mpirun -n 40 ./atmosphere_model
' > test.rsl

bsub < test.rsl

