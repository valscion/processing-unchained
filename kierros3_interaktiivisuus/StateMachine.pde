import java.util.List;
import java.util.LinkedList;
import java.util.Iterator;

class StateMachine {
  List<State> states = new LinkedList<State>();
  Class<?> currentState = null;

  void addState(State state) {
    states.add(state);
    if (currentState == null) {
      currentState = state.getClass();
    }
  }

  void setup() {
    Iterator<State> iter = states.iterator();
    while (iter.hasNext()) {
      State state = iter.next();
      state.setup();
    }
  }

  void draw() {
    Iterator<State> iter = states.iterator();
    State selectedState = null;
    while (iter.hasNext()) {
      State state = iter.next();
      if (state.getClass() == currentState) {
        selectedState = state;
      }
    }
    if (selectedState != null) {
      selectedState.draw();
    }
    else {
      throw new RuntimeException("No state selected!");
    }
  }
}