module AXI2CSB( // @[:@11.2]
  input         clock, // @[:@12.4]
  input         reset, // @[:@13.4]
  output        io_csb_csb2nvdla_valid, // @[:@14.4]
  input         io_csb_csb2nvdla_ready, // @[:@14.4]
  output [15:0] io_csb_csb2nvdla_addr, // @[:@14.4]
  output [31:0] io_csb_csb2nvdla_wdat, // @[:@14.4]
  output        io_csb_csb2nvdla_write, // @[:@14.4]
  input         io_csb_nvdla2csb_valid, // @[:@14.4]
  input  [31:0] io_csb_nvdla2csb_data, // @[:@14.4]
  input         io_csb_nvdla2csb_wr_complete, // @[:@14.4]
  input  [17:0] io_axi_awaddr, // @[:@14.4]
  input         io_axi_awvalid, // @[:@14.4]
  output        io_axi_awready, // @[:@14.4]
  input  [31:0] io_axi_wdata, // @[:@14.4]
  input         io_axi_wvalid, // @[:@14.4]
  output        io_axi_wready, // @[:@14.4]
  output        io_axi_bvalid, // @[:@14.4]
  input         io_axi_bready, // @[:@14.4]
  input  [17:0] io_axi_araddr, // @[:@14.4]
  input         io_axi_arvalid, // @[:@14.4]
  output        io_axi_arready, // @[:@14.4]
  output [31:0] io_axi_rdata, // @[:@14.4]
  output        io_axi_rvalid, // @[:@14.4]
  input         io_axi_rready // @[:@14.4]
);
  reg [31:0] addr_data_reg; // @[AXI2CSB.scala 19:26:@16.4]
  reg [31:0] _RAND_0;
  wire  txn_send; // @[AXI2CSB.scala 21:41:@17.4]
  wire  wr_resp; // @[AXI2CSB.scala 22:31:@18.4]
  wire  rd_resp; // @[AXI2CSB.scala 23:31:@19.4]
  reg [3:0] curr_state; // @[AXI2CSB.scala 28:27:@21.4]
  reg [31:0] _RAND_1;
  wire  _T_105; // @[Conditional.scala 37:30:@25.4]
  wire  _T_106; // @[AXI2CSB.scala 37:30:@29.8]
  wire [3:0] _GEN_0; // @[AXI2CSB.scala 43:36:@42.14]
  wire [3:0] _GEN_1; // @[AXI2CSB.scala 41:35:@38.12]
  wire [3:0] _GEN_2; // @[AXI2CSB.scala 39:36:@34.10]
  wire [3:0] _GEN_3; // @[AXI2CSB.scala 37:48:@30.8]
  wire [3:0] _GEN_4; // @[AXI2CSB.scala 36:37:@28.6]
  wire  _T_107; // @[Conditional.scala 37:30:@48.6]
  wire  _T_108; // @[Conditional.scala 37:30:@53.8]
  wire  _T_109; // @[Conditional.scala 37:30:@58.10]
  wire  _T_110; // @[AXI2CSB.scala 56:36:@61.12]
  wire [3:0] _GEN_5; // @[AXI2CSB.scala 56:54:@62.12]
  wire  _T_111; // @[Conditional.scala 37:30:@67.12]
  wire  _T_112; // @[AXI2CSB.scala 62:36:@70.14]
  wire [3:0] _GEN_6; // @[AXI2CSB.scala 62:55:@71.14]
  wire  _T_113; // @[Conditional.scala 37:30:@76.14]
  wire [3:0] _GEN_7; // @[AXI2CSB.scala 68:23:@79.16]
  wire  _T_114; // @[Conditional.scala 37:30:@84.16]
  wire  _T_115; // @[Conditional.scala 37:30:@92.18]
  wire  _T_116; // @[Conditional.scala 37:30:@100.20]
  wire [3:0] _GEN_8; // @[AXI2CSB.scala 86:43:@103.22]
  wire  _T_117; // @[Conditional.scala 37:30:@108.22]
  wire [3:0] _GEN_9; // @[AXI2CSB.scala 92:22:@111.24]
  wire  _T_118; // @[Conditional.scala 37:30:@116.24]
  wire [3:0] _GEN_10; // @[AXI2CSB.scala 98:23:@119.26]
  wire  _T_119; // @[Conditional.scala 37:30:@124.26]
  wire [3:0] _GEN_11; // @[AXI2CSB.scala 104:37:@127.28]
  wire  _T_120; // @[Conditional.scala 37:30:@132.28]
  wire [3:0] _GEN_12; // @[AXI2CSB.scala 110:22:@135.30]
  wire [3:0] _GEN_13; // @[Conditional.scala 39:67:@133.28]
  wire [3:0] _GEN_14; // @[Conditional.scala 39:67:@125.26]
  wire [3:0] _GEN_15; // @[Conditional.scala 39:67:@117.24]
  wire [3:0] _GEN_16; // @[Conditional.scala 39:67:@109.22]
  wire [3:0] _GEN_17; // @[Conditional.scala 39:67:@101.20]
  wire [3:0] _GEN_18; // @[Conditional.scala 39:67:@93.18]
  wire [3:0] _GEN_19; // @[Conditional.scala 39:67:@85.16]
  wire [3:0] _GEN_20; // @[Conditional.scala 39:67:@77.14]
  wire [3:0] _GEN_21; // @[Conditional.scala 39:67:@68.12]
  wire [3:0] _GEN_22; // @[Conditional.scala 39:67:@59.10]
  wire [3:0] _GEN_23; // @[Conditional.scala 39:67:@54.8]
  wire [3:0] _GEN_24; // @[Conditional.scala 39:67:@49.6]
  wire [3:0] next_state; // @[Conditional.scala 40:58:@26.4]
  wire [15:0] _T_144; // @[AXI2CSB.scala 149:31:@179.16]
  wire [17:0] _GEN_33; // @[Conditional.scala 39:67:@216.24]
  wire [17:0] _GEN_41; // @[Conditional.scala 39:67:@210.22]
  wire [17:0] _GEN_49; // @[Conditional.scala 39:67:@206.20]
  wire [17:0] _GEN_55; // @[Conditional.scala 39:67:@196.18]
  wire [17:0] _GEN_66; // @[Conditional.scala 39:67:@187.16]
  wire [17:0] _GEN_78; // @[Conditional.scala 39:67:@177.14]
  wire [17:0] _GEN_90; // @[Conditional.scala 39:67:@173.12]
  wire [17:0] _GEN_102; // @[Conditional.scala 39:67:@169.10]
  wire [17:0] _GEN_115; // @[Conditional.scala 39:67:@164.8]
  wire [17:0] _GEN_128; // @[Conditional.scala 39:67:@159.6]
  wire [17:0] addr_in; // @[Conditional.scala 40:58:@155.4]
  wire [31:0] _GEN_26; // @[Conditional.scala 39:67:@228.28]
  wire [31:0] _GEN_29; // @[Conditional.scala 39:67:@224.26]
  wire  _GEN_31; // @[Conditional.scala 39:67:@224.26]
  wire [31:0] _GEN_35; // @[Conditional.scala 39:67:@216.24]
  wire  _GEN_37; // @[Conditional.scala 39:67:@216.24]
  wire  _GEN_40; // @[Conditional.scala 39:67:@210.22]
  wire [31:0] _GEN_43; // @[Conditional.scala 39:67:@210.22]
  wire  _GEN_45; // @[Conditional.scala 39:67:@210.22]
  wire  _GEN_47; // @[Conditional.scala 39:67:@206.20]
  wire  _GEN_48; // @[Conditional.scala 39:67:@206.20]
  wire [31:0] _GEN_51; // @[Conditional.scala 39:67:@206.20]
  wire  _GEN_53; // @[Conditional.scala 39:67:@206.20]
  wire  _GEN_54; // @[Conditional.scala 39:67:@196.18]
  wire [31:0] _GEN_56; // @[Conditional.scala 39:67:@196.18]
  wire  _GEN_60; // @[Conditional.scala 39:67:@196.18]
  wire  _GEN_61; // @[Conditional.scala 39:67:@196.18]
  wire [31:0] _GEN_62; // @[Conditional.scala 39:67:@196.18]
  wire  _GEN_64; // @[Conditional.scala 39:67:@196.18]
  wire  _GEN_65; // @[Conditional.scala 39:67:@187.16]
  wire [31:0] _GEN_67; // @[Conditional.scala 39:67:@187.16]
  wire  _GEN_68; // @[Conditional.scala 39:67:@187.16]
  wire  _GEN_70; // @[Conditional.scala 39:67:@187.16]
  wire  _GEN_72; // @[Conditional.scala 39:67:@187.16]
  wire  _GEN_73; // @[Conditional.scala 39:67:@187.16]
  wire [31:0] _GEN_74; // @[Conditional.scala 39:67:@187.16]
  wire  _GEN_76; // @[Conditional.scala 39:67:@187.16]
  wire  _GEN_77; // @[Conditional.scala 39:67:@177.14]
  wire [31:0] _GEN_79; // @[Conditional.scala 39:67:@177.14]
  wire  _GEN_80; // @[Conditional.scala 39:67:@177.14]
  wire  _GEN_81; // @[Conditional.scala 39:67:@177.14]
  wire  _GEN_82; // @[Conditional.scala 39:67:@177.14]
  wire  _GEN_84; // @[Conditional.scala 39:67:@177.14]
  wire  _GEN_85; // @[Conditional.scala 39:67:@177.14]
  wire [31:0] _GEN_86; // @[Conditional.scala 39:67:@177.14]
  wire  _GEN_88; // @[Conditional.scala 39:67:@177.14]
  wire  _GEN_89; // @[Conditional.scala 39:67:@173.12]
  wire [31:0] _GEN_91; // @[Conditional.scala 39:67:@173.12]
  wire  _GEN_92; // @[Conditional.scala 39:67:@173.12]
  wire  _GEN_93; // @[Conditional.scala 39:67:@173.12]
  wire  _GEN_94; // @[Conditional.scala 39:67:@173.12]
  wire  _GEN_96; // @[Conditional.scala 39:67:@173.12]
  wire  _GEN_97; // @[Conditional.scala 39:67:@173.12]
  wire [31:0] _GEN_98; // @[Conditional.scala 39:67:@173.12]
  wire  _GEN_100; // @[Conditional.scala 39:67:@173.12]
  wire  _GEN_101; // @[Conditional.scala 39:67:@169.10]
  wire [31:0] _GEN_103; // @[Conditional.scala 39:67:@169.10]
  wire  _GEN_104; // @[Conditional.scala 39:67:@169.10]
  wire  _GEN_105; // @[Conditional.scala 39:67:@169.10]
  wire  _GEN_106; // @[Conditional.scala 39:67:@169.10]
  wire  _GEN_108; // @[Conditional.scala 39:67:@169.10]
  wire  _GEN_109; // @[Conditional.scala 39:67:@169.10]
  wire [31:0] _GEN_110; // @[Conditional.scala 39:67:@169.10]
  wire  _GEN_112; // @[Conditional.scala 39:67:@169.10]
  wire  _GEN_113; // @[Conditional.scala 39:67:@164.8]
  wire  _GEN_114; // @[Conditional.scala 39:67:@164.8]
  wire [31:0] _GEN_116; // @[Conditional.scala 39:67:@164.8]
  wire  _GEN_117; // @[Conditional.scala 39:67:@164.8]
  wire  _GEN_118; // @[Conditional.scala 39:67:@164.8]
  wire  _GEN_120; // @[Conditional.scala 39:67:@164.8]
  wire  _GEN_121; // @[Conditional.scala 39:67:@164.8]
  wire [31:0] _GEN_122; // @[Conditional.scala 39:67:@164.8]
  wire  _GEN_124; // @[Conditional.scala 39:67:@164.8]
  wire  _GEN_125; // @[Conditional.scala 39:67:@159.6]
  wire  _GEN_126; // @[Conditional.scala 39:67:@159.6]
  wire  _GEN_127; // @[Conditional.scala 39:67:@159.6]
  wire [31:0] _GEN_129; // @[Conditional.scala 39:67:@159.6]
  wire  _GEN_130; // @[Conditional.scala 39:67:@159.6]
  wire  _GEN_132; // @[Conditional.scala 39:67:@159.6]
  wire  _GEN_133; // @[Conditional.scala 39:67:@159.6]
  wire [31:0] _GEN_134; // @[Conditional.scala 39:67:@159.6]
  wire  _GEN_136; // @[Conditional.scala 39:67:@159.6]
  wire  _T_168; // @[Conditional.scala 37:30:@233.4]
  wire [18:0] _T_170; // @[Cat.scala 30:58:@235.6]
  wire  _T_171; // @[Conditional.scala 37:30:@239.6]
  wire  _T_172; // @[Conditional.scala 37:30:@244.8]
  wire [31:0] _GEN_149; // @[Conditional.scala 39:67:@245.8]
  wire [31:0] _GEN_150; // @[Conditional.scala 39:67:@240.6]
  assign txn_send = io_csb_csb2nvdla_ready & io_csb_csb2nvdla_valid; // @[AXI2CSB.scala 21:41:@17.4]
  assign wr_resp = io_axi_bready & io_axi_bvalid; // @[AXI2CSB.scala 22:31:@18.4]
  assign rd_resp = io_axi_rready & io_axi_rvalid; // @[AXI2CSB.scala 23:31:@19.4]
  assign _T_105 = 4'h0 == curr_state; // @[Conditional.scala 37:30:@25.4]
  assign _T_106 = io_axi_awvalid & io_axi_wvalid; // @[AXI2CSB.scala 37:30:@29.8]
  assign _GEN_0 = io_axi_arvalid ? 4'ha : curr_state; // @[AXI2CSB.scala 43:36:@42.14]
  assign _GEN_1 = io_axi_wvalid ? 4'h2 : _GEN_0; // @[AXI2CSB.scala 41:35:@38.12]
  assign _GEN_2 = io_axi_awvalid ? 4'h1 : _GEN_1; // @[AXI2CSB.scala 39:36:@34.10]
  assign _GEN_3 = _T_106 ? 4'h7 : _GEN_2; // @[AXI2CSB.scala 37:48:@30.8]
  assign _GEN_4 = io_csb_csb2nvdla_ready ? _GEN_3 : curr_state; // @[AXI2CSB.scala 36:37:@28.6]
  assign _T_107 = 4'h1 == curr_state; // @[Conditional.scala 37:30:@48.6]
  assign _T_108 = 4'h2 == curr_state; // @[Conditional.scala 37:30:@53.8]
  assign _T_109 = 4'h3 == curr_state; // @[Conditional.scala 37:30:@58.10]
  assign _T_110 = io_csb_csb2nvdla_ready & io_axi_wvalid; // @[AXI2CSB.scala 56:36:@61.12]
  assign _GEN_5 = _T_110 ? 4'h6 : curr_state; // @[AXI2CSB.scala 56:54:@62.12]
  assign _T_111 = 4'h4 == curr_state; // @[Conditional.scala 37:30:@67.12]
  assign _T_112 = io_csb_csb2nvdla_ready & io_axi_awvalid; // @[AXI2CSB.scala 62:36:@70.14]
  assign _GEN_6 = _T_112 ? 4'h5 : curr_state; // @[AXI2CSB.scala 62:55:@71.14]
  assign _T_113 = 4'h6 == curr_state; // @[Conditional.scala 37:30:@76.14]
  assign _GEN_7 = txn_send ? 4'h8 : curr_state; // @[AXI2CSB.scala 68:23:@79.16]
  assign _T_114 = 4'h5 == curr_state; // @[Conditional.scala 37:30:@84.16]
  assign _T_115 = 4'h7 == curr_state; // @[Conditional.scala 37:30:@92.18]
  assign _T_116 = 4'h8 == curr_state; // @[Conditional.scala 37:30:@100.20]
  assign _GEN_8 = io_csb_nvdla2csb_wr_complete ? 4'h9 : curr_state; // @[AXI2CSB.scala 86:43:@103.22]
  assign _T_117 = 4'h9 == curr_state; // @[Conditional.scala 37:30:@108.22]
  assign _GEN_9 = wr_resp ? 4'h0 : curr_state; // @[AXI2CSB.scala 92:22:@111.24]
  assign _T_118 = 4'ha == curr_state; // @[Conditional.scala 37:30:@116.24]
  assign _GEN_10 = txn_send ? 4'hb : curr_state; // @[AXI2CSB.scala 98:23:@119.26]
  assign _T_119 = 4'hb == curr_state; // @[Conditional.scala 37:30:@124.26]
  assign _GEN_11 = io_csb_nvdla2csb_valid ? 4'hc : curr_state; // @[AXI2CSB.scala 104:37:@127.28]
  assign _T_120 = 4'hc == curr_state; // @[Conditional.scala 37:30:@132.28]
  assign _GEN_12 = rd_resp ? 4'h0 : curr_state; // @[AXI2CSB.scala 110:22:@135.30]
  assign _GEN_13 = _T_120 ? _GEN_12 : 4'h0; // @[Conditional.scala 39:67:@133.28]
  assign _GEN_14 = _T_119 ? _GEN_11 : _GEN_13; // @[Conditional.scala 39:67:@125.26]
  assign _GEN_15 = _T_118 ? _GEN_10 : _GEN_14; // @[Conditional.scala 39:67:@117.24]
  assign _GEN_16 = _T_117 ? _GEN_9 : _GEN_15; // @[Conditional.scala 39:67:@109.22]
  assign _GEN_17 = _T_116 ? _GEN_8 : _GEN_16; // @[Conditional.scala 39:67:@101.20]
  assign _GEN_18 = _T_115 ? _GEN_7 : _GEN_17; // @[Conditional.scala 39:67:@93.18]
  assign _GEN_19 = _T_114 ? _GEN_7 : _GEN_18; // @[Conditional.scala 39:67:@85.16]
  assign _GEN_20 = _T_113 ? _GEN_7 : _GEN_19; // @[Conditional.scala 39:67:@77.14]
  assign _GEN_21 = _T_111 ? _GEN_6 : _GEN_20; // @[Conditional.scala 39:67:@68.12]
  assign _GEN_22 = _T_109 ? _GEN_5 : _GEN_21; // @[Conditional.scala 39:67:@59.10]
  assign _GEN_23 = _T_108 ? 4'h4 : _GEN_22; // @[Conditional.scala 39:67:@54.8]
  assign _GEN_24 = _T_107 ? 4'h3 : _GEN_23; // @[Conditional.scala 39:67:@49.6]
  assign next_state = _T_105 ? _GEN_4 : _GEN_24; // @[Conditional.scala 40:58:@26.4]
  assign _T_144 = addr_data_reg[15:0]; // @[AXI2CSB.scala 149:31:@179.16]
  assign _GEN_33 = _T_118 ? io_axi_araddr : 18'h0; // @[Conditional.scala 39:67:@216.24]
  assign _GEN_41 = _T_117 ? 18'h0 : _GEN_33; // @[Conditional.scala 39:67:@210.22]
  assign _GEN_49 = _T_116 ? 18'h0 : _GEN_41; // @[Conditional.scala 39:67:@206.20]
  assign _GEN_55 = _T_115 ? io_axi_awaddr : _GEN_49; // @[Conditional.scala 39:67:@196.18]
  assign _GEN_66 = _T_114 ? io_axi_awaddr : _GEN_55; // @[Conditional.scala 39:67:@187.16]
  assign _GEN_78 = _T_113 ? {{2'd0}, _T_144} : _GEN_66; // @[Conditional.scala 39:67:@177.14]
  assign _GEN_90 = _T_111 ? 18'h0 : _GEN_78; // @[Conditional.scala 39:67:@173.12]
  assign _GEN_102 = _T_109 ? 18'h0 : _GEN_90; // @[Conditional.scala 39:67:@169.10]
  assign _GEN_115 = _T_108 ? 18'h0 : _GEN_102; // @[Conditional.scala 39:67:@164.8]
  assign _GEN_128 = _T_107 ? 18'h0 : _GEN_115; // @[Conditional.scala 39:67:@159.6]
  assign addr_in = _T_105 ? 18'h0 : _GEN_128; // @[Conditional.scala 40:58:@155.4]
  assign _GEN_26 = _T_120 ? addr_data_reg : 32'h0; // @[Conditional.scala 39:67:@228.28]
  assign _GEN_29 = _T_119 ? 32'h0 : _GEN_26; // @[Conditional.scala 39:67:@224.26]
  assign _GEN_31 = _T_119 ? 1'h0 : _T_120; // @[Conditional.scala 39:67:@224.26]
  assign _GEN_35 = _T_118 ? 32'h0 : _GEN_29; // @[Conditional.scala 39:67:@216.24]
  assign _GEN_37 = _T_118 ? 1'h0 : _GEN_31; // @[Conditional.scala 39:67:@216.24]
  assign _GEN_40 = _T_117 ? 1'h0 : _T_118; // @[Conditional.scala 39:67:@210.22]
  assign _GEN_43 = _T_117 ? 32'h0 : _GEN_35; // @[Conditional.scala 39:67:@210.22]
  assign _GEN_45 = _T_117 ? 1'h0 : _GEN_37; // @[Conditional.scala 39:67:@210.22]
  assign _GEN_47 = _T_116 ? 1'h0 : _T_117; // @[Conditional.scala 39:67:@206.20]
  assign _GEN_48 = _T_116 ? 1'h0 : _GEN_40; // @[Conditional.scala 39:67:@206.20]
  assign _GEN_51 = _T_116 ? 32'h0 : _GEN_43; // @[Conditional.scala 39:67:@206.20]
  assign _GEN_53 = _T_116 ? 1'h0 : _GEN_45; // @[Conditional.scala 39:67:@206.20]
  assign _GEN_54 = _T_115 ? 1'h1 : _GEN_48; // @[Conditional.scala 39:67:@196.18]
  assign _GEN_56 = _T_115 ? io_axi_wdata : 32'h0; // @[Conditional.scala 39:67:@196.18]
  assign _GEN_60 = _T_115 ? 1'h0 : _GEN_47; // @[Conditional.scala 39:67:@196.18]
  assign _GEN_61 = _T_115 ? 1'h0 : _GEN_48; // @[Conditional.scala 39:67:@196.18]
  assign _GEN_62 = _T_115 ? 32'h0 : _GEN_51; // @[Conditional.scala 39:67:@196.18]
  assign _GEN_64 = _T_115 ? 1'h0 : _GEN_53; // @[Conditional.scala 39:67:@196.18]
  assign _GEN_65 = _T_114 ? 1'h1 : _GEN_54; // @[Conditional.scala 39:67:@187.16]
  assign _GEN_67 = _T_114 ? addr_data_reg : _GEN_56; // @[Conditional.scala 39:67:@187.16]
  assign _GEN_68 = _T_114 ? 1'h1 : _T_115; // @[Conditional.scala 39:67:@187.16]
  assign _GEN_70 = _T_114 ? 1'h0 : _T_115; // @[Conditional.scala 39:67:@187.16]
  assign _GEN_72 = _T_114 ? 1'h0 : _GEN_60; // @[Conditional.scala 39:67:@187.16]
  assign _GEN_73 = _T_114 ? 1'h0 : _GEN_61; // @[Conditional.scala 39:67:@187.16]
  assign _GEN_74 = _T_114 ? 32'h0 : _GEN_62; // @[Conditional.scala 39:67:@187.16]
  assign _GEN_76 = _T_114 ? 1'h0 : _GEN_64; // @[Conditional.scala 39:67:@187.16]
  assign _GEN_77 = _T_113 ? 1'h1 : _GEN_65; // @[Conditional.scala 39:67:@177.14]
  assign _GEN_79 = _T_113 ? io_axi_wdata : _GEN_67; // @[Conditional.scala 39:67:@177.14]
  assign _GEN_80 = _T_113 ? 1'h1 : _GEN_68; // @[Conditional.scala 39:67:@177.14]
  assign _GEN_81 = _T_113 ? 1'h1 : _GEN_70; // @[Conditional.scala 39:67:@177.14]
  assign _GEN_82 = _T_113 ? 1'h0 : _GEN_68; // @[Conditional.scala 39:67:@177.14]
  assign _GEN_84 = _T_113 ? 1'h0 : _GEN_72; // @[Conditional.scala 39:67:@177.14]
  assign _GEN_85 = _T_113 ? 1'h0 : _GEN_73; // @[Conditional.scala 39:67:@177.14]
  assign _GEN_86 = _T_113 ? 32'h0 : _GEN_74; // @[Conditional.scala 39:67:@177.14]
  assign _GEN_88 = _T_113 ? 1'h0 : _GEN_76; // @[Conditional.scala 39:67:@177.14]
  assign _GEN_89 = _T_111 ? 1'h0 : _GEN_77; // @[Conditional.scala 39:67:@173.12]
  assign _GEN_91 = _T_111 ? 32'h0 : _GEN_79; // @[Conditional.scala 39:67:@173.12]
  assign _GEN_92 = _T_111 ? 1'h0 : _GEN_80; // @[Conditional.scala 39:67:@173.12]
  assign _GEN_93 = _T_111 ? 1'h0 : _GEN_81; // @[Conditional.scala 39:67:@173.12]
  assign _GEN_94 = _T_111 ? 1'h0 : _GEN_82; // @[Conditional.scala 39:67:@173.12]
  assign _GEN_96 = _T_111 ? 1'h0 : _GEN_84; // @[Conditional.scala 39:67:@173.12]
  assign _GEN_97 = _T_111 ? 1'h0 : _GEN_85; // @[Conditional.scala 39:67:@173.12]
  assign _GEN_98 = _T_111 ? 32'h0 : _GEN_86; // @[Conditional.scala 39:67:@173.12]
  assign _GEN_100 = _T_111 ? 1'h0 : _GEN_88; // @[Conditional.scala 39:67:@173.12]
  assign _GEN_101 = _T_109 ? 1'h0 : _GEN_89; // @[Conditional.scala 39:67:@169.10]
  assign _GEN_103 = _T_109 ? 32'h0 : _GEN_91; // @[Conditional.scala 39:67:@169.10]
  assign _GEN_104 = _T_109 ? 1'h0 : _GEN_92; // @[Conditional.scala 39:67:@169.10]
  assign _GEN_105 = _T_109 ? 1'h0 : _GEN_93; // @[Conditional.scala 39:67:@169.10]
  assign _GEN_106 = _T_109 ? 1'h0 : _GEN_94; // @[Conditional.scala 39:67:@169.10]
  assign _GEN_108 = _T_109 ? 1'h0 : _GEN_96; // @[Conditional.scala 39:67:@169.10]
  assign _GEN_109 = _T_109 ? 1'h0 : _GEN_97; // @[Conditional.scala 39:67:@169.10]
  assign _GEN_110 = _T_109 ? 32'h0 : _GEN_98; // @[Conditional.scala 39:67:@169.10]
  assign _GEN_112 = _T_109 ? 1'h0 : _GEN_100; // @[Conditional.scala 39:67:@169.10]
  assign _GEN_113 = _T_108 ? 1'h1 : _GEN_105; // @[Conditional.scala 39:67:@164.8]
  assign _GEN_114 = _T_108 ? 1'h0 : _GEN_101; // @[Conditional.scala 39:67:@164.8]
  assign _GEN_116 = _T_108 ? 32'h0 : _GEN_103; // @[Conditional.scala 39:67:@164.8]
  assign _GEN_117 = _T_108 ? 1'h0 : _GEN_104; // @[Conditional.scala 39:67:@164.8]
  assign _GEN_118 = _T_108 ? 1'h0 : _GEN_106; // @[Conditional.scala 39:67:@164.8]
  assign _GEN_120 = _T_108 ? 1'h0 : _GEN_108; // @[Conditional.scala 39:67:@164.8]
  assign _GEN_121 = _T_108 ? 1'h0 : _GEN_109; // @[Conditional.scala 39:67:@164.8]
  assign _GEN_122 = _T_108 ? 32'h0 : _GEN_110; // @[Conditional.scala 39:67:@164.8]
  assign _GEN_124 = _T_108 ? 1'h0 : _GEN_112; // @[Conditional.scala 39:67:@164.8]
  assign _GEN_125 = _T_107 ? 1'h1 : _GEN_118; // @[Conditional.scala 39:67:@159.6]
  assign _GEN_126 = _T_107 ? 1'h0 : _GEN_113; // @[Conditional.scala 39:67:@159.6]
  assign _GEN_127 = _T_107 ? 1'h0 : _GEN_114; // @[Conditional.scala 39:67:@159.6]
  assign _GEN_129 = _T_107 ? 32'h0 : _GEN_116; // @[Conditional.scala 39:67:@159.6]
  assign _GEN_130 = _T_107 ? 1'h0 : _GEN_117; // @[Conditional.scala 39:67:@159.6]
  assign _GEN_132 = _T_107 ? 1'h0 : _GEN_120; // @[Conditional.scala 39:67:@159.6]
  assign _GEN_133 = _T_107 ? 1'h0 : _GEN_121; // @[Conditional.scala 39:67:@159.6]
  assign _GEN_134 = _T_107 ? 32'h0 : _GEN_122; // @[Conditional.scala 39:67:@159.6]
  assign _GEN_136 = _T_107 ? 1'h0 : _GEN_124; // @[Conditional.scala 39:67:@159.6]
  assign _T_168 = 4'h1 == next_state; // @[Conditional.scala 37:30:@233.4]
  assign _T_170 = {1'h0,io_axi_awaddr}; // @[Cat.scala 30:58:@235.6]
  assign _T_171 = 4'h2 == next_state; // @[Conditional.scala 37:30:@239.6]
  assign _T_172 = 4'hc == next_state; // @[Conditional.scala 37:30:@244.8]
  assign _GEN_149 = _T_172 ? io_csb_nvdla2csb_data : addr_data_reg; // @[Conditional.scala 39:67:@245.8]
  assign _GEN_150 = _T_171 ? io_axi_wdata : _GEN_149; // @[Conditional.scala 39:67:@240.6]
  assign io_csb_csb2nvdla_valid = _T_105 ? 1'h0 : _GEN_127; // @[AXI2CSB.scala 118:26:@139.4 AXI2CSB.scala 148:30:@178.16 AXI2CSB.scala 155:30:@188.18 AXI2CSB.scala 162:30:@197.20 AXI2CSB.scala 177:30:@217.26]
  assign io_csb_csb2nvdla_addr = addr_in[17:2]; // @[AXI2CSB.scala 120:25:@142.4]
  assign io_csb_csb2nvdla_wdat = _T_105 ? 32'h0 : _GEN_129; // @[AXI2CSB.scala 121:25:@143.4 AXI2CSB.scala 150:29:@181.16 AXI2CSB.scala 157:29:@190.18 AXI2CSB.scala 164:29:@199.20]
  assign io_csb_csb2nvdla_write = _T_105 ? 1'h0 : _GEN_130; // @[AXI2CSB.scala 122:26:@144.4 AXI2CSB.scala 151:30:@182.16 AXI2CSB.scala 158:30:@191.18 AXI2CSB.scala 165:30:@200.20 AXI2CSB.scala 179:30:@219.26]
  assign io_axi_awready = _T_105 ? 1'h0 : _GEN_125; // @[AXI2CSB.scala 125:18:@146.4 AXI2CSB.scala 140:22:@160.8 AXI2CSB.scala 159:22:@192.18 AXI2CSB.scala 166:22:@201.20]
  assign io_axi_wready = _T_105 ? 1'h0 : _GEN_126; // @[AXI2CSB.scala 127:18:@147.4 AXI2CSB.scala 143:21:@165.10 AXI2CSB.scala 152:22:@183.16 AXI2CSB.scala 167:22:@202.20]
  assign io_axi_bvalid = _T_105 ? 1'h0 : _GEN_132; // @[AXI2CSB.scala 130:18:@149.4 AXI2CSB.scala 174:22:@212.24]
  assign io_axi_arready = _T_105 ? 1'h0 : _GEN_133; // @[AXI2CSB.scala 132:18:@150.4 AXI2CSB.scala 180:22:@220.26]
  assign io_axi_rdata = _T_105 ? 32'h0 : _GEN_134; // @[AXI2CSB.scala 134:18:@151.4 AXI2CSB.scala 186:22:@229.30]
  assign io_axi_rvalid = _T_105 ? 1'h0 : _GEN_136; // @[AXI2CSB.scala 136:18:@153.4 AXI2CSB.scala 188:22:@231.30]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  addr_data_reg = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  curr_state = _RAND_1[3:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (_T_168) begin
      addr_data_reg <= {{13'd0}, _T_170};
    end else begin
      if (_T_171) begin
        addr_data_reg <= io_axi_wdata;
      end else begin
        if (_T_172) begin
          addr_data_reg <= io_csb_nvdla2csb_data;
        end
      end
    end
    if (reset) begin
      curr_state <= 4'h0;
    end else begin
      if (_T_105) begin
        if (io_csb_csb2nvdla_ready) begin
          if (_T_106) begin
            curr_state <= 4'h7;
          end else begin
            if (io_axi_awvalid) begin
              curr_state <= 4'h1;
            end else begin
              if (io_axi_wvalid) begin
                curr_state <= 4'h2;
              end else begin
                if (io_axi_arvalid) begin
                  curr_state <= 4'ha;
                end
              end
            end
          end
        end
      end else begin
        if (_T_107) begin
          curr_state <= 4'h3;
        end else begin
          if (_T_108) begin
            curr_state <= 4'h4;
          end else begin
            if (_T_109) begin
              if (_T_110) begin
                curr_state <= 4'h6;
              end
            end else begin
              if (_T_111) begin
                if (_T_112) begin
                  curr_state <= 4'h5;
                end
              end else begin
                if (_T_113) begin
                  if (txn_send) begin
                    curr_state <= 4'h8;
                  end
                end else begin
                  if (_T_114) begin
                    if (txn_send) begin
                      curr_state <= 4'h8;
                    end
                  end else begin
                    if (_T_115) begin
                      if (txn_send) begin
                        curr_state <= 4'h8;
                      end
                    end else begin
                      if (_T_116) begin
                        if (io_csb_nvdla2csb_wr_complete) begin
                          curr_state <= 4'h9;
                        end
                      end else begin
                        if (_T_117) begin
                          if (wr_resp) begin
                            curr_state <= 4'h0;
                          end
                        end else begin
                          if (_T_118) begin
                            if (txn_send) begin
                              curr_state <= 4'hb;
                            end
                          end else begin
                            if (_T_119) begin
                              if (io_csb_nvdla2csb_valid) begin
                                curr_state <= 4'hc;
                              end
                            end else begin
                              if (_T_120) begin
                                if (rd_resp) begin
                                  curr_state <= 4'h0;
                                end
                              end else begin
                                curr_state <= 4'h0;
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
endmodule
module AXI2DBB( // @[:@249.2]
  input  [7:0]  io_dbbif_aw_awid, // @[:@252.4]
  input  [31:0] io_dbbif_aw_awaddr, // @[:@252.4]
  input  [3:0]  io_dbbif_aw_awlen, // @[:@252.4]
  input         io_dbbif_aw_awvalid, // @[:@252.4]
  output        io_dbbif_aw_awready, // @[:@252.4]
  input  [31:0] io_dbbif_w_wdata, // @[:@252.4]
  input  [3:0]  io_dbbif_w_wstrb, // @[:@252.4]
  input         io_dbbif_w_wlast, // @[:@252.4]
  input         io_dbbif_w_wvalid, // @[:@252.4]
  output        io_dbbif_w_wready, // @[:@252.4]
  output [7:0]  io_dbbif_b_bid, // @[:@252.4]
  output        io_dbbif_b_bvalid, // @[:@252.4]
  input         io_dbbif_b_bready, // @[:@252.4]
  input  [7:0]  io_dbbif_ar_arid, // @[:@252.4]
  input  [31:0] io_dbbif_ar_araddr, // @[:@252.4]
  input  [3:0]  io_dbbif_ar_arlen, // @[:@252.4]
  input         io_dbbif_ar_arvalid, // @[:@252.4]
  output        io_dbbif_ar_arready, // @[:@252.4]
  output [7:0]  io_dbbif_r_rid, // @[:@252.4]
  output [31:0] io_dbbif_r_rdata, // @[:@252.4]
  output        io_dbbif_r_rlast, // @[:@252.4]
  output        io_dbbif_r_rvalid, // @[:@252.4]
  input         io_dbbif_r_rready, // @[:@252.4]
  output [7:0]  io_axi_awid, // @[:@252.4]
  output [31:0] io_axi_awaddr, // @[:@252.4]
  output [7:0]  io_axi_awlen, // @[:@252.4]
  output        io_axi_awvalid, // @[:@252.4]
  input         io_axi_awready, // @[:@252.4]
  output [31:0] io_axi_wdata, // @[:@252.4]
  output [3:0]  io_axi_wstrb, // @[:@252.4]
  output        io_axi_wlast, // @[:@252.4]
  output        io_axi_wvalid, // @[:@252.4]
  input         io_axi_wready, // @[:@252.4]
  input  [7:0]  io_axi_bid, // @[:@252.4]
  input         io_axi_bvalid, // @[:@252.4]
  output        io_axi_bready, // @[:@252.4]
  output [7:0]  io_axi_arid, // @[:@252.4]
  output [31:0] io_axi_araddr, // @[:@252.4]
  output [7:0]  io_axi_arlen, // @[:@252.4]
  output        io_axi_arvalid, // @[:@252.4]
  input         io_axi_arready, // @[:@252.4]
  input  [7:0]  io_axi_rid, // @[:@252.4]
  input  [31:0] io_axi_rdata, // @[:@252.4]
  input         io_axi_rlast, // @[:@252.4]
  input         io_axi_rvalid, // @[:@252.4]
  output        io_axi_rready // @[:@252.4]
);
  assign io_dbbif_aw_awready = io_axi_awready; // @[AXI2DBB.scala 22:24:@257.4]
  assign io_dbbif_w_wready = io_axi_wready; // @[AXI2DBB.scala 33:22:@267.4]
  assign io_dbbif_b_bid = io_axi_bid; // @[AXI2DBB.scala 42:22:@275.4]
  assign io_dbbif_b_bvalid = io_axi_bvalid; // @[AXI2DBB.scala 41:22:@274.4]
  assign io_dbbif_ar_arready = io_axi_arready; // @[AXI2DBB.scala 46:23:@278.4]
  assign io_dbbif_r_rid = io_axi_rid; // @[AXI2DBB.scala 60:22:@291.4]
  assign io_dbbif_r_rdata = io_axi_rdata; // @[AXI2DBB.scala 61:22:@292.4]
  assign io_dbbif_r_rlast = io_axi_rlast; // @[AXI2DBB.scala 64:22:@295.4]
  assign io_dbbif_r_rvalid = io_axi_rvalid; // @[AXI2DBB.scala 62:22:@293.4]
  assign io_axi_awid = io_dbbif_aw_awid; // @[AXI2DBB.scala 19:24:@254.4]
  assign io_axi_awaddr = io_dbbif_aw_awaddr; // @[AXI2DBB.scala 20:24:@255.4]
  assign io_axi_awlen = {{4'd0}, io_dbbif_aw_awlen}; // @[AXI2DBB.scala 21:24:@256.4]
  assign io_axi_awvalid = io_dbbif_aw_awvalid; // @[AXI2DBB.scala 23:24:@258.4]
  assign io_axi_wdata = io_dbbif_w_wdata; // @[AXI2DBB.scala 35:22:@269.4]
  assign io_axi_wstrb = io_dbbif_w_wstrb; // @[AXI2DBB.scala 37:22:@271.4]
  assign io_axi_wlast = io_dbbif_w_wlast; // @[AXI2DBB.scala 36:22:@270.4]
  assign io_axi_wvalid = io_dbbif_w_wvalid; // @[AXI2DBB.scala 34:22:@268.4]
  assign io_axi_bready = io_dbbif_b_bready; // @[AXI2DBB.scala 40:22:@273.4]
  assign io_axi_arid = io_dbbif_ar_arid; // @[AXI2DBB.scala 49:23:@281.4]
  assign io_axi_araddr = io_dbbif_ar_araddr; // @[AXI2DBB.scala 48:23:@280.4]
  assign io_axi_arlen = {{4'd0}, io_dbbif_ar_arlen}; // @[AXI2DBB.scala 50:23:@282.4]
  assign io_axi_arvalid = io_dbbif_ar_arvalid; // @[AXI2DBB.scala 47:23:@279.4]
  assign io_axi_rready = io_dbbif_r_rready; // @[AXI2DBB.scala 63:22:@294.4]
endmodule
module NvdlaAXIWrapper( // @[:@299.2]
  input         core_port_dla_core_clock, // @[:@300.4]
  input         core_port_dla_csb_clock, // @[:@300.4]
  input         core_port_global_clk_ovr_on, // @[:@300.4]
  input         core_port_tmc2slcg_disable_clock_gating, // @[:@300.4]
  input         core_port_dla_reset_rstn, // @[:@300.4]
  input         core_port_direct_reset_, // @[:@300.4]
  input         core_port_test_mode, // @[:@300.4]
  output        core_port_dla_intr, // @[:@300.4]
  input  [31:0] core_port_nvdla_pwrbus_ram_c_pd, // @[:@300.4]
  input  [31:0] core_port_nvdla_pwrbus_ram_ma_pd, // @[:@300.4]
  input  [31:0] core_port_nvdla_pwrbus_ram_mb_pd, // @[:@300.4]
  input  [31:0] core_port_nvdla_pwrbus_ram_p_pd, // @[:@300.4]
  input  [31:0] core_port_nvdla_pwrbus_ram_o_pd, // @[:@300.4]
  input  [31:0] core_port_nvdla_pwrbus_ram_a_pd, // @[:@300.4]
  input  [17:0] s00_axi_awaddr, // @[:@301.4]
  input  [2:0]  s00_axi_awprot, // @[:@301.4]
  input         s00_axi_awvalid, // @[:@301.4]
  output        s00_axi_awready, // @[:@301.4]
  input  [31:0] s00_axi_wdata, // @[:@301.4]
  input  [3:0]  s00_axi_wstrb, // @[:@301.4]
  input         s00_axi_wvalid, // @[:@301.4]
  output        s00_axi_wready, // @[:@301.4]
  output [1:0]  s00_axi_bresp, // @[:@301.4]
  output        s00_axi_bvalid, // @[:@301.4]
  input         s00_axi_bready, // @[:@301.4]
  input  [17:0] s00_axi_araddr, // @[:@301.4]
  input  [2:0]  s00_axi_arprot, // @[:@301.4]
  input         s00_axi_arvalid, // @[:@301.4]
  output        s00_axi_arready, // @[:@301.4]
  output [31:0] s00_axi_rdata, // @[:@301.4]
  output [1:0]  s00_axi_rresp, // @[:@301.4]
  output        s00_axi_rvalid, // @[:@301.4]
  input         s00_axi_rready, // @[:@301.4]
  output [7:0]  m03_axi_awid, // @[:@302.4]
  output [31:0] m03_axi_awaddr, // @[:@302.4]
  output [7:0]  m03_axi_awlen, // @[:@302.4]
  output [2:0]  m03_axi_awsize, // @[:@302.4]
  output [1:0]  m03_axi_awburst, // @[:@302.4]
  output        m03_axi_awlock, // @[:@302.4]
  output [3:0]  m03_axi_awcache, // @[:@302.4]
  output [3:0]  m03_axi_awqos, // @[:@302.4]
  output [3:0]  m03_axi_awregion, // @[:@302.4]
  output [2:0]  m03_axi_awprot, // @[:@302.4]
  output        m03_axi_awvalid, // @[:@302.4]
  input         m03_axi_awready, // @[:@302.4]
  output [63:0] m03_axi_wdata, // @[:@302.4]
  output [7:0]  m03_axi_wstrb, // @[:@302.4]
  output        m03_axi_wlast, // @[:@302.4]
  output        m03_axi_wvalid, // @[:@302.4]
  input         m03_axi_wready, // @[:@302.4]
  input  [7:0]  m03_axi_bid, // @[:@302.4]
  input  [1:0]  m03_axi_bresp, // @[:@302.4]
  input         m03_axi_bvalid, // @[:@302.4]
  output        m03_axi_bready, // @[:@302.4]
  output [7:0]  m03_axi_arid, // @[:@302.4]
  output [31:0] m03_axi_araddr, // @[:@302.4]
  output [7:0]  m03_axi_arlen, // @[:@302.4]
  output [2:0]  m03_axi_arsize, // @[:@302.4]
  output [1:0]  m03_axi_arburst, // @[:@302.4]
  output        m03_axi_arlock, // @[:@302.4]
  output [3:0]  m03_axi_arcache, // @[:@302.4]
  output [3:0]  m03_axi_arqos, // @[:@302.4]
  output [3:0]  m03_axi_arregion, // @[:@302.4]
  output [2:0]  m03_axi_arprot, // @[:@302.4]
  output        m03_axi_arvalid, // @[:@302.4]
  input         m03_axi_arready, // @[:@302.4]
  input  [7:0]  m03_axi_rid, // @[:@302.4]
  input  [63:0] m03_axi_rdata, // @[:@302.4]
  input  [1:0]  m03_axi_rresp, // @[:@302.4]
  input         m03_axi_rlast, // @[:@302.4]
  input         m03_axi_rvalid, // @[:@302.4]
  output        m03_axi_rready // @[:@302.4]
);
  wire [7:0] nvdla_nvdla_core2dbb_aw_awid; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [31:0] nvdla_nvdla_core2dbb_aw_awaddr; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [3:0] nvdla_nvdla_core2dbb_aw_awlen; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla_nvdla_core2dbb_aw_awvalid; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla_nvdla_core2dbb_aw_awready; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [63:0] nvdla_nvdla_core2dbb_w_wdata; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [7:0] nvdla_nvdla_core2dbb_w_wstrb; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla_nvdla_core2dbb_w_wlast; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla_nvdla_core2dbb_w_wvalid; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla_nvdla_core2dbb_w_wready; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [7:0] nvdla_nvdla_core2dbb_b_bid; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla_nvdla_core2dbb_b_bvalid; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla_nvdla_core2dbb_b_bready; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [7:0] nvdla_nvdla_core2dbb_ar_arid; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [31:0] nvdla_nvdla_core2dbb_ar_araddr; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [3:0] nvdla_nvdla_core2dbb_ar_arlen; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla_nvdla_core2dbb_ar_arvalid; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla_nvdla_core2dbb_ar_arready; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [7:0] nvdla_nvdla_core2dbb_r_rid; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [63:0] nvdla_nvdla_core2dbb_r_rdata; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla_nvdla_core2dbb_r_rlast; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla_nvdla_core2dbb_r_rvalid; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla_nvdla_core2dbb_r_rready; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.csb2nvdla_valid; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.csb2nvdla_ready; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [15:0] nvdla.csb2nvdla_addr; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [31:0] nvdla.csb2nvdla_wdat; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.csb2nvdla_write; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.csb2nvdla_nposted; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.nvdla2csb_valid; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [31:0] nvdla.nvdla2csb_data; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.nvdla2csb_wr_complete; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.dla_core_clock; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.dla_csb_clock; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.global_clk_ovr_on; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.tmc2slcg_disable_clock_gating; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.dla_reset_rstn; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.direct_reset_; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.test_mode; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  nvdla.dla_intr; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [31:0] nvdla.nvdla_pwrbus_ram_c_pd; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [31:0] nvdla.nvdla_pwrbus_ram_ma_pd; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [31:0] nvdla.nvdla_pwrbus_ram_mb_pd; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [31:0] nvdla.nvdla_pwrbus_ram_p_pd; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [31:0] nvdla.nvdla_pwrbus_ram_o_pd; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire [31:0] nvdla.nvdla_pwrbus_ram_a_pd; // @[nvdla_axi_wrapper.scala 15:21:@304.4]
  wire  axi2csb_clock; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_reset; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_csb_csb2nvdla_valid; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_csb_csb2nvdla_ready; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire [15:0] axi2csb_io_csb_csb2nvdla_addr; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire [31:0] axi2csb_io_csb_csb2nvdla_wdat; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_csb_csb2nvdla_write; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_csb_nvdla2csb_valid; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire [31:0] axi2csb_io_csb_nvdla2csb_data; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_csb_nvdla2csb_wr_complete; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire [17:0] axi2csb_io_axi_awaddr; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_axi_awvalid; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_axi_awready; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire [31:0] axi2csb_io_axi_wdata; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_axi_wvalid; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_axi_wready; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_axi_bvalid; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_axi_bready; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire [17:0] axi2csb_io_axi_araddr; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_axi_arvalid; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_axi_arready; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire [31:0] axi2csb_io_axi_rdata; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_axi_rvalid; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire  axi2csb_io_axi_rready; // @[nvdla_axi_wrapper.scala 16:93:@309.4]
  wire [7:0] axi2dbb_io_dbbif_aw_awid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [31:0] axi2dbb_io_dbbif_aw_awaddr; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [3:0] axi2dbb_io_dbbif_aw_awlen; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_dbbif_aw_awvalid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_dbbif_aw_awready; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [31:0] axi2dbb_io_dbbif_w_wdata; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [3:0] axi2dbb_io_dbbif_w_wstrb; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_dbbif_w_wlast; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_dbbif_w_wvalid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_dbbif_w_wready; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [7:0] axi2dbb_io_dbbif_b_bid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_dbbif_b_bvalid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_dbbif_b_bready; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [7:0] axi2dbb_io_dbbif_ar_arid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [31:0] axi2dbb_io_dbbif_ar_araddr; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [3:0] axi2dbb_io_dbbif_ar_arlen; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_dbbif_ar_arvalid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_dbbif_ar_arready; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [7:0] axi2dbb_io_dbbif_r_rid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [31:0] axi2dbb_io_dbbif_r_rdata; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_dbbif_r_rlast; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_dbbif_r_rvalid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_dbbif_r_rready; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [7:0] axi2dbb_io_axi_awid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [31:0] axi2dbb_io_axi_awaddr; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [7:0] axi2dbb_io_axi_awlen; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_axi_awvalid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_axi_awready; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [31:0] axi2dbb_io_axi_wdata; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [3:0] axi2dbb_io_axi_wstrb; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_axi_wlast; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_axi_wvalid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_axi_wready; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [7:0] axi2dbb_io_axi_bid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_axi_bvalid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_axi_bready; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [7:0] axi2dbb_io_axi_arid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [31:0] axi2dbb_io_axi_araddr; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [7:0] axi2dbb_io_axi_arlen; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_axi_arvalid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_axi_arready; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [7:0] axi2dbb_io_axi_rid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire [31:0] axi2dbb_io_axi_rdata; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_axi_rlast; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_axi_rvalid; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  wire  axi2dbb_io_axi_rready; // @[nvdla_axi_wrapper.scala 17:94:@313.4]
  NV_nvdla nvdla ( // @[nvdla_axi_wrapper.scala 15:21:@304.4]
    .nvdla_core2dbb_aw_awid(nvdla_nvdla_core2dbb_aw_awid),
    .nvdla_core2dbb_aw_awaddr(nvdla_nvdla_core2dbb_aw_awaddr),
    .nvdla_core2dbb_aw_awlen(nvdla_nvdla_core2dbb_aw_awlen),
    .nvdla_core2dbb_aw_awvalid(nvdla_nvdla_core2dbb_aw_awvalid),
    .nvdla_core2dbb_aw_awready(nvdla_nvdla_core2dbb_aw_awready),
    .nvdla_core2dbb_w_wdata(nvdla_nvdla_core2dbb_w_wdata),
    .nvdla_core2dbb_w_wstrb(nvdla_nvdla_core2dbb_w_wstrb),
    .nvdla_core2dbb_w_wlast(nvdla_nvdla_core2dbb_w_wlast),
    .nvdla_core2dbb_w_wvalid(nvdla_nvdla_core2dbb_w_wvalid),
    .nvdla_core2dbb_w_wready(nvdla_nvdla_core2dbb_w_wready),
    .nvdla_core2dbb_b_bid(nvdla_nvdla_core2dbb_b_bid),
    .nvdla_core2dbb_b_bvalid(nvdla_nvdla_core2dbb_b_bvalid),
    .nvdla_core2dbb_b_bready(nvdla_nvdla_core2dbb_b_bready),
    .nvdla_core2dbb_ar_arid(nvdla_nvdla_core2dbb_ar_arid),
    .nvdla_core2dbb_ar_araddr(nvdla_nvdla_core2dbb_ar_araddr),
    .nvdla_core2dbb_ar_arlen(nvdla_nvdla_core2dbb_ar_arlen),
    .nvdla_core2dbb_ar_arvalid(nvdla_nvdla_core2dbb_ar_arvalid),
    .nvdla_core2dbb_ar_arready(nvdla_nvdla_core2dbb_ar_arready),
    .nvdla_core2dbb_r_rid(nvdla_nvdla_core2dbb_r_rid),
    .nvdla_core2dbb_r_rdata(nvdla_nvdla_core2dbb_r_rdata),
    .nvdla_core2dbb_r_rlast(nvdla_nvdla_core2dbb_r_rlast),
    .nvdla_core2dbb_r_rvalid(nvdla_nvdla_core2dbb_r_rvalid),
    .nvdla_core2dbb_r_rready(nvdla_nvdla_core2dbb_r_rready),
    .csb2nvdla_valid(nvdla_csb_port_replaced_csb2nvdla_valid),
    .csb2nvdla_ready(nvdla_csb_port_replaced_csb2nvdla_ready),
    .csb2nvdla_addr(nvdla_csb_port_replaced_csb2nvdla_addr),
    .csb2nvdla_wdat(nvdla_csb_port_replaced_csb2nvdla_wdat),
    .csb2nvdla_write(nvdla_csb_port_replaced_csb2nvdla_write),
    .csb2nvdla_nposted(nvdla_csb_port_replaced_csb2nvdla_nposted),
    .nvdla2csb_valid(nvdla_csb_port_replaced_nvdla2csb_valid),
    .nvdla2csb_data(nvdla_csb_port_replaced_nvdla2csb_data),
    .nvdla2csb_wr_complete(nvdla_csb_port_replaced_nvdla2csb_wr_complete),
    .dla_core_clock(nvdla_core_port_replaced_dla_core_clock),
    .dla_csb_clock(nvdla_core_port_replaced_dla_csb_clock),
    .global_clk_ovr_on(nvdla_core_port_replaced_global_clk_ovr_on),
    .tmc2slcg_disable_clock_gating(nvdla_core_port_replaced_tmc2slcg_disable_clock_gating),
    .dla_reset_rstn(nvdla_core_port_replaced_dla_reset_rstn),
    .direct_reset_(nvdla_core_port_replaced_direct_reset_),
    .test_mode(nvdla_core_port_replaced_test_mode),
    .dla_intr(nvdla_core_port_replaced_dla_intr),
    .nvdla_pwrbus_ram_c_pd(nvdla_core_port_replaced_nvdla_pwrbus_ram_c_pd),
    .nvdla_pwrbus_ram_ma_pd(nvdla_core_port_replaced_nvdla_pwrbus_ram_ma_pd),
    .nvdla_pwrbus_ram_mb_pd(nvdla_core_port_replaced_nvdla_pwrbus_ram_mb_pd),
    .nvdla_pwrbus_ram_p_pd(nvdla_core_port_replaced_nvdla_pwrbus_ram_p_pd),
    .nvdla_pwrbus_ram_o_pd(nvdla_core_port_replaced_nvdla_pwrbus_ram_o_pd),
    .nvdla_pwrbus_ram_a_pd(nvdla_core_port_replaced_nvdla_pwrbus_ram_a_pd)
  );
  AXI2CSB axi2csb ( // @[nvdla_axi_wrapper.scala 16:93:@309.4]
    .clock(axi2csb_clock),
    .reset(axi2csb_reset),
    .io_csb_csb2nvdla_valid(axi2csb_io_csb_csb2nvdla_valid),
    .io_csb_csb2nvdla_ready(axi2csb_io_csb_csb2nvdla_ready),
    .io_csb_csb2nvdla_addr(axi2csb_io_csb_csb2nvdla_addr),
    .io_csb_csb2nvdla_wdat(axi2csb_io_csb_csb2nvdla_wdat),
    .io_csb_csb2nvdla_write(axi2csb_io_csb_csb2nvdla_write),
    .io_csb_nvdla2csb_valid(axi2csb_io_csb_nvdla2csb_valid),
    .io_csb_nvdla2csb_data(axi2csb_io_csb_nvdla2csb_data),
    .io_csb_nvdla2csb_wr_complete(axi2csb_io_csb_nvdla2csb_wr_complete),
    .io_axi_awaddr(axi2csb_io_axi_awaddr),
    .io_axi_awvalid(axi2csb_io_axi_awvalid),
    .io_axi_awready(axi2csb_io_axi_awready),
    .io_axi_wdata(axi2csb_io_axi_wdata),
    .io_axi_wvalid(axi2csb_io_axi_wvalid),
    .io_axi_wready(axi2csb_io_axi_wready),
    .io_axi_bvalid(axi2csb_io_axi_bvalid),
    .io_axi_bready(axi2csb_io_axi_bready),
    .io_axi_araddr(axi2csb_io_axi_araddr),
    .io_axi_arvalid(axi2csb_io_axi_arvalid),
    .io_axi_arready(axi2csb_io_axi_arready),
    .io_axi_rdata(axi2csb_io_axi_rdata),
    .io_axi_rvalid(axi2csb_io_axi_rvalid),
    .io_axi_rready(axi2csb_io_axi_rready)
  );
  AXI2DBB axi2dbb ( // @[nvdla_axi_wrapper.scala 17:94:@313.4]
    .io_dbbif_aw_awid(axi2dbb_io_dbbif_aw_awid),
    .io_dbbif_aw_awaddr(axi2dbb_io_dbbif_aw_awaddr),
    .io_dbbif_aw_awlen(axi2dbb_io_dbbif_aw_awlen),
    .io_dbbif_aw_awvalid(axi2dbb_io_dbbif_aw_awvalid),
    .io_dbbif_aw_awready(axi2dbb_io_dbbif_aw_awready),
    .io_dbbif_w_wdata(axi2dbb_io_dbbif_w_wdata),
    .io_dbbif_w_wstrb(axi2dbb_io_dbbif_w_wstrb),
    .io_dbbif_w_wlast(axi2dbb_io_dbbif_w_wlast),
    .io_dbbif_w_wvalid(axi2dbb_io_dbbif_w_wvalid),
    .io_dbbif_w_wready(axi2dbb_io_dbbif_w_wready),
    .io_dbbif_b_bid(axi2dbb_io_dbbif_b_bid),
    .io_dbbif_b_bvalid(axi2dbb_io_dbbif_b_bvalid),
    .io_dbbif_b_bready(axi2dbb_io_dbbif_b_bready),
    .io_dbbif_ar_arid(axi2dbb_io_dbbif_ar_arid),
    .io_dbbif_ar_araddr(axi2dbb_io_dbbif_ar_araddr),
    .io_dbbif_ar_arlen(axi2dbb_io_dbbif_ar_arlen),
    .io_dbbif_ar_arvalid(axi2dbb_io_dbbif_ar_arvalid),
    .io_dbbif_ar_arready(axi2dbb_io_dbbif_ar_arready),
    .io_dbbif_r_rid(axi2dbb_io_dbbif_r_rid),
    .io_dbbif_r_rdata(axi2dbb_io_dbbif_r_rdata),
    .io_dbbif_r_rlast(axi2dbb_io_dbbif_r_rlast),
    .io_dbbif_r_rvalid(axi2dbb_io_dbbif_r_rvalid),
    .io_dbbif_r_rready(axi2dbb_io_dbbif_r_rready),
    .io_axi_awid(axi2dbb_io_axi_awid),
    .io_axi_awaddr(axi2dbb_io_axi_awaddr),
    .io_axi_awlen(axi2dbb_io_axi_awlen),
    .io_axi_awvalid(axi2dbb_io_axi_awvalid),
    .io_axi_awready(axi2dbb_io_axi_awready),
    .io_axi_wdata(axi2dbb_io_axi_wdata),
    .io_axi_wstrb(axi2dbb_io_axi_wstrb),
    .io_axi_wlast(axi2dbb_io_axi_wlast),
    .io_axi_wvalid(axi2dbb_io_axi_wvalid),
    .io_axi_wready(axi2dbb_io_axi_wready),
    .io_axi_bid(axi2dbb_io_axi_bid),
    .io_axi_bvalid(axi2dbb_io_axi_bvalid),
    .io_axi_bready(axi2dbb_io_axi_bready),
    .io_axi_arid(axi2dbb_io_axi_arid),
    .io_axi_araddr(axi2dbb_io_axi_araddr),
    .io_axi_arlen(axi2dbb_io_axi_arlen),
    .io_axi_arvalid(axi2dbb_io_axi_arvalid),
    .io_axi_arready(axi2dbb_io_axi_arready),
    .io_axi_rid(axi2dbb_io_axi_rid),
    .io_axi_rdata(axi2dbb_io_axi_rdata),
    .io_axi_rlast(axi2dbb_io_axi_rlast),
    .io_axi_rvalid(axi2dbb_io_axi_rvalid),
    .io_axi_rready(axi2dbb_io_axi_rready)
  );
  assign core_port_dla_intr = nvdla.dla_intr; // @[nvdla_axi_wrapper.scala 18:13:@322.4]
  assign s00_axi_awready = axi2csb_io_axi_awready; // @[nvdla_axi_wrapper.scala 19:11:@345.4]
  assign s00_axi_wready = axi2csb_io_axi_wready; // @[nvdla_axi_wrapper.scala 19:11:@341.4]
  assign s00_axi_bresp = 2'h0; // @[nvdla_axi_wrapper.scala 19:11:@340.4]
  assign s00_axi_bvalid = axi2csb_io_axi_bvalid; // @[nvdla_axi_wrapper.scala 19:11:@339.4]
  assign s00_axi_arready = axi2csb_io_axi_arready; // @[nvdla_axi_wrapper.scala 19:11:@334.4]
  assign s00_axi_rdata = axi2csb_io_axi_rdata; // @[nvdla_axi_wrapper.scala 19:11:@333.4]
  assign s00_axi_rresp = 2'h0; // @[nvdla_axi_wrapper.scala 19:11:@332.4]
  assign s00_axi_rvalid = axi2csb_io_axi_rvalid; // @[nvdla_axi_wrapper.scala 19:11:@331.4]
  assign m03_axi_awid = axi2dbb_io_axi_awid; // @[nvdla_axi_wrapper.scala 20:11:@392.4]
  assign m03_axi_awaddr = axi2dbb_io_axi_awaddr; // @[nvdla_axi_wrapper.scala 20:11:@391.4]
  assign m03_axi_awlen = axi2dbb_io_axi_awlen; // @[nvdla_axi_wrapper.scala 20:11:@390.4]
  assign m03_axi_awsize = 3'h2; // @[nvdla_axi_wrapper.scala 20:11:@389.4]
  assign m03_axi_awburst = 2'h1; // @[nvdla_axi_wrapper.scala 20:11:@388.4]
  assign m03_axi_awlock = 1'h0; // @[nvdla_axi_wrapper.scala 20:11:@387.4]
  assign m03_axi_awcache = 4'h0; // @[nvdla_axi_wrapper.scala 20:11:@386.4]
  assign m03_axi_awqos = 4'h0; // @[nvdla_axi_wrapper.scala 20:11:@385.4]
  assign m03_axi_awregion = 4'h0; // @[nvdla_axi_wrapper.scala 20:11:@384.4]
  assign m03_axi_awprot = 3'h0; // @[nvdla_axi_wrapper.scala 20:11:@382.4]
  assign m03_axi_awvalid = axi2dbb_io_axi_awvalid; // @[nvdla_axi_wrapper.scala 20:11:@381.4]
  assign m03_axi_wdata = {{32'd0}, axi2dbb_io_axi_wdata}; // @[nvdla_axi_wrapper.scala 20:11:@379.4]
  assign m03_axi_wstrb = {{4'd0}, axi2dbb_io_axi_wstrb}; // @[nvdla_axi_wrapper.scala 20:11:@378.4]
  assign m03_axi_wlast = axi2dbb_io_axi_wlast; // @[nvdla_axi_wrapper.scala 20:11:@377.4]
  assign m03_axi_wvalid = axi2dbb_io_axi_wvalid; // @[nvdla_axi_wrapper.scala 20:11:@375.4]
  assign m03_axi_bready = axi2dbb_io_axi_bready; // @[nvdla_axi_wrapper.scala 20:11:@369.4]
  assign m03_axi_arid = axi2dbb_io_axi_arid; // @[nvdla_axi_wrapper.scala 20:11:@368.4]
  assign m03_axi_araddr = axi2dbb_io_axi_araddr; // @[nvdla_axi_wrapper.scala 20:11:@367.4]
  assign m03_axi_arlen = axi2dbb_io_axi_arlen; // @[nvdla_axi_wrapper.scala 20:11:@366.4]
  assign m03_axi_arsize = 3'h2; // @[nvdla_axi_wrapper.scala 20:11:@365.4]
  assign m03_axi_arburst = 2'h1; // @[nvdla_axi_wrapper.scala 20:11:@364.4]
  assign m03_axi_arlock = 1'h0; // @[nvdla_axi_wrapper.scala 20:11:@363.4]
  assign m03_axi_arcache = 4'h0; // @[nvdla_axi_wrapper.scala 20:11:@362.4]
  assign m03_axi_arqos = 4'h0; // @[nvdla_axi_wrapper.scala 20:11:@361.4]
  assign m03_axi_arregion = 4'h0; // @[nvdla_axi_wrapper.scala 20:11:@360.4]
  assign m03_axi_arprot = 3'h0; // @[nvdla_axi_wrapper.scala 20:11:@358.4]
  assign m03_axi_arvalid = axi2dbb_io_axi_arvalid; // @[nvdla_axi_wrapper.scala 20:11:@357.4]
  assign m03_axi_rready = axi2dbb_io_axi_rready; // @[nvdla_axi_wrapper.scala 20:11:@349.4]
  assign nvdla_nvdla_core2dbb_aw_awready = axi2dbb_io_dbbif_aw_awready; // @[nvdla_axi_wrapper.scala 22:20:@420.4]
  assign nvdla_nvdla_core2dbb_w_wready = axi2dbb_io_dbbif_w_wready; // @[nvdla_axi_wrapper.scala 22:20:@415.4]
  assign nvdla_nvdla_core2dbb_b_bid = axi2dbb_io_dbbif_b_bid; // @[nvdla_axi_wrapper.scala 22:20:@414.4]
  assign nvdla_nvdla_core2dbb_b_bvalid = axi2dbb_io_dbbif_b_bvalid; // @[nvdla_axi_wrapper.scala 22:20:@413.4]
  assign nvdla_nvdla_core2dbb_ar_arready = axi2dbb_io_dbbif_ar_arready; // @[nvdla_axi_wrapper.scala 22:20:@407.4]
  assign nvdla_nvdla_core2dbb_r_rid = axi2dbb_io_dbbif_r_rid; // @[nvdla_axi_wrapper.scala 22:20:@406.4]
  assign nvdla_nvdla_core2dbb_r_rdata = {{32'd0}, axi2dbb_io_dbbif_r_rdata}; // @[nvdla_axi_wrapper.scala 22:20:@405.4]
  assign nvdla_nvdla_core2dbb_r_rlast = axi2dbb_io_dbbif_r_rlast; // @[nvdla_axi_wrapper.scala 22:20:@404.4]
  assign nvdla_nvdla_core2dbb_r_rvalid = axi2dbb_io_dbbif_r_rvalid; // @[nvdla_axi_wrapper.scala 22:20:@403.4]
  assign nvdla.csb2nvdla_valid = axi2csb_io_csb_csb2nvdla_valid; // @[nvdla_axi_wrapper.scala 21:18:@401.4]
  assign nvdla.csb2nvdla_addr = axi2csb_io_csb_csb2nvdla_addr; // @[nvdla_axi_wrapper.scala 21:18:@399.4]
  assign nvdla.csb2nvdla_wdat = axi2csb_io_csb_csb2nvdla_wdat; // @[nvdla_axi_wrapper.scala 21:18:@398.4]
  assign nvdla.csb2nvdla_write = axi2csb_io_csb_csb2nvdla_write; // @[nvdla_axi_wrapper.scala 21:18:@397.4]
  assign nvdla.csb2nvdla_nposted = 1'h1; // @[nvdla_axi_wrapper.scala 21:18:@396.4]
  assign nvdla.dla_core_clock = core_port_dla_core_clock; // @[nvdla_axi_wrapper.scala 18:13:@329.4]
  assign nvdla.dla_csb_clock = core_port_dla_csb_clock; // @[nvdla_axi_wrapper.scala 18:13:@328.4]
  assign nvdla.global_clk_ovr_on = core_port_global_clk_ovr_on; // @[nvdla_axi_wrapper.scala 18:13:@327.4]
  assign nvdla.tmc2slcg_disable_clock_gating = core_port_tmc2slcg_disable_clock_gating; // @[nvdla_axi_wrapper.scala 18:13:@326.4]
  assign nvdla.dla_reset_rstn = core_port_dla_reset_rstn; // @[nvdla_axi_wrapper.scala 18:13:@325.4]
  assign nvdla.direct_reset_ = core_port_direct_reset_; // @[nvdla_axi_wrapper.scala 18:13:@324.4]
  assign nvdla.test_mode = core_port_test_mode; // @[nvdla_axi_wrapper.scala 18:13:@323.4]
  assign nvdla.nvdla_pwrbus_ram_c_pd = core_port_nvdla_pwrbus_ram_c_pd; // @[nvdla_axi_wrapper.scala 18:13:@321.4]
  assign nvdla.nvdla_pwrbus_ram_ma_pd = core_port_nvdla_pwrbus_ram_ma_pd; // @[nvdla_axi_wrapper.scala 18:13:@320.4]
  assign nvdla.nvdla_pwrbus_ram_mb_pd = core_port_nvdla_pwrbus_ram_mb_pd; // @[nvdla_axi_wrapper.scala 18:13:@319.4]
  assign nvdla.nvdla_pwrbus_ram_p_pd = core_port_nvdla_pwrbus_ram_p_pd; // @[nvdla_axi_wrapper.scala 18:13:@318.4]
  assign nvdla.nvdla_pwrbus_ram_o_pd = core_port_nvdla_pwrbus_ram_o_pd; // @[nvdla_axi_wrapper.scala 18:13:@317.4]
  assign nvdla.nvdla_pwrbus_ram_a_pd = core_port_nvdla_pwrbus_ram_a_pd; // @[nvdla_axi_wrapper.scala 18:13:@316.4]
  assign axi2csb_clock = core_port_dla_csb_clock; // @[:@310.4]
  assign axi2csb_reset = core_port_dla_reset_rstn == 1'h0; // @[:@311.4]
  assign axi2csb_io_csb_csb2nvdla_ready = nvdla.csb2nvdla_ready; // @[nvdla_axi_wrapper.scala 21:18:@400.4]
  assign axi2csb_io_csb_nvdla2csb_valid = nvdla.nvdla2csb_valid; // @[nvdla_axi_wrapper.scala 21:18:@395.4]
  assign axi2csb_io_csb_nvdla2csb_data = nvdla.nvdla2csb_data; // @[nvdla_axi_wrapper.scala 21:18:@394.4]
  assign axi2csb_io_csb_nvdla2csb_wr_complete = nvdla.nvdla2csb_wr_complete; // @[nvdla_axi_wrapper.scala 21:18:@393.4]
  assign axi2csb_io_axi_awaddr = s00_axi_awaddr; // @[nvdla_axi_wrapper.scala 19:11:@348.4]
  assign axi2csb_io_axi_awvalid = s00_axi_awvalid; // @[nvdla_axi_wrapper.scala 19:11:@346.4]
  assign axi2csb_io_axi_wdata = s00_axi_wdata; // @[nvdla_axi_wrapper.scala 19:11:@344.4]
  assign axi2csb_io_axi_wvalid = s00_axi_wvalid; // @[nvdla_axi_wrapper.scala 19:11:@342.4]
  assign axi2csb_io_axi_bready = s00_axi_bready; // @[nvdla_axi_wrapper.scala 19:11:@338.4]
  assign axi2csb_io_axi_araddr = s00_axi_araddr; // @[nvdla_axi_wrapper.scala 19:11:@337.4]
  assign axi2csb_io_axi_arvalid = s00_axi_arvalid; // @[nvdla_axi_wrapper.scala 19:11:@335.4]
  assign axi2csb_io_axi_rready = s00_axi_rready; // @[nvdla_axi_wrapper.scala 19:11:@330.4]
  assign axi2dbb_io_dbbif_aw_awid = nvdla_nvdla_core2dbb_aw_awid; // @[nvdla_axi_wrapper.scala 22:20:@424.4]
  assign axi2dbb_io_dbbif_aw_awaddr = nvdla_nvdla_core2dbb_aw_awaddr; // @[nvdla_axi_wrapper.scala 22:20:@423.4]
  assign axi2dbb_io_dbbif_aw_awlen = nvdla_nvdla_core2dbb_aw_awlen; // @[nvdla_axi_wrapper.scala 22:20:@422.4]
  assign axi2dbb_io_dbbif_aw_awvalid = nvdla_nvdla_core2dbb_aw_awvalid; // @[nvdla_axi_wrapper.scala 22:20:@421.4]
  assign axi2dbb_io_dbbif_w_wdata = nvdla_nvdla_core2dbb_w_wdata[31:0]; // @[nvdla_axi_wrapper.scala 22:20:@419.4]
  assign axi2dbb_io_dbbif_w_wstrb = nvdla_nvdla_core2dbb_w_wstrb[3:0]; // @[nvdla_axi_wrapper.scala 22:20:@418.4]
  assign axi2dbb_io_dbbif_w_wlast = nvdla_nvdla_core2dbb_w_wlast; // @[nvdla_axi_wrapper.scala 22:20:@417.4]
  assign axi2dbb_io_dbbif_w_wvalid = nvdla_nvdla_core2dbb_w_wvalid; // @[nvdla_axi_wrapper.scala 22:20:@416.4]
  assign axi2dbb_io_dbbif_b_bready = nvdla_nvdla_core2dbb_b_bready; // @[nvdla_axi_wrapper.scala 22:20:@412.4]
  assign axi2dbb_io_dbbif_ar_arid = nvdla_nvdla_core2dbb_ar_arid; // @[nvdla_axi_wrapper.scala 22:20:@411.4]
  assign axi2dbb_io_dbbif_ar_araddr = nvdla_nvdla_core2dbb_ar_araddr; // @[nvdla_axi_wrapper.scala 22:20:@410.4]
  assign axi2dbb_io_dbbif_ar_arlen = nvdla_nvdla_core2dbb_ar_arlen; // @[nvdla_axi_wrapper.scala 22:20:@409.4]
  assign axi2dbb_io_dbbif_ar_arvalid = nvdla_nvdla_core2dbb_ar_arvalid; // @[nvdla_axi_wrapper.scala 22:20:@408.4]
  assign axi2dbb_io_dbbif_r_rready = nvdla_nvdla_core2dbb_r_rready; // @[nvdla_axi_wrapper.scala 22:20:@402.4]
  assign axi2dbb_io_axi_awready = m03_axi_awready; // @[nvdla_axi_wrapper.scala 20:11:@380.4]
  assign axi2dbb_io_axi_wready = m03_axi_wready; // @[nvdla_axi_wrapper.scala 20:11:@374.4]
  assign axi2dbb_io_axi_bid = m03_axi_bid; // @[nvdla_axi_wrapper.scala 20:11:@373.4]
  assign axi2dbb_io_axi_bvalid = m03_axi_bvalid; // @[nvdla_axi_wrapper.scala 20:11:@370.4]
  assign axi2dbb_io_axi_arready = m03_axi_arready; // @[nvdla_axi_wrapper.scala 20:11:@356.4]
  assign axi2dbb_io_axi_rid = m03_axi_rid; // @[nvdla_axi_wrapper.scala 20:11:@355.4]
  assign axi2dbb_io_axi_rdata = m03_axi_rdata[31:0]; // @[nvdla_axi_wrapper.scala 20:11:@354.4]
  assign axi2dbb_io_axi_rlast = m03_axi_rlast; // @[nvdla_axi_wrapper.scala 20:11:@352.4]
  assign axi2dbb_io_axi_rvalid = m03_axi_rvalid; // @[nvdla_axi_wrapper.scala 20:11:@350.4]
endmodule
