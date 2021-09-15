/*********************************************************************************************************
 **                                  All right reserve 2008-2009(C) 
 **                             Created & maintain by http://www.edaok.net
 **=======================================================================================================
 ** ģ �� ��:   uart.v
 ** ��    ��:   ʵ��UART�ķ��͹���, ����֡�ֽڳ��ȿ�����, ֧����ż���鹦��; ʵ����AVR��Ƭ����ͨ���첽����
 **             �Ĵ󲿷ֹ���, (û�ж��ͨ��, ͬ�����ͷ�ʽ)
 **
 ** ԭ �� ��:  
 ** �� �� ��:  
 **
 **=======================================================================================================
 ********************************************************************************************************/

module txd (
    clk,
    rst_n,    
    clk_en,
    data_i,
    txd_xo,
	 ctrl_i,
	 TxReady,
	 TxDone  
);

input               clk;                                        //  ȫ��ʱ��ʱ
input               rst_n;                                      //  ȫ�ָ�λʱ, ����Ч

input               clk_en;
input   [7:0]       data_i;                                     //  ��Ҫ���͵�UART�����ϵ�����

output              txd_xo;                                     //  UART���ݷ��Ͷ˿�

input   [3:0]       ctrl_i;                                     //  �����ź�����




output              TxReady;                                    //  ����׼������
output              TxDone;                                     //  ���ͽ���
                                                                                                        

/*********************************************************************************************************
 ** UART������״̬��״̬����
 ********************************************************************************************************/

parameter   [7 : 0]
    TX_IDLE         = 8'b0000_0001,                //  ���߿���״̬, �ȴ���������
    TX_READY        = 8'b0000_0010,                //  ׼������״̬, �����ݷ��뷢�ͻ�����
    TX_START        = 8'b0000_0100,                //  ������ʼ��״̬, ����������(��0)
    TX_DATA         = 8'b0000_1000,                //  ��������λ״̬, ��������λ�������, LSB
    TX_PARITY       = 8'b0001_0000,                //  ����У��λ״̬, ����֡��ʽ�������
    TX_STOP1        = 8'b0010_0000,                //  ����ֹͣλ״̬, ������д"1"
    TX_STOP2        = 8'b0100_0000,
    TX_DONE         = 8'b1000_0000;                //  ������־״̬

parameter[3:0] DatWid=4'd9;

reg [7 : 0]    rStatTxCur,                     //  UART��������ǰ��״̬, Ĭ��Ϊ����״̬
                                rStatTxNext;                    //  UART��������һ��״̬

reg     [7:0]       rTxDatSft;
reg     [3:0]       rTxClkCnt;
reg     [3:0]       rTxBitCnt;
reg                 rPlsBaudTick;
reg                 rPlsStatChanged;



initial                                                         //  Ϊ������Գ�ʼ��
begin
    rStatTxCur      <= TX_IDLE;
    rStatTxNext     <= TX_IDLE;
    rTxDatSft       <= 8'h00;
    rTxClkCnt       <= 4'h0;
    rTxBitCnt       <= 4'h0;
    rPlsBaudTick    <= 1'b0;
    rPlsStatChanged <= 1'b0;
end


wire                wFlgParEn   = ctrl_i[3];                    //  1=ʹ����żУ��λ, 0=����
wire                wFlgParMod  = ctrl_i[2];                    //  1=��У��, 0=żУ��
wire                wStopBits   = ctrl_i[1];                    //  1=2λֹͣλ, 0=1λֹͣλ


wire                wFlgTxStart = ctrl_i[0];                    //  ���������ź�

//wire    [3:0]       wDatWid     = frame_bits_i;                 //  ֡������λ����, ʵ��λ��Ϊ����ֵ-'1', ��"8"Ϊ'7'
/*
reg                 rFlgDone;                                   //  ��������ɷ��ͱ��
reg                 rFlgNewDat;                                 //  �������ķ��ͻ���������������, ���������µ�����
reg                 rParVal;                                    //  ��żУ���������, ΪżУ����, ��У����ȡ��
*/
reg                 rTxReady;                                 
reg                 rTxDone;                                 



/*********************************************************************************************************
 ** ���µ�ǰ��״̬��, ��������صĹؼ�����
 ********************************************************************************************************/
always @(posedge clk or negedge rst_n)
begin : TX_STAT_UPDATE
    if (~rst_n) begin
        rStatTxCur      <= TX_IDLE;
        rPlsStatChanged <= 1'b0;
    end
    else begin
        rStatTxCur      <= rStatTxNext;                         //  ���µ�ǰ��������״̬��״̬
        rPlsStatChanged <= (rStatTxCur != rStatTxNext);
    end
end


/*********************************************************************************************************
 ** ���ݶ���źź͵�ǰ״̬����״̬, �жϷ�����״̬������һ��״̬
 **
 ** [�ر�ע��]: 
 ** ״ֵ̬ʹ��OneHot����, �����ֱ���һ�����Ϊ��λ�Ĵ���, Ϊ�˷�ֹ״̬����00000�����(��ʱ��������), 
 ** ���ۺ�����Ҫ����'safe stat mechine = on'(��ȫ״̬��)
 ********************************************************************************************************/
 
always @(
    rPlsBaudTick or
    wFlgTxStart or
    rStatTxCur or
    rTxClkCnt or 
    rTxBitCnt or
    wFlgParEn or 
    wFlgParMod or
    clk_en or
    wStopBits
    )
begin : TX_NEXT_STAT_JUDGE

    case (rStatTxCur)                                           //  ���ݵ�ǰ״̬����״̬, �ж������ź�, ��
                                                                //  ��������״̬������һ��״̬ 
    TX_IDLE: begin                                              
        if (wFlgTxStart)                              //  ��ģ��˿ڵķ������ݱ�־��Ч, �����������¼�
            rStatTxNext <= TX_READY;
        else 
            rStatTxNext <= TX_IDLE;
    end
    
    TX_READY: begin
        if (clk_en) begin                                       //  ͬ��UARTʱ��
            rStatTxNext <= TX_START;                            //  ���뷢����״̬���ķ�����ʼλ״̬
        end 
        else begin
            rStatTxNext <= TX_READY;
        end
    end

    TX_START: begin
        if (rPlsBaudTick)                                       //  ����һ������λ, ����֡������λ״̬
            rStatTxNext <= TX_DATA;
        else
            rStatTxNext <= TX_START;
    end
    
    TX_DATA:
    begin
        if ( (rTxBitCnt == DatWid) && (rPlsBaudTick) ) begin   //  ����λ������֡��ʽ���õ�λ����, ������һ״̬******@@@@
            if (wFlgParEn)
                rStatTxNext <= TX_PARITY;                       //  ���ʹ��У��λ, �����У��״̬
            else
                rStatTxNext <= TX_STOP1;                        //  �������ֹͣλ״̬
        end
        else begin
            rStatTxNext <= TX_DATA;
        end
    end

    TX_PARITY: begin
        if (rPlsBaudTick)
            rStatTxNext <= TX_STOP1;                            //  ����һ������λ��, ����ֹͣλ״̬
        else
            rStatTxNext <= TX_PARITY;
    end

    TX_STOP1: begin
        if (rPlsBaudTick) begin
            if (wStopBits)                                      //  ���������2��ֹͣλ, ���ٽ���ֹͣλ
                rStatTxNext <= TX_STOP2;
            else
                rStatTxNext <= TX_DONE;
        end
        else begin
            rStatTxNext <= TX_STOP1;
        end
    end

    TX_STOP2: begin
        if (rPlsBaudTick)
            rStatTxNext <= TX_DONE;
        else
            rStatTxNext <= TX_STOP2;
    end

    TX_DONE: begin
        rStatTxNext <= TX_IDLE;                                 //  �ٴν������״̬
    end
    
    default: begin
        rStatTxNext <= TX_IDLE;
    end 

    endcase
end


reg             rTxdTmp;

reg             rParVal;



always @(posedge clk or negedge rst_n)
begin : TX_STAT_PROCESS

    if (~rst_n) begin

        rTxDatSft   <= 8'h00;
        rTxdTmp     <= 1'b1;


		  rTxReady    <= 1'b1;
		  rTxDone     <= 1'b0;

        rParVal     <= 1'b0;
        

        rTxClkCnt       <= 4'h0;
        rTxBitCnt       <= 4'h0;
        rPlsBaudTick    <= 1'b0;
        
    end 
    else begin

        rPlsBaudTick    <= 1'b0;

        if ( (rStatTxCur == TX_IDLE) || 
             (rStatTxCur == TX_READY) ) begin                   //  ��һ״̬Ϊ����ʱ, ��λ������
            rTxClkCnt   <= 4'h0;
            rTxBitCnt   <= 4'h0;
				
        end
        else if (clk_en) begin 
            rTxClkCnt   <= rTxClkCnt + 4'h1;
            
            if (rTxClkCnt == 4'hF) begin                        //  UART������Ϊclk_en / 16
                rTxBitCnt   <= rTxBitCnt + 4'h1;                //  ������֡λ�ļ���
                rPlsBaudTick   <= 1'b1;                         //  ����������ʱ������
            end
        end

        case (rStatTxCur)

        TX_IDLE: begin
            rTxdTmp <= 1'b1;
            rParVal <= 1'b0;
            
				rTxReady    <= 1'b1;
				rTxDone     <= 1'b0;
        end

        TX_READY: begin
            rTxdTmp <= 1'b1;

            if (rPlsStatChanged) begin
                rTxDatSft   <= data_i;
					 rTxReady    <= 1'b0;
                //rFlgNewDat  <= 1'b1;
            end
        end

        TX_START: begin
            rTxdTmp <= 1'b0;
        end
        
        TX_DATA: begin
            if ( (rPlsBaudTick || rPlsStatChanged) && 
                (rTxBitCnt != DatWid) ) begin

                rParVal <= rParVal ^ rTxDatSft[0];
                
                rTxdTmp <= rTxDatSft[0];
                
                rTxDatSft   <= rTxDatSft >> 1;
            end
        end

        TX_PARITY: begin
            if (~wFlgParMod)                                    //  żУ��
                rTxdTmp <= rParVal;
            else
                rTxdTmp <= ~rParVal;                            //  ��У��ΪżУ��ķ���
        end

        TX_DONE: begin
				rTxDone     <= 1'b1;
            
        end

        default: begin
            rTxdTmp <= 1'b1;
        end

        endcase  
    end
end

assign  txd_xo  = rTxdTmp;                                      //  ���UART�ķ������� (TxD)

assign  TxDone  = rTxDone;

assign  TxReady=rTxReady;


endmodule

/*********************************************************************************************************
 ** End Of File
 ********************************************************************************************************/

