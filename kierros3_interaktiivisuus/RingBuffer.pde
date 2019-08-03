class RingBuffer {
  int buffer[];
  int currentIndex = 0;
  RingBuffer(int size) {
    buffer = new int[size];
  }

  void addValue(int value) {
    buffer[currentIndex] = value;
    currentIndex++;
    if (currentIndex >= buffer.length) {
      currentIndex = 0;
    }
  }

  float avg() {
    float sum = 0.0;
    for (int i = 0; i < buffer.length; i++) {
      sum += buffer[i];
    }
    float avg = sum / buffer.length;
    return avg;
  }
}
