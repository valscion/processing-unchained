import ddf.minim.*;

class AudioController {
  Minim minim;
  AudioInput in;

  AudioController() {
    minim = new Minim(this);
    in = minim.getLineIn();
  }

  void draw() {
     // draw the waveforms
    // the values returned by left.get() and right.get() will be between -1 and 1,
    // so we need to scale them up to see the waveform
    for(int i = 0; i < in.bufferSize() - 1; i++)
    {
      line(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
      line(i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
    }
  }
}