/*
Andy Dong
March 4, 2019

Shapes
- ellipses: mines
- rectangles: grid, flag
- triangles: flag
- lines: rain
Also 3D shapes; scene is in 3D!
- box, sphere: trees

Colours
- grid: alternating shades of green; grey when clicked; lighter when mouse over
- birds: grey
- background: dark blue
- rain: lighter blue
- lightning: yellow
- text: white numbers and loss message, blue win message
- outlines: black

Custom Shapes
- mines
- birds

Elements
- minesweeper squares (implemented using classes)
- mines
- flags
- birds
- trees
- rain
- lightning

"Alive" Elements
- lightning
- rain
- birds

User Interaction (minesweeper game!)
- mouse
  - allows clicking, flagging, sweeping squares
- keyboard
  - 'n' for manual new game
  - 'r' for toggle rain
  - 'l' for toggle lightning
  - 'f' while clicking to place flag


Note use of translate(0, 0, z) frequently throughout to avoid drawing shapes in the same plane;
this provides full control over the ordering of shapes on the screen (i.e. which is "closer" to the user).

Input is temporarily disabled when the new game is loading.

Heavy modularization allows easy addition of features such as difficulty levels (different board
sizes, number of mines, etc.)
*/


import java.util.Collection;
import java.util.Collections;


final int SQUARE_SIZE = 40;
final int NUM_RAINDROPS = 1000;

MinesweeperGrid mg;
boolean showTitle = false;
boolean won, lost;
Raindrop[] raindrops;
boolean showRain;
boolean showLightning;
int endTime; // -1 for no end time, i.e. game is still ongoing
int delayBetweenGames;
float delayLightning;
int lastLightning;


void setup() {
  text("Avoid lag on first click please lol", 0, -1000);
  noCursor();
  size(800, 800, P3D);
  newGame();
  raindrops = new Raindrop[NUM_RAINDROPS];
  for (int i = 0; i < NUM_RAINDROPS; i++) {
    raindrops[i] = new Raindrop(random(200));
  }
  showRain = true;
  showLightning = true;
  delayLightning = random(600, 1200); // lightning every 10-20 seconds
  lastLightning = frameCount;
  //println("starting lastLightning value: " + lastLightning);
}

void newGame() {
  mg = new MinesweeperGrid(10, 10, new Point(200, 200), SQUARE_SIZE, 10);
  won = lost = false;
  endTime = -1;
}

void drawCursor() {
  pushMatrix();
  translate(0, 0, 2);
  fill(255);
  ellipse(mouseX, mouseY, 5, 5); // in-game cursor
  popMatrix();
}

void drawBirds() {
  // draw birds flying at different speeds
  // use math to vary speed, direction, time off-screen, etc.
  drawBird(width * 1.5 - (frameCount + 200) % (width * 1.5), 200, 50);
  drawBird(1.2 * frameCount % (width * 2.5), 300, 50);
  drawBird((0.8 * frameCount + 350) % (width * 2), 400, 50);
  drawBird((1.6 * frameCount + 750) % (width * 2), 150, 50);
}

void drawTrees() {
  // draw trees around mine field
  drawTree(150, 280, 100);
  drawTree(200, 150, 80);
  drawTree(180, 400, 50);
  drawTree(600, 150, 60);
  drawTree(650, 300, 70);
  drawTree(650, 500, 120);
}

void drawRain() {
  for (int i = 0; i < NUM_RAINDROPS; i++) {
    raindrops[i].displayFrame();
    if (raindrops[i].z <= 0) {
      raindrops[i] = new Raindrop();
    }
  }
}

void drawLightning() {
  background(#FFEB08);
}

void handleWon() {
  fill(#C4CCFC);
  text("Congratulations, you won!", width / 2, height / 25);
  delayBetweenGames = 200;
}

void handleLost() {
  fill(255);
  text("You hit a mine. You lost!", width / 2, height / 25);
  delayBetweenGames = 100;
}

void draw() {
  if (showTitle) {
    // work on this later
    
    return;
  }
  if (showLightning && frameCount - lastLightning >= delayLightning) {
    drawLightning();
    lastLightning = frameCount;
    delayLightning = random(600, 1200);
    return;
  }
  background(#2C4B62);
  rotateX(radians(20));
  drawCursor();
  mg.display(endTime == -1);
  if (won) {
    handleWon();
  } else if (lost) {
    handleLost();
  }
  if (endTime != -1 && frameCount - endTime >= delayBetweenGames) {
    newGame();
  }
  //println("flagged: " + mg.numFlagged);
  drawBirds();
  drawTrees();
  if (showRain) {
    drawRain();
  }
}

void mousePressed() {
  if (endTime != -1) {
    return; // don't take input if game is over
  }
  int[] sq = mg.getSquare(mouseX, mouseY);
  //println("mouse: " + mouseX + ", " + mouseY);
  //println("square: " + sq[0] + ", " + sq[1]);
  if (mouseButton == LEFT) {
    if (sq[0] == -1) {
      return; // didn't click on a square
    }
    if (!keyPressed) {
      if (!mg.grid[sq[0]][sq[1]].isClicked()) {
        mg.clickSquare(sq[0], sq[1]);
      } else {
        mg.sweep(sq[0], sq[1]);
      }
      if (won || lost && endTime == -1) {
        endTime = frameCount;
      }
    } else if (keyPressed && key == 'f') {
      mg.toggleFlagged(sq[0], sq[1]);
    }
  }
}

void keyPressed() {
  switch (key) {
    case 'n': // 'n' for new game
      newGame();
      break;
    case 'r': // 'r' for rain
      showRain ^= true;
      break;
    case 'l': // 'l' for lightning
      showLightning ^= true;
      break;
  }
}
