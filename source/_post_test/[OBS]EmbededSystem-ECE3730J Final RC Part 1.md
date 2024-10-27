---
categories:
- Note
date:
- 2024-08-05 13:34:02
tags:
- Embeded-System
title: ECE3730J Final RC Part 1
toc: true

---
## L2 (Embedded system overview)
Take a look at the differences between **Microprocessor** (in our personal computer or phone) and **Microcontroller**
![[Pasted image 20240805142046.png]]
### Von Neumann vs Harvard architecture
![[Pasted image 20240805142016.png]]
efficiency: Harvard architecture can avoid the "Von Neumann bottleneck"
> VERBOSE~
**Von Neumann bottleneck**: when the bandwidth between CPU and RAM is much lower than the speed at which a typical CPU can process data, because the shared bus for instructions and data can cause competition.

In embedded system, harvard architecture is widely used. 
Our board (STM32F103C8T6) use harvard architecture on physical level (refer to the block diagram in reference manual)
![[Pasted image 20240805143312.png]]
>*VERBOSE~*
**ICode bus**:This bus connects the Instruction bus of the Cortex®-M3 core to the Flash memory instruction interface.
**DCode bus**:This bus connects the DCode bus (literal load and debug access) of the Cortex ®-M3 core to the Flash memory Data interface.

However, in the software level, we treat the instruction memory and data memory as a whole block of memory (therefore, it is more accurate to say that the stm32 uses a mixed Harvard and von Neumann architecture.).

In stm32, instruction memory, data memory, registers of peripherals/IO are all mapped to memory.
![[Pasted image 20240805213045.png]]
Table from https://embeddedsecurity.io/vendor-stm32

![[Pasted image 20240806115644.png]]
![[Pasted image 20240806115733.png]]

## L3 (Programming)

### Type Qualifiers
#### `const`
- implies that value not supposed to be written by program (read only) during run-time. Can be modified by others like hardware. 
> If you want to save the limited RAM spaces (data memory) for other variables, you can use this keyword to store this variable in ROM (program memory). It's important for harvard architecture.

#### `volatile`
- indicate the value can be changed by something other than program so it should be reexamined frequently.
> This means two things:
> - The compiler will not try to optimize the variable with `volatile`. See the two examples on slides.
> - Each time the program reads the `volatile` variable, the processor will not look into cached data memory, meaning that the program can always get the newest updated data in memory (which is very important when external hardware change the variable). ~~However, this case is not relevant with STM32 MCU since it didn't have cache.~~

#### What about `const volatile` ?
- The combination of the above two concepts. Usually used to declare pointers
*Example:*
`const volatile char *a` declares a pointer pointing to a value that cannot be changed by the program through `*a`, but the value of a can be changed (pointing to another value). `*a = 0` is not allowed, `a = &b` is allowed.

Generally, we use `const volatile` to declare pointers that points to hardware registers or memory-mapped Input ports(**read only**). 

### Basic Program Structure
```c
// import header file for the board (containing the declaration of SFR)
// declare global variables
int main(void){
	// initialization (system clock, peripherals)
	while(true) // super loop, the the program alive
	{
		// interact with peripherals
	}

}

```

### How to interact with peripherals
We need to use C code to set the value of SFR. 
#### SFR (special function registers)
These are registers that are embedded in peripherals, used for configuration and control of peripherals.
>*VERBOSE~*
>If we want to get the status of a peripheral, we read the value of SFR.
If we want to send something to peripheral, we write value to SFR.

Let's take timer as an example:
SFR in block diagram of timer:
![[Pasted image 20240805210220.png]]


SFR declaration in code:
![[Pasted image 20240805204631.png]]
![[Pasted image 20240805204818.png]]

We change operate with these registers through `Bit Operation`.
![[Pasted image 20240805210556.png]](These are PIC32 codes but I think you have got it)

## L4 (IO)

All the modes of GPIO:
![[Pasted image 20240805214356.png]]
The whole block diagram:
![[Pasted image 20240805215231.png]]

You may see an unfamiliar unit ![[Pasted image 20240805232310.png]] Here.
It's used to convert the input analog voltage to digital voltage.
You can memorize it through this graph:
**[Transfer function](https://en.wikipedia.org/wiki/Transfer_function) of a Schmitt trigger.**
![[Pasted image 20240805232536.png]]
>The horizontal and vertical axes are input voltage and output voltage, respectively. T and −T are the switching thresholds, and M and −M are the output voltage levels.

### Input
After we configured the GPIO to be input ports, the output driver is disabled (disconnected).
#### Pull down
![[Pasted image 20240805233438.png]]
- When the IO pin is connected to LOW (0V) or unconnected, the input data register will be 0.
- When the IO pin is connected to HIGH (3.3V/5V), the input data register will be 1.

#### Pull up
![[Pasted image 20240806000537.png]]
- When the IO pin is connected to LOW (0V), the input data register will be 0.
- When the IO pin is connected to HIGH (3.3V/5V) or unconnected, the input data register will be 1.

#### Floating
![[Pasted image 20240806001337.png]]
- When the IO pin is connected to LOW (0V), the input data register will be 0.
- When the IO pin is connected to HIGH (VDD), the input data register will be 1.
- When the IO pin is unconnected, the input data register will be unpredictable.

### General Purpose Output
The input driver part is still enabled so that we can read the output status.
#### Open Drain
Can "generate" voltage higher than `VDD` at IO pin.
![[Pasted image 20240806004041.png]]
![[Pasted image 20240806004653.png]]
- “0” in the Output register activates the N-MOS (LOW (0V) at IO pin)
- “1” in the Output register leaves the port in Hi-Z (HIGH (V+) at IO pin)
 (the P-MOS is never activated)

#### Push Pull
Most common one.
![[Pasted image 20240806005010.png]]
- “0” in the Output register activates the N-MOS (LOW (0V) at IO pin)
- “1” in the Output register activates the P-MOS (HIGH (VDD) at IO pin)

### Alternative Function Output
Not covered.

## L5 (Interrupts)
### Why interrupt?
![[Pasted image 20240806011926.png]]
Most of the peripherals take quite a few time to complete its task or trigger an event. Instead of instruct the processor to keep checking the status of these peripheral (polling), we want the peripherals to inform processor when there exists an event, so that the processor can focus on its own task.

Peripherals inform the processor through external interrupt.

### Where do interrupts come from
We mainly deal with the interrupts from peripherals.
![[Pasted image 20240806015023.png]]
Each peripheral can have multiple interrupt sources, indicating different events.

### How to handle interrupts

Through interrupt service routine (ISR)
![[Pasted image 20240806021820.png]]
#### Interrupt vectors
Interrupt vectors are **addresses that inform the interrupt handler as to where to find the ISR**

```
| Vector Number | Interrupt Number | Description                    | Vector Address   |
|---------------|------------------|--------------------------------|------------------|
| 0             | -                | Initial Stack Pointer          | 0x0800 0000      |
| 1             | -                | Reset Handler                  | 0x0800 0004      |
....
| 27            | 11               | DMA1 Channel1 global Interrupt | 0x0800 006C      |
| 28            | 12               | DMA1 Channel2 global Interrupt | 0x0800 0070      |
| 29            | 13               | DMA1 Channel3 global Interrupt | 0x0800 0074      |
| 30            | 14               | DMA1 Channel4 global Interrupt | 0x0800 0078      |
| 31            | 15               | DMA1 Channel5 global Interrupt | 0x0800 007C      |
| 32            | 16               | DMA1 Channel6 global Interrupt | 0x0800 0080      |
| 33            | 17               | DMA1 Channel7 global Interrupt | 0x0800 0084      |
...
| 41            | 25               | TIM1 Break Interrupt           | 0x0800 00A4      |
| 42            | 26               | TIM1 Update Interrupt          | 0x0800 00A8      |
| 43            | 27               | TIM1 Trigger and Commutation   | 0x0800 00AC      |
| 44            | 28               | TIM1 Capture Compare Interrupt | 0x0800 00B0      |
...
```
>This is an arbitrary IVT that depicts the pattern of IVT, for detailed IVT of STM32, please refer to the reference manual. 
#### What to do inside ISR
- Always remember to clear the interrupt flag in ISR.
- Because there is often more interrupt sources than interrupt vectors, you need to judge which source triggered this interrupt based on interrupt status register.
- Customized operation... (but be short, because if the operation take too many clock cycles, it may be interrupted by another interrupt source, which may not be on purpose)

### Nested interrupts
![[Pasted image 20240806021935.png]]
When executing ISR, the processor can be interrupted by interrupts with higher priority.
> **Remainder:** the lower the priority number, the higher the priority
![[Pasted image 20240806115404.png]]


## L6 (Timer)

Let's split Timer peripheral into 3 parts:
![[Pasted image 20240806120419.png]]
#### Blue part: Master/slave controller
The master/slave unit provides the time-base unit with the **counting clock signal** (for example the CK_PSC signal, PSC here means that it's for the prescaler in time-base unit), as well as the counting direction (counting up/down) control signal.
This unit mainly provides the **control signals** for the time-base unit.
#### Yellow part: Time-base unit
The main block of the programmable timer is a **16-bit** counter with its related auto-reload register.
The counter can count up, down or both up and down. 
The counter clock can be divided by a **prescaler** (which is basically another counter).
![[Pasted image 20240806120629.png]]
> On the reference manual there are many wave-forms for you to understand how these control registers take effects.

The reset frequency of the counter is $$\frac{f_{input}}{(Prescaler+1)\times(Counter Period+1)}$$

#### Red part: Timer-channels unit
The timer channels are the working elements of the timer.
They are the means by which a timer peripheral interacts with its external environment (through input capture or output compare).

![[Pasted image 20240806134426.png]]

### How to use multiple timer for more counting digits (32-bit)
![[Pasted image 20240806114606.png]]
It is possible to configure one slave timer to increment its counter based on a master-timer events such as the timer update event. The master-timer event is signaled by the master timer master/slave controller unit. This controlling unit uses the master timer output-TRGO signal. The master timer output-TRGO signal is connected to the slave timer TRGI-input signal. The master/slave controller unit of the slave timer is configured to use the TRGI-input signal as clock source to increment the slave timer counter.

## L7 (LCD)
Just refer to RC2_LCD. I think it's not the focus of final exam.

## L9 & L10 (Input Capture & Output Compare)
IC is a peripheral that can **monitor the input signal changes** (pos/neg edge) independent of the processor (Core).
OC is a peripheral that can **generate precise output signal** independent of the processor (Core).

In STM32, it is embedded in timer peripheral (together with output compare).
![[Pasted image 20240806131345.png]]

### IC
You can consider IC as a **timer value recorder**. It will record the timer value each time the capture condition is met (you can see from the diagram, the timer value is from `CNT counter`).
> These conditions can be:
> - rising edge
> - falling edge
> - both
With a prescaler, we trigger capture events every few edges.
Similar for interrupt, we can trigger an interrupt every few captures.


> **Note:**
The IC does not capture the edge immediately when a rising or falling edge happened. The capture event needs to be sync with PB_clk.
Further more, the module will capture the timer counter value that is valid 2-3 PB_clk cycles after the capture event.

For detailed configuration, please refer to `Reference Manual.pdf` on canvas, page 349-359, 382-385.

### OC
Just refer to RC2_Output_Campare and RC3_Lab4 for the concepts and PWM configuration.
Also, the solution of hw2 has been uploaded to canvas, please take a look.









