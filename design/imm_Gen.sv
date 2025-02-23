`timescale 1ns / 1ps

module imm_Gen (
    input  logic [31:0] inst_code,
    output logic [31:0] Imm_out
);

  always_comb begin
    case (inst_code[6:0])
      7'b0000011:  /*I-type load part*/
        Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:20]};

      7'b0010011:  /*I-type arithmetic*/
        Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:20]};

      7'b1100111:  /*I-type jalr*/
        Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:20]};

      7'b0100011:  /*S-type*/
        Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:25], inst_code[11:7]};

      7'b1100011:  /*B-type*/
        Imm_out = {
          inst_code[31] ? 19'h7FFFF : 19'b0,
          inst_code[31],
          inst_code[7],
          inst_code[30:25],
          inst_code[11:8],
          1'b0
        };

      7'b1101111:  /*J-type (JAL)*/
        Imm_out = {
          inst_code[31] ? 12'hFFF : 11'b0,  // Extens�o de sinal
          inst_code[31],                    // imm[20]
          inst_code[19:12],                 // imm[19:12]
          inst_code[20],                    // imm[11]
          inst_code[30:21],                 // imm[10:1]
          1'b0                              // Bit menos significativo (sempre 0)
        };

      default: 
        Imm_out = {32'b0};
    endcase
  end

endmodule
