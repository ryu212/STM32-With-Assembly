.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.EQU RCC_BASE, (0X40021000)
.equ RCC_CR, (RCC_BASE + 0X00)
.EQU RCC_CFGR, (RCC_BASE + 0X04)
.EQU FLASH_ACR, (0x40022000)


.global clock_init
clock_init:
	 // Bật HSE
        LDR     R0, =RCC_CR
        LDR     R1, [R0]
        ORR     R1, R1, #(0x00010001)        // bat HSEON va HSION
        STR     R1, [R0]
        //Phai bat HSI de phuc vu qua trinh ghi FLash
wait_hse_ready:
		LDR     R1, [R0]
        TST     R1, #(1 << 17)            // HSERDY
        BEQ     wait_hse_ready
        // Cấu hình Flash: bật prefetch, set latency = 2
        LDR     R0, =FLASH_ACR
        LDR     R1, [R0]
        ORR     R1, R1, #(1 << 4)         // PRFTBE
        BIC     R1, R1, #0x7              // clear LATENCY[2:0]
        ORR     R1, R1, #0x2              // set LATENCY = 2
        STR     R1, [R0]

        // Cấu hình clock chia
        LDR     R0, =RCC_CFGR
        LDR     R1, [R0]
        BIC     R1, R1, #(0xF << 4)       // clear HPRE[7:4]
        BIC     R1, R1, #(0x7 << 8)       // clear PPRE1[10:8]
        BIC     R1, R1, #(0x7 << 11)      // clear PPRE2[13:11]
		//MCO PLL/2
		ORR 	R1, #(0b111 << 24)
        ORR     R1, R1, #(0x4 << 8)       // PPRE1 = DIV2
        STR     R1, [R0]
		//Software must configure these bits ensure that the frequency in this domain does not exceed 36 MHz
        // Cấu hình PLL: nguồn từ HSE, nhân 9
        LDR     R1, [R0]
        BIC     R1, R1, #(0xF << 18)      // clear PLLMUL[21:18]
        ORR     R1, R1, #(0x7 << 18)      // PLLMUL = x9
        //Tam tat PLL de cau hinh cho PLLSRC
       	LDR     R2, =RCC_CR
       	LDR 	R3, [R2]
       	BIC 	R3, #(1 << 24)
       	// cau hinh bit nay chi khi PLL dang tat
        ORR     R1, R1, #(1 << 16)        // PLLSRC = HSE
        STR     R1, [R0]

        // Bật PLL
        LDR     R0, =RCC_CR
        LDR     R1, [R0]
        ORR     R1, R1, #(1 << 24)        // PLLON
        STR     R1, [R0]
wait_pll_ready:
        LDR     R1, [R0]
        TST     R1, #(1 << 25)            // PLLRDY
        BEQ     wait_pll_ready

        // Chọn PLL làm nguồn SYSCLK
        LDR     R0, =RCC_CFGR
        LDR     R1, [R0]
        BIC     R1, R1, #0x3              // clear SW[1:0]
        ORR     R1, R1, #0x2              // SW = 10 (PLL)
        STR     R1, [R0]

wait_sysclk_pll:
        LDR     R1, [R0]
        AND     R1, R1, #0xC              // check SWS[1:0]
        CMP     R1, #0x8                  // SWS == 10?
        BNE     wait_sysclk_pll

        BX      LR
