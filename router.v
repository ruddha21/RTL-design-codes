//router.v
module gold_router(cwsi,cwri,cwdi,ccwsi,ccwri,ccwdi,pesi,peri,pedi,cwso,cwro,cwdo,ccwso,ccwro,ccwdo,peso,pero,pedo,clk,reset,polarity);
	input cwsi;
	output cwri;
	reg cwri;
	input [0:63] cwdi;
	input ccwsi;
	output ccwri;
	reg ccwri;
	input [0:63] ccwdi;
	input pesi;
	output peri;
	reg peri;
	input [0:63] pedi;
	output cwso;
	reg cwso;
	input cwro;
	output [0:63] cwdo;
	reg [0:63] cwdo;
	output ccwso;
	reg ccwso;
	input ccwro;
	output [0:63] ccwdo;
	reg [0:63] ccwdo;
	output peso;
	reg peso;
	input pero;
	output [0:63] pedo;
	reg [0:63] pedo;
	input clk,reset;
	output polarity;
	reg polarity;
	reg [0:63] cwi_even_buff;
	reg [0:63] cwi_odd_buff;
	reg [0:63] cwo_even_buff;
	reg [0:63] cwo_odd_buff;
	reg [0:63] ccwi_even_buff;
	reg [0:63] ccwi_odd_buff;
	reg [0:63] ccwo_even_buff;
	reg [0:63] ccwo_odd_buff;
	reg [0:63] pei_even_buff;
	reg [0:63] pei_odd_buff;
	reg [0:63] peo_even_buff;
	reg [0:63] peo_odd_buff;
	reg cwi_even_buffer_empty;
	reg cwi_odd_buffer_empty;
	reg ccwi_even_buffer_empty;
	reg ccwi_odd_buffer_empty;
	reg pei_even_buffer_empty;
	reg pei_odd_buffer_empty;
	reg cwo_odd_buffer_empty;
	reg cwo_even_buffer_empty;
	reg ccwo_odd_buffer_empty;
	reg ccwo_even_buffer_empty;
	reg peo_odd_buffer_empty;
	reg peo_even_buffer_empty;
	reg priority_cwo,priority_ccwo,priority_peo;
	//reg state,nxt_state;
	//parameter idle_state		= 1'b0;
	//parameter ip_routing_state  = 1'b1;
	

	always@(posedge clk) begin
		if(reset) begin
			pedo=64'h0;
			cwdo=64'h0;
			ccwdo=64'h0;
			cwi_even_buff=64'h0;
			cwi_odd_buff=64'h0;
			cwo_even_buff=64'h0;
			cwo_odd_buff=64'h0;
			ccwi_even_buff=64'h0;
			ccwi_odd_buff=64'h0;
			ccwo_even_buff=64'h0;
			ccwo_odd_buff=64'h0;
			pei_even_buff=64'h0;
			pei_odd_buff=64'h0;
			peo_even_buff=64'h0;
			peo_odd_buff=64'h0;
			cwi_even_buffer_empty=1;
			cwi_odd_buffer_empty=1;
			ccwi_even_buffer_empty=1;
			ccwi_odd_buffer_empty=1;
			pei_even_buffer_empty=1;
			pei_odd_buffer_empty=1;
			cwo_odd_buffer_empty=1;
			cwo_even_buffer_empty=1;
			ccwo_odd_buffer_empty=1;
			ccwo_even_buffer_empty=1;
			peo_odd_buffer_empty=1;
			peo_even_buffer_empty=1;
			priority_cwo=1;
			priority_ccwo=1;
			priority_peo=1;
			cwso=0;
			ccwso=0;
			peso=0;
			cwri=1;
			ccwri=1;
			peri=1;
			polarity <= 0;
		end
				
		else begin
			cwso = 0;
			ccwso = 0;
			peso = 0;
			pedo=64'h0;
			cwdo=64'h0;
			ccwdo=64'h0;
			polarity <= ~polarity;
			if(polarity==0)
			begin
				if(cwi_odd_buffer_empty==1)
					begin
					cwri=1;
					end
				else
					begin
					cwri=0;
					end
		
				if(ccwi_odd_buffer_empty==1)
					begin
					ccwri=1;
					end
				else
					begin
					ccwri=0;
					end
			
				if(pei_odd_buffer_empty==1)
					begin
					peri=1;
					end
				else
					begin
					peri=0;
					end
			end
			
			else
			begin
				if(cwi_even_buffer_empty==1)
					begin
					cwri=1;
					end
				else
					begin
					cwri=0;
					end
			
				if(ccwi_even_buffer_empty==1)
					begin
					ccwri=1;
					end
				else
					begin
					ccwri=0;
					end
			
				if(pei_even_buffer_empty==1)
					begin
					peri=1;
					end
				else
					begin
					peri=0;
				end
			end

			/////////////////////////////////////////////////////////////////
			//begin of input latching 
			////////////////////////////////////////////////////////////////

			if(pesi==1) //if the previous router wants to send data
			begin
				if(peri==1) //if the current router is ready
				begin
					if(polarity==0) //if polarity is 0 externally odd packets travel(which is the case here) and internally even packets travel
						begin
						pei_odd_buff=pedi;
						pei_odd_buffer_empty=0; //latch in the data and say that the buffer is not empty
						end
					else
						begin
						pei_even_buff=pedi;
						pei_even_buffer_empty=0;
						end
				end
				else
					;				
			end
			else 
				;

			if(ccwsi==1)//if the previous router wants to send data
			begin
				if(ccwri==1)//if the current router is ready
					begin
					if(polarity==0)//if polarity is 0 externally odd packets travel and internally even packets travel
						begin
						ccwi_odd_buff=ccwdi;
						ccwi_odd_buffer_empty=0;
						//$display("ccwi_odd = %16h", ccwi_odd_buff);
						//data_latched_flag=1;
						end
					else
						begin
						ccwi_even_buff=ccwdi;
						ccwi_even_buffer_empty=0;
						//$display("ccwi_even = %16h", ccwi_even_buff);
						//data_latched_flag=1;
						end
				end
				else
					;
			end
			else
				;

			if(cwsi==1)//if the previous router wants to send data
			begin
				if(cwri==1)//if the current router is ready
					begin
					if(polarity==0)//if polarity is 0 externally odd packets travel and internally even packets travel
						begin
						cwi_odd_buff=cwdi;
						cwi_odd_buffer_empty=0;
						//$display("cwi_odd = %16h", cwi_odd_buff);
						//data_latched_flag=1;
					end
					else
						begin
						cwi_even_buff=cwdi;
						cwi_even_buffer_empty=0;
						//$display("cwi_even = %16h", cwi_even_buff);
						//data_latched_flag=1;
					end
				end
				else
					;
			end
			else
				;

				
		/////////////////////////////////////////////////////////////////
		//end of input latching 
		////////////////////////////////////////////////////////////////
			
			if(polarity == 0) begin
				if(peo_even_buffer_empty == 1) begin //for peo odd buffer routing
					if((cwi_even_buffer_empty == 0 && (cwi_even_buff[8:15] == 8'h00)) && !(ccwi_even_buffer_empty == 0 && (ccwi_even_buff[8:15] == 8'h00))) begin
						//cwi_even_buff[8:15]=cwi_even_buff[8:15]-8'h01;
						peo_even_buff=cwi_even_buff;
						cwi_even_buffer_empty=1;
						peo_even_buffer_empty = 0;
					end
					else if((ccwi_even_buffer_empty == 0 && (ccwi_even_buff[8:15] == 8'h00)) && !(cwi_even_buffer_empty == 0 && (cwi_even_buff[8:15] == 8'h00))) begin
						//ccwi_even_buff[8:15]=ccwi_even_buff[8:15]-8'h01;
						peo_even_buff=ccwi_even_buff;
						ccwi_even_buffer_empty=1;
						peo_even_buffer_empty = 0;
					end
					else if ((cwi_even_buffer_empty == 0 && (cwi_even_buff[8:15] == 8'h00)) && (ccwi_even_buffer_empty == 0 && (ccwi_even_buff[8:15] == 8'h00))) begin
						if(priority_peo) begin
							//cwi_even_buff[8:15]=cwi_even_buff[8:15]-8'h01;
							peo_even_buff=cwi_even_buff;
							cwi_even_buffer_empty=1;
							peo_even_buffer_empty = 0;
							priority_peo = ~priority_peo;
						end
						else begin
							//ccwi_even_buff[8:15]=ccwi_even_buff[8:15]-8'h01;
							peo_even_buff=ccwi_even_buff;
							ccwi_even_buffer_empty=1;
							peo_even_buffer_empty = 0;
							priority_peo = ~priority_peo;
						end
					end	
					else ;
				end	
				else
					;
				
				
				if(cwo_even_buffer_empty == 1) begin // for cwo odd buffer routing
					if((cwi_even_buffer_empty == 0 && (cwi_even_buff[8:15] >= 8'h01)) && !(pei_even_buffer_empty == 0 && (pei_even_buff[1] == 1'b0))) begin
						cwi_even_buff[8:15]=cwi_even_buff[8:15]-8'h01;
						cwo_even_buff=cwi_even_buff;
						cwi_even_buffer_empty=1;
						cwo_even_buffer_empty = 0;
						//$display("cwo_even = %16h", cwo_even_buff);
						//$display("cwo_even_empty = %1b", cwo_even_buffer_empty);
					end
					else if((pei_even_buffer_empty == 0 && (pei_even_buff[1] == 1'b0) && (pei_even_buff[8:15] >= 8'b01)) && !(cwi_even_buffer_empty == 0 && (cwi_even_buff[8:15] >= 8'h01))) begin
						pei_even_buff[8:15]=pei_even_buff[8:15]-8'h01;
						cwo_even_buff=pei_even_buff;
						pei_even_buffer_empty=1;
						cwo_even_buffer_empty = 0;
						//$display("cwo_even = %16h", cwo_even_buff);
						//$display("cwo_even_empty = %1b", cwo_even_buffer_empty);
					end
					else if ((cwi_even_buffer_empty == 0 && (cwi_even_buff[8:15] >= 8'h01)) && (pei_even_buffer_empty == 0 && (pei_even_buff[1] == 1'b0) && (pei_even_buff[8:15] >= 8'b01))) begin
						if(priority_cwo) begin
							cwi_even_buff[8:15]=cwi_even_buff[8:15]-8'h01;
							cwo_even_buff=cwi_even_buff;
							cwi_even_buffer_empty=1;
							cwo_even_buffer_empty = 0;
							priority_cwo = ~priority_cwo;
							//$display("cwo_even = %16h", cwo_even_buff);
							//$display("cwo_even_empty = %1b", cwo_even_buffer_empty);
						end
						else begin
							pei_even_buff[8:15]=pei_even_buff[8:15]-8'h01;
							cwo_even_buff=pei_even_buff;
							pei_even_buffer_empty=1;
							cwo_even_buffer_empty = 0;
							priority_cwo = ~priority_cwo;
							//$display("cwo_even = %16h", cwo_even_buff);
							//$display("cwo_even_empty = %1b", cwo_even_buffer_empty);
						end
					end	
					else ;
				end	
				else
					;
				
					

				if(ccwo_even_buffer_empty == 1) begin // for ccwo odd buffer routing
					if((ccwi_even_buffer_empty == 0 && (ccwi_even_buff[8:15] >= 8'h01)) && !(pei_even_buffer_empty == 0 && (pei_even_buff[1] == 1'b1))) begin
						ccwi_even_buff[8:15]=ccwi_even_buff[8:15]-8'h01;
						ccwo_even_buff=ccwi_even_buff;
						ccwi_even_buffer_empty=1;
						ccwo_even_buffer_empty = 0;
					end
					else if((pei_even_buffer_empty == 0 && (pei_even_buff[1] == 1'b1) && (pei_even_buff[8:15] >= 8'b01)) && !(ccwi_even_buffer_empty == 0 && (ccwi_even_buff[8:15] >= 8'h01))) begin
						pei_even_buff[8:15]=pei_even_buff[8:15]-8'h01;
						ccwo_even_buff=pei_even_buff;
						pei_even_buffer_empty=1;
						ccwo_even_buffer_empty = 0;
					end
					else if ((ccwi_even_buffer_empty == 0 && (ccwi_even_buff[8:15] >= 8'h01)) && (pei_even_buffer_empty == 0 && (pei_even_buff[1] == 1'b1) && (pei_even_buff[8:15] >= 8'b01))) begin
						if(priority_cwo) begin
							ccwi_even_buff[8:15]=ccwi_even_buff[8:15]-8'h01;
							ccwo_even_buff=ccwi_even_buff;
							ccwi_even_buffer_empty=1;
							ccwo_even_buffer_empty = 0;
							priority_ccwo = ~priority_ccwo;
						end
						else begin
							pei_even_buff[8:15]=pei_even_buff[8:15]-8'h01;
							ccwo_even_buff=pei_even_buff;
							pei_even_buffer_empty=1;
							ccwo_even_buffer_empty = 0;
							priority_ccwo = ~priority_ccwo;
						end
					end	
					else ;
				end	
				else
					;
			end
			////////////////////// polarity 0 ////////////////////////
			else begin// polarity is 0
				if(peo_odd_buffer_empty == 1) begin //for peo odd buffer routing
					if((cwi_odd_buffer_empty == 0 && (cwi_odd_buff[8:15] == 8'h00)) && !(ccwi_odd_buffer_empty == 0 && (ccwi_odd_buff[8:15] == 8'h00))) begin
						//cwi_odd_buff[8:15]=cwi_odd_buff[8:15]-8'h01;
						peo_odd_buff=cwi_odd_buff;
						cwi_odd_buffer_empty=1;
						peo_odd_buffer_empty = 0;
					end
					else if((ccwi_odd_buffer_empty == 0 && (ccwi_odd_buff[8:15] == 8'h00)) && !(cwi_odd_buffer_empty == 0 && (cwi_odd_buff[8:15] == 8'h00))) begin
						//ccwi_odd_buff[8:15]=ccwi_odd_buff[8:15]-8'h01;
						peo_odd_buff=ccwi_odd_buff;
						ccwi_odd_buffer_empty=1;
						peo_odd_buffer_empty = 0;
						
					end
					else if ((cwi_odd_buffer_empty == 0 && (cwi_odd_buff[8:15] == 8'h00)) && (ccwi_odd_buffer_empty == 0 && (ccwi_odd_buff[8:15] == 8'h00))) begin
						if(priority_peo) begin
							//cwi_odd_buff[8:15]=cwi_odd_buff[8:15]-8'h01;
							peo_odd_buff=cwi_odd_buff;
							cwi_odd_buffer_empty=1;
							peo_odd_buffer_empty = 0;
							priority_peo = ~priority_peo;
						end
						else begin
							//ccwi_odd_buff[8:15]=ccwi_odd_buff[8:15]-8'h01;
							peo_odd_buff=ccwi_odd_buff;
							ccwi_odd_buffer_empty=1;
							peo_odd_buffer_empty = 0;
							priority_peo = ~priority_peo;
						end
					end	
					else ;
				end	
				else
					;
				
				
				if(cwo_odd_buffer_empty == 1) begin // for cwo odd buffer routing
					if((cwi_odd_buffer_empty == 0 && (cwi_odd_buff[8:15] >= 8'h01)) && !(pei_odd_buffer_empty == 0 && (pei_odd_buff[1] == 1'b0))) begin
						cwi_odd_buff[8:15]=cwi_odd_buff[8:15]-8'h01;
						cwo_odd_buff=cwi_odd_buff;
						cwi_odd_buffer_empty=1;
						cwo_odd_buffer_empty = 0;
						//$display("cwo_odd = %16h", cwo_odd_buff);
						//$display("cwo_odd_empty = %1b", cwo_odd_buffer_empty);
					end
					else if((pei_odd_buffer_empty == 0 && (pei_odd_buff[1] == 1'b0) && (pei_odd_buff[8:15] >= 8'b01)) && !(cwi_odd_buffer_empty == 0 && (cwi_odd_buff[8:15] >= 8'h01))) begin
						pei_odd_buff[8:15]=pei_odd_buff[8:15]-8'h01;
						cwo_odd_buff=pei_odd_buff;
						pei_odd_buffer_empty=1;
						cwo_odd_buffer_empty = 0;
						//$display("cwo_odd = %16h", cwo_odd_buff);
						//$display("cwo_odd_empty = %1b", cwo_odd_buffer_empty);
					end
					else if ((cwi_odd_buffer_empty == 0 && (cwi_odd_buff[8:15] >= 8'h01)) && (pei_odd_buffer_empty == 0 && (pei_odd_buff[1] == 1'b0) && (pei_odd_buff[8:15] >= 8'b01))) begin
						if(priority_cwo) begin
							cwi_odd_buff[8:15]=cwi_odd_buff[8:15]-8'h01;
							cwo_odd_buff=cwi_odd_buff;
							cwi_odd_buffer_empty=1;
							cwo_odd_buffer_empty = 0;
							priority_cwo = ~priority_cwo;
							//$display("cwo_odd = %16h", cwo_odd_buff);
							//$display("cwo_odd_empty = %1b", cwo_odd_buffer_empty);
						end
						else begin
							pei_odd_buff[8:15]=pei_odd_buff[8:15]-8'h01;
							cwo_odd_buff=pei_odd_buff;
							pei_odd_buffer_empty=1;
							cwo_odd_buffer_empty = 0;
							priority_cwo = ~priority_cwo;
							//$display("cwo_odd = %16h", cwo_odd_buff);
							//$display("cwo_odd_empty = %1b", cwo_odd_buffer_empty);
						end
					end	
					else ;
				end	
				else
					;
				
					

				if(ccwo_odd_buffer_empty == 1) begin // for ccwo odd buffer routing
					if((ccwi_odd_buffer_empty == 0 && (ccwi_odd_buff[8:15] >= 8'h01)) && !(pei_odd_buffer_empty == 0 && (pei_odd_buff[1] == 1'b1))) begin
						ccwi_odd_buff[8:15]=ccwi_odd_buff[8:15]-8'h01;
						ccwo_odd_buff=ccwi_odd_buff;
						ccwi_odd_buffer_empty=1;
						ccwo_odd_buffer_empty = 0;
					end
					else if((pei_odd_buffer_empty == 0 && (pei_odd_buff[1] == 1'b1) && (pei_odd_buff[8:15] >= 8'b01)) && !(ccwi_odd_buffer_empty == 0 && (ccwi_odd_buff[8:15] >= 8'h01))) begin
						pei_odd_buff[8:15]=pei_odd_buff[8:15]-8'h01;
						ccwo_odd_buff=pei_odd_buff;
						pei_odd_buffer_empty=1;
						ccwo_odd_buffer_empty = 0;
					end
					else if ((ccwi_odd_buffer_empty == 0 && (ccwi_odd_buff[8:15] >= 8'h01)) && (pei_odd_buffer_empty == 0 && (pei_odd_buff[1] == 1'b1) && (pei_odd_buff[8:15] >= 8'b01))) begin
						if(priority_cwo) begin
							ccwi_odd_buff[8:15]=ccwi_odd_buff[8:15]-8'h01;
							ccwo_odd_buff=ccwi_odd_buff;
							ccwi_odd_buffer_empty=1;
							ccwo_odd_buffer_empty = 0;
							priority_ccwo = ~priority_ccwo;
						end
						else begin
							pei_odd_buff[8:15]=pei_odd_buff[8:15]-8'h01;
							ccwo_odd_buff=pei_odd_buff;
							pei_odd_buffer_empty=1;
							ccwo_odd_buffer_empty = 0;
							priority_ccwo = ~priority_ccwo;
						end
					end	
					else ;
				end	
				else
					;
			end
			
			////////////////////////////////////////////////////
			// output sending 
			///////////////////////////////////////////////////
			
			if(pero==1)//if the next router is ready to receive data
				begin
				if(polarity==0)//if polarity is 0 externally odd packets travel(which is true here) and internally even packets travel
					begin
					if(peo_odd_buffer_empty == 0) begin
						peso=1;
						pedo=peo_odd_buff;
						peo_odd_buffer_empty=1;
						end
					else
						begin
						pedo = 64'b0;
						peso = 0;
					//	peo_odd_buffer_empty=1;
						end
				end
				else//if polarity is 1
				begin
					if(peo_even_buffer_empty == 0) begin
						peso=1;
						pedo=peo_even_buff;
						peo_even_buffer_empty=1;
						end
					else
						begin
						pedo = 64'b0;
						peso = 0;
					//	peo_even_buffer_empty=1;
						end
					end
			end//
			else
			begin
				pedo = 64'b0;
				peso = 0;				
			end

			if(cwro==1)//if the next router is ready to receive data
			begin
				if(polarity==0)//if polarity is 0 externally odd packets travel(which is true here) and internally even packets travel
					begin
					if(cwo_odd_buffer_empty == 0) begin
						cwso=1;
						cwdo=cwo_odd_buff;
						cwo_odd_buffer_empty=1;
						//$display("cwo_odd last = %16h", cwo_odd_buff);
						//$display("cwdo = %16h", cwdo);
						end
					else
						begin
						cwdo= 64'b0;
						cwso = 0;
					//	$display("pol 0 here");
					//	cwo_odd_buffer_empty=1;
						end
				end
				else//if polarity is 1
				begin
					if(cwo_even_buffer_empty == 0) begin
						cwso=1;
						cwdo=cwo_even_buff;
						cwo_even_buffer_empty=1;
						//$display("cwo_even last = %16h", cwo_even_buff);
						//$display("cwdo = %16h", cwdo);						
						end
					else
						begin
						cwdo= 64'b0;
						cwso = 0;
						//$display("pol 1 here");
					//	cwo_even_buffer_empty=1;
						end
					end
			end//
			else
			begin
				cwdo= 64'b0;
				cwso = 0;
			end
			
			if(ccwro==1)//if the next router is ready to receive data
			begin
				if(polarity==0)//if polarity is 0 externally odd packets travel(which is true here) and internally even packets travel
					begin
					if(ccwo_odd_buffer_empty == 0) begin
						ccwso=1;
						ccwdo=ccwo_odd_buff;
						ccwo_odd_buffer_empty=1;
						end
					else
						begin
						ccwdo= 64'b0;
						ccwso = 0;
					//	ccwo_odd_buffer_empty=1;
						end
				end
				else//if polarity is 1
				begin
					if(ccwo_even_buffer_empty == 0) begin
						ccwso=1;
						ccwdo=ccwo_even_buff;
						ccwo_even_buffer_empty=1;
						end
					else
						begin
						ccwdo= 64'b0;
						ccwso = 0;
					//	ccwo_even_buffer_empty=1;
						end
					end
			end//
			else
			begin
				ccwdo= 64'b0;
				ccwso = 0;
			end
			
		end

	end
endmodule	
			