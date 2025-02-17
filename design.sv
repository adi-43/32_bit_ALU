module mux4_1 #(parameter WIDTH = 1) (
    input [1:0] sel,
    input [3:0] in,
    output reg out
);
    always @ (*)
        case(sel)
            2'b00: out = in[0];
            2'b01: out = in[1];
            2'b10: out = in[2];
            2'b11: out = in[3];
            default: out = 1'bx;
        endcase
endmodule

module arith_add #(parameter WIDTH = 32) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input sel,
    output [WIDTH-1:0] out,
    output Z,
    output V,
    output N
);
    wire xb;
    xor g0(xb, b[WIDTH-1], sel);
    assign out = sel ? a - b : a + b;
    assign Z = !(|out);
    assign V = (a[WIDTH-1] && xb && (!out[WIDTH-1])) || ((!a[WIDTH-1]) && (!xb) && out[WIDTH-1]);
    assign N = out[WIDTH-1];
endmodule

module cmp #(parameter WIDTH = 32) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [1:0] sel,
    output reg [WIDTH-1:0] out
);
    wire [WIDTH-1:0] Q;
    wire V, Z, N;
    wire lt, le;

    arith_add #(WIDTH) m0(a, b, 1'b1, Q, Z, V, N);
    xor g1(lt, V, N);
    or g2(le, Z, lt);

    always @(*)
        case(sel)
            2'b01: out = Z;
            2'b10: out = lt;
            2'b11: out = le;
            default: out = 1'bx;
        endcase
endmodule

module bitwise_bool #(parameter WIDTH = 32) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [3:0] fn,
    output [WIDTH-1:0] out
);
    genvar i;
    generate
        for(i = 0; i < WIDTH; i = i + 1) begin: mux4_1_gen_label
            mux4_1 #(1) mux_inst({b[i], a[i]}, fn, out[i]);
        end
    endgenerate
endmodule

module shift #(parameter WIDTH = 32) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [1:0] sel,
    output reg [WIDTH-1:0] out
);
    wire [WIDTH-1:0] t0, t1, t3;

    assign t0 = a << b;
    assign t1 = a >> b;
    assign t3 = a >>> b;

    always @ (*)
        case(sel)
            2'b00: out = t0;
            2'b01: out = t1;
            2'b11: out = t3;
            default: out = 1'bx;
        endcase
endmodule

module ALU #(parameter WIDTH = 32) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input [5:0] fn,
    output reg [WIDTH-1:0] out
);
    wire Z, V, N;
    wire [WIDTH-1:0] t0, t1, t2, t3;

    bitwise_bool #(WIDTH) m3(a, b, fn[3:0], t2);
    cmp #(WIDTH) m1(a, b, {fn[2], fn[1]}, t0);
    arith_add #(WIDTH) m2(a, b, fn[0], t1, Z, V, N);
    shift #(WIDTH) m4(a, b, {fn[1], fn[0]}, t3);

    always @ (*)
        case({fn[5], fn[4]})
            2'b00: out = t0;
            2'b01: out = t1;
            2'b10: out = t2;
            2'b11: out = t3;
        endcase
endmodule