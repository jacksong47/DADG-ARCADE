class ParticleGib extends Particle {
  int r = 255;
  int b = 255;
  float size;
  PImage img = null;

  ParticleGib(float x, float y) {
    super(x + random(-10, 10), y + random(-10, 10));

    if (random(1) < .5) {
      img = (random(1) < .5) ? statePlay.imgGib1 : statePlay.imgGib2;
      size = random(.2, 1);
    } 
    else {
      size = random(6, 10);
    } 

    bouyancy = random(.1, 2.5);
    lifeSpan = (int)random(50, 100);
    alpha = (int)random(100, 255);
    speedY = random(-1, 1);
    speedX = random(-1, 1);
    speedR = random(-.1, .1);

    r = (int)random(0, 255);
    b = (int)random(0, 128);
    if (b > r) b = r;
  }
  void draw() {
    if (img == null) {
      noStroke();
      fill(r, 0, b, alpha);
      ellipse(x, y, size, size);
    } 
    else {
      tint(255, alpha);
      pushMatrix();
      translate(x, y);
      rotate(rotation);
      scale(size, size);
      image(img, -20, -20);
      popMatrix();
    }
  }
}

