//ahb slave interface

module ahb_slave_interface(
input hclk,hresetn,hwrite,hreadyin,
input [1:0] htrans,hresp,
input [31:0] haddr,hwdata,prdata,
output reg [31:0] haddr1,haddr2,hwdata1,hwdata2,hrdata,
output reg valid,hwritereg,
output reg [2:0] tempselx,psize );

always @(*) begin
if (!hresetn) begin
  valid=1'b0;
  if((hreadyin)&&(htrans==2'b10||htrans==2'b11)&&(haddr>=32'h80000000&&haddr<32'h8c000000))
    valid=1'b1;
  else
    valid=1'b0;
  end
end

always @(*) begin
tempselx=3'b0;
if(haddr>=32'h8000_0000&&haddr<32'h8400_0000)
  tempselx=3'b001;
else if(haddr>=32'h8400_0000&&haddr<32'h8800_0000)
  tempselx=3'b010;
else if(haddr>=32'h8800_0000&&haddr<32'h8c00_0000)
  tempselx=3'b011;
else
  tempselx=3'b000;
end

always @(posedge hclk) begin
if (!hresetn) begin
  haddr1<=32'b0;
  haddr2<=32'b0;
  end
else begin
  haddr1<=haddr;
  haddr2<=haddr1;
  end
end

always @(posedge hclk) begin
if (!hresetn) begin
  hwdata1<=32'b0;
  hwdata2<=32'b0;
  end
else begin
  hwdata1<=hwdata;
  hwdata2<=hwdata1;
  end
end

endmodule
