#include <Adafruit_GFX.h>
#include <Adafruit_NeoMatrix.h>
#include <Adafruit_NeoPixel.h>
#define PIN 6

#ifndef PSTR
 #define PSTR // Make Arduino Due happy
#endif

Adafruit_NeoMatrix matrix = Adafruit_NeoMatrix(8, 8, PIN,
NEO_MATRIX_TOP     + NEO_MATRIX_RIGHT +
NEO_MATRIX_COLUMNS + NEO_MATRIX_PROGRESSIVE,
NEO_GRB            + NEO_KHZ800);

const uint16_t colors = matrix.Color(255, 0, 0);
int x = matrix.width();
char inData[1200] = {};  // Allocate some space for the Bytes
byte index = 0;   // Index into array; where to store the Bytes
int tweetlong = 0; // Where to store the length of the tweet

void setup() {
      Serial.begin(115200);
        matrix.begin();
        matrix.setTextWrap(false);
        matrix.setBrightness(5);
        matrix.setTextColor(colors);
}

void loop() { 
  Serial.write("ready \n");
      if (Serial.available() && tweetlong < 141) { //if serial is available
        char c = Serial.read(); // read the serial 
        if(c != 0){ // if the byte is not nothing  
          inData[index] = c; // get the read byte 
          index ++; // increment through array to populate 
          tweetlong = index; // get size of the array and set to tweetlong
            if(c == '\n'){
              inData[index] = 0; // set null terminate the string
            }
        } 
     } 
     display();
}


void display() {
     boolean finishedDisplay = x < -tweetlong * 6;
        if (finishedDisplay == false) {   
            delay(100);
              matrix.fillScreen(0); 
              matrix.setCursor(x, 0); //Where to start the string 
              matrix.print(inData); //Print the string inData
                if(--x < -tweetlong * 6) { //Check to see when the string is done printing 
                  matrix.setTextColor(colors); //Set the color of the text
                }   
              matrix.show(); //display the text on the arduino screen
        } else if (finishedDisplay == true) {
          x = matrix.width(); // reset x to get fresh width
          index = 0; // reset index to get a new tweet 
        }
}

