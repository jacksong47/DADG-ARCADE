class ParticleSmoke extends Particle {
  float size;
  float maxSpeedY;
  
  ParticleSmoke(float x, float y) {
    super(x + random(-10, 10), y + random(-10, 10));
    lifeSpan = (int)random(50, 100);
    alpha = (int)random(100, 255);
    speedY = random(-1, 0);
    speedX = random(-1, 1);
    maxSpeedY = random(-1, -.1);
    size = random(10, 30);
  }
  void update() {
    if(speedY > maxSpeedY) speedY -= .01;
    speedX *= .99;
    super.update();
  }
  void draw() {
    noStroke();
    fill(0, alpha);
    ellipse(x, y, size, size);
  }
}

