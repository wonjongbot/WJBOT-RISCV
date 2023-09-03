import wjbot_riscv::opcodetype_t;

module instr_decoder( input opcodetype_t op,
                      output logic [1:0] ImmSrc);
  always_comb begin
    ImmSrc = 2'bxx;
    case (op)
      wjbot_riscv::lw_op:          ImmSrc = 2'b00;
      wjbot_riscv::sw_op:          ImmSrc = 2'b01;
      wjbot_riscv::r_type_op:      ImmSrc = 2'b00;
      wjbot_riscv::beq_op:         ImmSrc = 2'b10;
      wjbot_riscv::i_type_alu_op:  ImmSrc = 2'b00;
      wjbot_riscv::jal_op:         ImmSrc = 2'b11;
      default: ;
    endcase
  end
endmodule
