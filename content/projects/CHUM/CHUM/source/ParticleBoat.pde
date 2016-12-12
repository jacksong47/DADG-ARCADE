class ParticleBoat extends Particle {
  float sizeX;
  float sizeY;
  
  ParticleBoat(float x, float y) {
    super(x + random(-10, 10), y + random(-10, 10));
    
    bouyant = (random(1) < .25);
    bouyancy = random(.1, 1.5);
    rotation = random(-PI, PI);
    speedR = random(-.1, .1);
    lifeSpan = (int)random(100, 500);
    alpha = (int)random(100, 255);
    speedY = random(-10, 1);
    speedX = random(-1, 1);
    sizeX = random(2, 10);
    sizeY = random(2, 10);
  }
  void draw() {
    noStroke();
    fill(0, alpha);
    rectMode(CENTER);
    pushMatrix();
    translate(x, y);
    rotate(rotation);
    rect(0, 0, sizeX, sizeY);
    popMatrix();
  }
}

