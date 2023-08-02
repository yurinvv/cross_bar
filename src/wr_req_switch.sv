module wr_req_switch(
	wr_req_if.in   i_wr_req_port0,
	wr_req_if.out  o_wr_req_port0,
	wr_req_if.out  o_wr_req_port1
);
	
	localparam M0 = 0,
			   M1 = 1;
		
	always_comb begin
		case (i_wr_req_port0.sel)
		M1: 
			begin
			o_wr_req_port1.sel   = i_wr_req_port0.sel  ;
			o_wr_req_port1.addr  = i_wr_req_port0.addr ;
			o_wr_req_port1.wdata = i_wr_req_port0.wdata;
			o_wr_req_port1.req   = i_wr_req_port0.req  ;
			end
		default:
			begin
			o_wr_req_port1.sel   = '0;
			o_wr_req_port1.addr  = '0;
			o_wr_req_port1.wdata = '0;
			o_wr_req_port1.req   = '0;
			end
		endcase
	end
	
	always_comb begin
		case (i_wr_req_port0.sel)
		M0: 
			begin
			o_wr_req_port0.sel   = i_wr_req_port0.sel  ;
			o_wr_req_port0.addr  = i_wr_req_port0.addr ;
			o_wr_req_port0.wdata = i_wr_req_port0.wdata;
			o_wr_req_port0.req   = i_wr_req_port0.req  ;
			end
		default:
			begin
			o_wr_req_port0.sel   = '0;
			o_wr_req_port0.addr  = '0;
			o_wr_req_port0.wdata = '0;
			o_wr_req_port0.req   = '0;
			end
		endcase
	end

endmodule