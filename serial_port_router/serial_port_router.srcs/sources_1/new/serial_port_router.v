module serial_port_router(
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
    output              tx3_slave
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

//serial device
    serial_device #(
        .CLK_FREQ               (50000000               ),
        .UART_master_BPS        (115200                 ),
                
        .UART_slave0_BPS        (19200                  ),
        .UART_slave1_BPS        (115200                 ),
        .UART_slave2_BPS        (115200                 ),
        .UART_slave3_BPS        (115200                 )
    )u_serial_device(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),

        .rx_master              (rx_master              ),
        .tx_master              (tx_master              ),

        .rx0_slave              (rx0_slave              ),
        .tx0_slave              (tx0_slave              ),
        .rx1_slave              (rx1_slave              ),
        .tx1_slave              (tx1_slave              ),
        .rx2_slave              (rx2_slave              ),
        .tx2_slave              (tx2_slave              ),
        .rx3_slave              (rx3_slave              ),
        .tx3_slave              (tx3_slave              ),

        .uart_master_rx_done    (uart_master_rx_done    ),
        .uart_master_data       (uart_master_data       ),

        .uart_salve0_tx_start   (uart_salve0_tx_start   ),
        .uart_salve0_tx_data    (uart_salve0_tx_data    ),
        .uart_salve1_tx_start   (uart_salve1_tx_start   ),
        .uart_salve1_tx_data    (uart_salve1_tx_data    ),
        .uart_salve2_tx_start   (uart_salve2_tx_start   ),
        .uart_salve2_tx_data    (uart_salve2_tx_data    ),
        .uart_salve3_tx_start   (uart_salve3_tx_start   ),
        .uart_salve3_tx_data    (uart_salve3_tx_data    )
    );















endmodule
