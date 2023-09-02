// aludec.sv
// trao@g.hmc.edu 15 January 2020
// Updated for RISC-V Architecture

module aludecoder(input  logic [1:0] ALUOp,
                  input  logic [2:0] funct3,
                  input  logic op_5, funct7_5,
                  output logic [2:0] ALUControl);
  always_comb begin : decoderlogic
    case (ALUOp)
      2'b00: ALUControl = 3'b000;
      2'b01: ALUControl = 3'b001;
      2'b11: begin
        case (funct3)
          3'b000: 
            case ({op_5, funct7_5})
              2'b00,
              2'b01,
              2'b10: ALUControl = 3'b000;
              2'b11: ALUControl = 3'b001;
              default: ALUControl = 3'b000;
            endcase
          3'b010: ALUControl = 3'b101;
          3'b110: ALUControl = 3'b011;
          3'b111: ALUControl = 3'b010;
        endcase
      end
      default: ALUControl = 3'b000;
    endcase
  end
endmodule

module testbench #(parameter VECTORSIZE=10);
  logic                   clk;
  logic                   op_5, funct7_5;
  logic [1:0]             ALUOp;
  logic [2:0]             funct3;
  logic [2:0]             ALUControl, ALUControlExpected;
  logic [6:0]             hash;
  logic [31:0]            vectornum, errors;
  // 32-bit numbers used to keep track of how many test vectors have been
  logic [VECTORSIZE-1:0]  testvectors[1000:0];
  logic [VECTORSIZE-1:0]  DONE = 'bx;
  
  // instantiate device under test
  aludecoder dut(ALUOp, funct3, op_5, funct7_5, ALUControl);
  
  // generate clock
  always begin
   clk = 1; #5; clk = 0; #5; 
  end
  
  // at start of test, load vectors and pulse reset
  initial begin
    $readmemb("aludecoder.tv", testvectors); // Students may have to add a file path if ModelSim set up incorrectly
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