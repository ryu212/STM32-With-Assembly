
.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb


.equ RCC_APH2ENR, 0x40021018
.equ ADC1_BASE, 0x40012400
.equ ADC1_CR2, (ADC1_BASE + 0x08)
.equ GPIOA_CRL, 0x40010800
.equ ADC1_SQR1, (ADC1_BASE + 0x2C)
.equ ADC1_SQR3, (ADC1_BASE + 0x34)

.global setupADC
setupADC:
ldr r0, =RCC_APH2ENR
ldr r1, [r0]
ldr r2, =(1 << 9)
orr  r1, r1, r2
str r1, [r0]

ldr r0, =GPIOA_CRL
ldr r1, [r0]
ldr r2, =(0b1111 << 16)
bic r1, r2
ldr r2, =(0b0000 << 16)
orr r1, r1, r2
str r1, [r0]

ldr r0, =ADC1_CR2
ldr r1, [r0]
orr r1, r1, #1
str r1, [r0]


mov r2, #0xFF
delay1:
    SUBS r2, r2, #1
    BNE delay1

ldr r0, =ADC1_SQR1
ldr r1, [r0]
ldr r2, =(0b1111 << 20)
bic r1, r2
str r1, [r0]


ldr r0, =ADC1_SQR3
ldr r1, [r0]
ldr r2, =(0b11111)
bic r1, r2
mov r2, #4
orr r1, r1, r2 
str r1, [r0]


ldr r0, =ADC1_CR2
ldr r1, [r0]
orr r1, r1, #(1 << 1)
str r1, [r0]


ldr r0, =ADC1_CR2
ldr r1, [r0]
orr r1, r1, #(1 << 0)
str r1, [r0]


mov r2, #0xFF
delay2:
    SUBS r2, r2, #1
    BNE delay2

ldr r0, =ADC1_CR2
ldr r1, [r0]
ldr r2, =(1 << 22)
orr r1, r1, r2
str r1, [r0]

bx lr



