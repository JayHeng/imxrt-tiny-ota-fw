/*
 * Copyright (c) 2013 - 2015, Freescale Semiconductor, Inc.
 * Copyright 2016-2017, 2024 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include "fsl_device_registers.h"
#include "fsl_debug_console.h"
#include "board.h"
#include "app.h"

#if (defined(__ICCARM__))
#pragma section = ".intvec"
#endif

/*******************************************************************************
 * Definitions
 ******************************************************************************/

#define APP_MAGIC (0x50504154) //'TAPP'

typedef struct _tota_app_header
{
    uint32_t reserved0[8];
    uint32_t length;
    uint16_t version;
    uint16_t authType;
    uint32_t checksum;
    uint32_t reserved1[2];
    uint32_t magic;
} tota_app_header_t;

/*******************************************************************************
 * Prototypes
 ******************************************************************************/

/*******************************************************************************
 * Variables
 ******************************************************************************/

/*******************************************************************************
 * Code
 ******************************************************************************/
/*!
 * @brief Main function
 */
int main(void)
{
    char ch;

    /* Init board hardware. */
    BOARD_InitHardware();

    PRINTF("MCUX SDK version: %s\r\n", MCUXSDK_VERSION_FULL_STR);

    PRINTF("hello Tiny OTA app.\r\n");

#if (defined(__ICCARM__))
    uint32_t vectorStart = (uint32_t)__section_begin(".intvec");
    PRINTF("app vector addr = 0x%x.\r\n", vectorStart);
    tota_app_header_t *appHeader = (tota_app_header_t *)vectorStart;
    if (appHeader->magic == APP_MAGIC)
    {
        PRINTF("app version: V%d.%d \r\n", appHeader->version >>8, appHeader->version & 0xFF);
        PRINTF("app length (bytes) = 0x%x.\r\n", appHeader->length);
    }
    else
    {
        PRINTF("app doesn't contain magic.\r\n");
    }
#endif

    while (1)
    {
        ch = GETCHAR();
        PUTCHAR(ch);
    }
}
