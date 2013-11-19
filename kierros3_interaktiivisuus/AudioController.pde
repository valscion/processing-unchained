import ddf.minim.analysis.*;
import ddf.minim.*;

class AudioController {
  Minim minim;
  AudioInput in;
  FFT fftLin;
  float spectrumScale = 4;
  RingBuffer smallerRingBuffer;
  RingBuffer largerRingBuffer;

  // ----------------
  // Values controlling highest frequency pick
  // ----------------
  // How many averages will be counted
  private final int AVERAGES_COUNT = 150;
  // The array to store all the averages. This needs to be initialized only once
  // and the values can be replaced
  private final float AVERAGES_ARR[] = new float[AVERAGES_COUNT];
  // Lowest frequency from which we start analyzing the sound
  private final float MIN_FREQ = 30;
  // The frequency step between calculated averages
  private final float FREQ_STEP = 4;

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
      // Average amplitude of all the frequencies to be measured
      float allAverage = fftLin.calcAvg(MIN_FREQ, MIN_FREQ + AVERAGES_COUNT*FREQ_STEP);
      // Count of frequencies which are louder than the average and either smaller
      // or higher than the middle of analyzed frequency
      int smallerCount = 0;
      int largerCount = 0;
      for (int i = 0; i < AVERAGES_COUNT; i++) {
        float thisAvg = fftLin.calcAvg(MIN_FREQ + i * FREQ_STEP, MIN_FREQ + (i+1) * FREQ_STEP);
        AVERAGES_ARR[i] = thisAvg;
        if (thisAvg > (allAverage * 0.75)) {
          if (i > AVERAGES_COUNT / 2) {
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
        for (int i = 0; i < AVERAGES_COUNT; i++) {
          if (AVERAGES_ARR[i] > tmpStrongest) {
            tmpStrongest = AVERAGES_ARR[i];
            strongestIndex = i;
          }
        }
      }

      // Draw the rectangles showing the measured averages
      float height23 = 2 * height / 3;
      int w = int( width / AVERAGES_ARR.length );
      for(int i = 0; i < AVERAGES_ARR.length; i++) {
        if ( i == strongestIndex ) {
          fill(255, 0, 0);
        }
        else {
            fill(255);
        }
        // draw a rectangle for each average, multiply the value by spectrumScale so we can see it better
        float rectHeight = AVERAGES_ARR[i]*spectrumScale;
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