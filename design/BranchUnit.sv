`timescale 1ns / 1ps

module BranchUnit #(
    parameter PC_W = 9
) (
    input logic [PC_W-1:0] Cur_PC,
    input logic [31:0] Imm,
    input logic Branch,
    input logic [31:0] AluResult,
    input logic Halt,
    input logic Jump,
    output logic [31:0] PC_Imm,
    output logic [31:0] PC_Four,
    output logic [31:0] BrPC,
    output logic PcSel
);

  logic Branch_Sel;
  logic [31:0] PC_Full;

  assign PC_Full = {23'b0, Cur_PC};

  assign PC_Imm = PC_Full + Imm;    
  assign PC_Four = PC_Full + 32'b100;
  assign Branch_Sel = (Branch && AluResult[0]); 

  assign BrPC = (Branch_Sel || Jump) ? PC_Imm : ((Halt) ? PC_Full : 0);   
  assign PcSel = Branch_Sel || Halt || Jump;    
  /*always @(*) begin
      $display("Time: %0t | PC_Imm: %b", 
               $time, PC_Imm[12:0]);
  end*/
  endmodule
