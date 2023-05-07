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

    input               uart_master_tx_start    ,
    input   [7 : 0]     uart_master_tx_data     ,
    output              uart_master_rx_done     ,
    output  [7 : 0]     uart_master_data        ,

    input               uart_salve0_tx_start    ,
    input   [7 : 0]     uart_salve0_tx_data     ,
    output              uart_salve0_rx_done     ,
    output  [7 : 0]     uart_salve0_data        ,

    input               uart_salve1_tx_start    ,
    input   [7 : 0]     uart_salve1_tx_data     ,
    output              uart_salve1_rx_done     ,
    output  [7 : 0]     uart_salve1_data        ,

    input               uart_salve2_tx_start    ,
    input   [7 : 0]     uart_salve2_tx_data     ,
    output              uart_salve2_rx_done     ,
    output  [7 : 0]     uart_salve2_data        ,

    input               uart_salve3_tx_start    ,
    input   [7 : 0]     uart_salve3_tx_data     ,
    output              uart_salve3_rx_done     ,
    output  [7 : 0]     uart_salve3_data        
);


//master
    uart_component #(
        .CLK_FREQ(CLK_FREQ          ),
        .UART_BPS(UART_master_BPS   )
    )uart_master(
        .clk                (clk                    ),
        .rst_n              (rst_n                  ),

        .uart_tx_start      (uart_master_tx_start   ),
        .uart_tx_data       (uart_master_tx_data    ),

        .uart_rx_done       (uart_master_rx_done    ),
        .uart_rx_data       (uart_master_data       ),

        .rx                 (rx_master              ),
        .tx                 (tx_master              )
    );

//slave0
    uart_component #(
        .CLK_FREQ(CLK_FREQ          ),
        .UART_BPS(UART_slave0_BPS   )
    )uart_slave0(
        .clk                (clk                    ),
        .rst_n              (rst_n                  ),

        .uart_tx_start      (uart_salve0_tx_start   ),
        .uart_tx_data       (uart_salve0_tx_data    ),

        .uart_rx_done       (uart_salve0_rx_done    ),
        .uart_rx_data       (uart_salve0_data       ),

        .rx                 (rx0_slave              ),
        .tx                 (tx0_slave              )
    );

//slave1
    uart_component #(
        .CLK_FREQ(CLK_FREQ          ),
        .UART_BPS(UART_slave1_BPS   )
    )uart_slave1(
        .clk                (clk                    ),
        .rst_n              (rst_n                  ),

        .uart_tx_start      (uart_salve1_tx_start   ),
        .uart_tx_data       (uart_salve1_tx_data    ),

        .uart_rx_done       (uart_salve1_rx_done    ),
        .uart_rx_data       (uart_salve1_data       ),

        .rx                 (rx1_slave              ),
        .tx                 (tx1_slave              )
    );

//slave2
    uart_component #(
        .CLK_FREQ(CLK_FREQ          ),
        .UART_BPS(UART_slave2_BPS   )
    )uart_slave2(
        .clk                (clk                    ),
        .rst_n              (rst_n                  ),

        .uart_tx_start      (uart_salve2_tx_start   ),
        .uart_tx_data       (uart_salve2_tx_data    ),

        .uart_rx_done       (uart_salve2_rx_done    ),
        .uart_rx_data       (uart_salve2_data       ),

        .rx                 (rx2_slave              ),
        .tx                 (tx2_slave              )
    );

//slave3
    uart_component #(
        .CLK_FREQ(CLK_FREQ          ),
        .UART_BPS(UART_slave3_BPS   )
    )uart_slave3(
        .clk                (clk                    ),
        .rst_n              (rst_n                  ),

        .uart_tx_start      (uart_salve3_tx_start   ),
        .uart_tx_data       (uart_salve3_tx_data    ),

        .uart_rx_done       (uart_salve3_rx_done    ),
        .uart_rx_data       (uart_salve3_data       ),

        .rx                 (rx3_slave              ),
        .tx                 (tx3_slave              )
    );













endmodule
