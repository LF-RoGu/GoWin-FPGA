/*********************************************************************************************************
 **                                  All right reserve 2008-2009(C) 
 **                             Created &maintain by 707 
 **=======================================================================================================
 ** ģ �� ��:   UART_Tx_module
 ** ��    ��:   ��ģ��ʵ��
 **             
 **
 ** �� ��: ����  ��͢�� 
 ** ���ڣ�2013/4/30
 ** �汾��
 **=======================================================================================================
 ********************************************************************************************************/
//
//register define:
//   rClk_Diver:  baudrate = clk/(16*rClk_Diver);
//   rTx_Config:  
//      bits:    / 15 /......./ 4 / 3 / 2 / 1 / 0 /
//                       frame_odd PMEN PM STB TXEN
//frame_odd: frame number  1= ֡��Ϊ������ 0=֡��Ϊż��
//PMEN: Parity enable 1=ʹ����żУ��λ, 0=����
//PM:   Parity Mode   1=��У��, 0=żУ��
//STB:  stop bits     1=2λֹͣλ, 0=1λֹͣλ
//TXEN: Tx enable     1=ʹ�ܷ��ͣ�0=��ֹ����
                                          
//////////////////////////////////////////////////////////////////////////////////


module UART_Tx_module(
    input clk,
    input rst,	
    input en,
    input [7:0] data_in,
	 output tx,
    input Wr

    );

reg [15:0] rClk_Diver;
reg [3:0] rTx_Config;


parameter                   
	 EVE_CHECK     = 3'b110,        //  ʹ��У�鹦��  ��  ����usetxd (ctrl_i)
	 ODD_CHECK     = 3'b100,        //              ż
	 NO_CHECK      = 3'b000,        //              �� 
	 
	 B_RATE_2400   = 16'd0,        // ������ѡ��        ���� usedivider��factor��
    B_RATE_4800   = 16'd1,
	 B_RATE_9600   = 16'd2,
    B_RATE_19200   = 16'd3,
	 B_RATE_38400   = 16'd4,
    B_RATE_57600   = 16'd5,
	 B_RATE_115200   = 16'd6,
    B_RATE_230400   = 16'd7,	
	 B_RATE_460800   = 16'd8,
	 B_RATE_921600   = 16'd9;



//always@(posedge clk or posedge rst)
//if(rst)	begin
//	rClk_Diver <= 16'd06;
//	rTx_Config <= 5'b0;
//	end
//else 
//	if(Wr&en)	begin
//	case (Ad)
//	3'd1: 	rClk_Diver <= data_in;
//	3'd2: 	rTx_Config <= data_in[3:0];
//	default:  begin
//				rClk_Diver <= rClk_Diver;
//				rTx_Config <= rTx_Config;
//				end
//	endcase
//	end


wire [15:0] wFIFO_out;
wire wEmpty;
wire wtx_ready,wtx_done;
wire [7:0] wdata8Tsend;
wire wTxstart,wFIFO_Rd;

//���ڿ���ģ��
uart_ctrl useuart_ctrl(
	 .clk(clk),
    .rst(rst),
    .FIFO_empty(wEmpty),
    .data8_in(wFIFO_out[7:0]),
    .tx_ready(wtx_ready),
	 .tx_done(wtx_done),
    .data8_out(wdata8Tsend),
    .TxStart(wTxstart),
    .FIFO_rd(wFIFO_Rd)
    );

//�����ʷ�������ʵ��׼ȷ��Ƶ
wire Tx_tick;
divider usedivider (
							.clk(clk), 
							.rst(rst),    
							.enable(en),
							.factor(B_RATE_9600), 
							.tick_out(Tx_tick) 
						  );	  

//���ڷ���ģ��
txd usetxd(
				.clk(clk),
				.rst_n(~rst),   
				.clk_en(Tx_tick),
				.data_i(wdata8Tsend),
				.txd_xo(tx),
				.ctrl_i({NO_CHECK,wTxstart}),
				.TxReady(wtx_ready),
				.TxDone(wtx_done)
			);
						





//16λ��1024��FIFO��ip core��





//fifo useFifoModule (
//	.clk(clk),
//	.rst(rst),
//	.din(data_in),    //16λ��������
//	.wr_en(Wr),   //д����
//	.rd_en(wFIFO_Rd), //������
//	.dout(wFIFO_out), //8λ�������
//	.full(), // output full\
//	.data_count(),
//	.empty(wEmpty));  //��ջ�գ�
//	
//

fifo_sc_top  fifo_sc_inst (
    .Clk(clk),
    .Reset(rst),
    .WrEn(Wr),
    .RdEn(wFIFO_Rd),
    .Data(data_in[7:0]),
    .Full(),
    .Empty(wEmpty),
    .Q(wFIFO_out[7:0])
);


endmodule
