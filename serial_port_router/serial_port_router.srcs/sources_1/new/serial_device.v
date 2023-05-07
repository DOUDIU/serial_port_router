module serial_device#(
    parameter   CLK_FREQ            =   50000000    ,
    parameter   UART_master_BPS     =   115200      ,
    parameter   UART_slave0_BPS     =   115200      ,
    parameter   UART_slave1_BPS     =   115200      ,
    parameter   UART_slave2_BPS     =   115200      ,
    parameter   UART_slave3_BPS     =   115200      
)(
    input               clk,
    input               rst_n,

    input               rx_master,
    output              tx_master,

    input               rx0_slave,
    output              tx0_slave,
    input               rx1_slave,
    output              tx1_slave,
    input               rx2_slave,
    output              tx2_slave,
    input               rx3_slave,
    output              tx3_slave,

    output              uart_master_rx_done     ,
    output  [7 : 0]     uart_master_data        ,

    input               uart_salve0_tx_start    ,
    input   [7 : 0]     uart_salve0_tx_data     ,

    input               uart_salve1_tx_start    ,
    input   [7 : 0]     uart_salve1_tx_data     ,

    input               uart_salve2_tx_start    ,
    input   [7 : 0]     uart_salve2_tx_data     ,

    input               uart_salve3_tx_start    ,
    input   [7 : 0]     uart_salve3_tx_data     
);


//master
    uart_tx #(
        .CLK_FREQ(CLK_FREQ          ),
        .UART_BPS(UART_master_BPS   )
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
        .CLK_FREQ(CLK_FREQ          ),
        .UART_BPS(UART_master_BPS   )
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


//slave0
    wire                salve0_uart_tx_busy     ;
    wire                salve0_uart_en_flag     ;
    reg                 salve0_uart_tx_busy_d1  ;
    wire                salve0_fifo_rd_empty    ;
    wire    [7 : 0]     salve0_fifo_rd_data     ;
    reg     [7 : 0]     salve0_fifo_rd_data_d1  ;
    reg                 salve0_fifo_rd_en       ;
    reg                 salve0_fifo_rd_en_d1    ;

    uart_tx #(
        .CLK_FREQ(CLK_FREQ          ),
        .UART_BPS(UART_slave0_BPS   )
    )u_uart_slave0_tx(
        .sys_clk		(clk                    ),         	//系统时钟
        .sys_rst_n	    (rst_n                  ),         	//系统复位，低电平有效

        .uart_en		(salve0_fifo_rd_en_d1   ),        	//发送使能信号
        .uart_din	    (salve0_fifo_rd_data_d1 ),        	//待发送数据

        .uart_tx_busy   (salve0_uart_tx_busy    ),        	//发送忙状态标志 
        .en_flag        (salve0_uart_en_flag    ),
        .tx_flag		(),         //发送过程标志信号
        .tx_data		(),         //寄存发送数据
        .tx_cnt		    (),        	//发送数据计数器
        .uart_txd       (tx0_slave              )       	//UART发送端口
    );

    fifo_ram #(
        .DATA_WIDTH     (8                      ),
        .DATA_DEPTH     (100                    )
    )u_uart_slave0_fifo_ram(
        .clk            (clk                    ),
        //write port
        .wr_en          (uart_salve0_tx_start   ),
        .wr_data        (uart_salve0_tx_data    ),
        .wr_full        (),
        //read port
        .rd_en          (salve0_fifo_rd_en & !salve0_fifo_rd_en_d1),
        .rd_data        (salve0_fifo_rd_data    ),
        .rd_empty       (salve0_fifo_rd_empty   )
    );

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            salve0_fifo_rd_en   <=  1'b0;
        end
        else if(!salve0_fifo_rd_empty & !salve0_uart_en_flag & !salve0_uart_tx_busy)begin
            salve0_fifo_rd_en   <=  1'b1;
        end
        else begin
            salve0_fifo_rd_en   <=  1'b0;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            salve0_fifo_rd_en_d1    <=  1'b0;
            salve0_uart_tx_busy_d1  <=  1'b0;
            salve0_fifo_rd_data_d1  <=  8'h00;
        end
        else begin
            salve0_fifo_rd_en_d1    <=  salve0_fifo_rd_en;
            salve0_uart_tx_busy_d1  <=  salve0_uart_tx_busy;
            salve0_fifo_rd_data_d1  <=  salve0_fifo_rd_data;
        end
    end

//slave1
    uart_tx #(
        .CLK_FREQ(CLK_FREQ          ),
        .UART_BPS(UART_slave1_BPS   )
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

//slave2
    uart_tx #(
        .CLK_FREQ(CLK_FREQ          ),
        .UART_BPS(UART_slave2_BPS   )
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

//slave3
    uart_tx #(
        .CLK_FREQ(CLK_FREQ          ),
        .UART_BPS(UART_slave3_BPS   )
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
