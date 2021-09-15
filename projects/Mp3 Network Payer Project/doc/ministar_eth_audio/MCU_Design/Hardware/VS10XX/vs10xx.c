#include "vs10xx.h"	 
#include "delay.h"
#include "spi_master.h"
#include <stdio.h>


//VS10XXĬ�����ò���
_vs10xx_obj vsset=
{
	220,	//����:220
	6,		//�������� 60Hz
	15,		//�������� 15dB	
	10,		//�������� 10Khz	
	15,		//�������� 10.5dB
	0,		//�ռ�Ч��	
};




//data:Ҫд�������
//����ֵ:����������
void VS_SPI_WriteByte(uint8_t data)
{		
	// ����û����� ����׼����ʱ���ܷ�������
	if(~SPI_GetToeStatus() && SPI_GetTrdyStatus() == 1)
	{
			SPI_WriteData(data);//Send Jedec
		//printf("%02x ",data);
	}	
}

//data:Ҫд�������
//����ֵ:����������
uint8_t VS_SPI_ReadByte(void)
{		
	uint8_t rxdata = 0;
	
	// ����û����� ����׼����ʱ���ܷ�������
	if(~SPI_GetRoeStatus() && SPI_GetRrdyStatus() == 1)
	{
			rxdata = SPI_ReadData();
	}
	return rxdata; 
}


//SD����ʼ����ʱ��,��Ҫ����
void VS_SPI_SpeedLow(void)
{			
	SPI_SetClkSel(CLKSEL_CLK_DIV_8);	
}
//SD������������ʱ��,���Ը�����
void VS_SPI_SpeedHigh(void)
{		
	SPI_SetClkSel(CLKSEL_CLK_DIV_8);	 
}

//��ʼ��VS10XX��IO��	 
void VS_Init(void)
{
	GPIO_InitTypeDef  GPIO_InitType;
	
	GPIO_InitType.GPIO_Pin = GPIO_Pin_15;    //	DREQ
	GPIO_InitType.GPIO_Mode = GPIO_Mode_IN;  //����
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;
	GPIO_Init(GPIO0,&GPIO_InitType);	
	
	GPIO_InitType.GPIO_Pin = GPIO_Pin_12;    //	XDCS
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;  //���
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;
	GPIO_Init(GPIO0,&GPIO_InitType);		
	GPIO_SetBit(GPIO0, GPIO_Pin_12);
	
	GPIO_InitType.GPIO_Pin = GPIO_Pin_13;    //	XRST
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;  //���
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;
	GPIO_Init(GPIO0,&GPIO_InitType);		
	GPIO_SetBit(GPIO0, GPIO_Pin_13);
	
	SPI1_Init();	 	
}	  
////////////////////////////////////////////////////////////////////////////////	 	  
//��λVS10XX
void VS_Soft_Reset(void)
{	 
	uint8_t retry=0;  				   
	while(VS_DQ()==0); 					//�ȴ������λ����	   
	VS_SPI_WriteByte(0Xff);			//��������
	retry=0;
	while(VS_RD_Reg(SPI_MODE)!=0x0800)	// �����λ,��ģʽ  
	{
		VS_WR_Cmd(SPI_MODE,0x0804);		// �����λ,��ģʽ	    
		delay_ms(2);//�ȴ�����1.35ms 
		if(retry++>100)break; 	    
	}	 		 
	while(VS_DQ()==0);//�ȴ������λ����	 
	retry=0;
	while(VS_RD_Reg(SPI_CLOCKF)!=0X9800)//����VS10XX��ʱ��,3��Ƶ ,1.5xADD 
	{
		VS_WR_Cmd(SPI_CLOCKF,0X9800);	//����VS10XX��ʱ��,3��Ƶ ,1.5xADD
		if(retry++>100)break; 	    
	}	 
	delay_ms(20);
} 
//Ӳ��λMP3
//����1:��λʧ��;0:��λ�ɹ�	   
uint8_t VS_HD_Reset(void)
{
	uint8_t retry=0;
	VS_RST(0);
	delay_ms(20);
	VS_XDCS(1);//ȡ�����ݴ���
//	VS_XCS=1;//ȡ�����ݴ���
	VS_RST(1);	   
	while(VS_DQ()==0&&retry<200)//�ȴ�DREQΪ��
	{
		retry++;
		delay_ms(1);
	};
	delay_ms(20);	
	if(retry>=200)return 1;
	else return 0;	    		 
}
//���Ҳ��� 
void VS_Sine_Test(void)
{											    
	VS_HD_Reset();	 
	VS_WR_Cmd(0x0b,0X2020);	  //��������	 
 	VS_WR_Cmd(SPI_MODE,0x0820);//����VS10XX�Ĳ���ģʽ     
	while(VS_DQ()==0);     //�ȴ�DREQΪ��
	//printf("mode sin:%x\n",VS_RD_Reg(SPI_MODE));
 	//��VS10XX�������Ҳ������0x53 0xef 0x6e n 0x00 0x00 0x00 0x00
 	//����n = 0x24, �趨VS10XX�����������Ҳ���Ƶ��ֵ��������㷽����VS10XX��datasheet
  	VS_SPI_SpeedLow();//���� 
	VS_XDCS(0);//ѡ�����ݴ���
	VS_SPI_WriteByte(0x53);
	VS_SPI_WriteByte(0xef);
	VS_SPI_WriteByte(0x6e);
	VS_SPI_WriteByte(0x24);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	delay_ms(100);
	VS_XDCS(1); 
    //�˳����Ҳ���
    VS_XDCS(0);//ѡ�����ݴ���
	VS_SPI_WriteByte(0x45);
	VS_SPI_WriteByte(0x78);
	VS_SPI_WriteByte(0x69);
	VS_SPI_WriteByte(0x74);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	delay_ms(100);
	VS_XDCS(1);		 

    //�ٴν������Ҳ��Բ�����nֵΪ0x44���������Ҳ���Ƶ������Ϊ�����ֵ
    VS_XDCS(0);//ѡ�����ݴ���      
	VS_SPI_WriteByte(0x53);
	VS_SPI_WriteByte(0xef);
	VS_SPI_WriteByte(0x6e);
	VS_SPI_WriteByte(0x44);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	delay_ms(100);
 	VS_XDCS(1);
    //�˳����Ҳ���
    VS_XDCS(0);//ѡ�����ݴ���
	VS_SPI_WriteByte(0x45);
	VS_SPI_WriteByte(0x78);
	VS_SPI_WriteByte(0x69);
	VS_SPI_WriteByte(0x74);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	delay_ms(100);
	VS_XDCS(1);	 
}	 
//ram ���� 
//����ֵ:RAM���Խ��
// VS1003����õ���ֵΪ0x807F����������;VS1053Ϊ0X83FF.																				 
uint16_t VS_Ram_Test(void)
{ 
	VS_HD_Reset();     
 	VS_WR_Cmd(SPI_MODE,0x0820);// ����VS10XX�Ĳ���ģʽ
	while (VS_DQ()==0); // �ȴ�DREQΪ��			   
 	VS_SPI_SpeedLow();//���� 
	VS_XDCS(0);	       		    // xDCS = 1��ѡ��VS10XX�����ݽӿ�
	VS_SPI_WriteByte(0x4d);
	VS_SPI_WriteByte(0xea);
	VS_SPI_WriteByte(0x6d);
	VS_SPI_WriteByte(0x54);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	VS_SPI_WriteByte(0x00);
	delay_ms(150);  
	VS_XDCS(1);
	return VS_RD_Reg(SPI_HDAT0);// VS1003����õ���ֵΪ0x807F����������;VS1053Ϊ0X83FF.;       
}     	

//��VS10XXд����
//address:�����ַ
//data:��������
void VS_WR_Cmd(uint8_t address,uint16_t data)
{  
	while(VS_DQ()==0);//�ȴ�����		  
	VS_SPI_SpeedLow();//���� 	   
	VS_XDCS(1); 	  
//	VS_XCS=0; 	 
	VS_SPI_WriteByte(VS_WRITE_COMMAND);//����VS10XX��д����
	VS_SPI_WriteByte(address); 	//��ַ
	VS_SPI_WriteByte(data>>8); 	//���͸߰�λ
	VS_SPI_WriteByte(data);	 	//�ڰ�λ
//	VS_XCS=1;           
	VS_SPI_SpeedHigh();				//����	   
} 

//��VS10XXд����
//data:Ҫд�������
void VS_WR_Data(uint8_t data)
{
	VS_SPI_SpeedHigh();//����,��VS1003B,���ֵ���ܳ���36.864/4Mhz����������Ϊ9M 
	VS_XDCS(0);   
	VS_SPI_WriteByte(data);
	VS_XDCS(1);      
} 

//��VS10XX�ļĴ���           
//address���Ĵ�����ַ
//����ֵ��������ֵ
//ע�ⲻҪ�ñ��ٶ�ȡ,�����
uint16_t VS_RD_Reg(uint8_t address)
{ 
	uint16_t temp=0;    	 
    while(VS_DQ()==0);//�ǵȴ�����״̬ 		  
	VS_SPI_SpeedLow();//���� 
	VS_XDCS(1);       
//	VS_XCS=0;        
	VS_SPI_WriteByte(VS_READ_COMMAND);	//����VS10XX�Ķ�����
	VS_SPI_WriteByte(address);       	//��ַ
	VS_SPI_WriteByte(0xff);
	temp=VS_SPI_ReadByte(); 		//��ȡ���ֽ�
	temp=temp<<8;
	VS_SPI_WriteByte(0xff);
	temp += VS_SPI_ReadByte(); 		//��ȡ���ֽ�
//	VS_XCS=1;     
	VS_SPI_SpeedHigh();//����	  
   return temp; 
} 

//��ȡVS10xx��RAM
//addr��RAM��ַ
//����ֵ��������ֵ
uint16_t VS_WRAM_Read(uint16_t addr) 
{ 
	uint16_t res;			   	  
 	VS_WR_Cmd(SPI_WRAMADDR, addr); 
	res=VS_RD_Reg(SPI_WRAM);  
 	return res;
} 

//дVS10xx��RAM
//addr��RAM��ַ
//val:Ҫд���ֵ 
void VS_WRAM_Write(uint16_t addr,uint16_t val) 
{  		   	  
 	VS_WR_Cmd(SPI_WRAMADDR,addr);	//дRAM��ַ 
	while(VS_DQ()==0); 				//�ȴ�����	   
	VS_WR_Cmd(SPI_WRAM,val); 		//дRAMֵ 
} 

//���ò����ٶȣ���VS1053��Ч�� 
//t:0,1,�����ٶ�;2,2���ٶ�;3,3���ٶ�;4,4����;�Դ�����
void VS_Set_Speed(uint8_t t)
{
	VS_WRAM_Write(0X1E04,t);		//д�벥���ٶ� 
}

//FOR WAV HEAD0 :0X7761 HEAD1:0X7665    
//FOR MIDI HEAD0 :other info HEAD1:0X4D54
//FOR WMA HEAD0 :data speed HEAD1:0X574D
//FOR MP3 HEAD0 :data speed HEAD1:ID
//������Ԥ��ֵ,�ײ�III
const uint16_t bitrate[2][16]=
{ 
{0,8,16,24,32,40,48,56,64,80,96,112,128,144,160,0}, 
{0,32,40,48,56,64,80,96,112,128,160,192,224,256,320,0}
};
//����Kbps�Ĵ�С
//����ֵ���õ�������
uint16_t VS_Get_HeadInfo(void)
{
	unsigned int HEAD0;
	unsigned int HEAD1;  
 	HEAD0=VS_RD_Reg(SPI_HDAT0); 
    HEAD1=VS_RD_Reg(SPI_HDAT1);
  	//printf("(H0,H1):%x,%x\n",HEAD0,HEAD1);
    switch(HEAD1)
    {        
        case 0x7665://WAV��ʽ
        case 0X4D54://MIDI��ʽ 
		case 0X4154://AAC_ADTS
		case 0X4144://AAC_ADIF
		case 0X4D34://AAC_MP4/M4A
		case 0X4F67://OGG
        case 0X574D://WMA��ʽ
		case 0X664C://FLAC��ʽ
        {
			////printf("HEAD0:%d\n",HEAD0);
            HEAD1=HEAD0*2/25;//�൱��*8/100
            if((HEAD1%10)>5)return HEAD1/10+1;//��С�����һλ��������
            else return HEAD1/10;
        }
        default://MP3��ʽ,�����˽ײ�III�ı�
        {
            HEAD1>>=3;
            HEAD1=HEAD1&0x03; 
            if(HEAD1==3)HEAD1=1;
            else HEAD1=0;
            return bitrate[HEAD1][HEAD0>>12];
        }
    }  
}
//�õ�ƽ���ֽ���
//����ֵ��ƽ���ֽ����ٶ�
uint32_t VS_Get_ByteRate(void)
{
	return VS_WRAM_Read(0X1E05);//ƽ��λ��
}
//�õ���Ҫ��������
//����ֵ:��Ҫ��������
uint16_t VS_Get_EndFillByte(void)
{
	return VS_WRAM_Read(0X1E06);//����ֽ�
}  
//����һ����Ƶ����
//�̶�Ϊ32�ֽ�
//����ֵ:0,���ͳɹ�
//		 1,VS10xx��ȱ����,��������δ�ɹ�����    
uint8_t VS_Send_MusicData(uint8_t* buf)
{
	uint8_t n = 0;
	
	if(VS_DQ() != 0)  //�����ݸ�VS10XX
	{			   	 
		VS_XDCS(0);  
    for(n=0;n<32;n++)
		{
			 VS_SPI_WriteByte(buf[n]);	 
		
//			VS_WR_Data(buf[n]);
				//printf("%02x ",buf[n]);
		}
		VS_XDCS(1); 
	}else return 1;
	return 0;//�ɹ�������
}


//����һ����Ƶ����
//����ָ������
//����ֵ:0,���ͳɹ�
//		 1,VS10xx��ȱ����,��������δ�ɹ�����    
uint8_t VS_Send_Nbyte_MusicData(uint8_t* buf,uint16_t len)
{
	uint16_t n;
	
	if(VS_DQ() != 0)  //�����ݸ�VS10XX
	{			   	 
		VS_XDCS(0);  
    for(n=0;n<len;n++)
		{
			VS_SPI_WriteByte(buf[n]);	 			
		}
		VS_XDCS(1);     				   
	}else return 1;
	return 0;//�ɹ�������
}


//�и�
//ͨ���˺����и裬��������л���������				
void VS_Restart_Play(void)
{
	uint16_t temp;
	uint16_t i;
	uint8_t n;	  
	uint8_t vsbuf[32];
	for(n=0;n<32;n++)vsbuf[n]=0;//����
	temp=VS_RD_Reg(SPI_MODE);	//��ȡSPI_MODE������
	temp|=1<<3;					//����SM_CANCELλ
	temp|=1<<2;					//����SM_LAYER12λ,������MP1,MP2
	VS_WR_Cmd(SPI_MODE,temp);	//����ȡ����ǰ����ָ��
	for(i=0;i<2048;)			//����2048��0,�ڼ��ȡSM_CANCELλ.���Ϊ0,���ʾ�Ѿ�ȡ���˵�ǰ����
	{
		if(VS_Send_MusicData(vsbuf)==0)//ÿ����32���ֽں���һ��
		{
			i+=32;						//������32���ֽ�
   			temp=VS_RD_Reg(SPI_MODE);	//��ȡSPI_MODE������
 			if((temp&(1<<3))==0)break;	//�ɹ�ȡ����
		}	
	}
	if(i<2048)//SM_CANCEL����
	{
		temp=VS_Get_EndFillByte()&0xff;//��ȡ����ֽ�
		for(n=0;n<32;n++)vsbuf[n]=temp;//����ֽڷ�������
		for(i=0;i<2052;)
		{
			if(VS_Send_MusicData(vsbuf)==0)i+=32;//���	  
		}   	
	}else VS_Soft_Reset();  	//SM_CANCEL���ɹ�,�����,��Ҫ��λ 	  
	temp=VS_RD_Reg(SPI_HDAT0); 
    temp+=VS_RD_Reg(SPI_HDAT1);
	if(temp)					//��λ,����û�гɹ�ȡ��,��ɱ���,Ӳ��λ
	{
		VS_HD_Reset();		   	//Ӳ��λ
		VS_Soft_Reset();  		//��λ 
	} 
}

//�������ʱ��                          
void VS_Reset_DecodeTime(void)
{
	VS_WR_Cmd(SPI_DECODE_TIME,0x0000);
	VS_WR_Cmd(SPI_DECODE_TIME,0x0000);//��������
}

//�õ�mp3�Ĳ���ʱ��n sec
//����ֵ������ʱ��
uint16_t VS_Get_DecodeTime(void)
{ 		
	uint16_t dt=0;	 
	dt=VS_RD_Reg(SPI_DECODE_TIME);      
 	return dt;
} 	 

//vs10xxװ��patch.
//patch��patch�׵�ַ
//len��patch����
void VS_Load_Patch(uint16_t *patch,uint16_t len) 
{
	uint16_t i; 
	uint16_t addr, n, val; 	  			   
	for(i=0;i<len;) 
	{ 
		addr = patch[i++]; 
		n    = patch[i++]; 
		if(n & 0x8000U) //RLE run, replicate n samples 
		{ 
			n  &= 0x7FFF; 
			val = patch[i++]; 
			while(n--)VS_WR_Cmd(addr, val);  
		}else //copy run, copy n sample 
		{ 
			while(n--) 
			{ 
				val = patch[i++]; 
				VS_WR_Cmd(addr, val); 
			} 
		} 
	} 	
} 		

//�趨VS10XX���ŵ������͸ߵ���
//volx:������С(0~254)
void VS_Set_Vol(uint8_t volx)
{
    uint16_t volt=0; 			//�ݴ�����ֵ
	
    volt=254-volx;			//ȡ��һ��,�õ����ֵ,��ʾ���ı�ʾ 
		volt<<=8;
    volt+=254-volx;			//�õ��������ú��С
    VS_WR_Cmd(SPI_VOL,volt);//������ 
}

//�趨�ߵ�������
//bfreq:��Ƶ����Ƶ��	2~15(��λ:10Hz)
//bass:��Ƶ����			0~15(��λ:1dB)
//tfreq:��Ƶ����Ƶ�� 	1~15(��λ:Khz)
//treble:��Ƶ����  	 	0~15(��λ:1.5dB,С��9��ʱ��Ϊ����)
void VS_Set_Bass(uint8_t bfreq,uint8_t bass,uint8_t tfreq,uint8_t treble)
{
    uint16_t bass_set=0; //�ݴ������Ĵ���ֵ
    signed char temp=0;   	 
	if(treble==0)temp=0;	   		//�任
	else if(treble>8)temp=treble-8;
 	else temp=treble-9;  
	bass_set=temp&0X0F;				//�����趨
	bass_set<<=4;
	bass_set+=tfreq&0xf;			//��������Ƶ��
	bass_set<<=4;
	bass_set+=bass&0xf;				//�����趨
	bass_set<<=4;
	bass_set+=bfreq&0xf;			//��������    
	VS_WR_Cmd(SPI_BASS,bass_set);	//BASS 
}

//�趨��Ч
//eft:0,�ر�;1,��С;2,�е�;3,���.
void VS_Set_Effect(uint8_t eft)
{
	uint16_t temp;	 
	temp=VS_RD_Reg(SPI_MODE);	//��ȡSPI_MODE������
	if(eft&0X01)temp|=1<<4;		//�趨LO
	else temp&=~(1<<5);			//ȡ��LO
	if(eft&0X02)temp|=1<<7;		//�趨HO
	else temp&=~(1<<7);			//ȡ��HO						   
	VS_WR_Cmd(SPI_MODE,temp);	//�趨ģʽ    
}	 


///////////////////////////////////////////////////////////////////////////////
//��������,��Ч��.
void VS_Set_All(void) 				
{			 
	VS_Set_Vol(vsset.mvol);			//��������
	VS_Set_Bass(vsset.bflimit,vsset.bass,vsset.tflimit,vsset.treble);  
	VS_Set_Effect(vsset.effect);	//���ÿռ�Ч��
}































