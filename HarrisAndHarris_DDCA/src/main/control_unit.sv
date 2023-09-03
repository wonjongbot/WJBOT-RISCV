// controller.sv
//
// This file is for HMC E85A Lab 5.
// Place controller.tv in same computer directory as this file to test your multicycle controller.
//
// Starter code last updated by Ben Bracker (bbracker@hmc.edu) 1/14/21
// - added opcodetype enum
// - updated testbench and hash generator to accomodate don't cares as expected outputs
// Solution code by ________ (________) ________

import wjbot_riscv::opcodetype_t;

module control_unit(input  logic       clk,
                    input  logic       reset,
                    input  opcodetype_t  op,
                    input  logic [2:0] funct3,
                    input  logic       funct7b5,
                    input  logic       Zero,
                    output logic [1:0] ImmSrc,
                    output logic [1:0] ALUSrcA, ALUSrcB,
                    output logic [1:0] ResultSrc,
                    output logic       AdrSrc,
                    output logic [2:0] ALUControl,
                    output logic       IRWrite, PCWrite,
                    output logic       RegWrite, MemWrite);
  logic Branch, PCUpdate;
  logic [1:0] ALUOp;

  control_unit_fsm main_fsm(.op(op),  .clk(clk),  .reset(reset),
                            .Branch(Branch),      .PCUpdate(PCUpdate),
                            .RegWrite(RegWrite),  .MemWrite(MemWrite),
                            .IRWrite(IRWrite),    .ResultSrc(ResultSrc),
                            .ALUSrcA(ALUSrcA),    .ALUSrcB(ALUSrcB),
                            .AdrSrc(AdrSrc),      .ALUOp(ALUOp));

  // glue logic for PCWrite
  assign PCWrite = (Zero & Branch) | PCUpdate;

  alu_decoder aludec( .ALUOp(ALUOp), .op_5(op[5]),
                      .funct3(funct3), .funct7_5(funct7b5),
                      .ALUControl(ALUControl));

  instr_decoder instrdec( .op(op), .ImmSrc(ImmSrc));

endmodule
