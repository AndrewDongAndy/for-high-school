/*
Andy Dong
Mr. Schaeffer
TEJ 3M
March 4, 2019

A game of minesweeper in a dark, gloomy atmosphere...

Right-click to place a flag
Click on an already-clicked square to sweep adjacent squares
Press r to toggle rain
Press l to toggle lightning
Press n for a new game at any time (will automatically start a new game when game over)

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
- cursor

"Alive" Elements
- lightning
- rain
- birds

User Interaction (minesweeper game!)
- mouse
  - left click fpr clicking and sweeping squares
  - right click to place a flag
- keyboard
  - 'n' for manual new game
  - 'r' for toggle rain
  - 'l' for toggle lightning

Comments
- whenever a line adds something to the screen (text, rect, ellipse, etc.)
- loops (for and while); used frequently to loop through arrays (1D and 2D)
- if/else if/else; used nearly everywhere


Additional Notes

Note the use of translate(0, 0, z) frequently throughout to avoid drawing shapes in the same plane;
this provides full control over the ordering of shapes on the screen (i.e. which is "closer" to the user).

Mouse input is temporarily disabled when the new game is loading.

Heavy modularization allows easy addition of features such as difficulty levels (different board
sizes, number of mines, etc.)

To change the board size, change the BOARD_SIZE variable in the code.
(Only square boards work as of now to avoid window-resizing shenanigans.)

Note that the minesweeper game may still be a bit buggy, however it works
well in most cases.
*/


import java.util.Collection;
import java.util.Collections;


final int BOARD_SIZE = 15;
final float SQUARE_SIZE = 400.0 / BOARD_SIZE;
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
  textAlign(CENTER);
  text(".", 0, -1000); // to avoid lag on the first appearance of text
  noCursor();
  size(800, 800, P3D);
  newGame();
  initRaindrops();
  showRain = true;
  showLightning = true;
  delayLightning = random(600, 1200); // lightning every 10-20 seconds
  lastLightning = frameCount;
  //println("starting lastLightning value: " + lastLightning);
}

void newGame() {
  mg = new MinesweeperGrid(BOARD_SIZE, BOARD_SIZE, new Point(200, 200), SQUARE_SIZE, 40);
  won = lost = false;
  endTime = -1;
  // uncomment the below lines to see the grid
//  for (int y = 0; y < mg.n; y++) {
//    for (int x = 0; x < mg.m; x++) {
//      print(mg.grid[y][x].getValue() + " ");
//    }
//    println();
//  }
//  println();
}

void drawCursor() {
  pushMatrix();
  translate(0, 0, 2); // display slightly above the board
  fill(255);
  ellipse(mouseX, mouseY, 5, 5); // in-game cursor
  popMatrix();
}

void drawBirds() {
  // draw birds flying at different speeds
  // use math (!) to vary speed, direction, time off-screen, etc.
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

void initRaindrops() {
  raindrops = new Raindrop[NUM_RAINDROPS];
  for (int i = 0; i < NUM_RAINDROPS; i++) { // for each raindrop
    raindrops[i] = new Raindrop(random(200)); // spawn a new raindrop at a random height
  }
}

void drawRain() {
  // the existing raindrops keep falling when the rain is disabled;
  // however, no new raindrops will spawn
  for (int i = 0; i < NUM_RAINDROPS; i++) { // for each raindrop
    raindrops[i].displayFrame(); // automatically decrements z value of raindrop
    if (raindrops[i].z <= -5) { // raindrop is below the board plane; respawn or hide
      if (showRain) { // if user wants rain, spawn a new raindrop at the top
        raindrops[i] = new Raindrop();
      } else { // hide the raindrop for future frames
        raindrops[i].setShown(false);
      }
    }
  }
}

void drawLightning() {
  background(#FFEB08); // set background to a bright yellow
}

void handleWon() {
  fill(#C4CCFC);
  textSize(20);
  text("Congratulations, you won!", width / 2, height / 15); // win prompt
  delayBetweenGames = 200;
}

void handleLost() {
  fill(255);
  textSize(20);
  text("You hit a mine. You lost!", width / 2, height / 15); // lose prompt
  delayBetweenGames = 100;
}

void showMinesLeft() {
  fill(255);
  textSize(20);
  text("Mines remaining: " + max(0, mg.mines - mg.numFlagged), width / 2, height / 50); // mines left
}

void draw() {
  if (showTitle) {
    // work on this later
    
    return;
  }
  if (showLightning && frameCount - lastLightning >= delayLightning) { // it has been long enough since the last lightning strike
    drawLightning();
    lastLightning = frameCount;
    delayLightning = random(600, 1200);
    return;
  }
  background(#2C4B62);
  rotateX(radians(20));
  drawCursor();
  mg.display(endTime == -1);
  if (won) { // user won the game
    handleWon();
  } else if (lost) { // user lost the game
    handleLost();
  }
  if (endTime != -1 && frameCount - endTime >= delayBetweenGames) { // it has been long enough since the last game ended
    newGame();
  }
  // draw scenery and update game
  drawBirds();
  drawTrees();
  drawRain();
  showMinesLeft();
}

void mousePressed() {
  if (endTime != -1) { // game was over
    return; // don't take input
  }
  int[] sq = mg.getSquare(mouseX, mouseY);
  if (sq[0] == -1) { // didn't click on a square
    return;
  }
  if (mouseButton == LEFT) { // left mouse button was clicked
    if (mg.grid[sq[0]][sq[1]].isClicked()) { // was a sweep
      mg.sweep(sq[0], sq[1]);
    } else { // wasn't a sweep (just a normal click)
      mg.clickSquare(sq[0], sq[1]);
    }
    if (won || lost && endTime == -1) { // game over, and endTime was uninitialized
      endTime = frameCount; // initialize to the frameCount of the game over time
    }
  } else if (mouseButton == RIGHT) { // right mouse button was clicked
    mg.toggleFlagged(sq[0], sq[1]);
  }
}

void keyPressed() {
  switch (key) { // find which key was clicked
    case 'n': // 'n' for new game
      newGame();
      break;
    case 'r': // 'r' for rain
      showRain = !showRain;
      if (showRain) { // user now wants rain
        initRaindrops();
      }
      break;
    case 'l': // 'l' for lightning
      showLightning ^= true;
      break;
  }
}
