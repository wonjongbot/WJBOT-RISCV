import wjbot_riscv::proj_root;

typedef enum logic[6:0] { r_type_op     = 7'b0110011,
i_type_alu_op = 7'b0010011,
lw_op         = 7'b0000011,
sw_op         = 7'b0100011,
beq_op        = 7'b1100011,
jal_op        = 7'b1101111 } opcodetype_t;
module tb_alu_decoder #(parameter VECTORSIZE=10);
  logic                   clk;
  logic                   op_5, funct7_5;
  logic [1:0]             ALUOp;
  logic [2:0]             funct3;
  logic [2:0]             ALUControl, ALUControlExpected;
  logic [6:0]             hash;
  logic [31:0]            vectornum, errors;
  // 32-bit numbers used to keep track of how many test vectors have been
  logic [VECTORSIZE-1:0]  testvectors[1000];
  logic [VECTORSIZE-1:0]  DONE = 'bx;

  // instantiate device under test
  alu_decoder dut(ALUOp, funct3, op_5, funct7_5, ALUControl);

  // generate clock
  always begin
   clk = 1; #5; clk = 0; #5;
  end

  // at start of test, load vectors and pulse reset
  initial begin
    $readmemb({proj_root, "HarrisAndHarris_DDCA/src/testbenches/vectors/aludecoder.tv"}, testvectors);
    vectornum = 0; errors = 0;
    hash = 0;
  end

  // apply test vectors on rising edge of clk
  always @(posedge clk) begin
    #1; {ALUOp, funct3, op_5, funct7_5, ALUControlExpected} = testvectors[vectornum];
  end

  // Check results on falling edge of clock.
  always @(negedge clk)begin
      if (ALUControl !== ALUControlExpected) begin // result is bad
      $display("Error: inputs=%b %b %b %b", ALUOp, funct3, op_5, funct7_5);
      $display(" outputs = %b (%b expected)", ALUControl, ALUControlExpected);
      errors = errors+1;
    end
    vectornum = vectornum + 1;
    hash = hash ^ {ALUControl};
    hash = {hash[5:0], hash[6] ^ hash[5]};
    if (testvectors[vectornum] === DONE) begin
      #2;
      $display("%d tests completed with %d errors", vectornum, errors);
      $display("Hash: %h", hash);
      $stop;
    end
  end
endmodule
