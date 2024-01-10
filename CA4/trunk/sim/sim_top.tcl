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
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/4_inc.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/adder.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/adder12.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/buffer_4.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/buffer_8.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/controller.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/convolution.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/counter.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/datapath.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/memory.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/multiplier.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mux2.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/register1.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/register4.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/PE.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mac.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/decoder.sv
	

	
	vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM 	./tb/$TB.sv
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
	