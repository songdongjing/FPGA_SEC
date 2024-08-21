module top(
	clk,
	reset_n,
  
	key_in,
	uart_rx,
	uart_tx,
	led
);
	input clk;
	input reset_n;
  
	input key_in;
	input uart_rx;
	output uart_tx;
   	output led;
  
	wire key_flag;
	wire key_state;
	wire [7:0]rx_data;
	wire rx_done;
	wire send_en;
	wire [7:0]tx_data;
	wire tx_done;
	wire [12:0]addra;
	wire [12:0]addrb;
	wire wea;
	wire led;
	key_filter key_filter_inst(
		.clk(clk),
		.reset_n(reset_n),

		.key_in(key_in),
		.key_flag(key_flag),
		.key_state(key_state )
);

	uart_byte_rx uart_byte_rx_inst(
		.clk(clk),
		.reset_n(reset_n),

		.baud_set(3'd4),
		.uart_rx(uart_rx),

		.data_byte(rx_data),
		.rx_done(rx_done)
);

	uart_byte_tx uart_byte_tx_inst(
		.clk(clk),
		.reset_n(reset_n),

		.data_byte(tx_data),
		.send_en(send_en),   
		.baud_set(3'd4),  

		.uart_tx(uart_tx),  
		.tx_done(tx_done),   
		.uart_state() 
);

	ctrl ctrl_inst(
		.clk(clk),
		.reset_n(reset_n),
		.key_flag(key_flag),
		.key_state(key_state),
		.rx_done(rx_done),
		.tx_done(tx_done),
		.addra(addra),
		.addrb(addrb),
		.wea(wea),
		.send_en(send_en),
		.led(led)
);

	ram ram_inst(
		.data(rx_data),
		.rdaddress(addrb),
		.rdclock(clk),
		.wraddress(addra),
		.wrclock(clk),
		.wren(wea),
		.q(tx_data)
);
endmodule