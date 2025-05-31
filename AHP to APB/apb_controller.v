//apb controller

module apb_controller(
input hclk,hresetn,valid,hwritereg,hwrite,
input [31:0] haddr,haddr1,haddr2,hwdata1,hwdata2,prdata,
input [2:0] tempselx,
output pwrite,penable,hreadyout,
output [2:0] pselx,
output [31:0] pwdata,paddr  );

parameter [2:0] IDLE=0, WWAIT=1, WRITEP=2, WENABLEP=3, 
                WRITE=4, WENABLE=5, READ=6, RENABLE=7;
		
reg [2:0] p_s,n_s;
reg pwrite_temp,penable_temp,hreadyout_temp;
reg [2:0] pselx_temp;
reg [31:0] paddr_temp,pwdata_temp;

always @(posedge hclk) begin                  //sequential
if(!hresetn)
  p_s<=IDLE;
else
  p_s<=n_s;
end

always @(*) begin                            //combinational
n_s=IDLE;
case(p_s)
  IDLE    :   if (!valid)
                n_s=IDLE;
              else if (valid && !hwritereg)
                n_s=READ;
              else if (valid && hwritereg)
                n_s=WWAIT;
	      else
                n_s=IDLE;

  READ    :   n_s=RENABLE;

  WWAIT   :   if (valid)
                n_s=WRITEP;
              else
                n_s=WRITE;

  WRITE   :   if (valid)
                n_s=WENABLEP;
              else
                n_s=WENABLE;

  WRITEP  :   n_s=WENABLEP;

  WENABLE :   if (valid && hwritereg)
                n_s=WWAIT;
              else if (valid && !hwritereg)
                n_s=READ;
              else if (!valid)
                n_s=IDLE;
              else
		n_s=WENABLE;

  WENABLEP:   if (valid && hwrite)
                n_s=WRITEP;
              else if (!valid && hwrite)
                n_s=WRITE;
              else if (valid && !hwrite)
                n_s=READ;
	      else
	      n_s=WENABLEP;

  RENABLE :   if (valid && hwritereg)
                n_s=WWAIT;
              else if (valid && !hwritereg)
                n_s=READ;
              else if (!valid)
                n_s=IDLE; 
	      else
		n_s=RENABLE;

endcase
end

//output logic

always @(*) begin
case(p_s)
  IDLE    :   if (valid && !hwritereg) begin  //read
                paddr_temp=haddr;
                pwrite_temp=1'b0;
                pselx_temp=tempselx;
                penable_temp=1'b0;
                hreadyout_temp=1'b0;
                end
              else if (valid && hwritereg) begin   //wwait
                pselx_temp=3'b0;
                penable_temp=1'b0;
                hreadyout_temp=1'b1;
                end

  READ    :   begin   //renable
              penable_temp=1'b1;
              hreadyout_temp=1'b1;
              end

  WWAIT   :   if (valid) begin   //writep
                paddr_temp=haddr2;
                pwrite_temp=hwrite;
                pselx_temp=tempselx;
                penable_temp=1'b0;
                pwdata_temp=hwdata1;
                hreadyout_temp=1'b0;
                end
              else begin   //write
                paddr_temp=haddr;
                pwrite_temp=hwrite;
                pselx_temp=tempselx;
                penable_temp=1'b0;
                pwdata_temp=hwdata1;
                hreadyout_temp=1'b0;
                end

  WRITE   :   if (valid) begin   //wenablep
                paddr_temp=haddr2;
                pwrite_temp=hwrite;
                pselx_temp=tempselx;
                penable_temp=1'b1;
                pwdata_temp=hwdata1;
                hreadyout_temp=1'b1;
                end
              else begin //wenable
                paddr_temp=haddr;
                pwrite_temp=1'b0;
                pselx_temp=1'b1;
                penable_temp=1'b1;
                pwdata_temp=hwdata1;
                hreadyout_temp=1'b1;
                end

  WRITEP  :   begin  //wenablep
                paddr_temp=haddr2;
                pwrite_temp=hwrite;
                pselx_temp=tempselx;
                penable_temp=1'b1;
                pwdata_temp=hwdata1;
                hreadyout_temp=1'b1;
                end

  WENABLE :   if (valid && hwritereg) begin //wwait
                pselx_temp=3'b0;
                penable_temp=1'b0;
                hreadyout_temp=1'b1;
                end
              else if (valid && !hwritereg) begin   //read
                paddr_temp=haddr;
                pwrite_temp=1'b0;
                pselx_temp=tempselx;
                penable_temp=1'b0;
                hreadyout_temp=1'b0;
                end
              else if (!valid) begin    //idle
                pselx_temp=3'b0;
                penable_temp=1'b0;
                hreadyout_temp=1'b0;
                end
              
  WENABLEP:   if (valid && hwrite) begin   //writep
                paddr_temp=haddr2;
                pwrite_temp=hwrite;
                pselx_temp=tempselx;
                penable_temp=1'b0;
                pwdata_temp=hwdata1;
                hreadyout_temp=1'b0;
                end
              else if (!valid && hwrite) begin   //write
                paddr_temp=haddr;
                pwrite_temp=hwrite;
                pselx_temp=tempselx;
                penable_temp=1'b0;
                pwdata_temp=hwdata1;
                hreadyout_temp=1'b0;
                end
              else if (valid && !hwrite) begin  //read
                paddr_temp=haddr;
                pwrite_temp=1'b0;
                pselx_temp=tempselx;
                penable_temp=1'b0;
                hreadyout_temp=1'b0;
                end

  RENABLE :   if (valid && hwritereg) begin //wwait
                pselx_temp=3'b0;
                penable_temp=1'b0;
                hreadyout_temp=1'b1;
                end
              else if (valid && !hwritereg) begin  //read
                paddr_temp=haddr;
                pwrite_temp=1'b0;
                pselx_temp=tempselx;
                penable_temp=1'b0;
                hreadyout_temp=1'b0;
                end
              else if (!valid) begin    //idle
                pselx_temp=3'b0;
                penable_temp=1'b0;
                hreadyout_temp=1'b0;
                end

endcase
end

assign pwrite=pwrite_temp;
assign penable=penable_temp;
assign hreadyout=hreadyout_temp;
assign pselx=pselx_temp;
assign paddr=paddr_temp;
assign pwdata=pwdata_temp;

endmodule
