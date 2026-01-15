; -------------------------------------------------------------------------
;  @file:    startup_MIMXRT1176_cm7.s
;  @purpose: CMSIS Cortex-M7 Core Device Startup File
;            MIMXRT1176_cm7
;  @version: 0.1
;  @date:    2018-3-5
;  @build:   b200610
; -------------------------------------------------------------------------
;
; Copyright 1997-2016 Freescale Semiconductor, Inc.
; Copyright 2016-2020 NXP
; All rights reserved.
;
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

        SECTION .intvec:CODE:NOROOT(2)

        EXTERN  __iar_program_start
        EXTERN  SystemInit
        PUBLIC  __vector_table
        PUBLIC  __vector_table_0x1c
        PUBLIC  __Vectors
        PUBLIC  __Vectors_End
        PUBLIC  __Vectors_Size

        DATA

__iar_init$$done:              ; The vector table is not needed
                      ; until after copy initialization is done

__vector_table
        DCD     sfe(CSTACK)
        DCD     Reset_Handler

        DCD     Empty_Handler                                   ;NMI Handler
        DCD     Empty_Handler                             ;Hard Fault Handler
        DCD     Empty_Handler                             ;MPU Fault Handler
        DCD     Empty_Handler                              ;Bus Fault Handler
        DCD     Empty_Handler                            ;Usage Fault Handler
__vector_table_0x1c
        DCD     0                                             ;Reserved
        DCD     0                                             ;Reserved
        DCD     0                                             ;Reserved
        DCD     0                                             ;Reserved
        DCD     Empty_Handler                                   ;SVCall Handler
        DCD     Empty_Handler                              ;Debug Monitor Handler
        DCD     0                                             ;Reserved
        DCD     Empty_Handler                                ;PendSV Handler
        DCD     Empty_Handler                               ;SysTick Handler

                                                              ;External Interrupts
        DCD     Empty_Handler                         ;DMA channel 0/16 transfer complete
        DCD     Empty_Handler                         ;DMA channel 1/17 transfer complete
        DCD     Empty_Handler                         ;DMA channel 2/18 transfer complete
        DCD     Empty_Handler                         ;DMA channel 3/19 transfer complete
        DCD     Empty_Handler                         ;DMA channel 4/20 transfer complete
        DCD     Empty_Handler                         ;DMA channel 5/21 transfer complete
        DCD     Empty_Handler                         ;DMA channel 6/22 transfer complete
        DCD     Empty_Handler                         ;DMA channel 7/23 transfer complete
        DCD     Empty_Handler                         ;DMA channel 8/24 transfer complete
        DCD     Empty_Handler                         ;DMA channel 9/25 transfer complete
        DCD     Empty_Handler                        ;DMA channel 10/26 transfer complete
        DCD     Empty_Handler                        ;DMA channel 11/27 transfer complete
        DCD     Empty_Handler                        ;DMA channel 12/28 transfer complete
        DCD     Empty_Handler                        ;DMA channel 13/29 transfer complete
        DCD     Empty_Handler                        ;DMA channel 14/30 transfer complete
        DCD     Empty_Handler                        ;DMA channel 15/31 transfer complete
        DCD     Empty_Handler                          ;DMA error interrupt channels 0-15 / 16-31
        DCD     Empty_Handler                         ;CTI0_Error
        DCD     Empty_Handler                         ;CTI1_Error
        DCD     Empty_Handler                               ;CorePlatform exception IRQ
        DCD     Empty_Handler                            ;LPUART1 TX interrupt and RX interrupt
        DCD     Empty_Handler                            ;LPUART2 TX interrupt and RX interrupt
        DCD     Empty_Handler                            ;LPUART3 TX interrupt and RX interrupt
        DCD     Empty_Handler                            ;LPUART4 TX interrupt and RX interrupt
        DCD     Empty_Handler                            ;LPUART5 TX interrupt and RX interrupt
        DCD     Empty_Handler                            ;LPUART6 TX interrupt and RX interrupt
        DCD     Empty_Handler                            ;LPUART7 TX interrupt and RX interrupt
        DCD     Empty_Handler                            ;LPUART8 TX interrupt and RX interrupt
        DCD     Empty_Handler                            ;LPUART9 TX interrupt and RX interrupt
        DCD     Empty_Handler                           ;LPUART10 TX interrupt and RX interrupt
        DCD     Empty_Handler                           ;LPUART11 TX interrupt and RX interrupt
        DCD     Empty_Handler                           ;LPUART12 TX interrupt and RX interrupt
        DCD     Empty_Handler                             ;LPI2C1 interrupt
        DCD     Empty_Handler                             ;LPI2C2 interrupt
        DCD     Empty_Handler                             ;LPI2C3 interrupt
        DCD     Empty_Handler                             ;LPI2C4 interrupt
        DCD     Empty_Handler                             ;LPI2C5 interrupt
        DCD     Empty_Handler                             ;LPI2C6 interrupt
        DCD     Empty_Handler                             ;LPSPI1 interrupt request line to the core
        DCD     Empty_Handler                             ;LPSPI2 interrupt request line to the core
        DCD     Empty_Handler                             ;LPSPI3 interrupt request line to the core
        DCD     Empty_Handler                             ;LPSPI4 interrupt request line to the core
        DCD     Empty_Handler                             ;LPSPI5 interrupt request line to the core
        DCD     Empty_Handler                             ;LPSPI6 interrupt request line to the core
        DCD     Empty_Handler                               ;CAN1 interrupt
        DCD     Empty_Handler                         ;CAN1 error interrupt
        DCD     Empty_Handler                               ;CAN2 interrupt
        DCD     Empty_Handler                         ;CAN2 error interrupt
        DCD     Empty_Handler                               ;CAN3 interrupt
        DCD     Empty_Handler                         ;CAN3 erro interrupt
        DCD     Empty_Handler                            ;FlexRAM address out of range Or access hit IRQ
        DCD     Empty_Handler                                ;Keypad nterrupt
        DCD     Empty_Handler                         ;Reserved interrupt
        DCD     Empty_Handler                            ;GPR interrupt
        DCD     Empty_Handler                             ;LCDIF1 interrupt
        DCD     Empty_Handler                             ;LCDIF2 interrupt
        DCD     Empty_Handler                                ;CSI interrupt
        DCD     Empty_Handler                                ;PXP interrupt
        DCD     Empty_Handler                           ;MIPI_CSI interrupt
        DCD     Empty_Handler                           ;MIPI_DSI interrupt
        DCD     Empty_Handler                              ;GPU2D interrupt
        DCD     Empty_Handler                ;Combined interrupt indication for GPIO6 signal 0 throughout 15
        DCD     Empty_Handler               ;Combined interrupt indication for GPIO6 signal 16 throughout 31
        DCD     Empty_Handler                                ;DAC interrupt
        DCD     Empty_Handler                        ;PUF interrupt
        DCD     Empty_Handler                              ;WDOG2 interrupt
        DCD     Empty_Handler                    ;SRTC Consolidated Interrupt. Non TZ
        DCD     Empty_Handler                 ;SRTC Security Interrupt. TZ
        DCD     Empty_Handler                    ;ON-OFF button press shorter than 5 secs (pulse event)
        DCD     Empty_Handler                          ;CAAM interrupt queue for JQ0
        DCD     Empty_Handler                          ;CAAM interrupt queue for JQ1
        DCD     Empty_Handler                          ;CAAM interrupt queue for JQ2
        DCD     Empty_Handler                          ;CAAM interrupt queue for JQ3
        DCD     Empty_Handler                 ;CAAM interrupt for recoverable error
        DCD     Empty_Handler                           ;CAAM interrupt for RTC
        DCD     Empty_Handler                         ;Reserved interrupt
        DCD     Empty_Handler                               ;SAI1 interrupt
        DCD     Empty_Handler                               ;SAI1 interrupt
        DCD     Empty_Handler                            ;SAI3 interrupt
        DCD     Empty_Handler                            ;SAI3 interrupt
        DCD     Empty_Handler                            ;SAI4 interrupt
        DCD     Empty_Handler                            ;SAI4 interrupt
        DCD     Empty_Handler                              ;SPDIF interrupt
        DCD     Empty_Handler                    ;ANATOP interrupt
        DCD     Empty_Handler               ;ANATOP interrupt
        DCD     Empty_Handler                  ;ANATOP interrupt
        DCD     Empty_Handler                ;ANATOP interrupt
        DCD     Empty_Handler                ;ANATOP interrupt
        DCD     Empty_Handler                               ;ADC1 interrupt
        DCD     Empty_Handler                               ;ADC2 interrupt
        DCD     Empty_Handler                            ;USBPHY1 interrupt
        DCD     Empty_Handler                            ;USBPHY2 interrupt
        DCD     Empty_Handler                                ;RDC interrupt
        DCD     Empty_Handler               ;Combined interrupt indication for GPIO13 signal 0 throughout 31
        DCD     Empty_Handler                                ;SFA interrupt
        DCD     Empty_Handler                              ;DCIC1 interrupt
        DCD     Empty_Handler                              ;DCIC2 interrupt
        DCD     Empty_Handler                               ;ASRC interrupt
        DCD     Empty_Handler                        ;FlexRAM ECC fatal interrupt
        DCD     Empty_Handler                        ;CM7_GPIO2,CM7_GPIO3 interrupt
        DCD     Empty_Handler                ;Combined interrupt indication for GPIO1 signal 0 throughout 15
        DCD     Empty_Handler               ;Combined interrupt indication for GPIO1 signal 16 throughout 31
        DCD     Empty_Handler                ;Combined interrupt indication for GPIO2 signal 0 throughout 15
        DCD     Empty_Handler               ;Combined interrupt indication for GPIO2 signal 16 throughout 31
        DCD     Empty_Handler                ;Combined interrupt indication for GPIO3 signal 0 throughout 15
        DCD     Empty_Handler               ;Combined interrupt indication for GPIO3 signal 16 throughout 31
        DCD     Empty_Handler                ;Combined interrupt indication for GPIO4 signal 0 throughout 15
        DCD     Empty_Handler               ;Combined interrupt indication for GPIO4 signal 16 throughout 31
        DCD     Empty_Handler                ;Combined interrupt indication for GPIO5 signal 0 throughout 15
        DCD     Empty_Handler               ;Combined interrupt indication for GPIO5 signal 16 throughout 31
        DCD     Empty_Handler                            ;FLEXIO1 interrupt
        DCD     Empty_Handler                            ;FLEXIO2 interrupt
        DCD     Empty_Handler                              ;WDOG1 interrupt
        DCD     Empty_Handler                            ;RTWDOG3 interrupt
        DCD     Empty_Handler                                ;EWM interrupt
        DCD     Empty_Handler              ;OCOTP read fuse error interrupt
        DCD     Empty_Handler              ;OCOTP read fuse done interrupt
        DCD     Empty_Handler                                ;GPC interrupt
        DCD     Empty_Handler                                ;MUA interrupt
        DCD     Empty_Handler                               ;GPT1 interrupt
        DCD     Empty_Handler                               ;GPT2 interrupt
        DCD     Empty_Handler                               ;GPT3 interrupt
        DCD     Empty_Handler                               ;GPT4 interrupt
        DCD     Empty_Handler                               ;GPT5 interrupt
        DCD     Empty_Handler                               ;GPT6 interrupt
        DCD     Empty_Handler                             ;PWM1 capture 0, compare 0, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM1 capture 1, compare 1, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM1 capture 2, compare 2, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM1 capture 3, compare 3, or reload 0 interrupt
        DCD     Empty_Handler                         ;PWM1 fault or reload error interrupt
        DCD     Empty_Handler                           ;FlexSPI1 interrupt
        DCD     Empty_Handler                           ;FlexSPI2 interrupt
        DCD     Empty_Handler                               ;SEMC interrupt
        DCD     Empty_Handler                             ;USDHC1 interrupt
        DCD     Empty_Handler                             ;USDHC2 interrupt
        DCD     Empty_Handler                           ;USBO2 USB OTG2
        DCD     Empty_Handler                           ;USBO2 USB OTG1
        DCD     Empty_Handler                               ;ENET interrupt
        DCD     Empty_Handler                    ;ENET_1588_Timer interrupt
        DCD     Empty_Handler             ;ENET 1G MAC0 transmit/receive done 0
        DCD     Empty_Handler             ;ENET 1G MAC0 transmit/receive done 1
        DCD     Empty_Handler                            ;ENET 1G interrupt
        DCD     Empty_Handler                 ;ENET_1G_1588_Timer interrupt
        DCD     Empty_Handler                      ;XBAR1 interrupt
        DCD     Empty_Handler                      ;XBAR1 interrupt
        DCD     Empty_Handler                       ;ADCETC IRQ0 interrupt
        DCD     Empty_Handler                       ;ADCETC IRQ1 interrupt
        DCD     Empty_Handler                       ;ADCETC IRQ2 interrupt
        DCD     Empty_Handler                       ;ADCETC IRQ3 interrupt
        DCD     Empty_Handler                  ;ADCETC Error IRQ interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                               ;PIT1 interrupt
        DCD     Empty_Handler                               ;PIT2 interrupt
        DCD     Empty_Handler                              ;ACMP interrupt
        DCD     Empty_Handler                              ;ACMP interrupt
        DCD     Empty_Handler                              ;ACMP interrupt
        DCD     Empty_Handler                              ;ACMP interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                               ;ENC1 interrupt
        DCD     Empty_Handler                               ;ENC2 interrupt
        DCD     Empty_Handler                               ;ENC3 interrupt
        DCD     Empty_Handler                               ;ENC4 interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                               ;TMR1 interrupt
        DCD     Empty_Handler                               ;TMR2 interrupt
        DCD     Empty_Handler                               ;TMR3 interrupt
        DCD     Empty_Handler                               ;TMR4 interrupt
        DCD     Empty_Handler                          ;SEMA4 CP0 interrupt
        DCD     Empty_Handler                          ;SEMA4 CP1 interrupt
        DCD     Empty_Handler                             ;PWM2 capture 0, compare 0, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM2 capture 1, compare 1, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM2 capture 2, compare 2, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM2 capture 3, compare 3, or reload 0 interrupt
        DCD     Empty_Handler                         ;PWM2 fault or reload error interrupt
        DCD     Empty_Handler                             ;PWM3 capture 0, compare 0, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM3 capture 1, compare 1, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM3 capture 2, compare 2, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM3 capture 3, compare 3, or reload 0 interrupt
        DCD     Empty_Handler                         ;PWM3 fault or reload error interrupt
        DCD     Empty_Handler                             ;PWM4 capture 0, compare 0, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM4 capture 1, compare 1, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM4 capture 2, compare 2, or reload 0 interrupt
        DCD     Empty_Handler                             ;PWM4 capture 3, compare 3, or reload 0 interrupt
        DCD     Empty_Handler                         ;PWM4 fault or reload error interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                        ;Reserved interrupt
        DCD     Empty_Handler                          ;PDM event interrupt
        DCD     Empty_Handler                          ;PDM error interrupt
        DCD     Empty_Handler                            ;EMVSIM1 interrupt
        DCD     Empty_Handler                            ;EMVSIM2 interrupt
        DCD     Empty_Handler                         ;MECC1 init
        DCD     Empty_Handler                   ;MECC1 fatal init
        DCD     Empty_Handler                         ;MECC2 init
        DCD     Empty_Handler                   ;MECC2 fatal init
        DCD     Empty_Handler                 ;XECC init
        DCD     Empty_Handler           ;XECC fatal init
        DCD     Empty_Handler                 ;XECC init
        DCD     Empty_Handler           ;XECC fatal init
        DCD     Empty_Handler                     ;XECC init
        DCD     Empty_Handler               ;XECC fatal init
        DCD     Empty_Handler                           ;ENET_QOS interrupt
        DCD     Empty_Handler                       ;ENET_QOS_PMT interrupt
        DCD     Empty_Handler                                    ;234
        DCD     Empty_Handler                                    ;235
        DCD     Empty_Handler                                    ;236
        DCD     Empty_Handler                                    ;237
        DCD     Empty_Handler                                    ;238
        DCD     Empty_Handler                                    ;239
        DCD     Empty_Handler                                    ;240
        DCD     Empty_Handler                                    ;241
        DCD     Empty_Handler                                    ;242
        DCD     Empty_Handler                                    ;243
        DCD     Empty_Handler                                    ;244
        DCD     Empty_Handler                                    ;245
        DCD     Empty_Handler                                    ;246
        DCD     Empty_Handler                                    ;247
        DCD     Empty_Handler                                    ;248
        DCD     Empty_Handler                                    ;249
        DCD     Empty_Handler                                    ;250
        DCD     Empty_Handler                                    ;251
        DCD     Empty_Handler                                    ;252
        DCD     Empty_Handler                                    ;253
        DCD     Empty_Handler                                    ;254
        DCD     Empty_Handler                                    ; Reserved for user TRIM value
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
        LDR     R0, =SystemInit
        BLX     R0
        CPSIE   I               ; Unmask interrupts
        LDR     R0, =__iar_program_start
        BX      R0

        PUBLIC Empty_Handler
        SECTION .text:CODE:REORDER:NOROOT(2)
Empty_Handler
        LDR     R0, =Empty_Handler
        BX      R0

        END
