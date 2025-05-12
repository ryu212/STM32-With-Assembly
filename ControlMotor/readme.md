- My project using toolchain of 'arm-none-eabi'. If you have not installed that, use cammand ```sudo apt install gcc-arm-none-eabi``` to install
- To write .bin file into flash we use ST-LINK, run command ```st-flash write myprogram.bin 0x8000000```, if you have not installed stlink-tool, follow this command to install ST-LINK tools ```sudo apt update
                                    sudo apt install stlink-tools```
 
- Using PB12-15 to read the control signal
- Using PA0-3 to create the PWM (PULL UP registor)
- Using PA4 to read the analog signal and set speed follow up the data
