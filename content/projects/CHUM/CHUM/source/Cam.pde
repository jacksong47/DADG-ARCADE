class Camera {

  float x = 0;
  float y = 0;
  float offsetScreenX;
  float offsetScreenY;
  float offsetWorldX;
  float offsetWorldY;
  PMatrix2D matrix = new PMatrix2D();
  PMatrix2D matrixWater = new PMatrix2D();

  Camera() {
    offsetScreenX = width/2;
    offsetScreenY = height/2;
  }
  void update() {
    x += (statePlay.hero.x - x)*.2;
    y += (statePlay.hero.y - y)*.2;

    if(statePlay.shakeTimer > 0) {
      x += (int)random(-statePlay.shakeTimer, statePlay.shakeTimer);
      y += (int)random(-statePlay.shakeTimer, statePlay.shakeTimer);
    }

    offsetWorldX = offsetScreenX - x;
    offsetWorldY = offsetScreenY - y;
    
    matrix.reset();
    matrix.translate(offsetWorldX, offsetWorldY);

    matrixWater.reset();
    matrixWater.translate(0, offsetWorldY);
  }
  float worldToScreenX(float x){
    return x + offsetWorldX;
  }
  float worldToScreenY(float y){
    return y + offsetWorldY;
  }
  float screenToWorldX(float x){
    return x - offsetWorldX;
  }
  float screenToWorldY(float y){
    return y - offsetWorldY;
  }
}

