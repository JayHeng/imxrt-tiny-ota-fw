/*
 * Copyright (c) 2015, Freescale Semiconductor, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * o Redistributions of source code must retain the above copyright notice, this list
 *   of conditions and the following disclaimer.
 *
 * o Redistributions in binary form must reproduce the above copyright notice, this
 *   list of conditions and the following disclaimer in the documentation and/or
 *   other materials provided with the distribution.
 *
 * o Neither the name of Freescale Semiconductor, Inc. nor the names of its
 *   contributors may be used to endorse or promote products derived from this
 *   software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "bootloader/bl_context.h"
#include "bootloader_common.h"
#include "bootloader/bl_reliable_update.h"
#include "bootloader/bl_app_crc_check.h"
#include "property/property.h"
#include "bootloader/bootloader.h"
#include "memory/memory.h"
#include "crc/crc32.h"
#include "utilities/fsl_assert.h"
#include "flexspi_nor_flash.h"
#include "flexspi_nor_memory.h"
#include "tota_func.h"

#if BL_FEATURE_RELIABLE_UPDATE

////////////////////////////////////////////////////////////////////////////////
// Definitions
////////////////////////////////////////////////////////////////////////////////

// image header for Cortex-M series
typedef struct
{
    uint32_t stackPointer;
    uint32_t applicationPointer;
} appliation_header_t;

////////////////////////////////////////////////////////////////////////////////
// Prototypes
////////////////////////////////////////////////////////////////////////////////

static bool is_reliable_update_active(void);

//! @brief Determine if the specified application is valid
static bool is_specified_application_valid(uint32_t applicationBase, uint16_t *applicationVersion);

//! @brief Determine if the specified application is valid
static void update_reliable_update_status(uint32_t status);

//! @brief Get the start address of specified application
static uint32_t get_application_base(specified_application_type_t applicationType);

//! @brief Do software reliable application update if slot1 application is valid
static status_t software_reliable_update(uint32_t slot1ApplicationBase);

//! @brief Copy source appliction to destination application region and return result
static bool get_result_after_copying_application(uint32_t src, uint32_t dst, uint32_t len);

////////////////////////////////////////////////////////////////////////////////
// Code
////////////////////////////////////////////////////////////////////////////////

// See bl_reliable_update.h for documents on this function.
void bootloader_reliable_update_as_requested(reliable_update_option_t option, uint32_t address)
{
    update_reliable_update_status(kStatus_ReliableUpdateSuccess);
    if (is_reliable_update_active())
    {
        status_t status = software_reliable_update(get_application_base(kSpecifiedApplicationType_Slot1));
        update_reliable_update_status(status);
        if (status != kStatus_ReliableUpdateSuccess)
        {
            debug_printf("Failed to copy slot 1 app to slot 0 address.\r\n");
            g_bootloaderContext.imageStart = 0xffffffffu;
        }
        else
        {
            debug_printf("Passed app copying.\r\n");
        }
    }
}

extern uint32_t flexspi_nor_get_amba_addr();

//! @brief Get the start address of specified application
static uint32_t get_application_base(specified_application_type_t applicationType)
{
    uint32_t appMapBase = 0;
    uint32_t slotStartAddr = tota_get_app_base(applicationType);
    if (!slotStartAddr)
    {
        return 0;
    }

    appMapBase = flexspi_nor_get_amba_addr();
    if (slotStartAddr < appMapBase)
    {
        appMapBase += slotStartAddr;
    }
    else
    {
        appMapBase = slotStartAddr;
    }

    return appMapBase;
}

// Update the status for reliable update
static void update_reliable_update_status(uint32_t status)
{
    property_store_t *propertyStore = g_bootloaderContext.propertyInterface->store;
    propertyStore->reliableUpdateStatus = status;
}

// Determine if the reliable update feature is active
static bool is_reliable_update_active(void)
{
    uint32_t slot0ApplicationBase = get_application_base(kSpecifiedApplicationType_Slot0);
    uint32_t slot1ApplicationBase = get_application_base(kSpecifiedApplicationType_Slot1);
    debug_printf("slot 0 app base: %x\r\n", slot0ApplicationBase);
    debug_printf("slot 1 app base: %x\r\n", slot1ApplicationBase);
    uint16_t slot0Version = 0;
    uint16_t slot1Version = 0;
    bool slot0Valid = is_specified_application_valid(slot0ApplicationBase, &slot0Version);
    bool slot1Valid = is_specified_application_valid(slot1ApplicationBase, &slot1Version);
    g_bootloaderContext.imageStart = slot0ApplicationBase;
    if ((!slot0Valid) && slot1Valid)
    {
        debug_printf("slot 0 app is invalid and slot 1 app is valid.\r\n");
        return true;
    }
    else if ((!slot1Valid) && slot0Valid)
    {
        debug_printf("slot 0 app is valid and slot 1 app is invalid.\r\n");
        return false;
    }
    else if (slot0Valid && slot1Valid)
    {
        debug_printf("both slot 0 and slot 1 app are valid.\r\n");
        debug_printf("slot 0 app version: V%d.%d \r\n", slot0Version >>8, slot0Version & 0xFF);
        debug_printf("slot 1 app version: V%d.%d \r\n", slot1Version >>8, slot1Version & 0xFF);
        return (slot1Version > slot0Version);
    }
    else
    {
        debug_printf("both slot 0 and slot 1 app are invalid.\r\n");
        update_reliable_update_status(kStatus_ReliableUpdateInacive);
        g_bootloaderContext.imageStart = 0xffffffffu;
        return false;
    }
}

// Determine if the application is valid.
static bool is_specified_application_valid(uint32_t applicationBase, uint16_t *applicationVersion)
{
    bool result = false;
    crc_checksum_header_t header;
    uint32_t crcChecksumBase;

    tota_app_header_t *appHeader = (tota_app_header_t *)applicationBase;
    appliation_header_t *pAppHeader = (appliation_header_t *)applicationBase;
    
    if (kAppAuthType_Magic == appHeader->authType)
    {
        result = (APP_MAGIC == appHeader->authResult);
        *applicationVersion = appHeader->version;
    }
    else if ((kAppAuthType_NonxipCRC32 == appHeader->authType) || (kAppAuthType_XipCRC32 == appHeader->authType))
    {
        header.tag = kPropertyStoreTag;
        header.crcStartAddress = applicationBase;
        header.crcByteCount = appHeader->length;
        header.crcExpectedValue = appHeader->authResult;
        
        crcChecksumBase = applicationBase + (uint32_t)(&appHeader->authResult) - (uint32_t)(&appHeader->reserved0[0]);
        uint32_t calculatedCrc = calculate_application_crc32(&header, crcChecksumBase);
        if (calculatedCrc == header.crcExpectedValue)
        {
            if (is_valid_application_location(pAppHeader->applicationPointer))
            {
                result =  true;
                *applicationVersion = appHeader->version;
            }
        }
    }
    
    return result;
}

static uint8_t s_nor_page_buffer[256];

//! @brief Copy source appliction to destination application region and return result
static bool get_result_after_copying_application(uint32_t src, uint32_t dst, uint32_t len)
{
    bool updateResult = true;
    status_t status;
    
    debug_printf("Copying slot 1 app to slot 0 address.\r\n");
    
    serial_nor_config_option_t option;
    option.option0.U = 0xc0000005;
    option.option1.U = 0x0;
    debug_printf("Initing FlexSPI controller using %x.\r\n", option.option0.U);
    status = flexspi_nor_mem_config((void *)(&option));
    if (kStatus_Success != status)
    {
        return false;
    }

    // Erase the destination application region
    status = flexspi_nor_mem_erase(dst, len);
    if (kStatus_Success != status)
    {
        updateResult = false;
    }
    else
    {
        uint32_t writeSize;
        uint32_t bufferSize = sizeof(s_nor_page_buffer);
        // Copy the source application to destination application region.
        while (len)
        {
            if (len >= bufferSize)
            {
                writeSize = bufferSize;
            }
            else
            {
                writeSize = len;
            }
            memcpy(s_nor_page_buffer, (uint8_t *)src, writeSize);
            status = flexspi_nor_mem_write(dst, writeSize, (uint8_t *)&s_nor_page_buffer[0]);
            if (kStatus_Success != status)
            {
                updateResult = false;
                break;
            }
            else
            {
                src += writeSize;
                dst += writeSize;
                len -= writeSize;
            }
        } // while(len)
        if (kStatus_Success == status)
        {
            status = flexspi_nor_mem_flush();
            if (kStatus_Success != status)
            {
                updateResult = false;
            }
        }
    }
    return updateResult;
}

// Execute software reliable update
// There are 4 steps needed to complete the reliable update process:
//      1. Erase the application region
//      2. Copy the back applcation to the applicaion region
//      3. Do integrity check for the copied application
status_t software_reliable_update(uint32_t applicationBase)
{
    bool updateResult = true;
    uint32_t applicationSizeInByte;
    uint16_t dummy;

    tota_app_header_t *appHeader = (tota_app_header_t *)applicationBase;
    uint32_t slot0ApplicationBase = get_application_base(kSpecifiedApplicationType_Slot0);

    // Get actual length to be erased.
    applicationSizeInByte = appHeader->length;

    // Copy the Backup Application to Main Appliction region
    updateResult =
        get_result_after_copying_application(applicationBase, slot0ApplicationBase, applicationSizeInByte);

    // Erase the Backup Application region
    if (updateResult)
    {
        if (!is_specified_application_valid(slot0ApplicationBase, &dummy))
        {
            updateResult = false;
        }
    }     // if (updateResult)

    return (updateResult) ? kStatus_ReliableUpdateSuccess : kStatus_ReliableUpdateFail;
}

#endif // BL_FEATURE_RELIABLE_UPDATE
