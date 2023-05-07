module uart_component#(
    parameter   CLK_FREQ    =   50000000    ,
    parameter   UART_BPS    =   115200      
)(
    input               clk             ,
    input               rst_n           ,

    input               uart_tx_start   ,
    input   [7 : 0]     uart_tx_data    ,

    output              uart_rx_done    ,
    output  [7 : 0]     uart_rx_data    ,

    input               rx              ,
    output              tx              
);

    wire                uart_tx_busy     ;
    wire                fifo_rd_empty    ;
    wire    [7 : 0]     fifo_rd_data     ;

    reg                 fifo_rd_en       ;
    reg                 fifo_rd_en_d1    ;
    reg     [7 : 0]     fifo_rd_data_d1  ;


    uart_rx #(
        .CLK_FREQ       (CLK_FREQ           ),
        .UART_BPS       (UART_BPS           )
    )u_uart_master_rx(
        .sys_clk		(clk                ),         	//系统时钟
        .sys_rst_n	    (rst_n              ),         	//系统复位，低电平有效

        .uart_rxd       (rx                 ),          //UART接收端口

        .rx_flag        (),                             //接收过程标志信号
        .rx_cnt         (),                             //接收数据计数器
        .rxdata         (),
        .uart_done      (uart_rx_done       ),          //接收一帧数据完成标志
        .uart_data      (uart_rx_data       )           //接收的数据
    );

    uart_tx #(
        .CLK_FREQ       (CLK_FREQ           ),
        .UART_BPS       (UART_BPS           )
    )u_uart_slave0_tx(
        .sys_clk		(clk                ),         	//系统时钟
        .sys_rst_n	    (rst_n              ),         	//系统复位，低电平有效

        .uart_en		(fifo_rd_en_d1      ),        	//发送使能信号
        .uart_din	    (fifo_rd_data_d1    ),        	//待发送数据

        .uart_tx_busy   (uart_tx_busy       ),        	//发送忙状态标志 
        .en_flag        (),
        .tx_flag		(),         //发送过程标志信号
        .tx_data		(),         //寄存发送数据
        .tx_cnt		    (),        	//发送数据计数器
        .uart_txd       (tx                 )       	//UART发送端口
    );

    fifo_ram #(
        .DATA_WIDTH     (8                              ),
        .DATA_DEPTH     (100                            )
    )u_uart_slave0_fifo_ram(            
        .clk            (clk                            ),
        //write port            
        .wr_en          (uart_tx_start                  ),
        .wr_data        (uart_tx_data                   ),
        .wr_full        (),
        //read port
        .rd_en          (fifo_rd_en & !fifo_rd_en_d1    ),
        .rd_data        (fifo_rd_data                   ),
        .rd_empty       (fifo_rd_empty                  )
    );

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            fifo_rd_en   <=  1'b0;
        end
        else if(!fifo_rd_empty & !uart_tx_busy)begin
            fifo_rd_en   <=  1'b1;
        end
        else begin
            fifo_rd_en   <=  1'b0;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            fifo_rd_en_d1    <=  1'b0;
            fifo_rd_data_d1  <=  8'h00;
        end
        else begin
            fifo_rd_en_d1    <=  fifo_rd_en;
            fifo_rd_data_d1  <=  fifo_rd_data;
        end
    end





endmodule
