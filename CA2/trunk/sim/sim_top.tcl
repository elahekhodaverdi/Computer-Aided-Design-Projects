	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"tb"
	set hdl_path			"../src/hdl"
	set inc_path			"../src/inc"
	
	set run_time			"100 us"
#	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/absto2scomplement.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/activation.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/adder.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/and.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/and4.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/bit_multiplier.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/c1.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/c2.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/carryout.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/check.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/controller.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/datapath.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/dff.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/encoder.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/fulladder.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/maxnet.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/memory.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/multiplier.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mux2to1.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mux4to1.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/not.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/numberOR.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/or.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/or4.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/PU.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/register.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/s1.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/s2.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/xor.v

	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.v
	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


	add wave -binary -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/uut/*	
	add wave -hex -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	