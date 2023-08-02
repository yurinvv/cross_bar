module rd_req_switch#(
	parameter AWIDTH = 32,
	parameter MATSER_NUM = 2 // number of base master ports from cross-bar
)(
	rd_req_if.slave   s0_rd_req_port,
	rd_req_if.master  m0_rd_req_port,
	rd_req_if.master  m1_rd_req_port
);
	
	localparam M0 = 1'b0,
			   M1 = 1'b1;
    wire sel = s0_rd_req_port.addr[AWIDTH-1];
		
	always_comb begin
		case (sel)
		M0: 
			begin
			m0_rd_req_port.req       = s0_rd_req_port.req;
			m0_rd_req_port.addr      = s0_rd_req_port.addr;
			m0_rd_req_port.wren      = s0_rd_req_port.wren;
			end
		default:
			begin
			m0_rd_req_port.req       = '0;
			m0_rd_req_port.addr      = '0;
			m0_rd_req_port.wren      = '0;
			end
		endcase
	end

	always_comb begin
		case (sel)
		M1: 
			begin
			m1_rd_req_port.req       = s0_rd_req_port.req;
			m1_rd_req_port.addr      = s0_rd_req_port.addr;
			m1_rd_req_port.wren      = s0_rd_req_port.wren;
			end
		default:
			begin
			m1_rd_req_port.req       = '0;
			m1_rd_req_port.addr      = '0;
			m1_rd_req_port.wren      = '0;
			end
		endcase
	end	
	
	always_comb begin
		case (sel)
		M0: 
			begin
			s0_rd_req_port.fifo_full = m0_rd_req_port.fifo_full;
			end
		M1: 
			begin
			s0_rd_req_port.fifo_full = m1_rd_req_port.fifo_full;
			end
		endcase
	end	
	
endmodule