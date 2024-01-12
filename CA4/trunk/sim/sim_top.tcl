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
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/adder.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/adder12.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/buffer.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/conv_cu.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/conv_dp.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/conv.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/decoder.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mac.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mem_reader_cu.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mem_reader_dp.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mem_reader.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/memory.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/multiplier.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/mux2.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/pe_cu.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/pe_dp.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/PE.sv
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/register4.sv
	

	
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
	