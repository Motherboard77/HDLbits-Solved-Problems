#! /usr/bin/vvp
:ivl_version "12.0 (stable)";
:ivl_delay_selection "TYPICAL";
:vpi_time_precision + 0;
:vpi_module "/usr/lib/x86_64-linux-gnu/ivl/system.vpi";
:vpi_module "/usr/lib/x86_64-linux-gnu/ivl/vhdl_sys.vpi";
:vpi_module "/usr/lib/x86_64-linux-gnu/ivl/vhdl_textio.vpi";
:vpi_module "/usr/lib/x86_64-linux-gnu/ivl/v2005_math.vpi";
:vpi_module "/usr/lib/x86_64-linux-gnu/ivl/va_math.vpi";
S_0x5b0c458344c0 .scope module, "top_module" "top_module" 2 1;
 .timescale 0 0;
    .port_info 0 /INPUT 1 "clk";
    .port_info 1 /INPUT 1 "areset";
    .port_info 2 /INPUT 1 "x";
    .port_info 3 /OUTPUT 1 "z";
o0x7fcb18ca1018 .functor BUFZ 1, C4<z>; HiZ drive
v0x5b0c45834700_0 .net "areset", 0 0, o0x7fcb18ca1018;  0 drivers
o0x7fcb18ca1048 .functor BUFZ 1, C4<z>; HiZ drive
v0x5b0c4587e0f0_0 .net "clk", 0 0, o0x7fcb18ca1048;  0 drivers
v0x5b0c4587e1b0_0 .var "input_one_flag", 0 0;
o0x7fcb18ca10a8 .functor BUFZ 1, C4<z>; HiZ drive
v0x5b0c4587e280_0 .net "x", 0 0, o0x7fcb18ca10a8;  0 drivers
v0x5b0c4587e340_0 .var "z", 0 0;
v0x5b0c4587e400_0 .var "z_cap_reg", 0 0;
E_0x5b0c45834db0 .event anyedge, v0x5b0c4587e400_0;
E_0x5b0c45835080 .event posedge, v0x5b0c45834700_0, v0x5b0c4587e0f0_0;
    .scope S_0x5b0c458344c0;
T_0 ;
    %wait E_0x5b0c45835080;
    %load/vec4 v0x5b0c45834700_0;
    %flag_set/vec4 8;
    %jmp/0xz  T_0.0, 8;
    %pushi/vec4 0, 0, 1;
    %assign/vec4 v0x5b0c4587e1b0_0, 0;
    %pushi/vec4 0, 0, 1;
    %assign/vec4 v0x5b0c4587e400_0, 0;
    %jmp T_0.1;
T_0.0 ;
    %load/vec4 v0x5b0c4587e1b0_0;
    %flag_set/vec4 8;
    %jmp/0xz  T_0.2, 8;
    %load/vec4 v0x5b0c4587e280_0;
    %inv;
    %assign/vec4 v0x5b0c4587e400_0, 0;
    %jmp T_0.3;
T_0.2 ;
    %load/vec4 v0x5b0c4587e280_0;
    %cmpi/e 1, 0, 1;
    %jmp/0xz  T_0.4, 4;
    %pushi/vec4 1, 0, 1;
    %assign/vec4 v0x5b0c4587e1b0_0, 0;
    %load/vec4 v0x5b0c4587e280_0;
    %assign/vec4 v0x5b0c4587e400_0, 0;
T_0.4 ;
T_0.3 ;
T_0.1 ;
    %jmp T_0;
    .thread T_0;
    .scope S_0x5b0c458344c0;
T_1 ;
    %wait E_0x5b0c45834db0;
    %load/vec4 v0x5b0c4587e400_0;
    %assign/vec4 v0x5b0c4587e340_0, 0;
    %jmp T_1;
    .thread T_1, $push;
# The file index is used to find the file name in the following table.
:file_names 3;
    "N/A";
    "<interactive>";
    "moore_twos_comp_FSM.v";
