class State {
  // Called on program start
  void setup() {};
  // Called on every frame when the state is active
  void draw() {};
  // Called when the state changes to be the current one
  void startState() {};
  // Called when the state changes away
  void endState() {};
}