
`timescale 1 ns / 1 ps

	module SVM_IP_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S_AXI
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		parameter integer C_S_AXI_ADDR_WIDTH	= 4,
		parameter integer WIDTH                 = 16,

		// Parameters of Axi Slave Bus Interface S_AXIS
		parameter integer C_S_AXIS_TDATA_WIDTH	= 32
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S_AXI
		input wire  s_axi_aclk,
		input wire  s_axi_aresetn,
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_awaddr,
		input wire [2 : 0] s_axi_awprot,
		input wire  s_axi_awvalid,
		output wire  s_axi_awready,
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_wdata,
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb,
		input wire  s_axi_wvalid,
		output wire  s_axi_wready,
		output wire [1 : 0] s_axi_bresp,
		output wire  s_axi_bvalid,
		input wire  s_axi_bready,
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_araddr,
		input wire [2 : 0] s_axi_arprot,
		input wire  s_axi_arvalid,
		output wire  s_axi_arready,
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_rdata,
		output wire [1 : 0] s_axi_rresp,
		output wire  s_axi_rvalid,
		input wire  s_axi_rready,

		// Ports of Axi Slave Bus Interface S_AXIS
		input wire  s_axis_aclk,
		input wire  s_axis_aresetn,
		output wire  s_axis_tready,
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] s_axis_tdata,
		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] s_axis_tstrb,
		input wire  s_axis_tlast,
		input wire  s_axis_tvalid,
		
		//INTERRUPT OUT
		output wire interrupt
	);
	
	//WIRES TO CONNECT MODULES
	
	//AXI LITE <-> MEM SUBM
	wire start_al2mm;
	wire start_mm2al;
	wire ready_mm2al;
	wire [3:0] cl_num_mm2al;
	wire [3:0] state_mm2al;
	//MEM SUBM <-> SVM
    wire start_mm2sv;
    wire ready_sv2mm;
    wire [3:0] cl_num_sv2mm;
    wire [3:0] state_sv2mm;
	//SVM <-> AXI STREAM
    wire [15:0] sdata_as2sv;
    wire svalid_as2sv;
    wire sready_sv2as;
    //SVM <-> BRAM
    wire [15:0] bdata_br2sv;
    wire [15:0] bdata_sv2br;
    wire [10:0] baddr_sv2br;
    wire we_sv2br;
    wire en_sv2br;
    //BRAM <-> GND
    wire [15:0] bdata_nul;
    wire [15:0] bdata_gnd;
    wire [10:0] baddr_gnd;
    wire we_gnd;
    wire en_gnd;
    assign bdata_gnd = 0;
    assign baddr_gnd = 0;
    assign we_gnd = 0;
    assign en_gnd = 0;
    
    
// Instantiation of Axi Bus Interface S_AXI
	SVM_IP_v1_0_S_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
	) SVM_IP_v1_0_S_AXI_inst (
		.S_AXI_ACLK(s_axi_aclk),
		.S_AXI_ARESETN(s_axi_aresetn),
		.S_AXI_AWADDR(s_axi_awaddr),
		.S_AXI_AWPROT(s_axi_awprot),
		.S_AXI_AWVALID(s_axi_awvalid),
		.S_AXI_AWREADY(s_axi_awready),
		.S_AXI_WDATA(s_axi_wdata),
		.S_AXI_WSTRB(s_axi_wstrb),
		.S_AXI_WVALID(s_axi_wvalid),
		.S_AXI_WREADY(s_axi_wready),
		.S_AXI_BRESP(s_axi_bresp),
		.S_AXI_BVALID(s_axi_bvalid),
		.S_AXI_BREADY(s_axi_bready),
		.S_AXI_ARADDR(s_axi_araddr),
		.S_AXI_ARPROT(s_axi_arprot),
		.S_AXI_ARVALID(s_axi_arvalid),
		.S_AXI_ARREADY(s_axi_arready),
		.S_AXI_RDATA(s_axi_rdata),
		.S_AXI_RRESP(s_axi_rresp),
		.S_AXI_RVALID(s_axi_rvalid),
		.S_AXI_RREADY(s_axi_rready),
		//user added ports
		.S_AXI_START_O(start_al2mm),
        .S_AXI_START_I(start_mm2al),
        .S_AXI_READY_I(ready_mm2al),
        .S_AXI_CL_NUM_I(cl_num_mm2al),
        .S_AXI_STATE_I(state_mm2al)
	);

// Instantiation of Axi Bus Interface S_AXIS
	SVM_IP_v1_0_S_AXIS # ( 
		.C_S_AXIS_TDATA_WIDTH(C_S_AXIS_TDATA_WIDTH)
	) SVM_IP_v1_0_S_AXIS_inst (
		.S_AXIS_ACLK(s_axis_aclk),
		.S_AXIS_ARESETN(s_axis_aresetn),
		.S_AXIS_TREADY(s_axis_tready),
		.S_AXIS_TDATA(s_axis_tdata),
		.S_AXIS_TSTRB(s_axis_tstrb),
		.S_AXIS_TLAST(s_axis_tlast),
		.S_AXIS_TVALID(s_axis_tvalid),
		//user added ports
		.SVM_SREADY(sready_sv2as),
        .SVM_SVALID(svalid_as2sv),
        .SVM_SDATA(sdata_as2sv)
	);

// Add user logic here
    //INstantiation of SVM
    SVM #
    (
    .WIDTH(WIDTH)
    )
    SVM_inst
    (
    //clock, reset
    .clk(s_axi_aclk),
    .reset(s_axi_aresetn),
    //status registers
    .start(start_mm2sv),
    .ready(ready_sv2mm),
    .cl_num(cl_num_sv2mm),
    .state(state_sv2mm),
    .interrupt(interrupt),
    //stream interface
    .sdata(sdata_as2sv),
    .svalid(svalid_as2sv),
    .sready(sready_sv2as),
    //bram interface
    .bdata_in(bdata_br2sv),
    .bdata_out(bdata_sv2br),
    .baddr(baddr_sv2br),
    .en(en_sv2br),
    .we(we_sv2br)
  
    );	
    // Instantiation of Memory Submodule
    memory_submodul
    MEM_SUBM_inst
    (
    .clk(s_axi_aclk),
    .reset(s_axi_aresetn),
    //start
    .start_axi_i(start_al2mm),
    .start_axi_o(start_mm2al),
    .start_svm_o(start_mm2sv),
    //ready
    .ready_axi_o(ready_mm2al),
    .ready_svm_i(ready_sv2mm),
    //classified number
    .cl_num_axi_o(cl_num_mm2al),
    .cl_num_svm_i(cl_num_sv2mm),
    //status
    .state_axi_o(state_mm2al),
    .state_svm_i(state_sv2mm)
    );
    
    BRAM #
    (
    .WADDR(10),
    .WDATA(WIDTH)
    )BRAM_inst
    (
    .pi_clka(s_axi_aclk),
    .pi_ena(en_sv2br),
    .pi_wea(we_sv2br),
    .pi_addra(baddr_sv2br),
    .pi_dia(bdata_sv2br),
    .po_doa(bdata_br2sv),
    
    .pi_clkb(s_axi_aclk),
    .pi_enb(en_gnd),
    .pi_web(we_gnd),
    .pi_addrb(baddr_gnd),
    .pi_dib(bdata_gnd),
    .po_dob(bdata_nul)
    );
    
    
	// User logic ends

	endmodule
