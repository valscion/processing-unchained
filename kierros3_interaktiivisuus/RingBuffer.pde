class RingBuffer {
  float buffer[];
  int currentIndex = 0;
  RingBuffer(int size) {
    buffer = new float[size];
  }

  void addValue(float value) {
    buffer[currentIndex] = value;
    currentIndex++;
    if (currentIndex >= buffer.length) {
      currentIndex = 0;
    }
  }

  float avg() {
    float sum = sum();
    float avg = sum / buffer.length;
    return avg;
  }
  
  float sum() {
    float sum = 0.0;
    for (int i = 0; i < buffer.length; i++) {
      sum += buffer[i];
    }
    return sum;
  }
}
