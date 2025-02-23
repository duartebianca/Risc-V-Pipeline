`timescale 1ns / 1ps

module BranchUnit #(
    parameter PC_W = 9
) (
    input logic [PC_W-1:0] Cur_PC,
    input logic [31:0] Imm,
    input logic Branch,
    input logic JalrSel,
    input logic Jump,
    input logic [31:0] AluResult,
    input logic Halt,
    output logic [31:0] PC_Imm,
    output logic [31:0] PC_Four,
    output logic [31:0] BrPC,
    output logic PcSel
);

  logic Branch_Sel;
  logic [31:0] PC_Full;

  // extend the PC to 32 bits
  assign PC_Full = {23'b0, Cur_PC};

  //JalType == Jalr? if so then PC_Full + Imm, if not then AluResult --> ((rs1 + offset) & ~1) [Target Address]
  assign PC_Imm = (JalrSel) ? AluResult : $signed(PC_Full) + $signed(Imm);


  assign PC_Four = PC_Full + 32'b100;
  //Branch taken if Alu signal equals one or Jalr
  assign Branch_Sel = (Halt) ? 1'b1 : ((Branch && AluResult[0]) || (JalrSel || Jump));  // 0:Branch is taken; 1:Branch is not taken

  assign BrPC = (Halt) ? PC_Full : ((Branch_Sel) ? PC_Imm : 32'b0);  // Branch -> PC+Imm   // Otherwise, BrPC value is not important
  assign PcSel = Branch_Sel || (JalrSel || Jump);  // 1:branch is taken; 0:branch is not taken(choose pc+4)

endmodule
