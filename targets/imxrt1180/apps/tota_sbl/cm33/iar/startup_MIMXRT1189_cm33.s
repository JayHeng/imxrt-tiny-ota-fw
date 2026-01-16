; -------------------------------------------------------------------------
;  @file:    startup_MIMXRT1189_cm33.s
;  @purpose: CMSIS Cortex-M33 Core Device Startup File
;            MIMXRT1189_cm33
;  @version: 0.1
;  @date:    2021-3-9
;  @build:   b231213
; -------------------------------------------------------------------------
;
; Copyright 1997-2016 Freescale Semiconductor, Inc.
; Copyright 2016-2023 NXP
; SPDX-License-Identifier: BSD-3-Clause
;
; The modules in this file are included in the libraries, and may be replaced
; by any user-defined modules that define the PUBLIC symbol _program_start or
; a user defined start symbol.
; To override the cstartup defined in the library, simply add your modified
; version to the workbench project.
;
; The vector table is normally located at address 0.
; When debugging in RAM, it can be located in RAM, aligned to at least 2^6.
; The name "__vector_table" has special meaning for C-SPY:
; it is where the SP start value is found, and the NVIC vector
; table register (VTOR) is initialized to this address if != 0.
;
; Cortex-M version
;

        MODULE  ?cstartup

        ;; Forward declaration of sections.
        SECTION CSTACK:DATA:NOROOT(3)
        SECTION HEAP:DATA:NOROOT(3)
        SECTION RW:DATA:NOROOT(2)
        SECTION QACCESS_CODE_VAR:DATA:NOROOT(3)
        SECTION QACCESS_DATA_VAR:DATA:NOROOT(3)

        SECTION .intvec:CODE:NOROOT(2)

        EXTERN  __iar_program_start
        EXTERN  SystemInit
        PUBLIC  __vector_table
        PUBLIC  __vector_table_0x1c
        PUBLIC  __Vectors
        PUBLIC  __Vectors_End
        PUBLIC  __Vectors_Size

        DATA

__vector_table
        DCD     sfe(CSTACK)
        DCD     Reset_Handler

        DCD     Empty_Handler                                   ;NMI Handler
        DCD     Empty_Handler                             ;Hard Fault Handler
        DCD     Empty_Handler                             ;MPU Fault Handler
        DCD     Empty_Handler                              ;Bus Fault Handler
        DCD     Empty_Handler                            ;Usage Fault Handler
__vector_table_0x1c
        DCD     Empty_Handler                           ;Secure Fault Handler
        DCD     0x00080000                                             ;Reserved
        DCD     0x00100000                                             ;Reserved
        DCD     0                                             ;Reserved
        DCD     Empty_Handler                                   ;SVCall Handler
        DCD     Empty_Handler                              ;Debug Monitor Handler
        DCD     0x4C425354                                             ;Reserved
        DCD     Empty_Handler                                ;PendSV Handler
        DCD     Empty_Handler                               ;SysTick Handler

                                                              ;External Interrupts
        DCD     Empty_Handler                               ;TMR1 interrupt
        DCD     Empty_Handler                                ;DAP interrupt
        DCD     Empty_Handler              ;CTI trigger outputs from CM7
        DCD     Empty_Handler             ;CTI trigger outputs from CM33
        DCD     Empty_Handler                               ;TMR5 interrupt
        DCD     Empty_Handler                               ;TMR6 interrupt
        DCD     Empty_Handler                               ;TMR7 interrupt
        DCD     Empty_Handler                               ;TMR8 interrupt
        DCD     Empty_Handler                               ;CAN1 interrupt
        DCD     Empty_Handler                         ;CAN1 error interrupt
        DCD     Empty_Handler                            ;GPIO1 interrupt 0
        DCD     Empty_Handler                            ;GPIO1 interrupt 1
        DCD     Empty_Handler                               ;I3C1 interrupt
        DCD     Empty_Handler                             ;LPI2C1 interrupt
        DCD     Empty_Handler                             ;LPI2C2 interrupt
        DCD     Empty_Handler                              ;LPIT1 interrupt
        DCD     Empty_Handler                             ;LPSPI1 interrupt
        DCD     Empty_Handler                             ;LPSPI2 interrupt
        DCD     Empty_Handler                             ;LPTMR1 interrupt
        DCD     Empty_Handler                            ;LPUART1 interrupt
        DCD     Empty_Handler                            ;LPUART2 interrupt
        DCD     Empty_Handler                                ;MU1 interrupt
        DCD     Empty_Handler                                ;MU2 interrupt
        DCD     Empty_Handler                         ;PWM1 fault or reload error interrupt
        DCD     Empty_Handler                             ;PWM1 capture 0, compare 0, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM1 capture 1, compare 1, or reload 1 interrupt
        DCD     Empty_Handler                             ;PWM1 capture 2, compare 2, or reload 2 interrupt
        DCD     Empty_Handler                             ;PWM1 capture 3, compare 3, or reload 3 interrupt
        DCD     Empty_Handler         ;Edgelock Trust MUA RX full interrupt
        DCD     Empty_Handler        ;Edgelock Trust MUA TX empty interrupt
        DCD     Empty_Handler     ;Edgelock Apps Core MUA RX full interrupt
        DCD     Empty_Handler    ;Edgelock Apps Core MUA TX empty interrupt
        DCD     Empty_Handler    ;Edgelock Realtime Core MUA RX full interrupt
        DCD     Empty_Handler    ;Edgelock Realtime Core MUA TX empty interrupt
        DCD     Empty_Handler                    ;Edgelock secure interrupt
        DCD     Empty_Handler                 ;Edgelock non-secure interrupt
        DCD     Empty_Handler                               ;TPM1 interrupt
        DCD     Empty_Handler                               ;TPM2 interrupt
        DCD     Empty_Handler                            ;RTWDOG1 interrupt
        DCD     Empty_Handler                            ;RTWDOG2 interrupt
        DCD     Empty_Handler                       ;AONMIX TRDC transfer error interrupt
        DCD     Empty_Handler                    ;HWVAD event interrupt
        DCD     Empty_Handler                    ;HWVAD error interrupt
        DCD     Empty_Handler                          ;PDM event interrupt
        DCD     Empty_Handler                          ;PDM error interrupt
        DCD     Empty_Handler                               ;SAI interrupt
        DCD     Empty_Handler                            ;M33 PS Tag/Data Parity Error
        DCD     Empty_Handler                       ;M33 TCM ECC interrupt
        DCD     Empty_Handler                     ;M33 TCM Error interrupt
        DCD     Empty_Handler                        ;M7 TCM ECC interrupt
        DCD     Empty_Handler                      ;M7 TCM Error interrupt
        DCD     Empty_Handler                               ;CAN2 interrupt
        DCD     Empty_Handler                         ;CAN2 error interrupt
        DCD     Empty_Handler                            ;FLEXIO1 interrupt
        DCD     Empty_Handler                            ;FLEXIO2 interrupt
        DCD     Empty_Handler                           ;FLEXSPI1 interrupt
        DCD     Empty_Handler                           ;FLEXSPI2 interrupt
        DCD     Empty_Handler                            ;GPIO2 interrupt 0
        DCD     Empty_Handler                            ;GPIO2 interrupt 1
        DCD     Empty_Handler                            ;GPIO3 interrupt 0
        DCD     Empty_Handler                            ;GPIO3 interrupt 1
        DCD     Empty_Handler                               ;I3C2 interrupt
        DCD     Empty_Handler                             ;LPI2C3 interrupt
        DCD     Empty_Handler                             ;LPI2C4 interrput
        DCD     Empty_Handler                              ;LPIT2 interrupt
        DCD     Empty_Handler                             ;LPSPI3 interrupt
        DCD     Empty_Handler                             ;LPSPI4 interrupt
        DCD     Empty_Handler                             ;LPTMR2 interrupt
        DCD     Empty_Handler                            ;LPUART3 interrupt
        DCD     Empty_Handler                            ;LPUART4 interrupt
        DCD     Empty_Handler                            ;LPUART5 interrupt
        DCD     Empty_Handler                            ;LPUART6 interrupt
        DCD     Empty_Handler                         ;Reserved interrupt 88
        DCD     Empty_Handler                              ;BBNSM iterrupt
        DCD     Empty_Handler                           ;System Counter compare interrupt 0 and 1
        DCD     Empty_Handler                               ;TPM3 interrupt
        DCD     Empty_Handler                               ;TPM4 interrupt
        DCD     Empty_Handler                               ;TPM5 interrupt
        DCD     Empty_Handler                               ;TPM6 interrupt
        DCD     Empty_Handler                            ;RTWDOG3 interrupt
        DCD     Empty_Handler                            ;RTWDOG4 interrupt
        DCD     Empty_Handler                            ;RTWDOG5 interrupt
        DCD     Empty_Handler                      ;WAKEUPMIX TRDC transfer error interrupt
        DCD     Empty_Handler                         ;Temperature alarm interrupt
        DCD     Empty_Handler                               ;BBSM wakeup alarm interrupt
        DCD     Empty_Handler                        ;Brown out interrupt
        DCD     Empty_Handler                             ;USDHC1
        DCD     Empty_Handler                             ;USDHC2
        DCD     Empty_Handler                      ;MEGAMIX TRDC transfer error interrupt
        DCD     Empty_Handler                                ;Signal Frequency Analyzer interrupt
        DCD     Empty_Handler                        ;Brown out interrupt
        DCD     Empty_Handler                              ;MECC1 interrupt
        DCD     Empty_Handler                              ;MECC2 interrupt
        DCD     Empty_Handler                               ;ADC1 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA error interrupt
        DCD     Empty_Handler                           ;AON Domain eDMA channel 0 interrupt
        DCD     Empty_Handler                           ;AON Domain eDMA channel 1 interrupt
        DCD     Empty_Handler                           ;AON Domain eDMA channel 2 interrupt
        DCD     Empty_Handler                           ;AON Domain eDMA channel 3 interrupt
        DCD     Empty_Handler                           ;AON Domain eDMA channel 4 interrupt
        DCD     Empty_Handler                           ;AON Domain eDMA channel 5 interrupt
        DCD     Empty_Handler                           ;AON Domain eDMA channel 6 interrupt
        DCD     Empty_Handler                           ;AON Domain eDMA channel 7 interrupt
        DCD     Empty_Handler                           ;AON Domain eDMA channel 8 interrupt
        DCD     Empty_Handler                           ;AON Domain eDMA channel 9 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 10 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 11 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 12 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 13 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 14 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 15 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 16 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 17 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 18 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 19 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 20 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 21 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 22 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 23 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 24 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 25 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 26 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 27 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 28 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 29 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 30 interrupt
        DCD     Empty_Handler                          ;AON Domain eDMA channel 31 interrupt
        DCD     Empty_Handler                         ;WAKEUP Domain eDMA error interrupt
        DCD     Empty_Handler             ;WAKEUP Domain eDMA channel 0/1/32/33 interrupt
        DCD     Empty_Handler             ;WAKEUP Domain eDMA channel 2/3/34/35 interrupt
        DCD     Empty_Handler             ;WAKEUP Domain eDMA channel 4/5/36/37 interrupt
        DCD     Empty_Handler             ;WAKEUP Domain eDMA channel 6/7/38/39 interrupt
        DCD     Empty_Handler             ;WAKEUP Domain eDMA channel 8/9/40/41 interrupt
        DCD     Empty_Handler           ;WAKEUP Domain eDMA channel 10/11/42/43 interrupt
        DCD     Empty_Handler           ;WAKEUP Domain eDMA channel 12/13/44/45 interrupt
        DCD     Empty_Handler           ;WAKEUP Domain eDMA channel 14/15/46/47 interrupt
        DCD     Empty_Handler           ;WAKEUP Domain eDMA channel 16/17/48/49 interrupt
        DCD     Empty_Handler           ;WAKEUP Domain eDMA channel 18/19/50/51 interrupt
        DCD     Empty_Handler           ;WAKEUP Domain eDMA channel 20/21/52/53 interrupt
        DCD     Empty_Handler           ;WAKEUP Domain eDMA channel 22/23/54/55 interrupt
        DCD     Empty_Handler           ;WAKEUP Domain eDMA channel 24/25/56/57 interrupt
        DCD     Empty_Handler           ;WAKEUP Domain eDMA channel 26/27/58/59 interrupt
        DCD     Empty_Handler           ;WAKEUP Domain eDMA channel 28/29/60/61 interrupt
        DCD     Empty_Handler           ;WAKEUP Domain eDMA channel 30/31/62/63 interrupt
        DCD     Empty_Handler                      ;XBAR1 channel 0/1 interrupt
        DCD     Empty_Handler                      ;XBAR1 channel 2/3 interrupt
        DCD     Empty_Handler              ;SINC Filter Glue 3 channel 0/1/2/3
        DCD     Empty_Handler                                ;EWM reset out interrupt
        DCD     Empty_Handler                               ;SEMC interrupt
        DCD     Empty_Handler                              ;LPIT3 interrupt
        DCD     Empty_Handler                             ;LPTMR3 interrupt
        DCD     Empty_Handler                               ;TMR4 interrupt
        DCD     Empty_Handler                             ;LPI2C5 interrupt
        DCD     Empty_Handler                             ;LPI2C6 interrupt
        DCD     Empty_Handler                               ;SAI4 interrupt
        DCD     Empty_Handler                              ;SPDIF interrupt
        DCD     Empty_Handler                            ;LPUART9 interrupt
        DCD     Empty_Handler                           ;LPUART10 interrupt
        DCD     Empty_Handler                           ;LPUART11 interrupt
        DCD     Empty_Handler                           ;LPUART12 interrupt
        DCD     Empty_Handler            ;CM33, CM7, DAP access IRQ
        DCD     Empty_Handler                      ;Edgelock reuqest 1 interrupt
        DCD     Empty_Handler                      ;Edgelock reuqest 2 interrupt
        DCD     Empty_Handler                      ;Edgelock reuqest 3 interrupt
        DCD     Empty_Handler                               ;TMR3 interrupt
        DCD     Empty_Handler                              ;JTAGC SRC reset source
        DCD     Empty_Handler                   ;CM33 SYSREQRST SRC reset source
        DCD     Empty_Handler                         ;CM33 LOCKUP SRC reset source
        DCD     Empty_Handler                    ;CM33 SYSREQRST SRC reset source
        DCD     Empty_Handler                          ;CM33 LOCKUP SRC reset source
        DCD     Empty_Handler                         ;PWM2 fault or reload error interrupt
        DCD     Empty_Handler                             ;PWM2 capture 0, compare 0, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM2 capture 1, compare 1, or reload 1 interrupt
        DCD     Empty_Handler                             ;PWM2 capture 2, compare 2, or reload 2 interrupt
        DCD     Empty_Handler                             ;PWM2 capture 3, compare 3, or reload 3 interrupt
        DCD     Empty_Handler                         ;PWM3 fault or reload error interrupt
        DCD     Empty_Handler                             ;PWM3 capture 0, compare 0, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM3 capture 1, compare 1, or reload 1 interrupt
        DCD     Empty_Handler                             ;PWM3 capture 2, compare 2, or reload 2 interrupt
        DCD     Empty_Handler                             ;PWM3 capture 3, compare 3, or reload 3 interrupt
        DCD     Empty_Handler                         ;PWM4 fault or reload error interrupt
        DCD     Empty_Handler                             ;PWM4 capture 0, compare 0, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM4 capture 1, compare 1, or reload 1 interrupt
        DCD     Empty_Handler                             ;PWM4 capture 2, compare 2, or reload 2 interrupt
        DCD     Empty_Handler                             ;PWM4 capture 3, compare 3, or reload 3 interrupt
        DCD     Empty_Handler                              ;EQDC1 interrupt
        DCD     Empty_Handler                              ;EQDC2 interrupt
        DCD     Empty_Handler                              ;EQDC3 interrupt
        DCD     Empty_Handler                              ;EQDC4 interrupt
        DCD     Empty_Handler                               ;ADC2 interrupt
        DCD     Empty_Handler                               ;DCDC brown out interrupt
        DCD     Empty_Handler                               ;CAN3 interrupt
        DCD     Empty_Handler                         ;CAN3 error interrupt
        DCD     Empty_Handler                                ;DAC interrupt
        DCD     Empty_Handler                             ;LPSPI5 interrupt
        DCD     Empty_Handler                             ;LPSPI6 interrupt
        DCD     Empty_Handler                            ;LPUART7 interrupt
        DCD     Empty_Handler                            ;LPUART8 interrupt
        DCD     Empty_Handler                               ;SAI2 interrupt
        DCD     Empty_Handler                               ;SAI3 interrupt
        DCD     Empty_Handler                              ;CMP1 interrupt
        DCD     Empty_Handler                              ;CMP2 interrupt
        DCD     Empty_Handler                              ;CMP3 interrupt
        DCD     Empty_Handler                              ;CMP4 interrupt
        DCD     Empty_Handler                             ;M7 PS Tag/Data Parity Error
        DCD     Empty_Handler                            ;M7 MCM interrupt
        DCD     Empty_Handler                           ;M33 MCM interrupt
        DCD     Empty_Handler                           ;EtherCAT interrupt
        DCD     Empty_Handler                     ;Safety clock monitor interrupt
        DCD     Empty_Handler                               ;GPT1 interrupt
        DCD     Empty_Handler                               ;GPT2 interrupt
        DCD     Empty_Handler                                ;KPP interrupt
        DCD     Empty_Handler                            ;USBPHY1 interrupt
        DCD     Empty_Handler                            ;USBPHY2 interrupt
        DCD     Empty_Handler                           ;USBOTG2 interrupt
        DCD     Empty_Handler                           ;USBOTG1 interrupt
        DCD     Empty_Handler                        ;FLEXSPI follower interrupt
        DCD     Empty_Handler                               ;NETC interrupt
        DCD     Empty_Handler                           ;MSGINTR1 interrupt
        DCD     Empty_Handler                           ;MSGINTR2 interrupt
        DCD     Empty_Handler                           ;MSGINTR3 interrupt
        DCD     Empty_Handler                           ;MSGINTR4 interrupt
        DCD     Empty_Handler                           ;MSGINTR5 interrupt
        DCD     Empty_Handler                           ;MSGINTR6 interrupt
        DCD     Empty_Handler                          ;SINC Filter Glue 1 channel 0
        DCD     Empty_Handler                          ;SINC Filter Glue 1 channel 1
        DCD     Empty_Handler                          ;SINC Filter Glue 1 channel 2
        DCD     Empty_Handler                          ;SINC Filter Glue 1 channel 3
        DCD     Empty_Handler                          ;SINC Filter Glue 2 channel 0
        DCD     Empty_Handler                          ;SINC Filter Glue 2 channel 1
        DCD     Empty_Handler                          ;SINC Filter Glue 2 channel 2
        DCD     Empty_Handler                          ;SINC Filter Glue 2 channel 3
        DCD     Empty_Handler                              ;GPIO4 interrupt
        DCD     Empty_Handler                               ;TMR2 interrupt
        DCD     Empty_Handler                              ;GPIO5 interrupt
        DCD     Empty_Handler                               ;ASRC interrupt
        DCD     Empty_Handler                              ;GPIO6 interrupt
        DCD     Empty_Handler                          ;JTAGSW DAP MDM-AP SRC reset source
        DCD     Empty_Handler                       ;ECAT reset out interrupt
        DCD     Empty_Handler                                    ;255
__Vectors_End

__Vectors       EQU   __vector_table
__Vectors_Size  EQU   __Vectors_End - __Vectors


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Default interrupt handlers.
;;
        THUMB

        PUBWEAK Reset_Handler
        SECTION .text:CODE:REORDER:NOROOT(2)
Reset_Handler
        CPSID   I               ; Mask interrupts
        LDR     R0, =0xE000ED08
        LDR     R1, =__vector_table
        STR     R1, [R0]
        LDR     R2, [R1]
        MSR     MSP, R2
        LDR     R0, =sfb(CSTACK)
        MSR     MSPLIM, R0
        LDR     R0, =SystemInit
        BLX     R0
;
; Add RW / stack / heap initializaiton
; TCM controller must perform a read-modify-write for any access < 32-bit to keep the ECC updated.
; The Software must ensure the TCM is ECC clean by initializing all memories that have the potential to be accessed as < 32-bit.
        MOV    R0, #0
        LDR    R1, =SFB(RW)
        LDR    R2, =SFE(RW)
.LC2:
        CMP    R1, R2
        ITT    LT
        STRLT  R0, [R1], #4
        BLT    .LC2

        MOV    R0, #0
        LDR    R1, =SFB(HEAP)
        LDR    R2, =SFE(HEAP)
.LC3:
        CMP    R1, R2
        ITT    LT
        STRLT  R0, [R1], #4
        BLT    .LC3

        LDR     R1, =SFB(CSTACK)
        LDR     R2, =SFE(CSTACK)
.LC4:
        CMP     R1, R2
        ITT     LT
        STRLT   R0, [R1], #4
        BLT     .LC4

#if defined(FSL_SDK_DRIVER_QUICK_ACCESS_ENABLE) && FSL_SDK_DRIVER_QUICK_ACCESS_ENABLE
        LDR     R1, =SFB(QACCESS_CODE_VAR)
        LDR     R2, =SFE(QACCESS_CODE_VAR)
.LC5:
        CMP     R1, R2
        ITT     LT
        STRLT   R0, [R1], #4
        BLT     .LC5

        LDR     R1, =SFB(QACCESS_DATA_VAR)
        LDR     R2, =SFE(QACCESS_DATA_VAR)
.LC6:
        CMP     R1, R2
        ITT     LT
        STRLT   R0, [R1], #4
        BLT     .LC6
#endif

; End RW / stack / heap initialization

        CPSIE   I               ; Unmask interrupts
        LDR     R0, =__iar_program_start
        BX      R0

        PUBLIC Empty_Handler
        SECTION .text:CODE:REORDER:NOROOT(2)
Empty_Handler
        LDR     R0, =Empty_Handler
        BX      R0

        END
