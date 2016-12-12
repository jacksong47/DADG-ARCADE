class Spear extends Object {
  float speed = 10;
  
  Spear(float x, float y){
    this.x = x;
    this.y = y;
    float dx = statePlay.hero.x - x;
    float dy = statePlay.hero.y - y;
    float angle = atan2(dy, dx) + random(-.1, .1);
    speedX = speed * cos(angle);
    speedY = speed * sin(angle);
    rotation = angle;
    img = statePlay.imgSpear;
    radius = 0;
  }
  void update(){
    //if (distanceToSurface < 0) speedY += .1;
    x += speedX;
    y += speedY;
    if (checkCollision(statePlay.hero)) {
      statePlay.hero.hurt(10);
      removeMe = true;
    }
    if(isOffScreen()) removeMe = true;
  }
}
