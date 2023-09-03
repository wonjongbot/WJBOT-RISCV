import wjbot_riscv::opcodetype_t;

module control_unit_fsm ( input logic clk,
                          input logic reset,
                          input opcodetype_t op,
                          output logic Branch,
                          output logic PCUpdate,
                          output logic RegWrite,
                          output logic MemWrite,
                          output logic IRWrite,
                          output logic [1:0] ResultSrc,
                          output logic [1:0] ALUSrcA,
                          output logic [1:0] ALUSrcB,
                          output logic AdrSrc,
                          output logic [1:0] ALUOp
                          );
  typedef enum logic [3:0] {S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10} statetype_t;
  statetype_t state, nextstate;

  // state register
  always_ff @(posedge clk, posedge reset) begin
    if (reset) state <= S0;
    else      state <= nextstate;
  end

  // next state logic
  always_comb begin
    nextstate = state;
    case (state)
      // fetch
      S0: nextstate = S1;
      // decode
      S1: begin
        case (op)
          wjbot_riscv::lw_op,
          wjbot_riscv::sw_op:          nextstate = S2;
          wjbot_riscv::r_type_op:      nextstate = S6;
          wjbot_riscv::i_type_alu_op:  nextstate = S8;
          wjbot_riscv::jal_op:         nextstate = S9;
          wjbot_riscv::beq_op:         nextstate = S10;
          default: ;
        endcase
      end
      // MemAddr
      S2:
        case (op)
          wjbot_riscv::lw_op:  nextstate = S3;
          wjbot_riscv::sw_op:  nextstate = S5;
          default: ;
        endcase
      // MemRead
      S3: nextstate = S4;
      // MemWB
      S4: nextstate = S0;
      // MemWrite
      S5: nextstate = S0;
      // ExecuteR
      S6: nextstate = S7;
      // ALUWB
      S7: nextstate = S0;
      // Executel
      S8: nextstate = S7;
      // JAL
      S9: nextstate = S7;
      // BEQ
      S10: nextstate = S0;
      default: ;
    endcase
  end

  // output logic
  always_comb begin
    Branch = 1'b0;
    PCUpdate = 1'b0;
    RegWrite = 1'b0;
    MemWrite = 1'b0;
    IRWrite = 1'b0;
    ResultSrc = 2'b00;
    ALUSrcA = 2'b00;
    ALUSrcB = 2'b00;
    AdrSrc = 1'b0;
    ALUOp = 1'b0;
    case (state)
      // fetch
      S0: begin
        AdrSrc = 1'b0;
        IRWrite = 1'b1;
        ALUSrcA = 2'b00;
        ALUSrcB = 2'b10;
        ALUOp = 2'b00;
        ResultSrc = 2'b10;
        PCUpdate = 1'b1;
      end
      // decode
      S1: begin
        ALUSrcA = 2'b01;
        ALUSrcB = 2'b01;
        ALUOp = 2'b0;
      end
      // MemAddr
      S2: begin
        ALUSrcA = 2'b10;
        ALUSrcB = 2'b01;
        ALUOp = 2'b00;
      end
      // MemRead
      S3: begin
        ResultSrc = 2'b00;
        AdrSrc = 1'b1;
      end
      // MemWB
      S4: begin
        ResultSrc = 2'b01;
        RegWrite = 1'b1;
      end
      // MemWrite
      S5: begin
        ResultSrc = 2'b00;
        AdrSrc = 1'b1;
        MemWrite = 1'b1;
      end
      // ExecuteR
      S6: begin
        ALUSrcA = 2'b10;
        ALUSrcB = 2'b00;
        ALUOp = 2'b10;
      end
      // ALUWB
      S7: begin
        ResultSrc = 2'b00;
        RegWrite = 1'b1;
      end
      // Executel
      S8: begin
        ALUSrcA = 2'b10;
        ALUSrcB = 2'b01;
        ALUOp = 2'b10;
      end
      // JAL
      S9: begin
        ALUSrcA = 2'b01;
        ALUSrcB = 2'b10;
        ALUOp = 2'b00;
        ResultSrc = 2'b00;
        PCUpdate = 1'b1;
      end
      // BEQ
      S10: begin
        ALUSrcA = 2'b10;
        ALUSrcB = 2'b00;
        ALUOp = 2'b01;
        ResultSrc = 2'b00;
        Branch = 1'b1;
      end
      default: ;
    endcase
  end
endmodule
