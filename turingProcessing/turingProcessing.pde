/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */


import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
//boolean [] headState;
String headState= "";
String writeState= "";
int column = 0;

PFont font;

void setup() 
{
  size(800, 600);
  font = loadFont("Dialog-14.vlw");
  textFont(font, 14);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  println(Serial.list());
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
  // myPort.bufferUntil('\n');//'#');
}

void draw()
{
  background(0);

  text("READ STATE : " +headState, 100, 100);
  text("WRITTEN STATE :  "+writeState, 100, 130);
  text("MOVING TO :  "+str(column), 100, 160);
}

void rule(int state) {

  if (state>=63) {
    column++;
  } else {
    column--;
  }

  if (column<0) {
    column = 31;
  }
  if (column>31) {
    column = 0;
  }

  int newState = (int)random(128);
  myPort.write(newState);
  String bt = binary(newState);
  writeState = bt.substring(bt.length()-7, bt.length());
  
  myPort.write(column);

}

void keyPressed() {

  if (key=='q') {
    myPort.write(253);
  } else if (key=='w') {
    int newState = (int)random(128);
    myPort.write(newState);
    String bt = binary(newState);
    writeState = bt.substring(bt.length()-7, bt.length());
  } else if (key=='e') {
    column = (int)random(128, 162);
    myPort.write(column);
    column-=128;
  }
}

void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  int inByte = myPort.read();
  // if this is the first byte re

  println(inByte);
  if (inByte==253) {
    println("head arrived");
  } else {
    String bt =  binary(inByte);
    headState = bt.substring(bt.length()-7, bt.length());
  }
}
/*

 // Wiring / Arduino Code
 // Code for sensing a switch status and writing the value to the serial port.
 
 int switchPin = 4;                       // Switch connected to pin 4
 
 void setup() {
 pinMode(switchPin, INPUT);             // Set pin 0 as an input
 Serial.begin(9600);                    // Start serial communication at 9600 bps
 }
 
 void loop() {
 if (digitalRead(switchPin) == HIGH) {  // If switch is ON,
 Serial.write(1);               // send 1 to Processing
 } else {                               // If the switch is not ON,
 Serial.write(0);               // send 0 to Processing
 }
 delay(100);                            // Wait 100 milliseconds
 }
 
 */
