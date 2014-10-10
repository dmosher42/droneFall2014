// Graphing sketch


// This program takes ASCII-encoded strings
// from the serial port at 9600 baud and graphs them. It expects values in the
// range 0 to 1023, followed by a newline, or newline and carriage return

// Created 20 Apr 2005
// Updated 18 Jan 2008
// by Tom Igoe
// This example code is in the public domain.

import processing.serial.*;

Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
int numgraph = 3;      // how many graphs?
String serialconnection = "tty.usbmodem"; //What your serial connection is. For usb: "tty.usbmodem"

/*
//Smoothing test
 // Define the number of samples to keep track of.  The higher the number,
 // the more the readings will be smoothed, but the slower the output will
 // respond to the input.  Using a constant rather than a normal variable lets
 // use this value to determine the size of the readings array.
 int numReadings = 10;
 
 int[][] readings = new int[numgraph][numReadings];      // the readings from the analog input
 int index = 0;                  // the index of the current reading
 int total = 0;                  // the running total
 int average = 0;                // the average
 */


void setup () {
  // set the window size:
  size(1200, 900);        

  // List all the available serial ports
  int l = Serial.list().length;
  String[] supercereal = new String[l];
  supercereal=Serial.list();

  //This part finds the USB.
  int i=0;
  for (; i<l; i++)
  {
    String[] m2 = match(supercereal[i], serialconnection);
    if (m2 != null)
    {
      println("Found " + supercereal[i]);
      break;
    }
  }
  myPort = new Serial(this, Serial.list()[i], 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  // set inital background:
  background(0);
  /*
  //Smoothing test
   // initialize all the readings to 0: 
   for (int thisReading = 0; thisReading < numReadings; thisReading++)
   for (int thisgraph = 0; thisgraph < numgraph; thisgraph++)
   readings[thisgraph][thisReading] = 0;
   */
}

void draw () {
  // everything happens in the serialEvent()
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
  boolean graph = false;
  int yoffset = height/numgraph;
  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);

    //this is to avoid problems with short strings running through inString.charAt(1)
    if (inString.length()<2) {
      println("ERROR: SHORT STRING. RETURNING");
      return;
    }

    switch(inString.charAt(0))
    {
    case 'a':
      print("a");
      yoffset = yoffset;
      break;
    case 'g':
      print("g");
      yoffset = yoffset;
      break;
    default:
      println(inString.charAt(0));
      return;
    }


    //switch between x,y,z graphs
    switch(inString.charAt(1))
    {
    case 'x':
      println("2x");
      stroke(255, 0, 0);
      yoffset = 0;
      break;
    case 'y':
      println("2y");
      stroke(0, 255, 0);
      yoffset = yoffset;
      break;
    case 'z':
      println("2z");
      graph = true;
      stroke(0, 0, 255);
      yoffset = -yoffset;
      break;
    default:
      print("2D:");
      println(inString);
      return;
    }

/*
//Smooth test
    // subtract the last reading:
    total= total - readings[index];         
    // read from the sensor:  
    readings[index] = analogRead(inputPin); 
    // add the reading to the total:
    total= total + readings[index];       
    // advance to the next position in the array:  
    index = index + 1;                    

    // if we're at the end of the array...
    if (index >= numReadings)              
      // ...wrap around to the beginning: 
      index = 0;                           

    // calculate the average:
    average = total / numReadings;         
*/


    //discard which graph we are using
    inString = split(inString, ' ')[1];
    // convert to an int and map to the screen height:
    float inByte = float(inString);
    inByte = map(inByte, 0, 1023, 0, height);

    // draw the line:
    //      stroke(127, 34, 255);
    line(xPos, height/2+yoffset, xPos, height/2 - inByte+yoffset);

    // at the edge of the screen, go back to the beginning:
    if (xPos >= width) {
      xPos = 0;
      background(0);
    } else if (graph == true) {
      // increment the horizontal position:
      xPos++;
    }
  }
}

