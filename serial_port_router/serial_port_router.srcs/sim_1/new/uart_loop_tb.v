`timescale 1ns / 1ps
module uart_loop();

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
    tx_data         <=  8'h0f;
    #20
    tx_data_valid   <=  0;
    tx_data         <=  0;
end

    wire      			uart_tx_busy;        	//发送忙状态标志 
    wire      			en_flag     ;
    wire      			tx_flag		;         	//发送过程标志信号
    wire    [3 : 0] 	tx_cnt		;        	//发送数据计数器
    wire      			uart_txd    ;         	//UART发送端口

uart_tx #(
    .CLK_FREQ(50000000  ),
    .UART_BPS(115200    )
)u_uart_tx(
    .sys_clk		(clk_50         ),         	//系统时钟
    .sys_rst_n	    (rst_n          ),         	//系统复位，低电平有效

    .uart_en		(tx_data_valid  ),        	//发送使能信号
    .uart_din	    (tx_data        ),        	//待发送数据

    .uart_tx_busy   (uart_tx_busy   ),        	//发送忙状态标志 
    .en_flag        (en_flag        ),
    .tx_flag		(tx_flag	    ),          //发送过程标志信号
    .tx_data		(),                         //寄存发送数据
    .tx_cnt		    (tx_cnt		    ),        	//发送数据计数器
    .uart_txd       (uart_txd       )       	//UART发送端口
);

uart_rx #(
    .CLK_FREQ(50000000  ),
    .UART_BPS(115200    )
)u_uart_rx(
    .sys_clk		(clk_50         ),         	//系统时钟
    .sys_rst_n	    (rst_n          ),         	//系统复位，低电平有效
    
    .uart_rxd       (uart_txd       ),          //UART接收端口

    .uart_done      (),                         //接收一帧数据完成标志
    .rx_flag        (),                         //接收过程标志信号
    .rx_cnt         (),                         //接收数据计数器
    .rxdata         (),
    .uart_data      ()                          //接收的数据
);

endmodule
