`timescale 1ns / 1ps

module BranchUnit #(
    parameter PC_W = 9
) (
    input logic [PC_W-1:0] Cur_PC,
    input logic [31:0] Imm,
    input logic Branch,
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

  // possible addresses of the next instruction
  assign PC_Imm = PC_Full + Imm;     // branch -> PC+Imm
  assign PC_Four = PC_Full + 32'b100;// PC+4

  assign Branch_Sel = (Halt) ? 1'b1: (Branch && AluResult[0]);  // 0:Branch is taken; 1:Branch is not taken

  // if halt is active, the next instruction is the current PC
  // else if branch is taken, the next instruction is PC+Imm
  // else the next instruction is PC+4
  assign BrPC = (Halt) ? PC_Full : ((Branch_Sel) ? PC_Imm : 32'b0);   
  assign PcSel = Branch_Sel;  // 1:branch is taken; 0:branch is not taken(choose pc+4)

endmodule
