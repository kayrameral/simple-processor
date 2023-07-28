`timescale 1ns / 1ps

 module islemci(
    input clk,
    input rst,    
    input  [31:0] buyruk,
    output  reg [31:0] ps
     );
    reg [31:0] yazmac_obegi[255:0];    
    reg [31:0] veri_bellek[127:0];
    reg [31:0] immDuzenleme;
    
    initial begin            
        ps = 0;
        yazmac_obegi[0]=0;
        immDuzenleme[31:0]=0;
       
        
   
    end
    
    always@(posedge clk or posedge rst) begin
    if(rst)begin
       ps<=0;
       yazmac_obegi[0]<=0;
       immDuzenleme[31:0]<=0;
    end  
    else begin
    ////////////////////////////////////////////////////////////////
        ps<=ps+4;
        if(buyruk[6:0]==51)begin
            if(buyruk[14:12]==0)begin
               if(buyruk[30]==0)begin//add   
                  yazmac_obegi[buyruk[9:7]]<=yazmac_obegi[buyruk[17:15]] + yazmac_obegi[buyruk[22:20]];
                  yazmac_obegi[0]=0;
                  ps<=ps+4;   
                end 
                else if(buyruk[30]==1)begin//sub
                    yazmac_obegi[3]<=yazmac_obegi[buyruk[17:15]]-yazmac_obegi[buyruk[22:20]];
                    yazmac_obegi[0]=0;
                    ps<=ps+4;
                end
            end
            else if(buyruk[14:12]==4)begin//xor
                yazmac_obegi[buyruk[9:7]]<=yazmac_obegi[buyruk[17:15]]^yazmac_obegi[buyruk[22:20]];
                yazmac_obegi[0]=0;
                 ps<=ps+4;
            end
            else if(buyruk[14:12]==7)begin//and
              yazmac_obegi[buyruk[9:7]]<=yazmac_obegi[buyruk[17:15]]&yazmac_obegi[buyruk[22:20]];
              yazmac_obegi[0]=0;
              ps<=ps+4;
            end
            else if(buyruk[14:12]==6)begin//or
                yazmac_obegi[buyruk[9:7]]<=yazmac_obegi[buyruk[17:15]]| yazmac_obegi[buyruk[22:20]];
                yazmac_obegi[0]=0;
                 ps<=ps+4;
            end
        end        
        /////////////////////////////////////////////////////
        else if(buyruk[6:0]==19)begin
            if(buyruk[14:12]==0)begin//addi
                if(buyruk[31]==0)begin 
                    immDuzenleme[31:12]=0;
                end
                else if(buyruk[31]==1)begin 
                    immDuzenleme[31:12]=1048575;
                end
                immDuzenleme[11:0]=buyruk[31:20];
                
                yazmac_obegi[0]=0;
                    yazmac_obegi[buyruk[9:7]]<=yazmac_obegi[buyruk[17:15]] + immDuzenleme[31:0];
                    ps<=ps+4;
            end 
        end
        /////////////////////////////////////////////////////
        else if(buyruk[6:0]==103)begin//jalr
            yazmac_obegi[buyruk[9:7]]<=ps+4;
            if(buyruk[31]==0)begin 
                immDuzenleme[31:12]=0;
            end
            else if(buyruk[31]==1)begin 
                immDuzenleme[31:12]=1048575;
            end
            immDuzenleme[11:0]=buyruk[31:20];
            ps<=yazmac_obegi[buyruk[17:15]]+immDuzenleme[31:0];
        end
        /////////////////////////////////////////////////////
        else if(buyruk[6:0]==111)begin//jal
            if(buyruk[31]==0)begin 
                immDuzenleme[31:21]=0;
            end
            else if(buyruk[31]==1)begin 
                immDuzenleme[31:21]=2047;
            end
            immDuzenleme[20]=buyruk[31];
            immDuzenleme[10:1]=buyruk[30:21];
            immDuzenleme[11]=buyruk[20];
            immDuzenleme[19:12]=buyruk[19:12];
            immDuzenleme[0]=0;
            yazmac_obegi[buyruk[9:7]]<=ps+4;
            yazmac_obegi[0]=0;
            ps<=ps+immDuzenleme[31:0];
        end
         /////////////////////////////////////////////////////
        else if(buyruk[6:0]==99)begin   
            if(buyruk[14:12]==0)begin//beq
                if(yazmac_obegi[buyruk[17:15]]==yazmac_obegi[buyruk[22:20]])begin
                   if(buyruk[31]==0)begin 
                        immDuzenleme[31:13]=0;
                   end
                   else if(buyruk[31]==1)begin 
                        immDuzenleme[31:13]=524287;
                   end
                   immDuzenleme[31:13]=0;
                   immDuzenleme[12]=buyruk[31];
                   immDuzenleme[10:5]=buyruk[30:25];
                   immDuzenleme[11]=buyruk[7];
                   immDuzenleme[4:1]=buyruk[11:8];
                   immDuzenleme[0]=0;                   
                   ps<=immDuzenleme[31:0];
                end
                else begin
                    ps<=ps+4;
                end
            end
            //////////////////////////////////////////
            else if(buyruk[14:12]==1)begin//bne
                if(yazmac_obegi[buyruk[17:15]]==yazmac_obegi[buyruk[22:20]])begin
                   ps<=ps+4;
                end 
                else begin
                   if(buyruk[31]==0)begin 
                    immDuzenleme[31:13]=0;
                   end
                   else if(buyruk[31]==1)begin 
                    immDuzenleme[31:13]=524287;
                   end
                   immDuzenleme[12]=buyruk[31];
                   immDuzenleme[10:5]=buyruk[30:25];
                   immDuzenleme[11]=buyruk[7];
                   immDuzenleme[4:1]=buyruk[11:8];
                   immDuzenleme[0]=0;                   
                   ps<=immDuzenleme[31:0];   
                 end                
            end           
            ///////////////////////////////////////////         
            else if(buyruk[14:12]==5)begin//blt
                 if(yazmac_obegi[buyruk[17:15]]<yazmac_obegi[buyruk[22:20]])begin
                   if(buyruk[31]==0)begin 
                        immDuzenleme[31:13]=0;
                    end
                   else if(buyruk[31]==1)begin 
                        immDuzenleme[31:13]=524287;
                   end
                   immDuzenleme[31:13]=0;
                   immDuzenleme[12]=buyruk[31];
                   immDuzenleme[10:5]=buyruk[30:25];
                   immDuzenleme[11]=buyruk[7];
                   immDuzenleme[4:1]=buyruk[11:8];
                   immDuzenleme[0]=0;                   
                   ps<=immDuzenleme[31:0];
                 end  
                 else begin 
                     ps<=ps+4;
                 end                
            end     
        end
        ////////////////////////////////////////////////
        else if(buyruk[6:0]==55)begin//lui
            immDuzenleme[31:12]=buyruk[31:12];
            immDuzenleme[11:0]=0;
            yazmac_obegi[buyruk[9:7]]<=immDuzenleme[31:0];
            yazmac_obegi[0]=0;
            ps<=ps+4;
       end
       /////////////////////////////////////////////////
       else if(buyruk[6:0]==23)begin//auipc
            immDuzenleme[31:12]=buyruk[31:12];
            immDuzenleme[11:0]=0;
            yazmac_obegi[buyruk[9:7]]=immDuzenleme[31:0]+ps;
            yazmac_obegi[0]=0;
            ps<=ps+4;
       end
       ///////////////////////////////////////////////////////
       else if(buyruk[6:0]==3)begin//lw
            if(buyruk[31]==0)begin 
                immDuzenleme[31:12]=0;
            end
            else if(buyruk[31]==1)begin 
                immDuzenleme[31:12]=1048575;
            end
            immDuzenleme[11:0]=buyruk[31:20];
            
            if(immDuzenleme[31:0]+yazmac_obegi[buyruk[17:15]]%4==0) begin
                yazmac_obegi[buyruk[9:7]]<= veri_bellek[(immDuzenleme[31:0]+yazmac_obegi[buyruk[17:15]])>>2];
            end
            yazmac_obegi[0]=0;
            ps<=ps+4;
       end
       //////////////////////////////////////////////////
       else if(buyruk[6:0]==35)begin//sw
            if(buyruk[31]==0)begin 
                immDuzenleme[31:12]=0;
            end
            else if(buyruk[31]==1)begin 
                immDuzenleme[31:12]=1048575;
            end
            immDuzenleme[11:5]=buyruk[31:25];
            immDuzenleme[4:0]=buyruk[11:7];
            if((immDuzenleme[31:0]+yazmac_obegi[buyruk[17:15]])%4==0) begin
                veri_bellek[(immDuzenleme[31:0]+yazmac_obegi[buyruk[17:15]])>>2]<=yazmac_obegi[buyruk[22:20]];
            end
            yazmac_obegi[0]=0;
            ps<=ps+4;
       end
      
    end  
        
    end
    
    
    
    
    
    
    
endmodule