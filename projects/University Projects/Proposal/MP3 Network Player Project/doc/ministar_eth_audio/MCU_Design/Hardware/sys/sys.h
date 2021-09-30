#ifndef __SYS_H
#define __SYS_H	
#include "gw1ns4c.h"


															    
	 
//λ������,ʵ��51���Ƶ�GPIO���ƹ���
//����ʵ��˼��,�ο�<<CM3Ȩ��ָ��>>������(87ҳ~92ҳ).
//IO�ڲ����궨��
#define BITBAND(addr, bitnum) ((addr & 0xF0000000)+0x2000000+((addr &0xFFFFF)<<5)+(bitnum<<2)) 
#define MEM_ADDR(addr)  *((volatile unsigned long  *)(addr)) 
#define BIT_ADDR(addr, bitnum)   MEM_ADDR(BITBAND(addr, bitnum)) 
//IO�ڵ�ַӳ��
#define GPIO0_ODR_Addr    (GPIO0_BASE+12) //0x4001080C 
   
#define GPIO0_IDR_Addr    (GPIO0_BASE+8) //0x40010808 

 
//IO�ڲ���,ֻ�Ե�һ��IO��!
//ȷ��n��ֵС��16!
#define P0out(n)   BIT_ADDR(GPIO0_ODR_Addr,n)  //��� 
#define P0in(n)    BIT_ADDR(GPIO0_IDR_Addr,n)  //���� 


//����Ϊ��ຯ��
void WFI_SET(void);		//ִ��WFIָ��
void INTX_DISABLE(void);//�ر������ж�
void INTX_ENABLE(void);	//���������ж�
void MSR_MSP(uint32_t addr);	//���ö�ջ��ַ

#endif
