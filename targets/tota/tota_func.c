/*
 * Copyright (c) 2013 - 2015, Freescale Semiconductor, Inc.
 * Copyright 2016-2017, 2024 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include "tota_func.h"

#if (defined(__ICCARM__))
#pragma section = ".intvec"
#endif

/*******************************************************************************
 * Definitions
 ******************************************************************************/

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
void tota_app_ehco(void)
{
    PRINTF("hello Tiny OTA app.\r\n");

#if (defined(__ICCARM__))
    uint32_t vectorStart = (uint32_t)__section_begin(".intvec");
    PRINTF("app vector addr = 0x%x.\r\n", vectorStart);
    tota_app_header_t *appHeader = (tota_app_header_t *)vectorStart;
    if (((appHeader->authType == kAppAuthType_Magic) && (appHeader->authResult == APP_MAGIC)) ||
        ((appHeader->authType == kAppAuthType_NonxipCRC32) || (appHeader->authType == kAppAuthType_XipCRC32)))
    {
        PRINTF("app version: V%d.%d \r\n", appHeader->version >>8, appHeader->version & 0xFF);
        PRINTF("app length (bytes) = 0x%x.\r\n", appHeader->length);
    }
    else
    {
        PRINTF("app doesn't contain valid auth.\r\n");
    }
#endif
}

#if defined(BL_TARGET_RAM)
#include "bootloader_common.h"
#else
#define debug_printf(...)
#endif

void tota_sbl_ehco(void)
{
    debug_printf("-----------------\r\n");
    debug_printf("hello Tiny OTA sbl.\r\n");

#if (defined(__ICCARM__))
    uint32_t vectorStart = (uint32_t)__section_begin(".intvec");
    debug_printf("sbl vector addr = %x.\r\n", vectorStart);
    tota_sbl_header_t *sblHeader = (tota_sbl_header_t *)vectorStart;
    if (sblHeader->magic == SBL_MAGIC)
    {
        debug_printf("slot 0 start: %x \r\n", sblHeader->slot0StartAddr);
        debug_printf("slot 1 start: %x \r\n", sblHeader->slot1StartAddr);
    }
    else
    {
        debug_printf("sbl doesn't contain magic.\r\n");
    }
#endif
}

void tota_sbl_farewell(void)
{
    debug_printf("-----------------\r\n\r\n");
}

//! @brief Get the start address of specified application
uint32_t tota_get_app_base(specified_application_type_t applicationType)
{
    uint32_t slotStartAddr = 0;
#if (defined(__ICCARM__))
    uint32_t vectorStart = (uint32_t)__section_begin(".intvec");
    tota_sbl_header_t *sblHeader = (tota_sbl_header_t *)vectorStart;
    if (sblHeader->magic != SBL_MAGIC)
    {
        return 0;
    }

    if (applicationType == kSpecifiedApplicationType_Slot0)
    {
        slotStartAddr = sblHeader->slot0StartAddr;
    }
    else if (applicationType == kSpecifiedApplicationType_Slot1)
    {
        slotStartAddr = sblHeader->slot1StartAddr;
    }
#endif

    return slotStartAddr;
}
