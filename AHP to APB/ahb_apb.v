//bridge_top module

module ahb_apb(
input hclk,hresetn,hwrite,hreadyin,
input [1:0] htrans,
input [31:0] haddr,hwdata,prdata,
output pwrite,penable,hreadyout,
output [2:0] pselx,
output [31:0] pwdata,paddr,hrdata );


wire valid,hwritereg;
wire [1:0] hresp;
wire [2:0] tempselx;
wire [31:0] haddr1,haddr2,hwdata1,hwdata2;

ahb_slave_interface u1(hclk,hresetn,hwrite,hreadyin,htrans,hresp,haddr,hwdata,prdata,
                       haddr1,haddr2,hwdata1,hwdata2,hrdata,valid,hwritereg,tempselx,psize);

apb_controller u2(hclk,hresetn,valid,hwritereg,hwrite,haddr,haddr1,haddr2,hwdata1,hwdata2,prdata,tempselx,
                  pwrite,penable,hreadyout,pselx,pwdata,paddr);

endmodule


