class Heli extends Enemy {

  float pilotHeight;
  int floatCounter = 100;

  Heli(float x) {
    super(x);
    setImg(statePlay.imgHeli1);
    y = 150;
    float maxHeight = 500;
    if(statePlay.level == 3) maxHeight = 600;
    if(statePlay.level == 4) maxHeight = 700;
    if(statePlay.level >= 5) maxHeight = 800;
    
    pilotHeight = random(100, maxHeight);
    radius = 20;
    hp = 30;
    flyer = true;
    attackSpeedTheshold = 2;
  }
  void update() {
    if (!dead) {

      if (statePlay.hero.x > x + targetXOffset) speedX += .1;
      if (statePlay.hero.x < x + targetXOffset) speedX -= .1;

      float targetY = statePlay.water.getValueAt((int)x) - pilotHeight;

      if (targetY > y) speedY += .1;
      if (targetY < y) speedY -= .1;

      speedX *= .95;
      speedY *= .95;
      rotation = speedX < 0 ? -.5 : .5;
    } 
    else {
      
      rotation += speedR;
      speedR *= .99;
      if (bouyant) {
        if(random(1) < .25) statePlay.particles.add(new ParticleSmoke(x, y));
        floatCounter--;
        if (floatCounter < 0) {
          bouyant = false;
          sinker = true;
        }
      }
    }
    super.update();
  }
  void kill() {
    img = statePlay.imgHeliX;
    super.kill();
    statePlay.explosionAt(this);
    bouyant = true;
    flyer = false;
    statePlay.addScore(500, true);
    speedR = random(-.1, .1);
    speedY = -10;
  }
  void cueNextFrame(){
    if(dead) return;
    img = (img == statePlay.imgHeli1) ? statePlay.imgHeli2 : statePlay.imgHeli1;
  }
  void draw() {
    flipHorizontal = !dead && speedX < 0;
    super.draw();
  }
}

