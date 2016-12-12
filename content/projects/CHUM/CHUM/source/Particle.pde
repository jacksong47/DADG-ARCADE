class Particle {
  int life = 0;
  int lifeSpan = 20;
  int alpha = 255;
  int alphaSpeed = 10;
  float x = 0;
  float y = 0;
  float speedX = 0;
  float speedY = 0;
  float speedR = 0;
  float rotation = 0;
  boolean dead = false;

  boolean bouyant = false;
  float bouyancy = 0;

  Particle(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    
    if(bouyant || bouyancy > 0) updatePhysics();
    
    life++;
    x += speedX;
    y += speedY;
    rotation += speedR;
    if (life > lifeSpan) {
      alpha -= alphaSpeed;
      if (alpha < 0) {
        alpha = 0;
        dead = true;
      }
    }
  }
  void updatePhysics() {
    float surface = statePlay.water.getValueAt((int)x);
    float distanceToSurface = y - surface;
    
    if (bouyant && abs(distanceToSurface) < 2) {
      if (abs(speedY) < 2) {
        speedY = 0;
        y = surface;
      } 
      else { // break the surface:
        speedY *= .5;
      }
    }
    else {
      if (statePlay.water.nearSurface && !statePlay.water.nearSurfacePrev && bouyant) {
        y = surface;
      }
      else if (distanceToSurface < 0) { // above water:
        speedY += .5;
      }
      else if (distanceToSurface > 0) { // below water:
        if (bouyant) speedY -= .5;
        else if (speedY < bouyancy) speedY += .01;
        speedX *= .99;
        speedY *= .95;
        speedR *= .99;
      }
    }
  }
  void draw() {
  }
}

