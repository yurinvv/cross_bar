module rd_req_switch#(
	parameter AWIDTH = 32,
	parameter MATSER_NUM = 2 // number of base master ports from cross-bar
)(
	rd_req_if.slave   s0_rd_req_port,
	rd_req_if.master  m0_rd_req_port,
	rd_req_if.master  m1_rd_req_port
);
	
	localparam M0 = 2'b01,
			   M1 = 2'b10;
		
	always_comb begin
		case (s0_rd_req_port.wren)
		M0: 
			begin
			m0_rd_req_port.req       = s0_rd_req_port.req;
			m0_rd_req_port.addr      = s0_rd_req_port.addr;
			m0_rd_req_port.wren      = s0_rd_req_port.wren;
			s0_rd_req_port.rd_en     = m0_rd_req_port.rd_en;
			s0_rd_req_port.fifo_full = m0_rd_req_port.fifo_full;
			end
		default:
			begin
			m1_rd_req_port.req       = s0_rd_req_port.req;
			m1_rd_req_port.addr      = s0_rd_req_port.addr;
			m1_rd_req_port.wren      = s0_rd_req_port.wren;
			s0_rd_req_port.rd_en     = m1_rd_req_port.rd_en;
			s0_rd_req_port.fifo_full = m1_rd_req_port.fifo_full;
			end
		endcase
	end

endmodule