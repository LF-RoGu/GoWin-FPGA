
#ifndef __SPI_MASTER_H
#define __SPI_MASTER_H

#include "gw1ns4c.h"


//Initializes SPI
void SPI1_Init(void);

// ��SPI��������
void SPI_send_data(uint8_t data);

// ��SPI��������
uint8_t SPI_read_data(void);


#endif
