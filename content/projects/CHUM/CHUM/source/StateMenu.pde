class StateMenu {
  int alpha = 0;
  PImage imgTitle;
  PImage imgBG;
  
  StateMenu() {
    imgBG = loadImage("bg.png");
    imgTitle = loadImage("title.png");
  }
  void update() {
    if(alpha < 255) alpha += 10;
    if(alpha >= 255) alpha = 255;
    
    if(Keys.ENTER && !Keys.PREV_ENTER) playGame();
    Keys.Update();
  }
  void draw() {
    background(0);
    tint(255);
    image(imgBG, 0, 0);
    tint(255, alpha);
    image(imgTitle, 0, 0);
  }
}
