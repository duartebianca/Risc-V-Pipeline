`timescale 1ns / 1ps

module BranchUnit #(
    parameter PC_W = 9
) (
    input logic [PC_W-1:0] Cur_PC,
    input logic [31:0] Imm,
    input logic Branch,
    input logic [31:0] AluResult,
    input logic Halt,
    input logic [2:0] Funct3,
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

  assign Branch_Sel = (Halt) ? 1'b1 : (Branch && ((Funct3 == 3'b000 && AluResult[0]) ||  // BEQ (rs1 == rs2)
                                              (Funct3 == 3'b001 && !AluResult[0]))); // BNE (rs1 != rs2)

  // if halt is active, the next instruction is the current PC
  // else if branch is taken, the next instruction is PC+Imm
  // else the next instruction is PC+4
  assign BrPC = (Halt) ? PC_Full : ((Branch_Sel) ? PC_Imm : 32'b0);   
  assign PcSel = Branch_Sel;  // 1:branch is taken; 0:branch is not taken(choose pc+4)

endmodule
