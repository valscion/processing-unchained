import ddf.minim.analysis.*;
import ddf.minim.*;

class AudioController {
  AudioInput in;
  FFT fftLin;
  RingBuffer smallerRingBuffer;
  RingBuffer largerRingBuffer;

  // The lower bound limit of microphones loudness
  float minimumVolume = 0.4;

  // ----------------
  // Constants controlling highest frequency pick
  // ----------------
  // The range in Hz to calculate average amplitude.
  // The larger the average amplitude in lower range, the faster the player moves down
  private final float LOW_RANGE_START = 100;
  private final float LOW_RANGE_END = 200;
  // The larger the average amplitude in upper range, the faster the player moves up
  private final float HIGH_RANGE_START = 700;
  private final float HIGH_RANGE_END = 800;

  AudioController() {
    in = minim.getLineIn();
    smallerRingBuffer = new RingBuffer(15);
    largerRingBuffer = new RingBuffer(15);
    // create an FFT object that has a time-domain buffer the same size as mics' sample buffer
    // note that this needs to be a power of two
    // and that it means the size of the spectrum will be 1024.
    fftLin = new FFT( in.bufferSize(), in.sampleRate() );
    
    // We calculate averages from frequency ranges manually, so we don't
    // need FFT to calculate them for us beforehand.
    fftLin.noAverages();
    
    // Set a windowing function to get better values out
    fftLin.window(new HannWindow());
  }

  // Updates the frequency values. This should be called in every frame.
  void update() {
    // perform a forward FFT on the samples in mics' mix buffer
    fftLin.forward( in.mix );

    if (isSoundLoudEnough()) {
      float lowAmplitude = fftLin.calcAvg(LOW_RANGE_START, LOW_RANGE_END);
      float highAmplitude = fftLin.calcAvg(HIGH_RANGE_START, HIGH_RANGE_END);
      
      smallerRingBuffer.addValue(lowAmplitude);
      largerRingBuffer.addValue(highAmplitude);
    } else {
      smallerRingBuffer.addValue(0);
      largerRingBuffer.addValue(0);
    }
  }

  // Checks whether the current volume should be counted as loud enough
  boolean isSoundLoudEnough() {
    float currentVolume = getCurrentSoundVolume();
    return (currentVolume > minimumVolume);
  }

  // Gets the current sound volume
  float getCurrentSoundVolume() {
    return in.mix.level() * 100;
  }

  // Sets the new sound limit. If the sound coming from the microphone is more
  // quiet than the value in here, it will not be registered.
  void setSoundLimit(float newLimit) {
    if (newLimit <= 0.0) {
      throw new IllegalArgumentException("Incorrect sound limit");
    }
    minimumVolume = newLimit;
  }

  // Gets the current sound limit
  float getSoundLimit() {
    return minimumVolume;
  }

  // Draws some debug info to the screen
  void drawDebug() {
    noStroke();
    // Draw the calculated sums for smaller and larger ring buffer
    {
      float scale = 2.5 / getSoundLimit();
      fill(0, 0, 255);
      float smallValue = smallerRingBuffer.sum();
      rect(smallValue * scale, height - 50, 5, -40);
      text("down", smallValue * scale + 8, height - 50 - 40/2 + 5);
      
      float largeValue = largerRingBuffer.sum();
      fill(255, 255, 0);
      rect(largeValue * scale, height, 5, -40);
      text("up", largeValue * scale + 8, height - 40/2 + 5);
    }
    
    fill(255);
    float soundValue = soundValue();
    float yChange = soundValue * ((height - 5) / 2);
    rect(width - 20, height / 2 + yChange, 20, 5);
  }

  // Returns the value of sound frequency which can be used to control various
  // things. The value will be in range [-1, 1]
  float soundValue() {
    float diff = (smallerRingBuffer.sum() - largerRingBuffer.sum());
    float clamped = constrain(diff, -10, 10);
    float mappedValue = map(clamped, -10, 10, -1, 1);
    return mappedValue;
  }
}
