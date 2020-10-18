# Transfer_Data_From_Keyboard
Transfer Data from keyboard 

While keyboard connecting to FPGA we have this schedule to understand the operation of each socket.

![image](https://user-images.githubusercontent.com/71699869/96368010-d9df8c80-1159-11eb-9f64-debe97db548c.png)

 
Pin 1: +DATA Data  
Pin 2: No connection 
Pin 3: GND Ground
Pin 4: Vcc +5V DC 275mA
Pin 5: +CLK Clock
Pin 6: No Connection

From all this signals we will use only Data (pin 1) and Clock (pin 5).If keyboard is free to transmit a signal this happened via a byte at a time. Each byte of the keyboard is sent serially after first nesting on one message of 11 bits. Therefore each transmission includes the serial transmission of 11 bits to the kData line as shown in the following figure: 
![image](https://user-images.githubusercontent.com/71699869/96368020-f8de1e80-1159-11eb-8d46-29278b9ff40e.png)


•	1 Start bit: The binary bit indicates the start of a transmission and always takes the value of logic 0. The kData line goes from logic-1 that was in idle mode at logic-0.
•	8 binary bits: These bits correspond to the key code that was pressed. Note that the first bit sent corresponds to the least important digit of the code of each key.
•	1 parity bit: Indicate a possible mistake that probably happened during the transmission.
•	1 Stop bit: indicates the end of the transmission. Stop bit take always the value of logic 1.
But how does it stand out one key from the other? This is done via a unique code (1 byte) for each key (scancode). The codes corresponding to each key are shown in the figure below 
![image](https://user-images.githubusercontent.com/71699869/96368027-05fb0d80-115a-11eb-906c-3dcf0401250a.png)

 
For example, key 1 (!) Corresponds to the code 16Hex.There are two types of codes to distinguish the press of a button from its release. Pressing the button sends the key code of the key 16 in the case of key 1, while when it is released two more are sent codes: F0 (Hex) and again the key code (this happens in the simple case while in some other cases are sent 3 bytes). Therefore, by pressing and releasing it key 1 the data sent by the keypad is 16F016 (Hex). Knowing her the peculiarity of the keyboard you are asked to react only to the first corresponding code at the push of a button ignoring its release.
Finally as an exercise we have to display some specific colors in the monitor depending on what key will be pressed on the keyboard. R(red) G(green) B(blue)
