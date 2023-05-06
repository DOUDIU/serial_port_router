module serial_port_router(
    input       clk,
    input       rst_n,

    input       rx_master,
    output      tx_master,

    input       rx0_slave,
    output      tx0_slave,
    input       rx1_slave,
    output      tx1_slave,
    input       rx2_slave,
    output      tx2_slave,
    input       rx3_slave,
    output      tx3_slave
);

wire                uart_master_rx_done     ;
wire    [7 : 0]     uart_master_data        ;

wire                uart_salve0_tx_start    ;
wire    [7 : 0]     uart_salve0_tx_data     ;

wire                uart_salve1_tx_start    ;
wire    [7 : 0]     uart_salve1_tx_data     ;

wire                uart_salve2_tx_start    ;
wire    [7 : 0]     uart_salve2_tx_data     ;

wire                uart_salve3_tx_start    ;
wire    [7 : 0]     uart_salve3_tx_data     ;

//master
    uart_tx #(
        .CLK_FREQ(50000000  ),
        .UART_BPS(115200    )
    )u_uart_master_tx(
        .sys_clk		(clk                    ),         	//系统时钟
        .sys_rst_n	    (rst_n                  ),         	//系统复位，低电平有效

        .uart_en		(uart_master_rx_done    ),        	//发送使能信号
        .uart_din	    (uart_master_data       ),        	//待发送数据

        .uart_tx_busy   (),        	//发送忙状态标志 
        .en_flag        (),
        .tx_flag		(),         //发送过程标志信号
        .tx_data		(),         //寄存发送数据
        .tx_cnt		    (),        	//发送数据计数器
        .uart_txd       (tx_master              )       	//UART发送端口
    );

    uart_rx #(
        .CLK_FREQ(50000000  ),
        .UART_BPS(115200    )
    )u_uart_master_rx(
        .sys_clk		(clk                    ),  //系统时钟
        .sys_rst_n	    (rst_n                  ),  //系统复位，低电平有效

        .uart_rxd       (rx_master              ),  //UART接收端口

        .rx_flag        (),                         //接收过程标志信号
        .rx_cnt         (),                         //接收数据计数器
        .rxdata         (),
        .uart_done      (uart_master_rx_done    ),  //接收一帧数据完成标志
        .uart_data      (uart_master_data       )   //接收的数据
    );

//control
    router_control u_router_control(
        .clk                        (clk                    ),  //系统时钟
        .rst_n                      (rst_n                  ),  //系统复位，低电平有效

        .uart_master_rx_done        (uart_master_rx_done    ),
        .uart_master_data           (uart_master_data       ),

        .uart_salve0_tx_start       (uart_salve0_tx_start   ),
        .uart_salve0_tx_data        (uart_salve0_tx_data    ),

        .uart_salve1_tx_start       (uart_salve1_tx_start   ),
        .uart_salve1_tx_data        (uart_salve1_tx_data    ),

        .uart_salve2_tx_start       (uart_salve2_tx_start   ),
        .uart_salve2_tx_data        (uart_salve2_tx_data    ),

        .uart_salve3_tx_start       (uart_salve3_tx_start   ),
        .uart_salve3_tx_data        (uart_salve3_tx_data    )
    );

//slave
    uart_tx #(
        .CLK_FREQ(50000000  ),
        .UART_BPS(115200    )
    )u_uart_slave0_tx(
        .sys_clk		(clk                    ),         	//系统时钟
        .sys_rst_n	    (rst_n                  ),         	//系统复位，低电平有效

        .uart_en		(uart_salve0_tx_start   ),        	//发送使能信号
        .uart_din	    (uart_salve0_tx_data    ),        	//待发送数据

        .uart_tx_busy   (),        	//发送忙状态标志 
        .en_flag        (),
        .tx_flag		(),         //发送过程标志信号
        .tx_data		(),         //寄存发送数据
        .tx_cnt		    (),        	//发送数据计数器
        .uart_txd       (tx0_slave              )       	//UART发送端口
    );

    uart_tx #(
        .CLK_FREQ(50000000  ),
        .UART_BPS(115200    )
    )u_uart_slave1_tx(
        .sys_clk		(clk                    ),         	//系统时钟
        .sys_rst_n	    (rst_n                  ),         	//系统复位，低电平有效

        .uart_en		(uart_salve1_tx_start   ),        	//发送使能信号
        .uart_din	    (uart_salve1_tx_data    ),        	//待发送数据

        .uart_tx_busy   (),        	//发送忙状态标志 
        .en_flag        (),
        .tx_flag		(),         //发送过程标志信号
        .tx_data		(),         //寄存发送数据
        .tx_cnt		    (),        	//发送数据计数器
        .uart_txd       (tx1_slave              )       	//UART发送端口
    );

    uart_tx #(
        .CLK_FREQ(50000000  ),
        .UART_BPS(115200    )
    )u_uart_slave2_tx(
        .sys_clk		(clk                    ),         	//系统时钟
        .sys_rst_n	    (rst_n                  ),         	//系统复位，低电平有效

        .uart_en		(uart_salve2_tx_start   ),        	//发送使能信号
        .uart_din	    (uart_salve2_tx_data    ),        	//待发送数据

        .uart_tx_busy   (),        	//发送忙状态标志 
        .en_flag        (),
        .tx_flag		(),         //发送过程标志信号
        .tx_data		(),         //寄存发送数据
        .tx_cnt		    (),        	//发送数据计数器
        .uart_txd       (tx2_slave              )       	//UART发送端口
    );

    uart_tx #(
        .CLK_FREQ(50000000  ),
        .UART_BPS(115200    )
    )u_uart_slave3_tx(
        .sys_clk		(clk                    ),         	//系统时钟
        .sys_rst_n	    (rst_n                  ),         	//系统复位，低电平有效

        .uart_en		(uart_salve3_tx_start   ),        	//发送使能信号
        .uart_din	    (uart_salve3_tx_data    ),        	//待发送数据

        .uart_tx_busy   (),        	//发送忙状态标志 
        .en_flag        (),
        .tx_flag		(),         //发送过程标志信号
        .tx_data		(),         //寄存发送数据
        .tx_cnt		    (),        	//发送数据计数器
        .uart_txd       (tx3_slave              )       	//UART发送端口
    );


















endmodule
