class MinesweeperSquare {
  Point topLeft;
  int sideLength;
  boolean clicked = false; // left-clicked
  boolean flagged = false;
  int value = -2; // -1 for mine, -2 for unclicked
  
  MinesweeperSquare(Point topLeft, int sideLength) {
    this.topLeft = topLeft;
    assert sideLength > 0;
    this.sideLength = sideLength;
  }
  
  void setValue(int value) {
    this.value = value;
  }
  
  int getValue() {
    return value;
  }
  
  boolean isMine() {
    return value == -1;
  }
  
  void setClicked(boolean clicked) {
    this.clicked = clicked;
  }
  
  boolean isClicked() {
    return clicked;
  }
  
  void setFlagged(boolean flagged) {
    this.flagged = flagged;
  }
  
  void toggleFlagged() {
    setFlagged(!flagged);
  }
  
  boolean isFlagged() {
    return flagged;
  }
  
  void display() {
    rect(topLeft.x, topLeft.y, sideLength, sideLength);
    float centreX = topLeft.x + sideLength / 2;
    float centreY = topLeft.y + sideLength / 2;
    if (isFlagged()) {
      drawFlag(centreX, centreY, 4.0 / 5 * sideLength);
      return;
    }
    if (!isClicked()) {
      return;
    }
    if (isMine()) {
      drawMine(centreX, centreY, 4.0 / 5 * sideLength);
    } else {
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(3.0 / 5 * sideLength);
      pushMatrix();
      translate(0, 0, 0.2); // show text slightly above game board
      text(value == 0 ? "" : Integer.toString(value), centreX, centreY);
      popMatrix();
    }
  }
  
  boolean contains(int x, int y) {
    // returns whether (x, y) is in this square
    return topLeft.x < x && x < topLeft.x + sideLength
        && topLeft.y < y && y < topLeft.y + sideLength;
    // used strict inequalities to avoid being in multiple squares when on boundary
  }
}
