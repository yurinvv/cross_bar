proc getScriptDirectory {} {
    set dispScriptFile [file normalize [info script]]
    set scriptFolder [file dirname $dispScriptFile]
    return $scriptFolder
}

set scriptDir [getScriptDirectory]

# Set the project name
set proj_name_ "cross_bar_project"

# Create project
create_project proj_name_ ${scriptDir}/prj -part xc7k160tfbg676-3

set src_files [list \
 [file normalize "${scriptDir}/src/hdl/port_handle/ack_controller.sv" ]\
 [file normalize "${scriptDir}/src/hdl/arbiter/arbiter.sv" ]\
 [file normalize "${scriptDir}/src/hdl/arbiter/arbiter_controller.sv" ]\
 [file normalize "${scriptDir}/src/hdl/buses/cross_bar_if.sv" ]\
 [file normalize "${scriptDir}/src/hdl/arbiter/fifo.sv" ]\
 [file normalize "${scriptDir}/src/hdl/port_handle/port_handler.sv" ]\
 [file normalize "${scriptDir}/src/hdl/buses/rd_if.sv" ]\
 [file normalize "${scriptDir}/src/hdl/port_handle/rd_req_controller.sv" ]\
 [file normalize "${scriptDir}/src/hdl/buses/rd_req_if.sv" ]\
 [file normalize "${scriptDir}/src/hdl/switchs/rd_req_switch.sv" ]\
 [file normalize "${scriptDir}/src/hdl/port_handle/wr_req_controller.sv" ]\
 [file normalize "${scriptDir}/src/hdl/port_handle/resp_arbiter.sv" ]\
 [file normalize "${scriptDir}/src/hdl/port_handle/resp_separator.sv" ]\
 [file normalize "${scriptDir}/src/hdl/port_handle/rd_req_counter.sv" ]\
 [file normalize "${scriptDir}/src/hdl/buses/wr_req_if.sv" ]\
 [file normalize "${scriptDir}/src/hdl/switchs/wr_req_switch.sv" ]\
 [file normalize "${scriptDir}/src/hdl/cross_bar.sv" ]\
]

set sim_files [list \
 [file normalize "${scriptDir}/test/verification/RespDataTransaction.svh" ]\
 [file normalize "${scriptDir}/test/verification/Transaction.svh" ]\
 [file normalize "${scriptDir}/test/verification/Sequencer.svh" ]\
 [file normalize "${scriptDir}/test/verification/RequestTransaction.svh" ]\
 [file normalize "${scriptDir}/test/verification/Monitor.svh" ]\
 [file normalize "${scriptDir}/test/verification/Driver.svh" ]\
 [file normalize "${scriptDir}/test/verification/test5/ArbitrReadTest0.svh" ]\
 [file normalize "${scriptDir}/test/verification/DriverReq.svh" ]\
 [file normalize "${scriptDir}/test/verification/test1/DirectWriteTest.svh" ]\
 [file normalize "${scriptDir}/test/verification/MonitorResp.svh" ]\
 [file normalize "${scriptDir}/test/verification/DriverResp.svh" ]\
 [file normalize "${scriptDir}/test/verification/MonitorReq.svh" ]\
 [file normalize "${scriptDir}/test/verification/Agent.svh" ]\
 [file normalize "${scriptDir}/test/verification/Scoreboard.svh" ]\
 [file normalize "${scriptDir}/test/verification/test7/ArbitrWriteTest0.svh" ]\
 [file normalize "${scriptDir}/test/verification/Environment.svh" ]\
 [file normalize "${scriptDir}/test/verification/BaseTest.svh" ]\
 [file normalize "${scriptDir}/test/verification/test2/DirectReadTest.svh" ]\
 [file normalize "${scriptDir}/test/verification/test3/CrossWriteTest.svh" ]\
 [file normalize "${scriptDir}/test/verification/test4/CrossReadTest.svh" ]\
 [file normalize "${scriptDir}/test/verification/test6/ArbitrReadTest1.svh" ]\
 [file normalize "${scriptDir}/test/verification/test8/ArbitrWriteTest1.svh" ]\
 [file normalize "${scriptDir}/test/verification/tb_pckg.sv" ]\
 [file normalize "${scriptDir}/test/verification/tb.sv" ]\
 [file normalize "${scriptDir}/test/verification/test8/resquests/arb1_wr_req_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test5/resquests/arb0_rd_req_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test5/resquests/arb0_rd_req_seq_s0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test4/responces/cross_rd_resp_seq_s0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test3/requests/cross_req_seq_s0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test4/responces/cross_rd_resp_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test5/responces/arb0_rd_resp_seq_s0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test6/resquests/arb1_rd_req_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test8/responces/arb1_wr_resp_seq_s0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test5/resquests/arb0_rd_req_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test5/resquests/arb0_rd_req_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test6/responces/arb1_rd_resp_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test6/responces/arb1_rd_resp_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test8/responces/arb1_wr_resp_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test8/responces/arb1_wr_resp_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test8/resquests/arb1_wr_req_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test3/requests/cross_req_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test4/responces/cross_rd_resp_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test4/responces/cross_rd_resp_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test3/requests/cross_req_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test6/resquests/arb1_rd_req_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test7/resquests/arb0_wr_req_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test8/responces/arb1_wr_resp_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test6/responces/arb1_rd_resp_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test7/resquests/arb0_wr_req_seq_s0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test6/responces/arb1_rd_resp_seq_s0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test5/responces/arb0_rd_resp_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test7/responces/arb0_wr_resp_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test7/responces/arb0_wr_resp_seq_s0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test5/responces/arb0_rd_resp_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test5/responces/arb0_rd_resp_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test2/responces/dir_resp_seq_s0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test4/resquests/cross_rd_req_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test7/responces/arb0_wr_resp_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test2/resquests/dir_req_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test4/resquests/cross_rd_req_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test2/responces/dir_resp_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test1/dir_wr_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test2/responces/dir_resp_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test2/resquests/dir_req_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test7/responces/arb0_wr_resp_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test1/dir_wr_seq_s0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test2/responces/dir_resp_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test4/resquests/cross_rd_req_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test7/resquests/arb0_wr_req_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test4/resquests/cross_rd_req_seq_s0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test2/resquests/dir_req_seq_s0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test3/requests/cross_req_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test1/dir_wr_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test8/resquests/arb1_wr_req_seq_s1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test7/resquests/arb0_wr_req_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test6/resquests/arb1_rd_req_seq_m0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test1/dir_wr_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test2/resquests/dir_req_seq_m1.txt" ]\
 [file normalize "${scriptDir}/test/verification/test6/resquests/arb1_rd_req_seq_s0.txt" ]\
 [file normalize "${scriptDir}/test/verification/test8/resquests/arb1_wr_req_seq_s0.txt" ]\
]

add_files -fileset sources_1 $src_files
add_files -fileset constrs_1 -norecurse ${scriptDir}/src/constr.xdc
add_files -fileset sim_1 $sim_files