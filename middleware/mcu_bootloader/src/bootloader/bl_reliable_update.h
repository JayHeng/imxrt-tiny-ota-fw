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
#ifndef __BL_RELIABLE_UPDATE_H__
#define __BL_RELIABLE_UPDATE_H__

#include <stdbool.h>
#include <stdint.h>
#include "property/property.h"

//! @addtogroup reliable_update
//! @{

////////////////////////////////////////////////////////////////////////////////
// Declarations
////////////////////////////////////////////////////////////////////////////////

#define SBL_MAGIC (0x4C425354) //'TSBL'

typedef struct _tota_sbl_header
{
    uint32_t reserved0[8];
    uint32_t slot0StartAddr;
    uint32_t slot1StartAddr;
    uint32_t appLoadAddr;
    uint32_t reserved1[2];
    uint32_t magic;
} tota_sbl_header_t;

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

typedef enum _reliable_update_option
{
    kReliableUpdateOption_Normal = 0x0U, //!< Normal option, Update main appliction only if it is invalid
    kReliableUpdateOption_Swap = 0x1U,   //!< Swap option, Always update main appliction
} reliable_update_option_t;

typedef enum _specified_application_type
{
    kSpecifiedApplicationType_Slot0 = 0x0U,
    kSpecifiedApplicationType_Slot1 = 0x1U,
} specified_application_type_t;

//! @brief Application crc check status codes.
enum _reliable_update_status
{
    kStatus_ReliableUpdateSuccess = MAKE_STATUS(kStatusGroup_ReliableUpdate, 0), //!< Reliable Update succeeded.
    kStatus_ReliableUpdateFail = MAKE_STATUS(kStatusGroup_ReliableUpdate, 1),    //!< Reliable Update failed.
    kStatus_ReliableUpdateInacive =
        MAKE_STATUS(kStatusGroup_ReliableUpdate, 2), //!< Reliable Update Feature is inactive.
    kStatus_ReliableUpdateBackupApplicationInvalid =
        MAKE_STATUS(kStatusGroup_ReliableUpdate, 3), //!< Backup Application is invalid
    kStatus_ReliableUpdateStillInMainApplication =
        MAKE_STATUS(kStatusGroup_ReliableUpdate, 4), //!< Next boot will be still in Main Application

    kStatus_ReliableUpdateSwapTest = MAKE_STATUS(kStatusGroup_ReliableUpdate, 5), //!< Reliable Update succeeded.
};

////////////////////////////////////////////////////////////////////////////////
// Prototypes
////////////////////////////////////////////////////////////////////////////////

#if __cplusplus
extern "C" {
#endif

void bootloader_reliable_update_as_requested(reliable_update_option_t option, uint32_t address);
//@}

#if __cplusplus
}
#endif

//! @}

#endif // __BL_RELIABLE_UPDATE_H__
