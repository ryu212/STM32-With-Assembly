.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb



.equ RCC_BASE, (0X40021000)
.equ RCC_APB2ENR, (RCC_BASE + 0x18)
.equ RCC_APB1ENR, (RCC_BASE + 0x1C)
.equ RCC_APB2ENR_IOAEN, 0x00000004
.equ RCC_APB1ENR_TIM2EN, 0x00000001
.equ GPIOA_BASE, (0x40010800)
.equ GPIOA_CRL, (GPIOA_BASE +(0x00))
.equ GPIOA0_CRL_MASK, (0b1111 << 0)
.equ TIM2_BASE, (0x40000000)
.equ TIM2_CCMR1, (TIM2_BASE + 0X18) //halfword
.equ TIM2_CCMR1_CCS1_MASK, (0b11 << 0)//halfword
.equ TIM2_CCMR1_CCS1_output, (0b00 << 0)
.equ TIM2_CCMR1_OC1M_MASK, (0B111 << 4)
.equ TIM2_CCMR1_OC1M_SET_PWM1, (0B110 << 4)
.equ TIM2_EGR, (TIM2_BASE + 0x14)
.equ TIM2_CCER, (TIM2_BASE + 0x20)//half word
.equ TIM2_CCER_CC1P_MASK, (0b1 << 1)//set 0 active high
.equ TIM2_ARR, (TIM2_BASE + 0X2C)
.equ TIM2_CCR1, (TIM2_BASE + 0x34)
.equ TIM2_CCMR1_OC1PE_MASK, (0b1 << 3)//1 enable preload
.equ TIM2_CR1, (TIM2_BASE + 0x00)
.equ TIM2_CR1_SET_ARPE, (1 << 7)
.equ TIM2_CR1_CMS_MASK, (0b11 << 5)
.equ TIM2_CR1_CMS_MASK_SET_EDGE_ALIGN, (0B00 << 5)
.equ TIM2_CR1_DIR_SET_UPCOUNTER_MASK, (1 << 4)//
.equ TIM2_CR1_SET_CEN, (1 << 0)

.equ TIM2_PSC, (TIM2_BASE + 0x28) // Prescaler

.equ RCC_CR, (RCC_BASE + 0X00)
.EQU RCC_CFGR, (RCC_BASE + 0X04)
.EQU FLASH_ACR, 0x40022000

.global main
main:

	//config clock

	//enable apb2 GPIOA
	ldr r0, =RCC_APB2ENR
	ldr r1, [r0]
	ldr r2, =RCC_APB2ENR_IOAEN
	orr r1, r1, r2
	str r1, [r0]
	//enable apb1 TIM2
	ldr r0, =RCC_APB1ENR
	ldr r1, [r0]
	ldr r2, =RCC_APB1ENR_TIM2EN
	orr r1, r1, r2
	str r1, [r0]
	//set gpioA0 output, alternate function (check)
	ldr r0, =GPIOA_CRL
	ldr r1, [r0]
	bic r1, r1, #0xF
	orr r1, #(0b1011 << 0)
	str r1, [r0]
	//select tim2 output mode (checked)
	ldr r0, =TIM2_CCMR1
	ldrh r1, [r0]
	ldrh r2, =TIM2_CCMR1_CCS1_MASK
	mvn r2, r2
	and r1, r1, r2
	ldr r2, =TIM2_CCMR1_CCS1_output
	orr r1, r1, r2
	strh r1, [r0]
	//set polarity active high (checked)
	ldr r0, =TIM2_CCER
	ldrh r1, [r0]
	ldrh r2, =TIM2_CCER_CC1P_MASK
	mvn r2, r2
	and r1, r1, r2
	strh r1, [r0]
	//select PWM mode 1 (checked)
	ldr r0, =TIM2_CCMR1
	ldr r1, [r0]
	//
	ldrh r2, =TIM2_CCMR1_OC1M_MASK
	mvn r2, r2
	and r1, r1, r2
	ldrh r2, =TIM2_CCMR1_OC1M_SET_PWM1
	orr r1, r1, r2
	strh r1, [r0]
	//set ARR = 1000, CCR = 1000 * duty cycle (checked)
	ldr r0, =TIM2_ARR
	mov r1, #1000
	strh r1, [r0]

	ldr r0, =TIM2_CCR1
	mov r1, #300 //duty cycle = 0.7
	strh r1, [r0]
	//update TIM2_EGR CC1 (compare capture channel 1)
	ldr r0, =TIM2_EGR
	ldr r1, [r0]
	orr r1, (1<< 0)//set bit EGR.UG
	str r1, [r0]
	//Prescale
	// Set prescaler = 7199 → f = 72MHz / (7199 + 1) = 10kHz
	ldr r0, =TIM2_PSC
	mov r1, #719
	strh r1, [r0]

	//Set the preload bit in CCMRx register and the ARPE bit in the CR1 register.
	ldr r0, =TIM2_CCMR1
	ldrh r1, [r0]
	ldrh r2, =TIM2_CCMR1_OC1PE_MASK
	orr r1, r1, r2
	strh r1, [r0]
	//(checked)
	ldr r0, =TIM2_CR1
	ldrh r1, [r0]
	ldrh r2, =TIM2_CR1_SET_ARPE
	orr r1, r1, r2
	//select counting mode (checked)
	ldrh r2, =TIM2_CR1_CMS_MASK
	mvn r2, r2
	and r1, r1, r2
	ldrh r2, =TIM2_CR1_DIR_SET_UPCOUNTER_MASK
	mvn r2, r2
	and r1, r1, r2
	strh r1, [r0]
	//Turn on output channel 1 (checked)
	ldr r0, =TIM2_CCER
	ldrh r1, [r0]
	orr r1, r1, #1
	strh r1, [r0]
	//enable timer2 (checked)
	ldr r0, =TIM2_CR1
	ldrh r1, [r0]
	ldrh r2, =TIM2_CR1_SET_CEN
	orr r1, r1, r2
	strh r1, [r0]
loop:
	b loop
  