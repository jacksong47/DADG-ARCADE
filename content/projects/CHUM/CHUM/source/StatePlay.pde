class StatePlay {

  Water water;
  ArrayList<Spear> spears = new ArrayList();
  ArrayList<Enemy> enemies = new ArrayList();
  ArrayList<Particle> particles = new ArrayList();

  Shark hero;
  Camera cam;
  Praise praise = null;
  
  int score = 0;
  int shakeTimer = 0;
  boolean paused = false;
  int multiplier = 1;
  int multiplierCounter = 0;
  int level = 1;
  int levelEnemyCount = 5;
  int levelFoodCount = 1;
  int nextLevelBump = 1000;
  int nextLevelAt = 1000;
  int fade = 0;
  int time = 0;
  int timePrev = 0;
  int secondsCounter = 0;

  int recordAir = 0;
  int recordLife = 0;
  int recordMult = 1;
  int recordKills = 0;
  int recordSnacks = 0;

  int enemyCount = 0;
  int foodCount = 0;

  EnvSprite[] sprites = new EnvSprite[5];

  PImage imgSub;
  PImage imgSubX;
  PImage imgGib1;
  PImage imgGib2;
  PImage imgBoat;
  PImage imgBoatX;
  PImage imgSkele;
  PImage imgSpear;
  PImage imgFish1;
  PImage imgFish2;
  PImage imgOrca1;
  PImage imgOrca2;
  PImage imgHeli1;
  PImage imgHeli2;
  PImage imgHeliX;
  PImage imgJelly1;
  PImage imgJelly2;
  PImage imgJelly3;
  PImage imgJelly4;

  StatePlay() {
    imgSub = loadImage("sub.png");
    imgSubX = loadImage("subX.png");
    imgGib1 = loadImage("gib1.png");
    imgGib2 = loadImage("gib2.png");
    imgBoat = loadImage("boat.png");
    imgBoatX = loadImage("boatX.png");
    imgSkele = loadImage("skele.png");
    imgSpear = loadImage("spear.png");
    imgFish1 = loadImage("fish1.png");
    imgFish2 = loadImage("fish2.png");
    imgOrca1 = loadImage("orca1.png");
    imgOrca2 = loadImage("orca2.png");
    imgHeli1 = loadImage("heli1.png");
    imgHeli2 = loadImage("heli2.png");
    imgHeliX = loadImage("heliX.png");
    imgJelly1 = loadImage("jelly1.png");
    imgJelly2 = loadImage("jelly2.png");
    imgJelly3 = loadImage("jelly3.png");
    imgJelly4 = loadImage("jelly4.png");

    water = new Water();
    hero = new Shark();
    hero.x = 400;
    hero.y = 300;

    PImage imgCloud = loadImage("cloud.png");
    for (int i = 0; i < sprites.length; i++) {
      sprites[i] = new Cloud(imgCloud);
    }

    cam = new Camera();
    cam.x = 400;
    cam.y = 300;
  }
  boolean isLoaded() {
    return (audio.loaded);
  }
  void update() {
    if (fade >= 255) {
      gameOver(score, level, recordLife, recordKills, recordMult, recordAir, recordSnacks);
      return;
    }
    if (!focused || (Keys.P && !Keys.PREV_P)) paused = true;
    if (paused) {
      if (Keys.ENTER && !Keys.PREV_ENTER) {
        paused = false;
        time = millis();
      }
      return;
    }
    timePrev = time;
    time = millis();
    secondsCounter += (time - timePrev);
    if(!hero.dead && secondsCounter > 1000) {
      recordLife++;
      secondsCounter -= 1000;
      addScore(1, false);
      if (score >= nextLevelAt) {
        level ++;
        levelEnemyCount = 3 + level * 2;
        levelFoodCount = level - 1;
        if (levelFoodCount > 4) levelFoodCount = 4;
        nextLevelBump *= 2;
        nextLevelAt = score + nextLevelBump;
      }
    }
    
    cam.update();
    water.update();
    if (praise != null) praise.update();
    shakeTimer --;

    if (enemyCount < levelEnemyCount) {
      enemyCount++;
      switch((int)random(1, 8)) {
      case 1:
      case 2:
      case 3:
        newBoat();
        break;
      case 4:
      case 5:
        newSub();
        break;
      case 6:
      case 7:
        newHeli();
        break;
      }
    }
    if (foodCount < levelFoodCount) {
      foodCount++;
      newJelly();
    }

    for (int i = spears.size() - 1; i >= 0; i--) {
      spears.get(i).update();
      if (spears.get(i).removeMe) spears.remove(i);
    }
    for (int i = enemies.size() - 1; i >= 0; i--) {
      enemies.get(i).update();
      if (enemies.get(i).removeMe) enemies.remove(i);
    }
    for (int i = particles.size() - 1; i >= 0; i--) {
      particles.get(i).update();
      if (particles.get(i).dead) particles.remove(i);
    }
    for (int i = 0; i < sprites.length; i++) { 
      sprites[i].update();
    }
    hero.update();
    Keys.Update();


    if (multiplierCounter > 0) {
      multiplierCounter--;
    } 
    else {
      multiplier = 1;
    }
  }
  void draw() {
    background(100, 200, 255);
    fill(255);

    pushMatrix();
    translate(0, cam.offsetWorldY);
    pushMatrix();
    translate(cam.offsetWorldX, 0);
    if (water.nearSurface) {
      for (int i = 0; i < sprites.length; i++) { 
        sprites[i].draw();
      }
    }
    for (int i = 0; i < spears.size(); i++) spears.get(i).draw();
    for (int i = 0; i < enemies.size(); i++) enemies.get(i).draw();
    for (int i = 0; i < particles.size(); i++) particles.get(i).draw();
    hero.draw();
    popMatrix();
    water.draw();
    popMatrix();

    drawUI();
    if (praise != null) praise.draw();
    drawPause();
    drawFade();
  }
  void drawUI() {
    rectMode(CORNER);
    noStroke();
    fill(0, 50);
    rect(10, 10, 100, 20);
    fill(200, 255, 0);
    rect(10, 10, hero.hp, 20);
    stroke(0);
    strokeWeight(2);
    noFill();
    rect(10, 10, 100, 20);

    fill(255);
    textFont(font, 20);    
    textAlign(RIGHT);
    text("Level " + level, width - 10, 20);
    text(score, width - 10, 40);
    text(multiplier + "x", width - 10, 60);
  }
  void drawPause() {
    if (!paused) return;
    noStroke();
    fill(0, 200);
    rect(0, 0, width, height);
    fill(255);
    textAlign(CENTER);
    textFont(font, 80);
    text("PAUSED", 400, 300);
    textFont(font, 20);
    text("PRESS [ENTER] TO UNPAUSE", 400, 350);
  }
  void drawFade() {
    if (!hero.dead) return;
    fade += 2;
    if (fade >= 255) fade = 255;
    noStroke();
    fill(0, fade);
    rect(0, 0, width, height);
  }
  void drawLoading() {
    background(0);
    fill(255);
    textAlign(CENTER);
    text("LOADING...", width/2, height/2);
  }
  void addScore(float score, boolean incrMult) {
    this.score += multiplier * score;
    if (incrMult) {
      multiplier ++;
      multiplierCounter = 100;
      if (multiplier > recordMult) recordMult = multiplier;
      if (multiplier % 5 == 0) praise = new Praise();
    }
  }
  void splashAt(Object obj) {
    float speed = sqrt(obj.speedX * obj.speedX + obj.speedY * obj.speedY);
    for (int i = 0; i < 20; i ++) {
      boolean g = (i < 10);
      float y = obj.y + ((i < 10) ? -5 : 5);

      particles.add(new ParticleWater(obj.x, y, speed, g));
    }
  }
  void gibsAt(Object obj) {
    for (int i = 0; i < 10; i ++) {
      particles.add(new ParticleGib(obj.x, obj.y));
    }
  }
  void explosionAt(Object obj) {
    recordKills ++;
    audio.playExplosion();
    for (int i = 0; i < 10; i ++) {
      particles.add(new ParticleSmoke(obj.x, obj.y));
    }
    for (int i = 0; i < 10; i ++) {
      particles.add(new ParticleBoat(obj.x, obj.y));
    }
    shakeTimer = 20;
  }
  float newEnemyX() {
    float x = random(-2, 2);
    if (x > 0 && x < 1) x = 1;
    if (x < 0 && x >-1) x = -1;
    return hero.x + x * width + random(-width/2, width/2);
  }
  void newBoat() {
    enemies.add(new Boat(newEnemyX(), (random(1) < .2)));
  }
  void newHeli() {
    enemies.add(new Heli(newEnemyX()));
  }
  void newSub() {
    enemies.add(new Sub(newEnemyX()));
  }
  void newJelly() {
    enemies.add(new Food(newEnemyX()));
  }
}

