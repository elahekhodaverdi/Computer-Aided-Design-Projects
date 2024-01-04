	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"convolutionTB"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	#set run_time			"1 us"
	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/4_inc.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/adder.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/adder12.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/buffer_4.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/buffer_8.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/controller.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/convolution.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/counter.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/datapath.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/memory.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/multiplier.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mux2.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/register1.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/register4.v
		
	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/conv/*	
	add wave -hex -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	