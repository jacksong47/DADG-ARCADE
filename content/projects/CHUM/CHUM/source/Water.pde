class Water {

  float time = 0;
  float timeMult = 1/10.0;
  float period1 = 200;
  float period2 = 50;
  float amp1 = 50;
  float amp2 = 5;
  float base = 200;
  float values[] = new float[width];
  boolean nearSurface = true;
  boolean nearSurfacePrev = true;
  int bottom = 1500;

  EnvSprite wreck;

  Water() {
    wreck = new Wreck(bottom);
  }
  void update() {
    float time = statePlay.time;
    nearSurfacePrev = nearSurface;
    nearSurface = (statePlay.cam.screenToWorldY(0) < amp1 + amp2 + base + 100);
    time *= timeMult;

    if (nearSurface)this.time = time;
    amp2 = 5 + 5 * sin(this.time/100.0);

    for (int i = 0; i < values.length; i++) {
      values[i] = generateValueAt(i + this.time + statePlay.cam.x);
    }
    wreck.update();
  }
  float generateValueAt(float x) {
    return base + amp1 * sin(x / period1) + amp2 * sin(x / period2);
  }
  void draw() {
    drawBottom();
    drawSurface();
  }
  void drawBottom() {
    if (nearSurface) return;
    fill(150, 150, 150);
    noStroke();
    beginShape();
    vertex(-20, values[0] + bottom);
    for (int i = 0; i < values.length; i += 20) {
      vertex(i, values[i] + bottom);
    }
    float drawBottomY = statePlay.cam.screenToWorldY(height + 20);
    vertex(width + 20, values[values.length - 1] + bottom);
    vertex(width + 20, drawBottomY);
    vertex(-20, drawBottomY);
    endShape(CLOSE);
    wreck.draw();
  }
  void drawSurface() {
    stroke(200, 220, 255);
    strokeWeight(2);
    float lerpAmt = statePlay.cam.screenToWorldY(0) / 1000;
    if (lerpAmt < 0) lerpAmt = 0;
    if (lerpAmt > 1) lerpAmt = 1;
    float lerpAmtFlip = 1 - lerpAmt;
    fill(lerpAmtFlip * 50, lerpAmtFlip * 100, lerpAmtFlip * 200, 50 + 150 * lerpAmt);
    beginShape();
    vertex(-20, values[0]);
    if (nearSurface) {
      for (int i = 0; i < values.length; i += 40) {
        vertex(i, values[i]);
      }
    }
    float drawBottomY = statePlay.cam.screenToWorldY(height + 20);
    vertex(width + 20, values[values.length - 1]);
    vertex(width + 20, drawBottomY);
    vertex(-20, drawBottomY);
    endShape(CLOSE);
  }
  float getValueAt(int x) {
    x = (int) statePlay.cam.worldToScreenX(x);
    if (x < 0) x = 0;
    if (x >= values.length) x = values.length - 1;
    return values[x];
  }
  float getSlopeAt(int x) {
    int x1 = x - 20;
    int x2 = x + 20;
    float y1 = getValueAt(x1);
    float y2 = getValueAt(x2);
    return atan2(y2 - y1, x2 - x1);
  }
}


