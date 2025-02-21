`timescale 1ns / 1ps

module datamemory #(
    parameter DM_ADDRESS = 9,
    parameter DATA_W = 32
) (
    input logic clk,
    input logic MemRead,  // Comes from control unit
    input logic MemWrite,  // Comes from control unit
    input logic [DM_ADDRESS - 1:0] a,  // Read / Write address - 9 LSB bits of the ALU output
    input logic [DATA_W - 1:0] wd,  // Write Data
    input logic [2:0] Funct3,  // Bits 12 to 14 of the instruction
    output logic [DATA_W - 1:0] rd,  // Read Data
    output logic [DATA_W - 1:0] written_data
);

  logic [31:0] raddress;
  logic [31:0] waddress;
  logic [31:0] Datain;
  logic [31:0] Dataout;
  logic [ 3:0] Wr;

  Memoria32Data mem32 (
      .raddress(raddress),
      .waddress(waddress),
      .Clk(~clk),
      .Datain(Datain),
      .Dataout(Dataout),
      .Wr(Wr)
  );

  always_comb begin
    raddress = {{22{1'b0}}, a};
    waddress = {{22{1'b0}}, {a[8:2], {2{1'b0}}}};
    Datain = wd;
    Wr = 4'b0000;
    written_data = 32'b0;

    if (MemRead) begin
      case (Funct3)
        3'b010:  // LW
        rd = Dataout;
        default: rd = Dataout;
      endcase
    end else if (MemWrite) begin
      case (Funct3)
        3'b001: begin // SH
          Wr = 4'b0011;
          Datain = {16'b0, wd[15:0]};
          written_data = Datain;
        end
        3'b010: begin  // SW
          Wr = 4'b1111;
          Datain = wd;
          written_data = Datain;
        end
        default: begin
          Wr = 4'b1111;
          Datain = wd;
          written_data = Datain;
        end
      endcase
    end
  end

endmodule
