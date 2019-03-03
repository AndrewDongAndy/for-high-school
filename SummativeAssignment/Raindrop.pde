class Raindrop {
  private static final int RAIN_SPEED = 10;
  
  float x, y, z;
  
  Raindrop(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  Raindrop() {
    this(200);
  }
  
  Raindrop(float z) {
    this(random(width), random(height), z);
  }
  
  void displayFrame() {
    fill(0, 0, 128);
    line(x, y, z, x, y, z - 10);
    z -= RAIN_SPEED;
  }
}
