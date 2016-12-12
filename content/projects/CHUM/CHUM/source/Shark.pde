class Shark extends Object {

  Enemy attackEnemy = null;
  float speed = 0;
  float speedLength;
  float speedR = 0;
  float accelR = .005;
  boolean jumping = false;
  int jumpJuice = 0;

  PImage imgH;
  PImage imgV;

  Shark() {
    radius = 20;
    imgH = loadImage("shark.png");
    imgV = loadImage("shark1.png");
    millisPerFrame = 400;
    setImg(imgH);
    //hp = 10;
  }
  void update() {

    if (dead) {
      if (flipVertical) {
        speedR += (rotation > -PI && rotation < 0) ? .005 : -.005;
      } 
      else {
        speedR += (rotation > -PI && rotation < 0) ? -.005 : .005;
      }
      speedR *= .95;
      rotation += speedR;
      if (rotation > PI) rotation -= PI2;
      if (rotation < -PI) rotation += PI2;

      super.update();
      return;
    }

    hurtTimer = 0;

    if (Keys.SPACE && !Keys.PREV_SPACE) speed += 1;
    speed *= .95;

    if (Keys.LEFT) speedR -= .005;
    if (Keys.RIGHT) speedR += .005;

    if (distanceToSurface > 0) { // under water:
      speedX += speed * cos(rotation);
      speedY += speed * sin(rotation);
      resetJump();
    } 
    else if (distanceToSurface < 0) { // in the air:

      if (-distanceToSurface > statePlay.recordAir) statePlay.recordAir = -(int)distanceToSurface; 

      if (Keys.SPACE) {
        if (jumping) {
          if (jumpJuice > 0) {
            speedY --;
            jumpJuice --;
          }
        }
      } 
      else {
        jumpJuice = 0;
      }
      if (Keys.SPACE && !Keys.PREV_SPACE) jump();
      if (Keys.LEFT) speedX -= .2;
      if (Keys.RIGHT) speedX += .2;
      if (!Keys.LEFT && !Keys.RIGHT) {
        float rotationTarget = atan2(speedY, speedX);
        float rotationDelta = rotation - rotationTarget;
        if (rotationDelta > PI) rotationTarget += PI2;
        if (rotationDelta < -PI) rotationTarget -= PI2;
        if (rotationTarget > rotation) speedR += .005;
        if (rotationTarget < rotation) speedR -= .005;
      }
    }

    if (speedR > .1) speedR = .1;
    if (speedR < -.1) speedR = -.1;
    rotation += speedR;
    speedR *= .95;
    if (rotation > PI) rotation -= PI2;
    if (rotation < -PI) rotation += PI2;

    if (Keys.S && !Keys.PREV_S) sharkAttack();

    if (attackEnemy != null) {

      if (attackEnemy.dead) {
        attackEnemy = null;
      } 
      else {
        float dx = attackEnemy.x - x;
        float dy = attackEnemy.y - y;
        float angleTo = atan2(dy, dx);
        rotation = angleTo;
        speedX = 20 * cos(angleTo);
        speedY = 20 * sin(angleTo);
      }
    }
    super.update();

    if (distanceToSurfacePrev < 0 && distanceToSurface > 0) statePlay.splashAt(this);
    if (distanceToSurfacePrev > 0 && distanceToSurface < 0) statePlay.splashAt(this);

    speedLength = sqrt(speedX * speedX + speedY * speedY);

    if (speedLength > 10) {
      float ratioX = speedX / speedLength;
      float ratioY = speedY / speedLength;
      speedLength = 10;
      speedX = ratioX * speedLength;
      speedY = ratioY * speedLength;
    }
  }
  void resetJump() {
    jumping = false;
  }
  void jump() {
    if (jumping) return;
    audio.playJump();
    speedY = 0;
    jumping = true;
    speedY -= 10;
    jumpJuice = 15;
  }
  void sharkAttack() {

    Enemy enemy = null;
    float limit = 300;
    float distance = limit * limit;
    for (int i = 0; i < statePlay.enemies.size(); i++) {
      if (statePlay.enemies.get(i).dead) continue;
      float dx = statePlay.enemies.get(i).x - x;
      float dy = statePlay.enemies.get(i).y - y;
      if (dx > limit || dy > limit || dx < -limit || dy < -limit) continue;
      float d2 = dx*dx + dy*dy;
      if (d2 < distance) {
        distance = d2;
        enemy = statePlay.enemies.get(i);
      }
    }
    if (enemy != null) {
      attackEnemy = enemy;
      audio.playPowerup();
    }
  }
  boolean hurt(float amt) {
    boolean result = super.hurt(amt);
    if (result) audio.playHurt();
    return result;
  }
  void heal(float amt) {
    hp += amt;
    if (hp > 100) hp = 100;
    audio.playFeed();
  }
  void kill() {
    img = statePlay.imgSkele;
    bouyant = true;
    super.kill();
  }
  void cueNextFrame() {
    if (!dead) flipVertical = !flipVertical;
  }
  void draw() {
    tint(255);

    if (!dead) {
      if (rotation > -DEG45 && rotation < DEG45) { // right
        img = imgH;
        flipVertical = false;
      } 
      else if (rotation < -DEG135 || rotation > DEG135) { // left
        img = imgH;
        flipVertical = true;
      } 
      else {
        img = imgV;
      }
    } 
    else {
    }
    super.draw();
  }
}

