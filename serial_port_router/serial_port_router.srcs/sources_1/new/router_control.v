module router_control(
    input               clk                     ,
    input               rst_n                   ,

    input               uart_master_rx_done     ,
    input   [7 : 0]     uart_master_data        ,

    output              uart_salve0_tx_start    ,
    output  [7 : 0]     uart_salve0_tx_data     ,

    output              uart_salve1_tx_start    ,
    output  [7 : 0]     uart_salve1_tx_data     ,

    output              uart_salve2_tx_start    ,
    output  [7 : 0]     uart_salve2_tx_data     ,

    output              uart_salve3_tx_start    ,
    output  [7 : 0]     uart_salve3_tx_data     
);

    reg     [3 : 0]     slave_addr              ;
    reg     [3 : 0]     slave_addr_d1           ;
    reg                 uart_master_rx_done_d1  ;
    reg                 uart_master_rx_done_d2  ;
    reg     [7 : 0]     uart_master_data_d1     ;

    
    reg                 salve0_tx_start         ;
    reg     [7 : 0]     salve0_tx_data          ;
    reg                 salve1_tx_start         ;
    reg     [7 : 0]     salve1_tx_data          ;
    reg                 salve2_tx_start         ;
    reg     [7 : 0]     salve2_tx_data          ;
    reg                 salve3_tx_start         ;
    reg     [7 : 0]     salve3_tx_data          ;


//pipe 1
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            slave_addr  <=  0;
        end
        else if(uart_master_rx_done)begin
            case(uart_master_data)
                8'hf0   :   slave_addr  <=  4'b0001;
                8'hf1   :   slave_addr  <=  4'b0010;
                8'hf2   :   slave_addr  <=  4'b0100;
                8'hf3   :   slave_addr  <=  4'b1000;
                default :   slave_addr  <=  slave_addr;
            endcase
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            uart_master_rx_done_d1 <=  0;
            uart_master_rx_done_d2 <=  0;
            uart_master_data_d1    <=  0;
            slave_addr_d1          <=  0;
        end
        else begin
            uart_master_rx_done_d1 <=  uart_master_rx_done;
            uart_master_rx_done_d2 <=  uart_master_rx_done_d1;
            uart_master_data_d1    <=  uart_master_data;
            slave_addr_d1          <=  slave_addr;
        end
    end

//pipe 2
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            salve0_tx_start    <=  0;
            salve0_tx_data     <=  0;
            salve1_tx_start    <=  0;
            salve1_tx_data     <=  0;
            salve2_tx_start    <=  0;
            salve2_tx_data     <=  0;
            salve3_tx_start    <=  0;
            salve3_tx_data     <=  0;
        end
        else if((!uart_master_rx_done_d2 & uart_master_rx_done_d1) && (slave_addr_d1 == slave_addr))begin
            case(slave_addr_d1)
                4'b0001 :   begin
                            salve0_tx_start    <=  uart_master_rx_done_d1;
                            salve0_tx_data     <=  uart_master_data_d1;
                        end
                4'b0010 :   begin
                            salve1_tx_start    <=  uart_master_rx_done_d1;
                            salve1_tx_data     <=  uart_master_data_d1;
                        end
                4'b0100 :   begin
                            salve2_tx_start    <=  uart_master_rx_done_d1;
                            salve2_tx_data     <=  uart_master_data_d1;
                        end
                4'b1000 :   begin
                            salve3_tx_start    <=  uart_master_rx_done_d1;
                            salve3_tx_data     <=  uart_master_data_d1;
                        end
                default :   begin
                            salve0_tx_start    <=  0;
                            salve0_tx_data     <=  0;
                            salve1_tx_start    <=  0;
                            salve1_tx_data     <=  0;
                            salve2_tx_start    <=  0;
                            salve2_tx_data     <=  0;
                            salve3_tx_start    <=  0;
                            salve3_tx_data     <=  0;
                        end
            endcase
        end
        else begin
            salve0_tx_start    <=  0;
            salve0_tx_data     <=  0;
            salve1_tx_start    <=  0;
            salve1_tx_data     <=  0;
            salve2_tx_start    <=  0;
            salve2_tx_data     <=  0;
            salve3_tx_start    <=  0;
            salve3_tx_data     <=  0;
        end
    end



//output assignment
assign  uart_salve0_tx_start    =   salve0_tx_start ;
assign  uart_salve0_tx_data     =   salve0_tx_data  ;
assign  uart_salve1_tx_start    =   salve1_tx_start ;
assign  uart_salve1_tx_data     =   salve1_tx_data  ;
assign  uart_salve2_tx_start    =   salve2_tx_start ;
assign  uart_salve2_tx_data     =   salve2_tx_data  ;
assign  uart_salve3_tx_start    =   salve3_tx_start ;
assign  uart_salve3_tx_data     =   salve3_tx_data  ;


endmodule
