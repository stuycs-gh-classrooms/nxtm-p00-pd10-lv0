/**
 Controls:
 'LMB' to delete orbs
 'RMB' to move orbs
 '+' to add a front orb at random coordinates
 '-' to delete the front most orb
 'SPACE' to activate "Moving"
 'B' to activate "Bounce"
 'G' to activate "Gravity"
 'S' to activate "Spring"
 'D' to activate "Drag"
 'U' to activate "Buoyancy"
 'C' to activate "Combination" (Allows you to turn on multiple forces at once)
 'W' to activate "Water" (Only works when buoyancy is turned on)
 'O' to activate "Oil" (Only works when buoyancy is turned on)
 */

/**
 Vincent Zheng
 NeXTCS
 pd10
 p00_ForceSimulation
 3/27/2025
 Time Spent: 3.6 hrs
 */

int NUM_ORBS = 37;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 9.81;
float D_COEF = 1;
float F_DENSITY = 0;

int SPRING_LENGTH = 50;
float SPRING_K = 0.005;

int MOVING = 0;
int BOUNCE = 1;
int GRAVITY = 2;
int SPRING = 3;
int DRAGF = 4;
int BUOYANCY = 5;
int COMBINATION = 6;
int WATER = 0;
int OIL = 1;
boolean[] toggles = new boolean[7];
String[] modes = {"[ ] Moving", "[B] Bounce", "[G] Gravity", "[S] Spring", "[D] Drag", "[U] Buoyancy", "[C] Combination"};
boolean[] mtoggles = new boolean[2]; //medium toggles
String[] mediums = {"[W] Water", "[O] Oil"};

FixedOrb earth;

OrbList orbs;

void setup() {
  fullScreen();

  earth = new FixedOrb(width/2, height * 200, 1, 20000);

  orbs = new OrbList();
  orbs.populate(NUM_ORBS, true);
}//setup

void draw() {
  background(255);
  displayMode();

  orbs.display();

  if (toggles[MOVING]) {
    orbs.run(toggles[BOUNCE]);
  }//moving

  if (toggles[BUOYANCY]) {
    if (toggles[COMBINATION]) {
      if (mtoggles[WATER]) {
        fill(#def4fc, 80);
        rect(0, 0, width, height);
      }
      if (mtoggles[OIL]) {
        fill(#dbcf5c, 80);
        rect(0, 0, width, height);
      }
    } else {
      if (mtoggles[WATER]) {
        fill(#def4fc, 80);
        rect(0, 200, width, height - 200);
      }
      if (mtoggles[OIL]) {
        fill(#dbcf5c, 80);
        rect(0, 200, width, height - 200);
      }
    }
  }

  gravitySimulation();
  springSimulation();
  dragSimulation();
  buoyancySimulation();
}//draw

void mousePressed() {
  if (mouseButton == LEFT) {
    OrbNode selected = orbs.getSelected(mouseX, mouseY);
    if (selected != null) {
      orbs.removeNode(selected);
    }
  }
}//mousePressed

void mouseDragged() {
  if (mouseButton == RIGHT) {
    OrbNode selected = orbs.getSelected(mouseX, mouseY);
    if (selected != null) {
      selected.center.x = mouseX;
      selected.center.y = mouseY;
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    toggles[MOVING] = !toggles[MOVING];
  }
  if (key == 'b') {
    toggles[BOUNCE] = !toggles[BOUNCE];
  }
  if (key == 'g') {
    toggles[GRAVITY] = !toggles[GRAVITY];
    if (toggles[GRAVITY]) {
      if (!toggles[COMBINATION]) {
        toggles[SPRING] = false;
        toggles[DRAGF] = false;
        toggles[BUOYANCY] = false;
        orbs.populate(NUM_ORBS, true);
      }
    }
  }
  if (key == 's') {
    toggles[SPRING] = !toggles[SPRING];
    if (toggles[SPRING]) {
      if (!toggles[COMBINATION]) {
        toggles[GRAVITY] = false;
        toggles[DRAGF] = false;
        toggles[BUOYANCY] = false;
        orbs.populate(NUM_ORBS, false);
      }
    }
  }
  if (key == 'd') {
    toggles[DRAGF] = !toggles[DRAGF];
    if (toggles[DRAGF]) {
      if (!toggles[COMBINATION]) {
        toggles[GRAVITY] = false;
        toggles[SPRING] = false;
        toggles[BUOYANCY] = false;
        orbs.populate(NUM_ORBS, true);
      }
    }
  }
  if (key == 'u') {
    toggles[BUOYANCY] = !toggles[BUOYANCY];
    if (toggles[BUOYANCY]) {
      if (!toggles[COMBINATION]) {
        toggles[GRAVITY] = false;
        toggles[SPRING] = false;
        toggles[DRAGF] = false;
        orbs.populate(NUM_ORBS, true);
      }
    }
  }
  if (key == 'c') {
    toggles[COMBINATION] = !toggles[COMBINATION];
    toggles[GRAVITY] = false;
    toggles[SPRING] = false;
    toggles[DRAGF] = false;
    toggles[BUOYANCY] = false;
  }
  if (key == 'w') {
    mtoggles[WATER] = !mtoggles[WATER];
    F_DENSITY = 0.01;
    mtoggles[OIL] = false;
  }
  if (key == 'o') {
    mtoggles[OIL] = !mtoggles[OIL];
    F_DENSITY = 0.007;
    mtoggles[WATER] = false;
  }
  if (key == '=' || key =='+') {
    orbs.addFront(new OrbNode());
  }
  if (key == '-') {
    orbs.removeFront();
  }
  if (key == '1') {
    orbs.populate(NUM_ORBS, true);
  }
  if (key == '2') {
    orbs.populate(NUM_ORBS, false);
  }
  if (keyCode == UP) {
    G_CONSTANT +=  0.01;
  }
  if (keyCode == DOWN) {
    G_CONSTANT -= 0.01;
  }
  if (keyCode == RIGHT) {
    SPRING_K += 0.001;
  }
  if (keyCode == LEFT) {
    SPRING_K -= 0.001;
  }
  if (key == 'z') {
    D_COEF -= 0.1;
  }
  if (key == 'x') {
    D_COEF += 0.1;
  }
}//keyPressed


void displayMode() {
  textAlign(LEFT, TOP);
  textSize(20);
  noStroke();
  int spacing = 85;
  int x = 0;

  for (int m=0; m<toggles.length; m++) {
    //set box color
    if (toggles[m]) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }

    float w = textWidth(modes[m]);
    rect(x, 0, w+5, 20);
    fill(0);
    text(modes[m], x+2, 2);
    x+= w+5;
  }

  x = 0;

  for (int m=0; m<mtoggles.length; m++) {
    //set box color
    if (mtoggles[m]) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }

    float w = textWidth(mediums[m]);
    rect(x, 20, w+5, 20);
    fill(0);
    text(mediums[m], x+2, 22);
    x+= w+5;
  }

  text("[UP] [DOWN] gravity constant: " + G_CONSTANT, width - 310, 0);
  text("[LEFT] [RIGHT] spring constant: " + SPRING_K, width - 310, 20);
  text("[Z] [X] drag coefficient: " + D_COEF, width - 310, 40);
}//display

void gravitySimulation() {
  if (toggles[MOVING]) {
    if (toggles[GRAVITY]) {
      orbs.applyGravity(earth, G_CONSTANT);
    }//moving
  }
}

void springSimulation() {
  if (toggles[MOVING]) {
    if (toggles[SPRING]) {
      orbs.applySprings(SPRING_LENGTH, SPRING_K);
    }
  }//moving
}

void dragSimulation() {
  if (toggles[MOVING]) {
    if (toggles[DRAGF]) {
      orbs.applyDrag(D_COEF);
    }
  }
}

void buoyancySimulation() {
  if (toggles[MOVING]) {
    if (toggles[BUOYANCY]) {
      orbs.applyBuoyancy(F_DENSITY);
    }
  }
}
