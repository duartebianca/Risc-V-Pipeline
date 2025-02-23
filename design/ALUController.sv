`timescale 1ns / 1ps

module ALUController (
    //Inputs
    input logic [1:0] ALUOp,  // 2-bit opcode field from the Controller--00: LW/SW/AUIPC; 01:Branch; 10: Rtype/Itype; 11:JAL/LUI
    input logic [6:0] Funct7,  // bits 25 to 31 of the instruction
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction

    //Output
    output logic [3:0] Operation  // operation selection for ALU
);

  //jal 1101

  assign Operation[0] = 
  ((ALUOp == 2'b10) && (Funct3 == 3'b110))  && (Funct7 == 7'b0000000) ||  // OR
  ((ALUOp == 2'b10) && (Funct3 == 3'b100))  && (Funct7 == 7'b0000000) ||  // XOR
  ((ALUOp == 2'b10) && (Funct3 == 3'b101))  && (Funct7 == 7'b0000000) ||  // SRL
  ((ALUOp == 2'b01) && (Funct3 == 3'b100)) ||    // BLT
  ((ALUOp == 2'b01) && (Funct3 == 3'b001)) ||    // BNE
  ((ALUOp == 2'b10) && (Funct3 == 3'b101))  && (Funct7 == 7'b0100000);    // SRAI
  

  assign Operation[1] = 
  (ALUOp == 2'b00) ||  // LW\SW (still not clear for me why this is here)
  ((ALUOp == 2'b10) && (Funct3 == 3'b000))  && (Funct7 != 7'b0100000) ||  // ADD
  ((ALUOp == 2'b10) && (Funct3 == 3'b000))  && (Funct7 != 7'b0100000) ||  // ADDI
  ((ALUOp == 2'b10) && (Funct3 == 3'b100))  && (Funct7 == 7'b0000000) ||  // XOR
  ((ALUOp == 2'b01) && (Funct3 == 3'b101)) ||    // BGE
  ((ALUOp == 2'b01) && (Funct3 == 3'b001)) ||      // BNE 
  ((ALUOp == 2'b10) && (Funct3 == 3'b101))  && (Funct7 == 7'b0000000);    // SRAI
  



  assign Operation[2] =  
  ((ALUOp == 2'b10) && (Funct3 == 3'b000))  && (Funct7 == 7'b0100000) ||  // SUB
  ((ALUOp == 2'b10) && (Funct3 == 3'b001))  && (Funct7 == 7'b0000000) ||  // SLL
  ((ALUOp == 2'b10) && (Funct3 == 3'b101))  && (Funct7 == 7'b0000000) ||  // SRL
  ((ALUOp == 2'b10) && (Funct3 == 3'b010))  && (Funct7 == 7'b0000000) ||  // SLT
  ((ALUOp == 2'b10) && (Funct3 == 3'b101))  && (Funct7 == 7'b0100000);    // SRAI
  

  assign Operation[3] = 
  ((ALUOp == 2'b01) && (Funct3 == 3'b000)) ||  // BEQ
  ((ALUOp == 2'b01) && (Funct3 == 3'b100)) ||  // BLT
  ((ALUOp == 2'b01) && (Funct3 == 3'b101)) ||  // BGE
  ((ALUOp == 2'b01) && (Funct3 == 3'b001));    // BNE


endmodule