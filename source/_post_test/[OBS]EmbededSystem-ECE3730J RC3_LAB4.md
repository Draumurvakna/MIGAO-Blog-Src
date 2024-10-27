---
categories:
- Note
date:
- 2024-06-30 20:07:02
tags:
- Embeded-System
title: ECE3730J RC3_LAB4
toc: true

---
For this RC, we will go through Lab 4 in detail.

## CubeMX

We need to generate PWM signal on `PB14`(embeded with an LED `D1`, or `D2` if you like)
![[Pasted image 20240701151153.png]]
> when the `PB14` output `LOW`, `D1` will light up.

In STM32, Input Capture and Output Compare is configured in Timer channels.
![[Pasted image 20240701152054.png]]

Let's check which Timer is connected to `PB14`
![[Pasted image 20240701152158.png]]
It's the `CH2N` channel of timer 1.

Then we configure timer 1.
![[Pasted image 20240701143248.png]]
![[Pasted image 20240701144606.png]]
Prescaler: 7200-1
Counter Period: 200-1 (50Hz)
Pulse: 180 (duty cycle of 90%; TIM_CNT 0~179: HIGH, TIM_CNT 180~199: LOW)
CHN Polarity: LOW (needed for CHN)
> CHxN is the complementary channel of CHx in Timer1.
> If the polarity of CHxN and CHx are different, the two channels will follow the same output pattern, otherwise they will be complementary


Also remember to configure `PB12` (`SW4`) as GPIO_Input.
![[Pasted image 20240701152725.png]]
> You can try to use Input Capture to capture the press action of the button (as indicated in lab manual, i.e. connecting `PB12` to `PA0`).
## Code
Init PWM in `main()`:
```c
    /* USER CODE BEGIN 2 */
    HAL_TIM_PWM_Start(&htim1, TIM_CHANNEL_2);
    HAL_TIMEx_PWMN_Start(&htim1, TIM_CHANNEL_2);
    /* USER CODE END 2 */
```


Change PWM duty cycle:
```c
void ChangeDutyCycle(int pulse_width)
{
    __HAL_TIM_SET_COMPARE(&htim1, TIM_CHANNEL_2, pulse_width);
    // htim1.Instance->CCR2 = pulse_width;
}
```

Get the press/release action of the button (`PB12`):
```c
	int pressed = 0;
    /* USER CODE BEGIN WHILE */
    while (1) { // main loop
        /* USER CODE END WHILE */
        /* USER CODE BEGIN 3 */
        if (!HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_12) && pressed == 0) {
            pressed = 1;
            // what to do when pressed
        }
        else if (HAL_GPIO_ReadPin(GPIOB, GPIO_PIN_12) && pressed == 1) {
            pressed = 0;
            // what to do when releassed
        }
    }
    /* USER CODE END 3 */
```


