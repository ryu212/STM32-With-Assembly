## Quick start:
These folder is for creating the PWM by TIM2_CH1 and duty cycle is 0.3 and can change it in line 96 of file main.s
- Use command the command `make` to compile all files and create .hex debug file
- Use command `make clean` to delete all files with extension name ".o", ".elf", ".hex" 
- My project using toolchain of 'arm-none-eabi'. If you have not installed that, use cammand ```sudo apt install gcc-arm-none-eabi``` to install
- To write .bin file into flash we use ST-LINK, run command ```st-flash write myprogram.bin 0x8000000```, if you have not installed stlink-tool, follow this command to install ST-LINK tools ```sudo apt update
                                    sudo apt install stlink-tools```
 
- Using PB12-15 to read the control signal (PULL UP registor)
- Using PA0-3 to create the PWM 
- Using PA4 to read the analog signal and set speed follow up the data


## Pin Configuration

| Device 1        | Device 2        | Function                          |
|-----------------|-----------------|----------------------------------|
| 12V (L298N)     | DC Power (+)    | Supply power to motor driver     |
| GND (L298N)     | DC Power (-)    | Ground reference for power       |
| GND (L298N)     | GND (STM32)     | Common ground reference          |
| 5V (L298N)      | 5V (STM32)      | Power supply for STM32           |
| PA0 (STM32)     | IN1 (L298N)     | Motor control logic              |
| PA1 (STM32)     | IN2 (L298N)     | Motor control logic              |
| PA2 (STM32)     | IN3 (L298N)     | Motor control logic              |
| PA3 (STM32)     | IN4 (L298N)     | Motor control logic              |
| PA4 (STM32)     | Potentiometer   | Analog input (speed control)     |
| PB15 (STM32)    | Left Button     | Control input                    |
| PB14 (STM32)    | Right Button    | Control input                    |
| PB13 (STM32)    | Reverse Button  | Control input                    |
| PB12 (STM32)    | Forward Button  | Control input                    |


## Demo:
https://drive.google.com/file/d/1K4U_qZf-SJuuS_xAQttY1-zPEbBcGkvw/view?usp=sharing


