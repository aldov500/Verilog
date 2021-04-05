//Aldo Alexandro Vargas Meza
//Maquina de estados moore
module moore(
  input wire[1:0]a,
  input wire clk,
  input wire reset,
  output reg out
  
);
reg state;
reg bandera;


always@(posedge clk or state)
  begin
    if(a>=2'b10)begin
      bandera=1;
      state=0;
      out=0;
    end
    else if(reset)begin
      bandera=0;
      state=0;
      out=0;
    end
        case(state)
            0:
              if(a==2'b00 && bandera==1)begin
                state=0;
                out=0;
              end
                
              else if(a==2'b01 && bandera==1)begin
                state=1;
                out=1;
              end
                
            1:
              if(a==2'b00 && bandera==1)begin
                state=1;
                out=1;
              end
              else if(a==2'b01 && bandera==1)begin
                state=0;
                out=0;
                
              end
              
        endcase
  end
  
endmodule

