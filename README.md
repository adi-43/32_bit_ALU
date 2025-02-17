# 32_bit_ALU

Verilog code for 32 Bit ALU

The 32-bit ALU is a combinational circuit taking two 32-bit data words A and B as inputs, and producing a 32-bit output Y by performing a specified arithmetic or logical function on the A and B inputs. The particular function to be performed is specified by a 6-bit control input, FN, whose value encodes the function according to the following table: FN[5:0] Operation Output value Y[31:0] 00-011 CMPEQ Y=(A==B) 00-101 CMPLT Y=(A<B) 00-111 CMPLE Y=(A≤B) 01---0 32-bit ADD Y=A+B 01---1 32-bit SUBTRACT Y=A−B 10abcd Bit-wise Boolean Y[i]=Fabcd(A[i],B[i]) 11--00 Logical Shift left (SHL) Y=A<<B 11--01 Logical Shift right (SHR) Y=A>>B 11--11 Arithmetic Shift right (SRA) Y=A>>B (sign extended) Note that by specifying an appropriate value for the 6-bit FN input, the ALU can perform a variety of arithmetic operations, comparisons, shifts, and bitwise Boolean combinations.
