import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
FFT fft;

int sampleRate= 44100;

float freqhz;
float maxfreq=0;
float amp;
float xRange;
float yRange;
float soundcolor = 0;
float h;
float s = 255;
float b = 255;

//PShape s;

void setup()
{
  size(800, 800, OPENGL);

  minim = new Minim(this); // this starts the audio engine
  in = minim.getLineIn();
  in = minim.getLineIn(Minim.MONO, 4096, sampleRate);
  fft = new FFT(in.left.size(), sampleRate);
}

void draw()
{
  runaudio();

  fft.forward(in.left);
  for (int i = 0; i < sampleRate; i++) 
  {
    if (fft.getFreq(i) > fft.getFreq(maxfreq))
    {
      maxfreq = i;
    }
  }
  // println(maxfreq);

  //r = map(maxfreq, 1000, 16000, 0, 255);
  //g = map(maxfreq, 0, 16000, 0, 255);
  //b = map(maxfreq, 0, 200, 0, 255);

  colorMode(HSB);

  if (maxfreq < 2048) {
    h = map(maxfreq, 60, 2048, 0, 100);
  } else if (maxfreq >= 2048 && maxfreq < 8192)
  {
    h = map(maxfreq, 2048, 8192, 101, 200);
  } else if (maxfreq >= 8192) {
    h = map(maxfreq, 8192, 16834, 201, 300);
  }

  background(h, s, b);
  fill(h, s, b);
  stroke(255);

  float ampheight = map(amp, 0, 0.4, 0, 500);
  // soundcolor = map(amp, 0, 1, 0, 255);

  //float xRange = map(mouseX, 0, width - 1, 0, 70);
  //float zRange = map(mouseY, 0, height - 1, 70, 0);

  translate(width/2, height - 200 - ampheight, 0);
  box(120, 60 + ampheight, 130);
}

void runaudio()
{
  float rawamp = 0.;

  for (int i = 0; i < in.bufferSize () - 1; i++)
  {
    rawamp = rawamp + abs(in.left.get(i)); // add the abs value of the current sample to the amp
  }
  rawamp = rawamp / in.bufferSize();

  amp = mysmooth(rawamp, amp, 0.9);
}

float mysmooth(float x, float y, float a)
{
  return(a*y + (1.0-a)*x);
}

