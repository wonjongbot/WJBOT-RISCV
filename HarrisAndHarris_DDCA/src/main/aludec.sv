// aludec.sv
// trao@g.hmc.edu 15 January 2020
// Updated for RISC-V Architecture

module aludecoder(input  logic [1:0] ALUOp,
                  input  logic [2:0] funct3,
                  input  logic op_5, funct7_5,
                  output logic [2:0] ALUControl);
  always_comb begin : decoderlogic
ALUControl = 3'bxxx;
    case (ALUOp)
      2'b00: ALUControl = 3'b000;
      2'b01: ALUControl = 3'b001;
      2'b10: begin
        case (funct3)
          3'b000:
            case ({op_5, funct7_5})
              2'b00,
              2'b01,
              2'b10: ALUControl = 3'b000;
              2'b11: ALUControl = 3'b001;
              default: ;
            endcase
          3'b010: ALUControl = 3'b101;
          3'b110: ALUControl = 3'b011;
          3'b111: ALUControl = 3'b010;
          default: ;
        endcase
      end
      default: ;
    endcase
  end
endmodule
