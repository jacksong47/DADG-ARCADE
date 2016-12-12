static class Keys {
  static boolean A = false;
  static boolean W = false;
  static boolean D = false;
  static boolean S = false;
  static boolean P = false;
  static boolean LEFT = false;
  static boolean RIGHT = false;
  static boolean UP = false;
  static boolean DOWN = false;
  static boolean SPACE = false;
  static boolean ENTER = false;
  ///////////////////////////////// PREVIOUS:
  static boolean PREV_A = false;
  static boolean PREV_W = false;
  static boolean PREV_D = false;
  static boolean PREV_S = false;
  static boolean PREV_P = false;
  static boolean PREV_LEFT = false;
  static boolean PREV_RIGHT = false;
  static boolean PREV_UP = false;
  static boolean PREV_DOWN = false;
  static boolean PREV_SPACE = false;
  static boolean PREV_ENTER = false;
  static void Update() {
    Keys.PREV_A = Keys.A;
    Keys.PREV_W = Keys.W;
    Keys.PREV_D = Keys.D;
    Keys.PREV_S = Keys.S;
    Keys.PREV_P = Keys.P;
    Keys.PREV_LEFT = Keys.LEFT;
    Keys.PREV_RIGHT = Keys.RIGHT;
    Keys.PREV_UP = Keys.UP;
    Keys.PREV_DOWN = Keys.DOWN;
    Keys.PREV_SPACE = Keys.SPACE;
    Keys.PREV_ENTER = Keys.ENTER;
  }
  static void Set(int code, boolean pressed) {
    switch(code) {
    case 32:
      Keys.SPACE = pressed;
      break;
    case 37:
      Keys.LEFT = pressed;
      break;
    case 38:
      Keys.UP = pressed;
      break;
    case 39:
      Keys.RIGHT = pressed;
      break;
    case 40:
      Keys.DOWN = pressed;
      break;
    case 65:
      Keys.A = pressed;
      break;
    case 87:
      Keys.W = pressed;
      break;
    case 68:
      Keys.D = pressed;
      break;
    case 83:
      Keys.S = pressed;
      break;
    case 80:
      Keys.P = pressed;
      break;
    case 10:
      Keys.ENTER = pressed;
      break;
    }
  }
}


void keyPressed() {
  Keys.Set(keyCode, true);
}
void keyReleased() {
  Keys.Set(keyCode, false);
}

