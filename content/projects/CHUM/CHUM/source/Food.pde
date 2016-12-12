class Food extends Enemy {

  PImage[] imgs;

  Food(float x) {
    super(x);
    
    hp = 30;
    int type = (int)random(1, 4);
    
    switch(type) {
    case 1:
      speedX = random(.2, 1);
      imgs = new PImage[] {
        statePlay.imgJelly1, 
        statePlay.imgJelly2, 
        statePlay.imgJelly3, 
        statePlay.imgJelly4
      };
      break;
      case 2:
      speedX = random(1, 2);
      millisPerFrame = 200;
      imgs = new PImage[] {
        statePlay.imgFish1, 
        statePlay.imgFish2
      };
      break;
      case 3:
      speedX = random(2, 3);
      millisPerFrame = 400;
      imgs = new PImage[] {
        statePlay.imgOrca1, 
        statePlay.imgOrca2
      };
      break;
    }
    if (random(1) < .5) speedX *= -1;
    img = imgs[0];
    
    y = random(500, 1500);
    attackSpeedTheshold = 2;
    radius = 15;
  }
  void update() {
    if (!dead) {
      tickFrames();
      x += speedX;
      y += speedY;
      wrapPosition();
      if (collidesWithHero()) {
        hurt(30);
        removeMe = true;
      }
    } 
    else {
      removeMe = true;
    }
  }
  void cueNextFrame() {
    for (int i = 0; i < imgs.length; i++) {
      int j = (i == imgs.length - 1) ? 0 : i + 1;
      if (img == imgs[i]) {
        img = imgs[j];
        break;
      }
    }
  }
  void kill() {
    super.kill();
    statePlay.recordSnacks ++;
    statePlay.hero.heal(5);
    statePlay.gibsAt(this);
    statePlay.foodCount--;
  }
  void draw() {
    flipHorizontal = speedX > 0;
    super.draw();
  }
}

