class ArbitrWriteTest1 #(string NAME = "Write Test for Master 1 Arbiter") extends BaseTest#(.NAME(NAME));
	
	function new();
		super.new();
		sequence_s0_path = "./arb1_wr_req_seq_s0.txt";
		sequence_s1_path = "./arb1_wr_req_seq_s1.txt";
		//sequence_m0_path = "./arb0_wr_resp_seq_m0.txt";
		//sequence_m1_path = "./arb0_wr_resp_seq_m1.txt";

		//ref_sequence_s0_path = "./arb0_wr_resp_seq_s0.txt";
		//ref_sequence_s1_path = "./arb0_wr_resp_seq_s1.txt";
		ref_sequence_m0_path = "./arb1_wr_req_seq_m0.txt";
		ref_sequence_m1_path = "./arb1_wr_req_seq_m1.txt";
		
		readReqSequence(sequence_s0_path,      sequence_s0    );		
		readReqSequence(sequence_s1_path,      sequence_s1    );		
		readReqSequence(ref_sequence_m0_path,  ref_sequence_m0);		
		readReqSequence(ref_sequence_m1_path,  ref_sequence_m1);	

		readRespSequence(sequence_m0_path,     sequence_m0);
		readRespSequence(sequence_m1_path,     sequence_m1);
		readRespSequence(ref_sequence_s0_path, ref_sequence_s0);
		readRespSequence(ref_sequence_s1_path, ref_sequence_s1);
		
		environment0.setNo_respMaster0();		
		environment0.setNo_respMaster1();	
		
	endfunction
	
endclass