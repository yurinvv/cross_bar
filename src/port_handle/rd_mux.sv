module rd_mux(
	input sel,
	rd_if.in    i_rd_port0,
	rd_if.in    i_rd_port1,
	rd_if.out   o_rd_port
);

	localparam MASTER0 = 0,
	           MASTER1 = 1;

	always_comb begin
		case (sel)
		MASTER0:
			begin
			o_rd_port.rdata = i_rd_port0.rdata;
			o_rd_port.resp  = i_rd_port0.resp ;
			o_rd_port.ack   = i_rd_port0.ack  ;
			end
		MASTER1:
			begin
			o_rd_port.rdata = i_rd_port1.rdata;
			o_rd_port.resp  = i_rd_port1.resp ;
			o_rd_port.ack   = i_rd_port1.ack  ;
			end
		endcase
	end

endmodule