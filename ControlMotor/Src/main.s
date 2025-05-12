
.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb




.equ RCC_APH2ENR, 0x40021018
.equ RCC_APH1ENR, 0x4002101C
.equ GPIOA_CRL, 0x40010800
.equ TIM2_CR1, 0x40000000
.equ TIM2_CCMR1, 0x40000018
.equ TIM2_CCMR2, 0x4000001c
.equ TIM2_ARR, 0x4000002C
.equ TIM2_PRS, 0x40000028
.equ TIM2_CCER, 0x40000020
.equ TIM2_EGR, 0x40000014
.equ TIM2_CCR1, 0x40000034
.equ TIM2_CCR2, 0x40000038
.equ TIM2_CCR3, 0x4000003c
.equ TIM2_CCR4, 0x40000040

.equ GPIOA_BASE, 0x40010800
.equ GPIOA_ODR, (GPIOA_BASE + 0x0C)
.equ GPIOB_BASE, 0x40010C00
.equ GPIOB_CRH, (GPIOB_BASE + 0x04)
.equ GPIOB_IDR, (GPIOB_BASE + 0x08)
.equ ADC1_BASE, 0x40012400
.equ ADC1_DR, (ADC1_BASE + 0x4C)
.equ ADC1_SR, (ADC1_BASE + 0x00)
.data
speed: .word 


.text
.global main
main:

    //enable clock for gpioA, gpioB
	ldr r0, =RCC_APH2ENR
	mov r1, #0x0000000C //enable gpioA, gpioB
	str r1, [r0]

    ldr r0, =RCC_APH1ENR
    mov r1, #0x00000001
    str r1, [r0] 

    ldr r0, =GPIOA_CRL
    mov r1, #0x0000BBBB
    str r1, [r0]

    
    ldr r0, =TIM2_CCMR1
    ldr r1, [r0]
    mov r2, #0x0ffff
    and r1, r1, r2
    mov r2, #0x6464
    orr r1, r1, r2 
    str r1, [r0]

    ldr r0, =TIM2_CCMR2
    ldr r1, [r0]
    mov r2, #0x0ffff
    and r1, r1, r2
    mov r2, #0x6464
    orr r1, r1, r2 
    str r1, [r0]

    ldr r0, =TIM2_ARR
    mov r1, #4100
    str r1, [r0]

    ldr r0, =TIM2_PRS
    mov r1, #719
    str r1, [r0]

    ldr r0, =TIM2_CCER
    mov r1, #0x1111
    str r1, [r0]

    ldr r0, =TIM2_EGR
    ldr r1, [r0]
    mov r2, #1
    orr r1, r1, r2
    str r1, [r0]

    //config duty cycle here:
    ldr r1, =TIM2_CCR1
    ldr r2, =TIM2_CCR2
    ldr r3, =TIM2_CCR3
    ldr r4, =TIM2_CCR4

    mov r5, #0
    mov r6, #0
    mov r7, #0
    mov r0, #0

    str r5, [r1]
    str r6, [r2]
    str r7, [r3]
    str r0, [r4]


    //start tim2 and enable preload
    ldr r0, =TIM2_CR1
    ldr r1, [r0]
    mov r2, #0x0FFF

    and r1, r1, r2
    mov r2, #0x0081
    orr r1, r1, r2
    str r1, [r0]


    //gpioB 12-15 input push-pull
    ldr r0, =GPIOB_CRH
    ldr r1, =0x88880000
    str r1, [r0]
    bl setupADC

    
loop:
    ldr r0, =ADC1_SR
    ldr r1, [r0]
    and r1, #(2)
    cmp r1, #2
    bne end_read


    ldr r0, =ADC1_DR
    ldr r1, [r0]
    ldr r2, =0xFFF
    and r1, r1, r2
    //mov r2, #5
    //udiv r1, r1, r2
    ldr r0, =speed
    str r1, [r0]

    end_read:

    ldr r0, =GPIOB_IDR
    ldr r1, [r0]
    mvn r1, r1
    mov r2, #(1 << 15)
    and r3, r1, r2
    cmp r3, #(1 << 15)
    beq turn_right

    mov r2, #(1 << 14)
    and r3, r1, r2
    cmp r3, #(1 << 14)
    beq turn_left

    mov r2, #(1 << 13)
    and r3, r1, r2
    cmp r3, #(1 << 13)
    beq forward

    mov r2, #(1 << 12)
    and r3, r1, r2
    cmp r3, #(1 << 12)
    beq backward
    b no_ctrl_signal

    turn_right:
    ldr r1, =TIM2_CCR1 
    ldr r2, =TIM2_CCR2
    ldr r3, =TIM2_CCR3
    ldr r4, =TIM2_CCR4
    ldr r5, =speed
    ldr r0, [r5]
    str r0, [r1]
    str r0, [r4]
    mov r0, #0
    str r0, [r2]
    str r0, [r3]
    b end_control

    turn_left:
    ldr r1, =TIM2_CCR1 
    ldr r2, =TIM2_CCR2
    ldr r3, =TIM2_CCR3
    ldr r4, =TIM2_CCR4
    ldr r5, =speed
    ldr r0, [r5]
    str r0, [r2]
    str r0, [r3]
    mov r0, #0
    str r0, [r1]
    str r0, [r4]
    b end_control

    forward:
    ldr r1, =TIM2_CCR1 
    ldr r2, =TIM2_CCR2
    ldr r3, =TIM2_CCR3
    ldr r4, =TIM2_CCR4
    ldr r5, =speed
    ldr r0, [r5]
    str r0, [r1]
    str r0, [r3]
    mov r0, #0
    str r0, [r2]
    str r0, [r4]
    b end_control

    backward:
    ldr r1, =TIM2_CCR1 
    ldr r2, =TIM2_CCR2
    ldr r3, =TIM2_CCR3
    ldr r4, =TIM2_CCR4
    ldr r5, =speed
    ldr r0, [r5]
    str r0, [r2]
    str r0, [r4]
    mov r0, #0
    str r0, [r1]
    str r0, [r3]
    b end_control

    no_ctrl_signal:
    ldr r1, =TIM2_CCR1 
    ldr r2, =TIM2_CCR2
    ldr r3, =TIM2_CCR3
    ldr r4, =TIM2_CCR4
    mov r0, #0
    str r0, [r1]
    str r0, [r3]
    str r0, [r2]
    str r0, [r4]

    end_control:
    b loop