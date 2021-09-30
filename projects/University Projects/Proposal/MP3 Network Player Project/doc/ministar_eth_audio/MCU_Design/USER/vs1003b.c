/*
 * MP3ģ����Գ���
 * 
 * ��;��MP3ģ����Գ���
 *       vs1003 ��Ӳ�����Գ�������оƬΪSTC12LE5A60S2
 *       ������΢������(��SPI�ӿڵ�)ֻ���Լ��޸ļ�������
 *       ���ڲ���ӲSPI�ӿڵ�΢������������IO����SPI��ʱ��ģ��
 * 
 * ����					����				��ע
 * Huafeng Lin			20010/09/10			����
 * Huafeng Lin			20010/09/10			�޸�
 * 
 */
 
#include "vs1003b.h" 
#include "MusicDataMP3.c"
#include "delay.h"
#include <stdio.h>









/**********************************************************/
/*  �������� :   MSPI_Init                                */
/*  �������� �� ��ʼ��SPI�ӿڣ�����Ϊ������               */
/*  ����     :  ��                                        */
/*  ����ֵ   :  ��                                        */
/*--------------------------------------------------------*/
void  MSPI_Init(void)
{  
/*
	PINSEL0 = (PINSEL0 & 0xFFFF00FF) | 0x00005500;	//ѡ�� SPI 
        S0SPCCR = 0x08;		                        // SPI ʱ������
 	S0SPCR  = (0 << 3) |				// CPHA = 0, 
 		  (0 << 4) |				// CPOL = 0, 
 		  (1 << 5) |				// MSTR = 1, 
 		  (0 << 6) |				// LSBF = 0, 
 	          (0 << 7);				// SPIE = 0, 
*/
	GPIO_InitTypeDef GPIO_InitType;
	
	GPIO_InitType.GPIO_Pin = MP3_XRESET;
	GPIO_InitType.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitType.GPIO_Int = GPIO_Int_Disable;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,MP3_XRESET);
	
	GPIO_InitType.GPIO_Pin = MP3_XCS;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,MP3_XCS);	

	GPIO_InitType.GPIO_Pin = MP3_DREQ;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,MP3_DREQ);	
	
	GPIO_InitType.GPIO_Pin = MP3_XDCS;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,MP3_XDCS);		
	
	GPIO_InitType.GPIO_Pin = SPI_MISO;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,SPI_MISO);	

	GPIO_InitType.GPIO_Pin = SPI_MOSI;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,SPI_MOSI);

	GPIO_InitType.GPIO_Pin = SPI_CLK;
	GPIO_Init(GPIO0,&GPIO_InitType);
  GPIO_SetBit(GPIO0,SPI_CLK);

	Macro_Set_SO_High();
	Macro_DREQ_High();

}

/**********************************************************/
/*  �������� :  InitPortVS1003                            */
/*  �������� �� MCU��vs1003�ӿڵĳ�ʼ��                   */
/*  ����     :  ��                                        */
/*  ����ֵ   :  ��                                        */
/*--------------------------------------------------------*/
void  InitPortVS1003(void)
{
	MSPI_Init();//SPI�ڵĳ�ʼ��
//	IODIR &= 0xfffeffff;   //�����ӿ��ߵ����ã�����dreq Ϊ�����
//	IODIR |= MP3_XRESET | MP3_XCS | MP3_XDCS;//xRESET��xCS��xDS��Ϊ�����
//	IOSET |= MP3_XRESET | MP3_XCS | MP3_XDCS;//xRESET��xCS��xDSĬ������ߵ�ƽ	
	Macro_DREQ_High();		//��Ϊ����

	Mp3ReleaseFromReset();
	Mp3DeselectControl();
	Mp3DeselectData();
}

//uint8_t SD_SPI_ReadByte(void);
//void SD_SPI_WriteByte(uint8_t ucSendData);

//#define SPI_RecByte()  SD_SPI_ReadByte()
//#define SPIPutChar(x) SD_SPI_WriteByte(x)

#if 1
/**********************************************************/
/*  �������� :  SPIPutChar                                */
/*  �������� �� ͨ��SPI����һ���ֽڵ�����                 */
/*  ����     :  �����͵��ֽ�����                          */
/*  ����ֵ   :  ��                                        */
/*--------------------------------------------------------*/
void  SPIPutChar(unsigned char ucSendData)
{      
//	S0SPDR = c;
//	while((S0SPSR & 0x80) == 0);	 //�ȴ�SPI�����ݷ������
	uint8_t ucCount;
	uint8_t ucMaskCode;

	ucMaskCode = 0x80;
	for(ucCount=0; ucCount<8; ucCount++)
	{
		Macro_Set_CLK_Low();

		if(ucMaskCode & ucSendData)
		{
			Macro_Set_SI_High();
		}
		else
		{
			Macro_Set_SI_Low();
		}

		Macro_Set_CLK_High();
		ucMaskCode >>= 1;

	}
}

/*******************************************************************************************************************
** ��������: INT8U SPI_RecByte()				Name:	  INT8U SPI_RecByte()
** ��������: ��SPI�ӿڽ���һ���ֽ�				Function: receive a byte from SPI interface
** �䡡  ��: ��									Input:	  NULL
** �� �� ��: �յ����ֽ�							Output:	  the byte that be received
********************************************************************************************************************/
static uint8_t SPI_RecByte(void)
{
	uint8_t ucReadData;
	uint8_t ucCount;

	ucReadData = 0;
	Macro_Set_SI_High();

	for(ucCount=0; ucCount<8; ucCount++)
	{
		ucReadData <<= 1;
			//����ʱ��Ƶ��
		Macro_Set_CLK_Low();

	
		if(Macro_Read_SO()) 
		{
			ucReadData |= 0x01;
		}
		Macro_Set_CLK_High();

	}

	return(ucReadData);
}

#endif

/*************************************************************/
/*  �������� :  Mp3WriteRegister                             */
/*  �������� �� дvs1003�Ĵ���                               */
/*  ����     :  �Ĵ�����ַ����д���ݵĸ�8λ����д���ݵĵ�8λ */
/*  ����ֵ   :  ��                                           */
/*-----------------------------------------------------------*/
void Mp3WriteRegister(unsigned char addressbyte, unsigned char highbyte, unsigned char lowbyte)
{
	Mp3DeselectData();
	Mp3SelectControl();//XCS = 0
	SPIPutChar(VS_WRITE_COMMAND); //����д�Ĵ�������
	SPIPutChar(addressbyte);      //���ͼĴ����ĵ�ַ
	SPIPutChar(highbyte);         //���ʹ�д���ݵĸ�8λ
	SPIPutChar(lowbyte);          //���ʹ�д���ݵĵ�8λ
	Mp3DeselectControl();
}

/*************************************************************/
/*  �������� :  Mp3ReadRegister                              */
/*  �������� �� дvs1003�Ĵ���                               */
/*  ����     :  �Ĵ�����ַ				     */
/*  ����ֵ   :  vs1003��16λ�Ĵ�����ֵ                       */
/*-----------------------------------------------------------*/
unsigned int Mp3ReadRegister(unsigned char addressbyte)
{
	unsigned int resultvalue = 0;
	uint8_t ucReadValue;

	Mp3DeselectData();
	Mp3SelectControl();//XCS = 0
	SPIPutChar(VS_READ_COMMAND); //���Ͷ��Ĵ�������
	SPIPutChar((addressbyte));	 //���ͼĴ����ĵ�ַ

//	SPIPutChar(0xff); 		//���Ͷ�ʱ��
//	resultvalue = (SPI_RESULT_BYTE) << 8;//��ȡ��8λ����
	ucReadValue = SPI_RecByte();
	resultvalue = ucReadValue<<8;
//	SPIPutChar(0xff);		   //���Ͷ�ʱ��
//	resultvalue |= (SPI_RESULT_BYTE);  //��ȡ��8λ����
	ucReadValue = SPI_RecByte();
	resultvalue |= ucReadValue;

	Mp3DeselectControl();              
	return resultvalue;                 //����16λ�Ĵ�����ֵ
}

/**********************************************************/
/*  �������� :  Mp3SoftReset                              */
/*  �������� �� vs1003�����λ                            */
/*  ����     :  ��                                        */
/*  ����ֵ   :  ��                                        */
/*--------------------------------------------------------*/
void Mp3SoftReset(void)
{
	Mp3WriteRegister (SPI_MODE, 0x08, 0x04); //�����λ

	delay_ms(1); //��ʱ1ms
	while (MP3_DREQ == 0); //�ȴ������λ����
	printf("dreq = 0\r\n");
	Mp3WriteRegister(SPI_CLOCKF, 0x98, 0x00);//����vs1003��ʱ��,3��Ƶ
	Mp3WriteRegister (SPI_AUDATA, 0xBB, 0x81); //������48k��������
	Mp3WriteRegister(SPI_BASS, 0x00, 0x55);//��������
	Mp3SetVolume(10,10);//��������
    delay_ms(1); //��ʱ1ms
    	
    	//��vs1003����4���ֽ���Ч���ݣ���������SPI����
   	Mp3SelectData();
	SPIPutChar(0);
	SPIPutChar(0);
	SPIPutChar(0);
	SPIPutChar(0);
	Mp3DeselectData();

}
/**********************************************************/
/*  �������� :  Mp3Reset                                  */
/*  �������� �� vs1003Ӳ����λ                            */
/*  ����     :  ��                                        */
/*  ����ֵ   :  ��                                        */
/*--------------------------------------------------------*/
void Mp3Reset(void)
{	
	Mp3PutInReset();//xReset = 0   ��λvs1003      
	delay_ms(200);//��ʱ100ms
	SPIPutChar(0xff);//����һ���ֽڵ���Ч���ݣ�����SPI����
	Mp3DeselectControl();   //xCS = 1
	Mp3DeselectData();     //xDCS = 1
	Mp3ReleaseFromReset(); //xRESET = 1
	delay_ms(200);            //��ʱ100ms
	while (Macro_DREQ_Read() == 0);//�ȴ�DREQΪ��
printf("DREQ init OK!\r\n");	
	
	delay_ms(200);            //��ʱ100ms
 	Mp3SetVolume(50,50);  
	Mp3SoftReset();//vs1003��λ
}


uint8_t CheckVS1003B_DRQ(void)
{
	uint8_t bResult;

	bResult = Macro_DREQ_Read();
	return(bResult);
}

/***********************************************************/
/*  �������� :  VsSineTest                                 */
/*  �������� �� vs1003���Ҳ��ԣ����ú�������whileѭ���У�  */
/*              ����ܳ�������һ��һ�͵�������֤������ͨ�� */                            
/*  ����     :  ��                                         */
/*  ����ֵ   :  ��                                         */
/*---------------------------------------------------------*/
void VsSineTest(void)
{
	Mp3PutInReset();  //xReset = 0   ��λvs1003
	delay_ms(200);        //��ʱ100ms        
	SPIPutChar(0xff);//����һ���ֽڵ���Ч���ݣ�����SPI����
	Mp3DeselectControl();  
	Mp3DeselectData();     
	Mp3ReleaseFromReset(); 
	delay_ms(200);	               
	Mp3SetVolume(50,50);  

 	Mp3WriteRegister(SPI_MODE,0x08,0x20);//����vs1003�Ĳ���ģʽ
	while (Macro_DREQ_Read() == 0);     //�ȴ�DREQΪ��
 	Mp3SelectData();       //xDCS = 1��ѡ��vs1003�����ݽӿ�
 	printf("sin wave test start\r\n");
 	//��vs1003�������Ҳ������0x53 0xef 0x6e n 0x00 0x00 0x00 0x00
 	//����n = 0x24, �趨vs1003�����������Ҳ���Ƶ��ֵ��������㷽����vs1003��datasheet
   	SPIPutChar(0x53);      
	SPIPutChar(0xef);      
	SPIPutChar(0x6e);      
	SPIPutChar(0x24);      
	SPIPutChar(0x00);      
	SPIPutChar(0x00);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
//	delay_ms(500);
	delay_ms(250);
	delay_ms(250);
	Mp3DeselectData();//����ִ�е������Ӧ���ܴӶ�������һ����һƵ�ʵ�����
  
        //�˳����Ҳ���
	Mp3SelectData();
	SPIPutChar(0x45);
	SPIPutChar(0x78);
	SPIPutChar(0x69);
	SPIPutChar(0x74);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
//	delay_ms(500);
	delay_ms(250);
	delay_ms(250);

	Mp3DeselectData();

        //�ٴν������Ҳ��Բ�����nֵΪ0x44���������Ҳ���Ƶ������Ϊ�����ֵ
    Mp3SelectData();       
	SPIPutChar(0x53);      
	SPIPutChar(0xef);      
	SPIPutChar(0x6e);      
	SPIPutChar(0x44);      
	SPIPutChar(0x00);      
	SPIPutChar(0x00);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
//	delay_ms(500);
	delay_ms(250);
	delay_ms(250);

	Mp3DeselectData(); 

	//�˳����Ҳ���
	Mp3SelectData();
	SPIPutChar(0x45);
	SPIPutChar(0x78);
	SPIPutChar(0x69);
	SPIPutChar(0x74);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
	SPIPutChar(0x00);
//	delay_ms(500);
	delay_ms(250);
	delay_ms(250);
 	printf("sin wave test end\r\n");
	
	Mp3DeselectData();
 }

//д�Ĵ�������������ַ������
void VS1003B_WriteCMD(unsigned char addr, unsigned int dat)
{
/*
	VS1003B_XDCS_H();
	VS1003B_XCS_L();
	VS1003B_WriteByte(0x02);
	//delay_Nus(20);
	VS1003B_WriteByte(addr);
	VS1003B_WriteByte(dat>>8);
	VS1003B_WriteByte(dat);
	//delay_Nus(200);
	VS1003B_XCS_H();
*/
	Mp3WriteRegister(addr,dat>>8,dat);
}

//���Ĵ��������� ��ַ ��������
unsigned int VS1003B_ReadCMD(unsigned char addr)
{
/*
	unsigned int temp;
	unsigned char temp1;
	VS1003B_XDCS_H();
	VS1003B_XCS_L();
	VS1003B_WriteByte(0x03);
	//delay_Nus(20);
	VS1003B_WriteByte(addr);
	temp=  VS1003B_ReadByte();
	temp=temp<<8;
	temp1= VS1003B_ReadByte();
	temp=temp|temp1;;
	VS1003B_XCS_H();
	return temp;
*/
	return(Mp3ReadRegister(addr));
}

//д���ݣ���������
void VS1003B_WriteDAT(unsigned char dat)
{
//	VS1003B_XDCS_L();
//	VS1003B_WriteByte(dat);
//	VS1003B_XDCS_H();
//	VS1003B_XCS_H();

   	Mp3SelectData();
	SPIPutChar(dat);
	Mp3DeselectData();
	Mp3DeselectControl();

}

//����������
void VS1003B_SetVirtualSurroundOn(void)
{
	uint8_t ucRepeatCount;
	uint16_t uiModeValue;

	ucRepeatCount =0;

	while(1)//дʱ�ӼĴ���
	{
		uiModeValue = VS1003B_ReadCMD(0x00);
		if(uiModeValue & 0x0001)
		{
			break;
		}
		else
		{
			uiModeValue |= 0x0001;
			VS1003B_WriteCMD(0,uiModeValue);
		}
		ucRepeatCount++;
		if(ucRepeatCount++ >10 )break;
	}

}

//�رջ�����
void VS1003B_SetVirtualSurroundOff(void)
{
	uint8_t ucRepeatCount;
	uint16_t uiModeValue;

	ucRepeatCount =0;

	while(1)//дʱ�ӼĴ���
	{
		uiModeValue = VS1003B_ReadCMD(0x00);
		if(uiModeValue & 0x0001)
		{
			break;
		}
		else
		{
			uiModeValue |= 0x0001;
			VS1003B_WriteCMD(0,uiModeValue);
		}
		ucRepeatCount++;
		if(ucRepeatCount++ >10 )break;
	}

}

//��ǿ����
//��ڲ���	1.ǿ��0-15
//			2.Ƶ��0-15 (X10Hz)
void VS1003B_SetBassEnhance(uint8_t ucValue, uint16_t ucFrequencyID)
{
	uint8_t ucRepeatCount;
	uint16_t uiWriteValue;
	uint16_t uiReadValue;	

	ucRepeatCount =0;

	uiWriteValue = VS1003B_ReadCMD(0x02);

	uiWriteValue &= 0xFF00;
	uiWriteValue |= ucValue<<4;
	uiWriteValue &= (ucFrequencyID & 0x0F);

	while(1)//дʱ�ӼĴ���
	{

		VS1003B_WriteCMD(2,uiWriteValue);
		uiReadValue = VS1003B_ReadCMD(0x02);
		
		if(uiReadValue == uiWriteValue)
		{
			break;
		}
		ucRepeatCount++;
		if(ucRepeatCount++ >10 )break;
	}

}


 uint16_t uiVolumeCount;		//��ǰ����ֵ

//VS1003��ʼ����0�ɹ� 1ʧ��
unsigned char VS1003B_Init()
{
	unsigned char retry;
/*
	PORT_INI();
	DDRB|=0xa0;
	VS1003B_DDR &=~(1<<VS1003B_DREQ);
	//delay_Nus(50);
	VS1003B_XCS_H();
	VS1003B_XDCS_H();
	VS1003B_XRESET_L();
	VS1003B_Delay(0xffff);
	VS1003B_XRESET_H();//ʹ��оƬ
	VS1003B_SPI_Low();//���Ե�Ƶ����
	VS1003B_Delay(0xffff);//��ʱ
*/
Mp3Reset();

	retry=0;
	while(VS1003B_ReadCMD(0x00) != 0x0800)//дmode�Ĵ���
	{
		VS1003B_WriteCMD(0x00,0x0800);
		if(retry++ >10 )break;//{PORTB|=_BV(PB1);break;}
	}
	retry=0;
	/*while(VS1003B_ReadCMD(0x02) != 0x75)//дmode�Ĵ���
	{
		VS1003B_WriteCMD(0x02,0x75);
		if(retry++ >10 )break;//{PORTB|=_BV(PB1);break;}
	}*/
	retry=0;
	while(VS1003B_ReadCMD(0x03) != 0x9800)//дʱ�ӼĴ���
	{
		VS1003B_WriteCMD(0x03,0x9800);
		if(retry++ >10 )break;
	}
	retry=0;
//	while(VS1003B_ReadCMD(0x0b) != 0x1111)//������
//	{
//		VS1003B_WriteCMD(0x0b,0x1111);
//		if(retry++ >10 )break;
//	}
	while(VS1003B_ReadCMD(0x0b) != uiVolumeCount)//������
	{
		VS1003B_WriteCMD(0x0b,uiVolumeCount);
		if(retry++ >10 )break;
	}

//	VS1003B_SPI_High();//����ٶȣ�ȫ������
	if(retry > 10)return 1;
	return 0;
}

//VS1003�����λ
void VS1003B_SoftReset()
{
	VS1003B_WriteCMD(0x00,0x0804);//д��λ
//	VS1003B_Delay(0xffff);//��ʱ������1.35ms
	delay_ms(2);
}

void VS1003B_Fill2048Zero()
{
	unsigned char i,j;

	for(i=0;i<64;i++)
	{
		if(CheckVS1003B_DRQ())
		{
			Mp3SelectData();

			for(j=0;j<32;j++)
			{

				VS1003B_WriteDAT(0x00);
			}
			Mp3DeselectData();
		}
	}
}


void test_1003_PlayMP3File() 
{
  unsigned int data_pointer;unsigned char i;
	unsigned int uiCount;

	uiCount = sizeof(MusicData);
	
	data_pointer=0; 
	VS1003B_SoftReset();
	while(uiCount>0)
	{ 
		if(CheckVS1003B_DRQ())
		{
			for(i=0;i<32;i++)
			{
					VS1003B_WriteDAT(MusicData[data_pointer]);
					data_pointer++;
			}
		uiCount -= 32;
		}
	}
	VS1003B_Fill2048Zero();
}


// test
void TestVS1003B(void)
{
	Mp3Reset();
	VsSineTest();
	Mp3SoftReset();
	test_1003_PlayMP3File();
}


