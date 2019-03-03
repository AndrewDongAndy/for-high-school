void drawMine(float x, float y, float sz) {
  // centred at (x, y)
  // sz is height and width of mine
  float h = sz / 2;
  pushMatrix();
  translate(0, 0, 0.2);
  fill(128);
  ellipse(x, y, sz, sz);
  pushMatrix();
  translate(0, 0, 0.2);
  ellipse(x, y, 2.0 / 3 * sz, 2.0 / 3 * sz); // draw slightly above above circle
  pushMatrix();
  translate(0, 0, 0.2); // draw slightly above circles
  fill(0);
  beginShape(); // mine
  vertex(x, y - h);
  vertex(x + h / 3, y - h / 3);
  vertex(x + h, y);
  vertex(x + h / 3, y + h / 3);
  vertex(x, y + h);
  vertex(x - h / 3, y + h / 3);
  vertex(x - h, y);
  vertex(x - h / 3, y - h / 3);
  endShape(CLOSE);
  popMatrix();
  popMatrix();
  popMatrix();
}

void drawFlag(float x, float y, float sz) {
  // centred at (x, y)
  // sz is height and width of flag
  pushMatrix();
  translate(0, 0, 0.2);
  fill(0);
  noStroke();
  rect(x - sz / 3, y + sz / 3, 2 * sz / 3, sz / 10); // base
  rect(x - sz / 10, y - sz / 3, sz / 10, 2 * sz / 3); // pole
  stroke(1);
  pushMatrix();
  translate(0, 0, 0.2);
  fill(255, 0, 0);
  triangle(x - sz / 10, y - sz / 3, x - sz / 10, y + sz / 6, x + sz / 3, y - sz / 6); // red flag
  popMatrix();
  popMatrix();
}

void drawBird(float x, float y, float z) {
  pushMatrix();
  translate(x, y, z);
  fill(64);
  beginShape();
  vertex(0, 0, 0); // top left
  vertex(10, 0, 0);
  vertex(40, 0, -20);
  vertex(70, 0, 0);
  vertex(80, 0, 0); // top right
  vertex(40, 0, -40); // lowest point of bird
  endShape(CLOSE);
  popMatrix();
}

void drawTree(float x, float y, float h) {
  pushMatrix();
  translate(x, y);
  fill(#553434);
  box(20, 20, h);
  pushMatrix();
  fill(#32810C);
  translate(0, 0, h / 2);
  sphere(h / 3);
  popMatrix();
  popMatrix();
}
