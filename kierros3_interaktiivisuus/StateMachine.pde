import java.util.List;
import java.util.LinkedList;
import java.util.Iterator;

class StateMachine {
  List<State> states = new LinkedList<State>();
  String currentStateName = null;

  void addState(State state) {
    states.add(state);
  }

  void changeState(Class<?> stateClass) {
    String newStateName = stateClass.getName();
    if (newStateName != currentStateName) {
      State newState = findStateByName(newStateName);
      if (currentStateName != null) {
        State oldState = getCurrentState();
        oldState.endState();
      }
      newState.startState();
      currentStateName = newStateName;
    }
  }

  State getState(Class<?> stateClass) {
    String stateName = stateClass.getName();
    State state = findStateByName(stateName);
    return state;
  }

  void setup() {
    Iterator<State> iter = states.iterator();
    while (iter.hasNext()) {
      State state = iter.next();
      state.setup();
      println("state.getClass().getName(): "+state.getClass().getName());
    }
  }

  void draw() {
    State currentState = getCurrentState();
    pushStyle();
    currentState.draw();
    popStyle();
  }
  // --------------------------------------------------------
  // Private methods
  // --------------------------------------------------------

  private State findStateByName(String stateName) {
    Iterator<State> iter = states.iterator();
    State selectedState = null;
    while (iter.hasNext()) {
      State state = iter.next();
      if (state.getClass().getName() == stateName) {
        selectedState = state;
      }
    }
    if (selectedState != null) {
      return selectedState;
    }
    else {
      String err = String.format("No state found with name %s!", stateName);
      throw new RuntimeException(err);
    }
  }

  private State getCurrentState() {
    return findStateByName(currentStateName);
  }

}