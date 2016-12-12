class ParticleWater extends Particle {

  boolean gravity = true;
  float size;

  ParticleWater(float x, float y, float speed, boolean gravity) {
    super(x, y);
    this.gravity = gravity;
    size = speed * random(2, 4)/2;
    alpha = 150 + (int)random(0, 100);
    float angle = random(-.5, .5) - PIHALF;
    speed *= random(.1, 1);
    if (!gravity) angle += PI;
    speedX = speed * cos(angle);
    speedY = speed * sin(angle);
  }
  void update() {
    if (gravity) {
      speedY += .5;
    }
    else {
      speedY -= .5;
    }

    super.update();
    float surface = statePlay.water.getValueAt((int)x);
    if ((gravity && speedY > 0 && y > surface) || (!gravity && speedY < 0 && y < surface)) {
      alpha = 0;
      dead = true;
    }
  }
  void draw() {
    noStroke();
    fill(255, alpha);
    ellipse(x, y, size, size);
  }
}

