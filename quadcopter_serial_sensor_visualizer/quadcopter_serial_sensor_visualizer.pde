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

void setup () {
  // set the window size:
  size(1200, 900);        

  // List all the available serial ports
  int l = Serial.list().length;
  String[] supercereal = new String[l];
  supercereal=Serial.list();
  int i=0;
  for (; i<l; i++)
  {
    String[] m2 = match(supercereal[i], "tty.usbmodem");
    if (m2 != null)
    {
      println("Found " + supercereal[i]);
      break;
    }
  }
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[i], 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  // set inital background:
  background(0);
}
void draw () {
  // everything happens in the serialEvent()
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');
  boolean graph = false;
  int yoffset = 255;
  println(inString);
  if (inString != null) {
    // trim off any whitespace:
    inString = trim(inString);

    //switch graphs
    print("1 ");
    if (inString.length()<2) {
      println("PING!");
      return;
    }
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
      println("2D");
      break;
    }

    //
    //    if (graph == 1)
    //    {
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

    //    }
  }
}

