class Object {
  float x;
  float y;
  float speedX = 0;
  float speedY = 0;
  float speedR = 0;
  int limitX = 2000;
  float radius = 20;
  float rotation = 0;
  float distanceToSurface = 0;
  float distanceToSurfacePrev = 0;
  float hp = 100;
  int hurtTimer = 0;
  PImage img;
  boolean flipHorizontal = false;
  boolean flipVertical = false;
  float attackSpeedTheshold = 8;
  int regX;
  int regY;
  int nextFrame = 0;
  int millisPerFrame = 100;

  boolean dead = false;
  boolean bouyant = false;
  boolean sinker = false;
  boolean flyer = false;
  boolean removeMe = false;
  void setImg(PImage img) {
    this.img = img;
    regX = img.width/2;
    regY = img.height/2;
  }
  void tickFrames() {
    if (statePlay.time > nextFrame) {
      nextFrame = statePlay.time + millisPerFrame;
      cueNextFrame();
    }
  }
  void update() {
    tickFrames();
    if (hurtTimer > 0) hurtTimer --;

    distanceToSurfacePrev = distanceToSurface;
    float surface = statePlay.water.getValueAt((int)x);
    distanceToSurface = y - surface;

    if (distanceToSurface < 0) { // in the air
      if (!flyer) speedY += .5;
    } 
    else if (distanceToSurface > 0) { // below water:
      if (bouyant) {
        if (statePlay.water.nearSurface && !statePlay.water.nearSurfacePrev) {
          snapToSurface();
        }
        else if (distanceToSurface < 3) { // near surface 
          speedY = 0;
          y = surface;
        } 
        else {
          if (distanceToSurfacePrev < 0) {
            speedY *= .5; // break the surface
            statePlay.splashAt(this);
          }

          speedY -= .5; // rising to surface
          if (speedY < -3) speedY = -3;
        }
      } 
      else if (sinker) {
        if (speedY < 5) speedY += .005;
      } 
      else {
        speedY *= .95;
      }
      speedX *= .95;
    }
    x += speedX;
    y += speedY;
    if (y > surface + statePlay.water.bottom) {
      y = surface + statePlay.water.bottom;
      speedY -= .5;
    }
  }
  void snapToSurface() {
    y = statePlay.water.getValueAt((int)x);
    rotation = statePlay.water.getSlopeAt((int)x);
  }
  float getDistanceSquaredTo(Object other) {
    float min = radius + other.radius;
    float dx = abs(x - other.x);
    float dy = abs(y - other.y);
    float d2 = dx*dx + dy*dy;
    return d2;
  }
  boolean checkCollision(Object other) {
    float min = radius + other.radius;
    float dx = abs(x - other.x);
    float dy = abs(y - other.y);

    if (dx > min || dy > min) return false;
    float d2 = dx*dx + dy*dy;

    return (d2 < min * min);
  }
  boolean hurt(float amt) {
    if (dead || hurtTimer > 0) return false;
    hp -= amt;
    hurtTimer = 50;
    if (hp <= 0) kill();
    return true;
  }
  void draw() {
    if (img == null) return;
    if (isOffScreen()) return;
    pushMatrix();
    translate(x, y);
    rotate(rotation);
    if (flipVertical && flipHorizontal) scale(-1, -1);
    else if (flipHorizontal) scale(-1, 1);
    else if (flipVertical) scale(1, -1);

    if (img != null) image(img, -regX, -regY);
    popMatrix();
  }
  void cueNextFrame() {
  }
  void wrapPosition() {
    float disToHero = x - statePlay.hero.x;
    if (disToHero > limitX) x -= limitX * 2 - 50;
    else if (disToHero < -limitX) x += limitX * 2 - 50;
  }
  boolean collidesWithHero() {
    if (statePlay.hero.dead) return false;
    if (statePlay.hero.speedLength < attackSpeedTheshold) return false;
    return checkCollision(statePlay.hero);
  }
  boolean isOffScreen() {
    if (statePlay.cam.worldToScreenX(x) > width + 50) return true; // right
    if (statePlay.cam.worldToScreenX(x) < -50) return true; // left
    if (statePlay.cam.worldToScreenY(y) > height + 50) return true; // bottom
    if (statePlay.cam.worldToScreenY(y) < -50) return true; // top
    return false;
  }
  void kill() {
    dead = true;
  }
}

