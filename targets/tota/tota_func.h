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

#if defined(__cplusplus)
extern "C" {
#endif /* __cplusplus */

/*******************************************************************************
 * API
 ******************************************************************************/

void tota_app_ehco(void);

#if defined(__cplusplus)
}
#endif /* __cplusplus */

#endif /* _TOTA_FUNC_H_ */
