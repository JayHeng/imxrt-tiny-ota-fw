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
#include "flash/fsl_flash.h"
#include "memory/memory.h"
#include "crc/crc32.h"
#include "utilities/fsl_assert.h"

#if BL_FEATURE_RELIABLE_UPDATE

////////////////////////////////////////////////////////////////////////////////
// Definitions
////////////////////////////////////////////////////////////////////////////////

#if (BL_BACKUP_APP_START & (FSL_FEATURE_FLASH_PFLASH_BLOCK_SECTOR_SIZE - 1))
#error "The backup application start address must be sector-aligned!"
#endif

// image header for Cortex-M series
typedef struct
{
    uint32_t stackPointer;
    uint32_t applicationPointer;
} appliation_header_t;

////////////////////////////////////////////////////////////////////////////////
// Prototypes
////////////////////////////////////////////////////////////////////////////////
//! @brief Determine if the reliable update feature is active.
static bool is_reliable_update_active(uint32_t backupApplicationBase);

//! @brief Determine if the specified application is valid
static bool is_specified_application_valid(uint32_t applicationBase);

//! @brief Update the property of reliable update status
static void update_reliable_update_status(uint32_t status);

//! @brief Get the start address of specified application
static uint32_t get_application_base(specified_application_type_t applicationType);

//! @brief Get the base address of Bootloader Config Area
static uint32_t get_bootloader_config_area_base(uint32_t applicationBase);

//! @brief Get the maxmimum backup application size.
static uint32_t get_max_backup_app_size(uint32_t address);

//! @brief Do software reliable application update if backup application is valid
static status_t software_reliable_update(uint32_t backupApplicationBase);

//! @brief Copy source appliction to destination application region and return result
static bool get_result_after_copying_application(uint32_t src, uint32_t dst, uint32_t len);

////////////////////////////////////////////////////////////////////////////////
// Code
////////////////////////////////////////////////////////////////////////////////

// See bl_reliable_update.h for documents on this function.
void bootloader_reliable_update_as_requested(reliable_update_option_t option, uint32_t address)
{
    // For software implementation, the option doesn't take effect, It always be kReliableUpdateOption_Swap.
    // For hardware implementation, the option works properly
    uint32_t backupApplicationBase;
    backupApplicationBase = (address == 0) ? get_application_base(kSpecifiedApplicationType_Backup) : address;

    // Below implementaion is for both kReliableUpdateOption_Normal and kReliableUpdateOption_Swap
    if (!is_reliable_update_active(backupApplicationBase))
    {
        update_reliable_update_status(kStatus_ReliableUpdateInacive);
    }
    else
    {
        if (is_specified_application_valid(backupApplicationBase))
        {
            status_t status = software_reliable_update(backupApplicationBase);
            update_reliable_update_status(status);
        }
        else
        {
            update_reliable_update_status(kStatus_ReliableUpdateBackupApplicationInvalid);
        }
    }
}

//! @brief Get the maxmimum backup application size.
static uint32_t get_max_backup_app_size(uint32_t address)
{
#if BL_TARGET_ROM
    return (g_bootloaderContext.flashState.PFlashTotalSize >> 1);
#elif BL_TARGET_FLASH
    int32_t maxAppSize;
    int32_t maxBackupAppSize;

    maxAppSize = address - get_application_base(kSpecifiedApplicationType_Main);
    maxBackupAppSize =
        g_bootloaderContext.flashState.PFlashBlockBase + g_bootloaderContext.flashState.PFlashTotalSize - address;

    maxAppSize = ALIGN_DOWN(maxAppSize, g_bootloaderContext.flashState.PFlashSectorSize);
    maxBackupAppSize = ALIGN_UP(maxBackupAppSize, g_bootloaderContext.flashState.PFlashSectorSize);

    assert((maxAppSize > 0) && (maxBackupAppSize > 0));

    return (uint32_t)MIN(maxAppSize, maxBackupAppSize);
#else
#error "This Bootloader type is NOT supported!"
#endif
}

//! @brief Get the start address of specified application
static uint32_t get_application_base(specified_application_type_t applicationType)
{
    if (applicationType == kSpecifiedApplicationType_Main)
    {
#if BL_TARGET_ROM
        return g_bootloaderContext.flashState.PFlashBlockBase;
#elif BL_TARGET_FLASH
        return BL_APP_VECTOR_TABLE_ADDRESS;
#else
#error "This Bootloader type is NOT supported!"
#endif
    }
    else if (applicationType == kSpecifiedApplicationType_Backup)
    {
#if BL_TARGET_ROM
        return g_bootloaderContext.flashState.PFlashBlockBase + (g_bootloaderContext.flashState.PFlashTotalSize >> 1);
#elif BL_TARGET_FLASH
        return BL_BACKUP_APP_START;
#else
#error "This Bootloader type is NOT supported!"
#endif
    }

    return 0;
}

//! @brief Get the base address of Bootloader Config Area
static uint32_t get_bootloader_config_area_base(uint32_t applicationBase)
{
    return (applicationBase + 0x3c0);
}

// Determine if the reliable update feature is active
// Note : the reliable update feature is active only when following conditions are met:
//        1. the backup application is valid
//        2. the BCA is enabled.
static bool is_reliable_update_active(uint32_t backupApplicationBase)
{
    // The reliable udpate feature is active only when  and the BCA is enabled.
    uint32_t backupCrcChecksumBase = get_bootloader_config_area_base(backupApplicationBase);
    crc_checksum_header_t *pchecksumHeader = (crc_checksum_header_t *)backupCrcChecksumBase;
    appliation_header_t *pAppHeader = (appliation_header_t *)backupApplicationBase;

    if (is_valid_application_location(pAppHeader->applicationPointer) && (kPropertyStoreTag == pchecksumHeader->tag))
    {
        return true;
    }
    else
    {
        return false;
    }
}

// Update the status for reliable update
static void update_reliable_update_status(uint32_t status)
{
    property_store_t *propertyStore = g_bootloaderContext.propertyInterface->store;
    propertyStore->reliableUpdateStatus = status;
}

// Determine if the application is valid.
// Note: the applicaiton is valid only if following conditions are met:
//       1. (backup image only)crcByteCount <= backup app start - BL_APP_VECTOR_TABLE_ADDRESS -
//       sizeof(header.expectedCrcValue).
//       2. crcStartAddress = BL_APP_VECTOR_TABLE_ADDRESS
//       3. The calculated crc checksum = expectedCrcValue
static bool is_specified_application_valid(uint32_t applicationBase)
{
    crc_checksum_header_t header;
    uint32_t crcChecksumBase = get_bootloader_config_area_base(applicationBase);
    uint32_t mainApplicationBase = get_application_base(kSpecifiedApplicationType_Main);

    memcpy(&header, (void *)crcChecksumBase, sizeof(header));

    // The size of the backup image must be less than or equal to maximumn reserved backup application space
    if (applicationBase != mainApplicationBase)
    {
        uint32_t maxBackupAppSize = get_max_backup_app_size(applicationBase);
        int32_t backupAppSize = header.crcByteCount;
        if (backupAppSize > maxBackupAppSize)
        {
            return false;
        }
    }
    // crcStartAddress must be BL_BACKUP_APP_START, and calculated crc checksum must be expectedCrcValue
    if (header.crcStartAddress != mainApplicationBase)
    {
        return false;
    }
    else
    {
        header.crcStartAddress = applicationBase;

        uint32_t calculatedCrc = calculate_application_crc32(&header, crcChecksumBase);
        if (calculatedCrc != header.crcExpectedValue)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
}

//! @brief Copy source appliction to destination application region and return result
static bool get_result_after_copying_application(uint32_t src, uint32_t dst, uint32_t len)
{
    bool updateResult = true;
    status_t status;

    // Erase the destination application region
    status = mem_erase(dst, len);
    if (kStatus_Success != status)
    {
        updateResult = false;
    }
    else
    {
        uint32_t copyBuffer[8]; // Bufer used to hold the data to be written.
        uint32_t writeSize;
        uint32_t bufferSize = sizeof(copyBuffer);
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
            memcpy(copyBuffer, (uint8_t *)src, writeSize);
            status = mem_write(dst, writeSize, (uint8_t *)&copyBuffer[0]);
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
    }
    return updateResult;
}

// Execute software reliable update
// There are 4 steps needed to complete the reliable update process:
//      1. Erase the application region
//      2. Copy the back applcation to the applicaion region
//      3. Do integrity check for the copied application
//      4. Erase the backup application
status_t software_reliable_update(uint32_t backupApplicationBase)
{
    bool updateResult = true;
    uint32_t applicationSizeInByte;

    uint32_t backupCrcChecksumBase = get_bootloader_config_area_base(backupApplicationBase);
    uint32_t mainApplicationBase = get_application_base(kSpecifiedApplicationType_Main);

    // Get actual length to be erased.
    crc_checksum_header_t header;
    memcpy(&header, (uint8_t *)backupCrcChecksumBase, sizeof(header));
    header.crcStartAddress = backupApplicationBase;

    applicationSizeInByte = header.crcByteCount;
    applicationSizeInByte = ALIGN_UP(applicationSizeInByte, g_bootloaderContext.flashState.PFlashSectorSize);

    // Copy the Backup Application to Main Appliction region
    updateResult =
        get_result_after_copying_application(backupApplicationBase, mainApplicationBase, applicationSizeInByte);

    // Erase the Backup Application region
    if (updateResult)
    {
        // Reload the user configuration data so that we can validate if the updated application is valid
        g_bootloaderContext.propertyInterface->load_user_config();

        if (!is_application_crc_check_pass())
        {
            updateResult = false;
        }
        else
        {
            status_t status = mem_erase(backupApplicationBase, applicationSizeInByte);
            if (kStatus_Success != status)
            {
                updateResult = false;
            }
        } // if (!is_application_crc_check_pass())
    }     // if (updateResult)

    return (updateResult) ? kStatus_ReliableUpdateSuccess : kStatus_ReliableUpdateFail;
}

#endif // BL_FEATURE_RELIABLE_UPDATE
