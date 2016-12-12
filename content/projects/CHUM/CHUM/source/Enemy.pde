class Enemy extends Object {

  int shootTimer = 0;

  float targetXOffset = random(-400, 400);
  float targetYOffset = random(-100, 100);

  float reloadLuck = .5; 
  int reloadTimeMin = 100;
  int reloadTimeMax = 200;

  Enemy(float x) {
    this.x = x;
  }
  void update() {
    if (dead) {
      if (statePlay.cam.worldToScreenY(y) > height + 50 && !removeMe) {
        removeMe = true;
        statePlay.enemyCount --;
      }
    } 
    else {
      wrapPosition();
      if (collidesWithHero()) hurt(30);
      shoot();
    }
    super.update();
  }
  void shoot() {
    float disToHero = x - statePlay.hero.x;
    if (disToHero > 400 || disToHero < -400) return;

    if (shootTimer <= 0) {
      statePlay.spears.add(new Spear(x, y));
      shootTimer = (int)random(reloadTimeMin, reloadTimeMax);
      if (random(1) > reloadLuck) shootTimer = (int)random(reloadTimeMin, reloadTimeMax);
    } 
    else {
      shootTimer --;
    }
  }
  void kill() {
    statePlay.hero.resetJump();
    super.kill();
  }
  void draw() {
    tint(255);
    super.draw();
  }
}

