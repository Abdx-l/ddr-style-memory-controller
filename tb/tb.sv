module tb;
 logic clk=0,rst=1,valid=0,write=0,ready,rvalid;
 logic [1:0] bank=0,cmd_bank;
 logic [3:0] row=0,col=0,cmd_row,cmd_col;
 logic [31:0] wdata=0,rdata,cmd_wdata,mem_rdata;
 logic [2:0] cmd;
 always #5 clk=~clk;
 ddr_controller #(.TREFI(80)) dut(.*);
 memory_model memory(.clk(clk),.rst(rst),.cmd(cmd),.bank(cmd_bank),.row(cmd_row),.col(cmd_col),.wdata(cmd_wdata),.rdata(mem_rdata));
 integer refs=0;
 always @(posedge clk) if(cmd==5) refs=refs+1;
 task transaction(input bit wr,input integer b,r,c,input logic [31:0] value);
  begin
   @(negedge clk); while(!ready) @(negedge clk);
   valid=1;write=wr;bank=b;row=r;col=c;wdata=value;
   @(negedge clk);valid=0;
   while(!rvalid) @(negedge clk);
   if(!wr && rdata!==value) $fatal(1,"data mismatch: %h expected %h",rdata,value);
  end
 endtask
 initial begin
  repeat(3) @(negedge clk);rst=0;
  for(integer b=0;b<4;b=b+1)
   for(integer r=0;r<3;r=r+1)
    for(integer c=0;c<4;c=c+1) transaction(1,b,r,c,b*256+r*16+c);
  for(integer b=0;b<4;b=b+1)
   for(integer r=0;r<3;r=r+1)
    for(integer c=0;c<4;c=c+1) transaction(0,b,r,c,b*256+r*16+c);
  repeat(150) @(negedge clk);
  if(refs==0) $fatal(1,"refresh never issued");
  rst=1;repeat(3) @(negedge clk);rst=0;
  transaction(1,0,0,0,32'h1234);transaction(0,0,0,0,32'h1234);
  $display("PASS directed row hit, conflict, bank, refresh, reset");$finish;
 end
 initial begin #1000000;$fatal(1,"timeout");end
endmodule
