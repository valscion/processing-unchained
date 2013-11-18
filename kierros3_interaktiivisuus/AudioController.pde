import ddf.minim.analysis.*;
import ddf.minim.*;

class AudioController {
  Minim minim;
  AudioInput in;
  FFT fftLin;
  float spectrumScale = 4;
  RingBuffer smallerRingBuffer;
  RingBuffer largerRingBuffer;

  AudioController() {
    minim = new Minim(this);
    in = minim.getLineIn();
    smallerRingBuffer = new RingBuffer(15);
    largerRingBuffer = new RingBuffer(15);
    setupFFT();
  }

  void draw() {
    // perform a forward FFT on the samples in mics' mix buffer
    fftLin.forward( in.mix );

     // draw the waveforms
    // the values returned by left.get() and right.get() will be between -1 and 1,
    // so we need to scale them up to see the waveform
    for(int i = 0; i < in.bufferSize() - 1; i++)
    {
      line(i, 50 + in.mix.get(i)*50, i+1, 50 + in.mix.get(i+1)*50);
    }


    // draw the linear averages
    noStroke();
    //rectMode(CORNERS);
    {
      int avSize = 150;
      float averages[] = new float[avSize];
      float minFreq = 30;
      float step = 4;
      float allAverage = fftLin.calcAvg(minFreq, minFreq + avSize*step);
      int smallerCount = 0;
      int largerCount = 0;
      for (int i = 0; i < avSize; i++) {
        float thisAvg = fftLin.calcAvg(minFreq + i * step, minFreq + (i+1) * step);
        averages[i] = thisAvg;
        if (thisAvg > (allAverage * 0.75)) {
          if (i > avSize / 2) {
            largerCount++;
          }
          else {
            smallerCount++;
          }
        }
      }
      int strongestIndex = 0;
      {
        float tmpStrongest = 0.0;
        for (int i = 0; i < avSize; i++) {
          if (averages[i] > tmpStrongest) {
            tmpStrongest = averages[i];
            strongestIndex = i;
          }
        }
      }
      float height23 = 2 * height / 3;
      // since linear averages group equal numbers of adjacent frequency bands
      // we can simply precalculate how many pixel wide each average's
      // rectangle should be.
      int w = int( width / averages.length );
      for(int i = 0; i < averages.length; i++)
      {
        if ( i == strongestIndex )
        {
          fill(255, 0, 0);
        }
        else
        {
            fill(255);
        }
        // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
        float rectHeight = averages[i]*spectrumScale;
        rect(i*w, 200, w, -rectHeight);
      }
      fill(255);
      if (in.mix.level() * 100 > 2.0) {
        smallerRingBuffer.addValue(smallerCount);
        largerRingBuffer.addValue(largerCount);
      }
      text("Volume: " + in.mix.level() * 100, 10, 30);
    }
    float diff = (largerRingBuffer.avg() - smallerRingBuffer.avg());
    text("Diff: " + diff, 10, 10);
    rect(width - 20, height / 2 + (diff * 10), 20, 5);

  }

  private void setupFFT() {
    // create an FFT object that has a time-domain buffer the same size as mics' sample buffer
    // note that this needs to be a power of two
    // and that it means the size of the spectrum will be 1024.
    fftLin = new FFT( in.bufferSize(), in.sampleRate() );

    // calculate the averages by grouping frequency bands linearly. use 30 averages.
    //fftLin.logAverages( 11, 2 );
  }
}