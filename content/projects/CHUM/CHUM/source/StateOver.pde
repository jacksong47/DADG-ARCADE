class StateOver {
  int score;
  int level;
  int lifeM;
  int lifeS;
  int mult;
  int air;
  int kills;
  int snacks;
  
  PImage imgBG;

  StateOver(int score, int level, int life, int kills, int mult, int air, int snacks) {
    this.score = score;
    this.level = level;
    this.kills = kills;
    this.mult = mult;
    this.air = (int)air;
    this.snacks = snacks;
    
    //println("total seconds: " + life);
    lifeM = (int)(life / 60);
    lifeS = life % 60;
    
    imgBG = loadImage("bg.png");
  }
  void update() {
    if(Keys.ENTER && !Keys.PREV_ENTER) showMenu();
    Keys.Update();
  }
  void draw() {
    background(0);
    image(imgBG, 0, 0);
    fill(255);
    textFont(fontBig, 30);
    textAlign(RIGHT);
    text("points:\nlevel reached:\nsurvival time:\nvessels destroyed:\nhighest multiplier:\nbiggest air:\ncreatures eaten:", 440, 140);
    textAlign(LEFT);
    text(score + "\n" + level + "\n" + lifeM + ":" + nf(lifeS, 2) + "\n" + kills + "\n" + mult + "x\n" + air + " ft\n" + snacks, 450, 140);
    
    textAlign(CENTER);
    textFont(font, 20);
    text("press [ENTER] to return to menu...", 400, 500);
  }
}

