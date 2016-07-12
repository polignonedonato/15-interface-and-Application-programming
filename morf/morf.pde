
import processing.serial.*;

import geomerative.*;

RShape   grp;
RShape   circle;

boolean ignoringStyles = false;


Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
float t=0.01;

void setup() 
{
  size(600, 600);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myPort = new Serial(this, "/dev/tty.usbserial-AI049V5J", 9600);


  smooth();

  // VERY IMPORTANT: Allways initialize the library before using it
  RG.init(this);

  grp = RG.loadShape("bot1.svg");

  RG.setPolygonizer(RG.ADAPTATIVE);
  RG.setPolygonizerAngle(0.045);
  grp = RG.polygonize(grp);

  circle = RG.getEllipse(0, 0, 20);
  circle = RG.centerIn(circle, g, 220);
}

void draw() {

  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();         // read it and store it in val
    println(val);
  }
  if (t > 0.98) {
    t = 0.01;
  }
  
  else if (val == 100) {
    t = t +0.01;
  }
  
println(t);
  translate(width/2, height/2);
  background(#2D4D83);

  noFill();
  stroke(255, 200);

  RShape circleSeg = RG.split(circle, t)[0];

  RG.setAdaptor(RG.BYPOINT);
  RShape adaptedGrp = RG.adapt(grp, circleSeg);

  RG.shape( adaptedGrp );
  RG.shape( circleSeg );
}