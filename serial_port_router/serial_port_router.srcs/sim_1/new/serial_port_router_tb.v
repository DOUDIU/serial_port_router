`timescale 1ns / 1ps
module serial_port_router_tb();

reg     clk_50;
reg     rst_n;

initial begin
    clk_50  <=  0;
    rst_n   <=  0;
    #100;
    rst_n   <=  1;
end

always #10 clk_50  <=  ~clk_50;

reg                 tx_data_valid;
reg     [7 : 0]     tx_data;
initial begin
    tx_data_valid   <=  0;
    tx_data         <=  0;
    #1000;
    tx_data_valid   <=  1;
    tx_data         <=  8'hf0;
    #20
    tx_data_valid   <=  0;
    tx_data         <=  0;
    #100000;
    tx_data_valid   <=  1;
    tx_data         <=  8'he1;
    #20
    tx_data_valid   <=  0;
    tx_data         <=  0;
    #100000;
    tx_data_valid   <=  1;
    tx_data         <=  8'h26;
    #20
    tx_data_valid   <=  0;
    tx_data         <=  0;
    #100000;
    tx_data_valid   <=  1;
    tx_data         <=  8'h8a;
    #20
    tx_data_valid   <=  0;
    tx_data         <=  0;

    // #100000;
    // tx_data_valid   <=  1;
    // tx_data         <=  8'hf3;
    // #20
    // tx_data_valid   <=  0;
    // tx_data         <=  0;
    // #100000;
    // tx_data_valid   <=  1;
    // tx_data         <=  8'he1;
    // #20
    // tx_data_valid   <=  0;
    // tx_data         <=  0;
    // #100000;
    // tx_data_valid   <=  1;
    // tx_data         <=  8'h92;
    // #20
    // tx_data_valid   <=  0;
    // tx_data         <=  0;


end
uart_tx #(
    .CLK_FREQ(50000000  ),
    .UART_BPS(115200    )
)u_uart_tx(
    .sys_clk		(clk_50         ),         	//系统时钟
    .sys_rst_n	    (rst_n          ),         	//系统复位，低电平有效

    .uart_en		(tx_data_valid  ),        	//发送使能信号
    .uart_din	    (tx_data        ),        	//待发送数据

    .uart_tx_busy   (),        	                //发送忙状态标志 
    .en_flag        (),
    .tx_flag		(),                         //发送过程标志信号
    .tx_data		(),                         //寄存发送数据
    .tx_cnt		    (),        	                //发送数据计数器
    .uart_txd       (rx_master      )       	//UART发送端口
);


serial_port_router u_serial_port_router(
    .clk        (clk_50     ),
    .rst_n      (rst_n      ),

    .rx_master  (rx_master  ),
    .tx_master  (tx_master  ),

    .rx0_slave  (rx0_slave  ),
    .tx0_slave  (tx0_slave  ),
    .rx1_slave  (rx1_slave  ),
    .tx1_slave  (tx1_slave  ),
    .rx2_slave  (rx2_slave  ),
    .tx2_slave  (tx2_slave  ),
    .rx3_slave  (rx3_slave  ),
    .tx3_slave  (tx3_slave  )
);


endmodule
