class Raindrop {
  private static final int RAIN_SPEED = 10;
  
  float x, y, z;
  boolean show = true;
  
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
  
  void setShown(boolean show) {
    this.show = show;
  }
  
  void displayFrame() {
    if (!show) {
      return;
    }
    fill(0, 0, 128);
    line(x, y, z, x, y, z - 10);
    z -= RAIN_SPEED;
  }
}
