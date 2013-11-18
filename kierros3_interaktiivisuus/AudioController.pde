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
    // create an FFT object that has a time-domain buffer the same size as mics' sample buffer
    // note that this needs to be a power of two
    // and that it means the size of the spectrum will be 1024.
    fftLin = new FFT( in.bufferSize(), in.sampleRate() );
  }

  void draw() {
    // perform a forward FFT on the samples in mics' mix buffer
    fftLin.forward( in.mix );

    // draw the linear averages
    noStroke();
    {
      int avSize = 150;
      float averages[] = new float[avSize];
      // Lowest frequency from which we start analyzing the sound
      float minFreq = 30;
      // The frequency step between calculated averages
      float step = 4;
      // Average amplitude of all the frequencies to be measured
      float allAverage = fftLin.calcAvg(minFreq, minFreq + avSize*step);
      // Count of frequencies which are louder than the average and either smaller
      // or higher than the middle of analyzed frequency
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
      // Find the strongest frequency band from the averages spectrum for
      // debugging purposes
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

      // Draw the rectangles showing the measured averages
      float height23 = 2 * height / 3;
      int w = int( width / averages.length );
      for(int i = 0; i < averages.length; i++) {
        if ( i == strongestIndex ) {
          fill(255, 0, 0);
        }
        else {
            fill(255);
        }
        // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
        float rectHeight = averages[i]*spectrumScale;
        rect(i*w, 200, w, -rectHeight);
      }
      fill(255);

      // If mic input is large enough, store the current smaller and larger frequencies count
      // to a ring buffer in order to be able to smooth the movement of controls
      if (in.mix.level() * 100 > 2.0) {
        smallerRingBuffer.addValue(smallerCount);
        largerRingBuffer.addValue(largerCount);
      }
      text("Volume: " + in.mix.level() * 100, 10, 30);
    }
    float diff = (smallerRingBuffer.avg() - largerRingBuffer.avg());
    text("Diff: " + diff, 10, 10);
    rect(width - 20, height / 2 + (diff * 5), 20, 5);
  }
}