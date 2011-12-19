/*
  7segment LED
 
 Controls a 7-segment LED Display
 
 LED part No: ELS-321HDB
 
 PINS:
 1   14
 2   13
 .   12
 4   .
 .   .
 6   9
 7   8
 
 7SEGMENT PIN DESCRIPTION:
 1: F
 2: G
 4: Common Cathode
 6: E
 7: D
 8: C
 9: RDP
 12: Common Cathode
 13: B
 14: A
 
 DISPLAY:
    A
  F   B
    G
  E   C
    D
 
 LDP   RDP
 
 
 ARDUINO PIN MAPPING:              On 7segment, mapping to Arduino Pins
 A: 2                               7    2
 B: 3                               8    3
 C: 4                               .    GND
 D: 5                               GND  .
 E: 6                               .    .
 F: 7                               6    .
 G: 8                               5    4
 RDP: xxx
 
 
 NUMBER MAPPING / Number -> Anodes -> Arduino Pins -> Binary:
 0 - ABCDEF  -> 2,3,4,5,6,7   -> 11111100
 1 - BC      -> 3,4           -> 01100000
 2 - ABDEG   -> 2,3,5,6,8     -> 11011010
 3 - ABCDG   -> 2,3,4,5,8     -> 11110010
 4 - BCFG    -> 3,4,7,8       -> 01100110
 5 - ACDFG   -> 2,4,5,7,8     -> 10110110
 6 - ACDEFG  -> 2,4,5,6,7,8   -> 10111110
 7 - ABC     -> 2,3,4         -> 11100000
 8 - ABCDEFG -> 2,3,4,5,6,7,8 -> 11111110
 9 - ABCDFG  -> 2,3,4,7,8     -> 11100110
 
 * - Binary representation reads left-to-right order, with first bit pin 2, next pin 3, etc.
 
 */

// bit masks for each number

byte numbers[10] = {B11111100, B01100000, B11011010, B11110010, B01100110, B10110110, B10111110, B11100000, B11111110, B11100110};

void setup() {                
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
  for(int i = 2; i <= 8; i++) {
    pinMode(i, OUTPUT);     
  }
  
  // For the button, pin 12 will be constant output
  // 13 will be the input for the pin
  pinMode(12, OUTPUT);
  digitalWrite(12, HIGH);
  pinMode(13, INPUT);
}

// global vars to keep track of the count
int counter = 0;
bool go_by_button = true;
int last_input_value = LOW;


void loop() {
  if(go_by_button) {
    int button_input_value = digitalRead(13);
    if(last_input_value == LOW && button_input_value == HIGH) {
      counter = (counter + 1) % 10;
    }
    last_input_value = button_input_value;
  } else {
    delay(300);              // wait for a second
    counter = (counter + 1) % 10;
  }
  writeNumber(counter);
}

void writeNumber(int number) {
  if(number < 0 || number > 9) {
    return;
  }

  byte mask = numbers[number];

  // Using the mask, set each pin to the correct HIGH/LOW value
  byte currentPinMask = B10000000;
  for(int i = 2; i <= 8; i++) {
    if(mask & currentPinMask) digitalWrite(i,HIGH); else digitalWrite(i,LOW);
    currentPinMask = currentPinMask >> 1;
  }

}

