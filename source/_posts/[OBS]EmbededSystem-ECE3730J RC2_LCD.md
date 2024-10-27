---
categories:
- Note
date:
- 2024-06-15 17:51:30
tags:
- Embeded-System
title: ECE3730J RC2
toc: true

---


![](Pasted_image_20240616202750.png)
Basically, we are using MCU to communicate with the LCD controller (HD44780).

Datasheet for HD44780: https://www.sparkfun.com/datasheets/LCD/HD44780.pdf

## LCD Controller Pin

1. **VSS (Pin 1)**: Ground (GND).
2. **VDD (Pin 2)**: Power supply (usually +5V).
	Note: If you use J-link debugger to power the board, the output voltage at `+5V` pin will not be 5V, maybe around 2.8V, so remember to use the 5V power supply wire to power the board.
1. **VO (Pin 3)**: Contrast adjustment pin. Usually connected to a potentiometer to adjust the contrast.
2. **RS (Pin 4)**: Register select pin. Low for instruction register, high for data register.
3. **RW (Pin 5)**: Read/Write pin. Low for write operation, high for read operation. Usually grounded (write mode).
4. **E (Pin 6)**: Enable pin. The LCD controller only captures (grabs) the data presented at its register lines(D0-D7) only when the E pin "transitions" from high to low.
5. **D0-D7 (Pins 7-14)**: Data bus pins. Used for communication with the microcontroller in either 4-bit (D4-D7) or 8-bit (D0-D7) mode.
6. **A (Pin 15)**: For the backlight. Typically connected to +5V.
7. **K (Pin 16)**: For the backlight. Typically grounded (GND).

### Connection with STM32
![](Pasted_image_20240616210515.png)

## Some Useful Charts
From [datasheet](https://www.sparkfun.com/datasheets/LCD/HD44780.pdf)

1. Four operation
![](Pasted_image_20240616212637.png)
**IR: instruction register**
**DR: data register**

*In this Lab, we will mainly use the first and third operation*

2. Instruction
![](Pasted_image_20240616212934.png)
![](Pasted_image_20240616213009.png)

3. DDRAM
![](Pasted_image_20240616214538.png)

4. CGRAM
![](Pasted_image_20240616215520.png)

## Application Example

### Send Command to LCD Controller

Recall the operation:
![](Pasted_image_20240616220104.png)

1. Set the pin of `RS` & `R/W` to low.
2. Set `E` to high, preparing for the data transfer.
3. Set `D7-D0` to the desired instruction(8-bit).
4. Set `E` to low

Sample code:
```c
void LCD_Write_Command(uchar Com) {
  Delay_ms(10);
  HAL_GPIO_WritePin(GPIOB, LCD_RS_Pin, GPIO_PIN_RESET); // LCD_RS = 0;
  HAL_GPIO_WritePin(GPIOB, LCD_RW_Pin, GPIO_PIN_RESET); //	LCD_RW = 0;
  HAL_GPIO_WritePin(GPIOB, LCD_E_Pin, GPIO_PIN_SET);    // LCD_E_Pin = 1;
  Delay_ms(1);                                          // wait for tpw;

  LCD_PORT = Com;// put command on the bus

  HAL_GPIO_WritePin(GPIOB, LCD_E_Pin, GPIO_PIN_RESET); // LCD_E_Pin =0;
  Delay_ms(1);                                         // wait for tpw;

}

```

### Write Data To DDRAM

Recall the operation:
![](Pasted_image_20240616222832.png)

1. Set the pin of `RS` to high and `R/W` to low.
2. Set `E` to high, preparing for the data transfer.
3. Set `D7-D0` to the desired address.
	![](Pasted_image_20240616223239.png)
	
1. Set `E` to low

Sample code:
```c
void LCD_Write_Data(uchar dat) {
  Delay_ms(1);

  HAL_GPIO_WritePin(GPIOB, LCD_RS_Pin, GPIO_PIN_SET);   // LCD_RS = 1;
  HAL_GPIO_WritePin(GPIOB, LCD_RW_Pin, GPIO_PIN_RESET); //	LCD_RW = 0;
  HAL_GPIO_WritePin(GPIOB, LCD_E_Pin, GPIO_PIN_SET);    // LCD_E_Pin = 1;
  // Delay_ms(1);

  LCD_PORT = dat; // put data on the bus

  HAL_GPIO_WritePin(GPIOB, LCD_E_Pin, GPIO_PIN_RESET); // Set LCD_E = 0;

  Delay_ms(1); // wait for tpw;
}
```

### Init LCD
```c
#define LCD_2_LINE_4_BITS 0x28
#define LCD_2_LINE_8_BITS 0x38
#define LCD_DSP_CSR 0x0c
#define LCD_CLR_DSP 0x01 
#define LCD_CSR_INC 0x06

void LCD_init(void)
{
  LCD_Write_Command(LCD_2_LINE_8_BITS); // function set -8 bit interface
  Delay_ms(5);
  LCD_Write_Command(LCD_2_LINE_8_BITS); 
  
  LCD_Write_Command(LCD_CLR_DSP); // clear display
  Delay_us(100);
  LCD_Write_Command(LCD_CSR_INC); // Set entry mode: increment
  Delay_us(100);
  LCD_Write_Command(LCD_DSP_CSR); // open display, close cursor
}
```

### Display Charactor

First we need to set the cursor position

The cursor position is basically the DDRAM address that you want to write data in, which is corresponding to the display location on LCD screen.

```c
void LCD_Set_Position(uchar x, uchar y) {
  if (y == 0) // first line
  {
    LCD_Write_Command(0x80 + x);
  } else if (y == 1) // second line
  {
    LCD_Write_Command(0xc0 + x);
  }
}
```

If we want to display a character at first line, first column:
```c
LCD_Set_Position(0,0);
```

Then, we need to write data into DDRAM\[addr\] to tell the LCD which character you want to display, for example "J".
```c
LCD_Write_Data("J"); // send the ascii code
```

Putting them all together:
```c
void LCD_Display_Char(uchar Char, uchar x, uchar y)
{
  LCD_Set_Position(x, y);
  LCD_Write_Data(Char);
}
```

### Display String

The cursor will shift right (because we set `increment` entry mode) after each `write_data` operation, so displaying a string is quite simple.

```c
void LCD_Display_Char(uchar Char, uchar x, uchar y) // 显示字符ASCII码
{
  LCD_Set_Position(x, y);
  LCD_Write_Data(Char);
}
```


## Demo
...
