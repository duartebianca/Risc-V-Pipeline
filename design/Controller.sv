`timescale 1ns / 1ps

module Controller (
    //Input
    input logic [6:0] Opcode,
    //7-bit opcode field from the instruction

    //Outputs
    output logic ALUSrc,
    //0: The second ALU operand comes from the second register file output (Read data 2); 
    //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic MemtoReg,
    //0: The value fed to the register Write data input comes from the ALU.
    //1: The value fed to the register Write data input comes from the data memory.
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input 
    output logic MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic [1:0] ALUOp,  //00: LW/SW; 01:Branch; 10: Rtype
    output logic Branch,  //0: branch is not taken; 1: branch is taken
    output logic  JalrSel,
    output logic  Jump


);

    logic [6:0] R_TYPE, LW, SW, BR, I_TYPE,  JAL, JALR;

  assign R_TYPE = 7'b0110011;  // xor, sub, slt, or
  assign LW = 7'b0000011;  // lb, lh, lbu 
  assign SW = 7'b0100011;  // sh, sb
  assign BR = 7'b1100011;  // bne, blt, bge, 
  assign I_TYPE = 7'b0010011;  // addi, slti, slli, srli, srai
  assign JAL  = 7'b1101111; // jal 
  assign JALR = 7'b1100111;  //jalr

  //goes to ALU src mux
  assign ALUSrc = (Opcode == LW || Opcode == SW || Opcode == I_TYPE || Opcode == JALR);

  assign MemtoReg = (Opcode == LW);
  // saves PC+4 for JAL and JALR
  assign RegWrite = (Opcode == R_TYPE || Opcode == LW || Opcode == I_TYPE || Opcode == JAL|| Opcode == JALR);
  assign MemRead = (Opcode == LW);
  assign MemWrite = (Opcode == SW);

  //goes to ALUController to decide which operation
  assign ALUOp[0] = (Opcode == BR);
  assign ALUOp[1] = (Opcode == I_TYPE || Opcode == R_TYPE);
  
  assign Branch = (Opcode == BR);
  assign JalrSel = (Opcode == JALR); // jal or jalr
  assign Jump = (Opcode == JAL); // jal or jalr



endmodule

