// SPIROGRAPH
// http://en.wikipedia.org/wiki/Spirograph
// also (for inspiration):
// http://ensign.editme.com/t43dances
//
// this processing sketch uses simple OpenGL transformations to create a
// Spirograph-like effect with interlocking circles (called sines).  
// press the spacebar to switch between tracing and
// showing the underlying geometry.
//
// your tasks:
// (1) tweak the code to change the simulation so that it draws something you like.
// hint: you can change the underlying system, the way it gets traced when you hit the space bar,
// or both.  try to change *both*.  :)
// (2) use minim to make the simulation MAKE SOUND.  the full minim docs are here:
// http://code.compartmental.net/minim/
// hint: the website for the docs has three sections (core, ugens, analysis)... look at all three
// another hint: minim isn't super efficient with a large number of things playing at once.
// see if there's a simple way to get an effective sound, or limit the number of shapes
// you're working with.

import ddf.minim.*; //importing minim
import ddf.minim.ugens.*; 

Minim minim; //initialize minim
AudioOutput out; //initialize audio output
Oscil wave; //initialize oscillator

int NUMSINES = 20; // how many of these things can we do at once?
float[] sines = new float[NUMSINES]; // an array to hold all the current angles
float rad; // an initial radius value for the central sine
int i; // a counter variable

// play with these to get a sense of what's going on:
float fund = 0.02; // the speed of the central sine
float ratio = 1.5; // what multiplier for speed is each additional sine?
int alpha = 75; // how opaque is the tracing system

float eradius = 0;

boolean trace = false; // are we tracing?

void setup()
{
  size(800, 600, P3D); // OpenGL mode
  
  minim = new Minim(this);
  out = minim.getLineOut();
  
  wave = new Oscil(440, 0.6, Waves.SINE);
  wave.patch(out);

  rad = height/4.; // compute radius for central circle
  background(255); // clear the screen

  for (int i = 0; i<sines.length; i++)
  {
    sines[i] = PI; // start EVERYBODY facing NORTH
  }
}

void draw()
{

  if (!trace) background(255); // clear screen if showing geometry
  if (!trace) {
    stroke(0, 255); // black pen
    noFill(); // don't fill
  }  

  // MAIN ACTION
  pushMatrix(); // start a transformation matrix
  translate(width/2, height/2); // move to middle of screen

  for (i = 0; i<sines.length; i++) // go through all the sines
  {
    float erad = 0; // radius for small "point" within circle... this is the 'pen' when tracing
    // setup tracing
    if (trace) {
      stroke(0, 255*(float(i)/sines.length), 0, alpha); // blue
      fill(random(0,255), 0, random(0,255), alpha/2); // also, um, blue
      erad = 5.0*(1.0-float(i)/sines.length); // pen width will be related to which sine
      eradius = erad;
    }
    float radius = rad/(i+1); // radius for circle itself
    wave.setFrequency(map(sines[i], (sines[0]+(fund+(fund*i*ratio)))%TWO_PI, (sines[19]+(fund+(fund*i*ratio)))%TWO_PI, mtof(40), mtof(60)));
    wave.setAmplitude(map(radius, 0, rad/(NUMSINES+1), 0.4,0.7));
    rotateZ(sines[i]); // rotate circle
    if (!trace) ellipse(0, 0, radius*2, radius*2); // if we're simulating, draw the sine
    pushMatrix(); // go up one level
    translate(0, radius*1.5); // move to sine edge
    if (!trace) ellipse(0, 0, 5, 5); // draw a little circle
    if (trace) ellipse(0, 0, erad, erad); // draw with erad if tracing
    popMatrix(); // go down one level
    translate(0, radius*1.5); // move into position for next sine
    sines[i] = (sines[i]+(fund+(fund*i*ratio)))%TWO_PI; // update angle based on fundamental
  }
  popMatrix(); // pop down final transformation
}

void keyReleased()
{
  if (key==' ') {
    trace = !trace; 
    background(255);
  }
}

float mtof(int note) // mtof
{
  return (440. * exp(0.057762265 * (note - 69.)));
}
