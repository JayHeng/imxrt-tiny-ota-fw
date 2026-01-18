/*
 * Copyright 2021-2024 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */

#ifndef _TOTA_FUNC_H_
#define _TOTA_FUNC_H_

#include "fsl_device_registers.h"
#include "fsl_debug_console.h"
#include "fsl_common.h"

/*******************************************************************************
 * Definitions
 ******************************************************************************/

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

typedef enum _specified_application_type
{
    kSpecifiedApplicationType_Slot0 = 0x0U,
    kSpecifiedApplicationType_Slot1 = 0x1U,
} specified_application_type_t;

#if defined(__cplusplus)
extern "C" {
#endif /* __cplusplus */

/*******************************************************************************
 * API
 ******************************************************************************/

void tota_app_ehco(void);

uint32_t tota_get_app_base(specified_application_type_t applicationType);

#if defined(__cplusplus)
}
#endif /* __cplusplus */

#endif /* _TOTA_FUNC_H_ */
