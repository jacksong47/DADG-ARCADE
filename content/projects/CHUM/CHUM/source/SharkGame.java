import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.spi.*; 
import ddf.minim.signals.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.ugens.*; 
import ddf.minim.effects.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SharkGame extends PApplet {








/* @pjs preload="bg.png,title.png,cloud.png,wreck.png,gib1.png,gib2.png,shark.png,shark1.png,spear.png,skele.png,heli1.png,heli2.png,heliX.png,sub.png,subX.png,boat.png,boatX.png,jelly1.png,jelly2.png,jelly3.png,jelly4.png,fish1.png,fish2.png,orca1.png,orca2.png"; */

float PI2 = PI * 2;
float PIHALF = PI/2;
float DEG45 = PI/4;
float DEG135 = PI * 3/4;
PFont font;
PFont fontBig;

StateMenu stateMenu;
StatePlay statePlay;
StateOver stateOver;
Minim minim;
JavaAudio audio;
//HTMLAudio audio = new HTMLAudio();


public void setup() {
  size(800, 600);

  minim = new Minim(this);
  audio = new JavaAudio();
  audio.setVolume(.5f);

  font = createFont("Arial", 20);
  fontBig = createFont("Arial Bold Italic", 100);

  showMenu();
}
public void draw() {
  if (statePlay != null) {
    if (statePlay.isLoaded()) {
      statePlay.update();
      if (statePlay != null) statePlay.draw();
    } 
    else {
      statePlay.drawLoading();
    }
  }
  if (stateOver != null) stateOver.update();
  if (stateOver != null) stateOver.draw();
  if (stateMenu != null) stateMenu.update();
  if (stateMenu != null) stateMenu.draw();
}

public void showMenu() {
  stateOver = null;
  stateMenu = new StateMenu();
}
public void gameOver(int score, int level, int life, int kills, int mult, int air, int snacks) {
  statePlay = null;
  stateOver = new StateOver(score, level, life, kills, mult, air, snacks);
}
public void playGame() {
  stateMenu = null;
  statePlay = new StatePlay();
}
public void stop() {
  audio.stop();
  minim.stop();
  super.stop();
}

class Boat extends Enemy {

  float acceleration = random(.001f, .01f);
  float maxSpeed = random(.2f, .5f) + random(.2f, .5f);
  boolean speedBoat = false;

  Boat(float x, boolean speedBoat) {
    super(x);
    this.speedBoat = speedBoat;
    snapToSurface();
    setImg(statePlay.imgBoat);
    regY += 5;
    bouyant = true;
    hp = 30;

    if (speedBoat) {
      maxSpeed = 2;
      acceleration = .05f;
    }
  }  
  public void update() {
    if (!dead) {

      if (bouyant && !speedBoat) {
        snapToSurface();
        speedY = 0;
      }
      if (statePlay.hero.x > x + targetXOffset) speedX += acceleration;
      if (statePlay.hero.x < x + targetXOffset) speedX -= acceleration;

      if (speedX > maxSpeed) speedX = maxSpeed;
      if (speedX <-maxSpeed) speedX = -maxSpeed;
    }
    x += speedX;

    super.update();
    float rotationTarget = statePlay.water.getSlopeAt((int)x);

    if (rotation > rotationTarget) rotation -= .01f;
    if (rotation < rotationTarget) rotation += .01f;
  }
  public void kill() {
    img = statePlay.imgBoatX;
    super.kill();
    statePlay.explosionAt(this);
    bouyant = false;
    sinker = true;
    statePlay.addScore(100, true);
  }
}

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
  public void update() {
    x += (statePlay.hero.x - x)*.2f;
    y += (statePlay.hero.y - y)*.2f;

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
  public float worldToScreenX(float x){
    return x + offsetWorldX;
  }
  public float worldToScreenY(float y){
    return y + offsetWorldY;
  }
  public float screenToWorldX(float x){
    return x - offsetWorldX;
  }
  public float screenToWorldY(float y){
    return y - offsetWorldY;
  }
}

class Enemy extends Object {

  int shootTimer = 0;

  float targetXOffset = random(-400, 400);
  float targetYOffset = random(-100, 100);

  float reloadLuck = .5f; 
  int reloadTimeMin = 100;
  int reloadTimeMax = 200;

  Enemy(float x) {
    this.x = x;
  }
  public void update() {
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
  public void shoot() {
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
  public void kill() {
    statePlay.hero.resetJump();
    super.kill();
  }
  public void draw() {
    tint(255);
    super.draw();
  }
}

class EnvSprite {
  float x;
  float y;
  float speedX;
  float speedY;
  PImage img;
  float limitX = 1000;
  boolean inScreenSpace = false;

  public void wrapPosition() {
    float disToHero = x - statePlay.hero.x;
    if (disToHero > limitX) x -= limitX * 2 - 50;
    else if (disToHero < -limitX) x += limitX * 2 - 50;
  }
  public void update() {
    x += speedX;
    y += speedY;
    wrapPosition();
  }
  public void draw() {
    float tx = x;
    if(inScreenSpace) tx = statePlay.cam.worldToScreenX(tx);
    
    image(img, tx, y);
  }
}
class Cloud extends EnvSprite {
  Cloud(PImage img) {
    this.img = img;
    y = random(-400, -1);
    x = random(-1000, 1000);
    speedX = random(-2, 2);
  }
  public void draw() {
    tint(255, 128);
    super.draw();
  }
}
class Wreck extends EnvSprite {
  Wreck(float bottom) {
    inScreenSpace = true;
    img = loadImage("wreck.png");
    x = 0;
    y = bottom + 70;
  }
  public void draw() {
    tint(255);
    if(img != null) super.draw();
  }
}
class Food extends Enemy {

  PImage[] imgs;

  Food(float x) {
    super(x);
    
    hp = 30;
    int type = (int)random(1, 4);
    
    switch(type) {
    case 1:
      speedX = random(.2f, 1);
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
    if (random(1) < .5f) speedX *= -1;
    img = imgs[0];
    
    y = random(500, 1500);
    attackSpeedTheshold = 2;
    radius = 15;
  }
  public void update() {
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
  public void cueNextFrame() {
    for (int i = 0; i < imgs.length; i++) {
      int j = (i == imgs.length - 1) ? 0 : i + 1;
      if (img == imgs[i]) {
        img = imgs[j];
        break;
      }
    }
  }
  public void kill() {
    super.kill();
    statePlay.recordSnacks ++;
    statePlay.hero.heal(5);
    statePlay.gibsAt(this);
    statePlay.foodCount--;
  }
  public void draw() {
    flipHorizontal = speedX > 0;
    super.draw();
  }
}

/*
class HTMLAudio {
  int loadCount = 0;
  boolean loaded = false;
  Audio jump = new Audio();
  Audio hurt = new Audio();
  Audio feed = new Audio();
  Audio music = new Audio();
  Audio powerup = new Audio();
  Audio explosion1 = new Audio();
  Audio explosion2 = new Audio();
  Audio explosion3 = new Audio();
  Audio explosion4 = new Audio();

  HTMLAudio() {
    String ext = (jump.canPlayType && jump.canPlayType("audio/ogg")) ? ".ogg" : ".mp3";
    jump.addEventListener("loadedmetadata", loadedFunc);
    hurt.addEventListener("loadedmetadata", loadedFunc);
    feed.addEventListener("loadedmetadata", loadedFunc);
    music.addEventListener("loadedmetadata", loadedFunc);
    powerup.addEventListener("loadedmetadata", loadedFunc);
    explosion1.addEventListener("loadedmetadata", loadedFunc);
    explosion2.addEventListener("loadedmetadata", loadedFunc);
    explosion3.addEventListener("loadedmetadata", loadedFunc);
    explosion4.addEventListener("loadedmetadata", loadedFunc);

    music.addEventListener("ended", repeatMusic); 

    jump.setAttribute("src", "jump"+ext);
    hurt.setAttribute("src", "hurt"+ext);
    feed.setAttribute("src", "feed"+ext);
    music.setAttribute("src", "music"+ext);
    powerup.setAttribute("src", "powerup"+ext);
    explosion1.setAttribute("src", "explosion1"+ext);
    explosion2.setAttribute("src", "explosion2"+ext);
    explosion3.setAttribute("src", "explosion3"+ext);
    explosion4.setAttribute("src", "explosion4"+ext);
  }
  function loadedFunc() {
    if (++loadCount >=9) {
      if (!loaded) music.play();
      loaded = true;
    }
  }
  function repeatMusic() {
    playMusic();
  }
  void setVolume(float amt) {
    jump.volume = amt;
    hurt.volume = amt;
    feed.volume = amt;
    music.volume = amt;
    powerup.volume = amt;
    explosion1.volume = amt;
    explosion2.volume = amt;
    explosion3.volume = amt;
    explosion4.volume = amt;
  }
  void playFeed() {
    feed.load();
    feed.play();
  }
  void playJump() {
    jump.load();
    jump.play();
  }
  void playHurt() {
    hurt.load();
    hurt.play();
  }
  void playMusic() {
    music.load();
    music.play();
  }
  void playPowerup() {
    powerup.load();
    powerup.play();
  }
  void playExplosion() {
    switch((int)random(1, 5)) {
    case 1: 
      explosion1.load();
      explosion1.play(); 
      break;
    case 2: 
      explosion2.load();
      explosion2.play(); 
      break;
    case 3: 
      explosion3.load();
      explosion3.play(); 
      break;
    case 4: 
      explosion4.load();
      explosion4.play(); 
      break;
    }
  }
}
*/
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
  public void update() {
    if (!dead) {

      if (statePlay.hero.x > x + targetXOffset) speedX += .1f;
      if (statePlay.hero.x < x + targetXOffset) speedX -= .1f;

      float targetY = statePlay.water.getValueAt((int)x) - pilotHeight;

      if (targetY > y) speedY += .1f;
      if (targetY < y) speedY -= .1f;

      speedX *= .95f;
      speedY *= .95f;
      rotation = speedX < 0 ? -.5f : .5f;
    } 
    else {
      
      rotation += speedR;
      speedR *= .99f;
      if (bouyant) {
        if(random(1) < .25f) statePlay.particles.add(new ParticleSmoke(x, y));
        floatCounter--;
        if (floatCounter < 0) {
          bouyant = false;
          sinker = true;
        }
      }
    }
    super.update();
  }
  public void kill() {
    img = statePlay.imgHeliX;
    super.kill();
    statePlay.explosionAt(this);
    bouyant = true;
    flyer = false;
    statePlay.addScore(500, true);
    speedR = random(-.1f, .1f);
    speedY = -10;
  }
  public void cueNextFrame(){
    if(dead) return;
    img = (img == statePlay.imgHeli1) ? statePlay.imgHeli2 : statePlay.imgHeli1;
  }
  public void draw() {
    flipHorizontal = !dead && speedX < 0;
    super.draw();
  }
}


class JavaAudio {
  int loadCount = 0;
  boolean loaded = true;
  AudioSample jump;
  AudioSample hurt;
  AudioSample feed;
  AudioPlayer music;
  AudioSample powerup;
  AudioSample explosion1;
  AudioSample explosion2;
  AudioSample explosion3;
  AudioSample explosion4;

  JavaAudio() {
    jump = minim.loadSample("jump.mp3");
    hurt = minim.loadSample("hurt.mp3");
    feed = minim.loadSample("feed.mp3");
    music = minim.loadFile("music.mp3");
    powerup = minim.loadSample("powerup.mp3");
    explosion1 = minim.loadSample("explosion1.mp3");
    explosion2 = minim.loadSample("explosion2.mp3");
    explosion3 = minim.loadSample("explosion3.mp3");
    explosion4 = minim.loadSample("explosion4.mp3");
    playMusic();
  }
  public void setVolume(float amt) {
    jump.setVolume(amt);
    hurt.setVolume(amt);
    feed.setVolume(amt);
    music.setVolume(amt);
    powerup.setVolume(amt);
    explosion1.setVolume(amt);
    explosion2.setVolume(amt);
    explosion3.setVolume(amt);
    explosion4.setVolume(amt);
  }
  public void playFeed() {
    feed.trigger();
  }
  public void playJump() {
    jump.trigger();
  }
  public void playHurt() {
    hurt.trigger();
  }
  public void playMusic() {
    music.loop();
  }
  public void playPowerup() {
    powerup.trigger();
  }
  public void playExplosion() {
    switch((int)random(1, 5)) {
    case 1:
      explosion1.trigger(); 
      break;
    case 2:
      explosion2.trigger(); 
      break;
    case 3:
      explosion3.trigger(); 
      break;
    case 4:
      explosion4.trigger(); 
      break;
    }
  }
  public void stop() {
    jump.close();
    hurt.close();
    feed.close();
    music.close();
    powerup.close();
    explosion1.close();
    explosion2.close();
    explosion3.close();
    explosion4.close();
  }
}

static class Keys {
  static boolean A = false;
  static boolean W = false;
  static boolean D = false;
  static boolean S = false;
  static boolean P = false;
  static boolean LEFT = false;
  static boolean RIGHT = false;
  static boolean UP = false;
  static boolean DOWN = false;
  static boolean SPACE = false;
  static boolean ENTER = false;
  ///////////////////////////////// PREVIOUS:
  static boolean PREV_A = false;
  static boolean PREV_W = false;
  static boolean PREV_D = false;
  static boolean PREV_S = false;
  static boolean PREV_P = false;
  static boolean PREV_LEFT = false;
  static boolean PREV_RIGHT = false;
  static boolean PREV_UP = false;
  static boolean PREV_DOWN = false;
  static boolean PREV_SPACE = false;
  static boolean PREV_ENTER = false;
  public static void Update() {
    Keys.PREV_A = Keys.A;
    Keys.PREV_W = Keys.W;
    Keys.PREV_D = Keys.D;
    Keys.PREV_S = Keys.S;
    Keys.PREV_P = Keys.P;
    Keys.PREV_LEFT = Keys.LEFT;
    Keys.PREV_RIGHT = Keys.RIGHT;
    Keys.PREV_UP = Keys.UP;
    Keys.PREV_DOWN = Keys.DOWN;
    Keys.PREV_SPACE = Keys.SPACE;
    Keys.PREV_ENTER = Keys.ENTER;
  }
  public static void Set(int code, boolean pressed) {
    switch(code) {
    case 32:
      Keys.SPACE = pressed;
      break;
    case 37:
      Keys.LEFT = pressed;
      break;
    case 38:
      Keys.UP = pressed;
      break;
    case 39:
      Keys.RIGHT = pressed;
      break;
    case 40:
      Keys.DOWN = pressed;
      break;
    case 65:
      Keys.A = pressed;
      break;
    case 87:
      Keys.W = pressed;
      break;
    case 68:
      Keys.D = pressed;
      break;
    case 83:
      Keys.S = pressed;
      break;
    case 80:
      Keys.P = pressed;
      break;
    case 10:
      Keys.ENTER = pressed;
      break;
    }
  }
}


public void keyPressed() {
  Keys.Set(keyCode, true);
}
public void keyReleased() {
  Keys.Set(keyCode, false);
}

class Object {
  float x;
  float y;
  float speedX = 0;
  float speedY = 0;
  float speedR = 0;
  int limitX = 2000;
  float radius = 20;
  float rotation = 0;
  float distanceToSurface = 0;
  float distanceToSurfacePrev = 0;
  float hp = 100;
  int hurtTimer = 0;
  PImage img;
  boolean flipHorizontal = false;
  boolean flipVertical = false;
  float attackSpeedTheshold = 8;
  int regX;
  int regY;
  int nextFrame = 0;
  int millisPerFrame = 100;

  boolean dead = false;
  boolean bouyant = false;
  boolean sinker = false;
  boolean flyer = false;
  boolean removeMe = false;
  public void setImg(PImage img) {
    this.img = img;
    regX = img.width/2;
    regY = img.height/2;
  }
  public void tickFrames() {
    if (statePlay.time > nextFrame) {
      nextFrame = statePlay.time + millisPerFrame;
      cueNextFrame();
    }
  }
  public void update() {
    tickFrames();
    if (hurtTimer > 0) hurtTimer --;

    distanceToSurfacePrev = distanceToSurface;
    float surface = statePlay.water.getValueAt((int)x);
    distanceToSurface = y - surface;

    if (distanceToSurface < 0) { // in the air
      if (!flyer) speedY += .5f;
    } 
    else if (distanceToSurface > 0) { // below water:
      if (bouyant) {
        if (statePlay.water.nearSurface && !statePlay.water.nearSurfacePrev) {
          snapToSurface();
        }
        else if (distanceToSurface < 3) { // near surface 
          speedY = 0;
          y = surface;
        } 
        else {
          if (distanceToSurfacePrev < 0) {
            speedY *= .5f; // break the surface
            statePlay.splashAt(this);
          }

          speedY -= .5f; // rising to surface
          if (speedY < -3) speedY = -3;
        }
      } 
      else if (sinker) {
        if (speedY < 5) speedY += .005f;
      } 
      else {
        speedY *= .95f;
      }
      speedX *= .95f;
    }
    x += speedX;
    y += speedY;
    if (y > surface + statePlay.water.bottom) {
      y = surface + statePlay.water.bottom;
      speedY -= .5f;
    }
  }
  public void snapToSurface() {
    y = statePlay.water.getValueAt((int)x);
    rotation = statePlay.water.getSlopeAt((int)x);
  }
  public float getDistanceSquaredTo(Object other) {
    float min = radius + other.radius;
    float dx = abs(x - other.x);
    float dy = abs(y - other.y);
    float d2 = dx*dx + dy*dy;
    return d2;
  }
  public boolean checkCollision(Object other) {
    float min = radius + other.radius;
    float dx = abs(x - other.x);
    float dy = abs(y - other.y);

    if (dx > min || dy > min) return false;
    float d2 = dx*dx + dy*dy;

    return (d2 < min * min);
  }
  public boolean hurt(float amt) {
    if (dead || hurtTimer > 0) return false;
    hp -= amt;
    hurtTimer = 50;
    if (hp <= 0) kill();
    return true;
  }
  public void draw() {
    if (img == null) return;
    if (isOffScreen()) return;
    pushMatrix();
    translate(x, y);
    rotate(rotation);
    if (flipVertical && flipHorizontal) scale(-1, -1);
    else if (flipHorizontal) scale(-1, 1);
    else if (flipVertical) scale(1, -1);

    if (img != null) image(img, -regX, -regY);
    popMatrix();
  }
  public void cueNextFrame() {
  }
  public void wrapPosition() {
    float disToHero = x - statePlay.hero.x;
    if (disToHero > limitX) x -= limitX * 2 - 50;
    else if (disToHero < -limitX) x += limitX * 2 - 50;
  }
  public boolean collidesWithHero() {
    if (statePlay.hero.dead) return false;
    if (statePlay.hero.speedLength < attackSpeedTheshold) return false;
    return checkCollision(statePlay.hero);
  }
  public boolean isOffScreen() {
    if (statePlay.cam.worldToScreenX(x) > width + 50) return true; // right
    if (statePlay.cam.worldToScreenX(x) < -50) return true; // left
    if (statePlay.cam.worldToScreenY(y) > height + 50) return true; // bottom
    if (statePlay.cam.worldToScreenY(y) < -50) return true; // top
    return false;
  }
  public void kill() {
    dead = true;
  }
}

class Particle {
  int life = 0;
  int lifeSpan = 20;
  int alpha = 255;
  int alphaSpeed = 10;
  float x = 0;
  float y = 0;
  float speedX = 0;
  float speedY = 0;
  float speedR = 0;
  float rotation = 0;
  boolean dead = false;

  boolean bouyant = false;
  float bouyancy = 0;

  Particle(float x, float y) {
    this.x = x;
    this.y = y;
  }

  public void update() {
    
    if(bouyant || bouyancy > 0) updatePhysics();
    
    life++;
    x += speedX;
    y += speedY;
    rotation += speedR;
    if (life > lifeSpan) {
      alpha -= alphaSpeed;
      if (alpha < 0) {
        alpha = 0;
        dead = true;
      }
    }
  }
  public void updatePhysics() {
    float surface = statePlay.water.getValueAt((int)x);
    float distanceToSurface = y - surface;
    
    if (bouyant && abs(distanceToSurface) < 2) {
      if (abs(speedY) < 2) {
        speedY = 0;
        y = surface;
      } 
      else { // break the surface:
        speedY *= .5f;
      }
    }
    else {
      if (statePlay.water.nearSurface && !statePlay.water.nearSurfacePrev && bouyant) {
        y = surface;
      }
      else if (distanceToSurface < 0) { // above water:
        speedY += .5f;
      }
      else if (distanceToSurface > 0) { // below water:
        if (bouyant) speedY -= .5f;
        else if (speedY < bouyancy) speedY += .01f;
        speedX *= .99f;
        speedY *= .95f;
        speedR *= .99f;
      }
    }
  }
  public void draw() {
  }
}

class ParticleBoat extends Particle {
  float sizeX;
  float sizeY;
  
  ParticleBoat(float x, float y) {
    super(x + random(-10, 10), y + random(-10, 10));
    
    bouyant = (random(1) < .25f);
    bouyancy = random(.1f, 1.5f);
    rotation = random(-PI, PI);
    speedR = random(-.1f, .1f);
    lifeSpan = (int)random(100, 500);
    alpha = (int)random(100, 255);
    speedY = random(-10, 1);
    speedX = random(-1, 1);
    sizeX = random(2, 10);
    sizeY = random(2, 10);
  }
  public void draw() {
    noStroke();
    fill(0, alpha);
    rectMode(CENTER);
    pushMatrix();
    translate(x, y);
    rotate(rotation);
    rect(0, 0, sizeX, sizeY);
    popMatrix();
  }
}

class ParticleGib extends Particle {
  int r = 255;
  int b = 255;
  float size;
  PImage img = null;

  ParticleGib(float x, float y) {
    super(x + random(-10, 10), y + random(-10, 10));

    if (random(1) < .5f) {
      img = (random(1) < .5f) ? statePlay.imgGib1 : statePlay.imgGib2;
      size = random(.2f, 1);
    } 
    else {
      size = random(6, 10);
    } 

    bouyancy = random(.1f, 2.5f);
    lifeSpan = (int)random(50, 100);
    alpha = (int)random(100, 255);
    speedY = random(-1, 1);
    speedX = random(-1, 1);
    speedR = random(-.1f, .1f);

    r = (int)random(0, 255);
    b = (int)random(0, 128);
    if (b > r) b = r;
  }
  public void draw() {
    if (img == null) {
      noStroke();
      fill(r, 0, b, alpha);
      ellipse(x, y, size, size);
    } 
    else {
      tint(255, alpha);
      pushMatrix();
      translate(x, y);
      rotate(rotation);
      scale(size, size);
      image(img, -20, -20);
      popMatrix();
    }
  }
}

class ParticleSmoke extends Particle {
  float size;
  float maxSpeedY;
  
  ParticleSmoke(float x, float y) {
    super(x + random(-10, 10), y + random(-10, 10));
    lifeSpan = (int)random(50, 100);
    alpha = (int)random(100, 255);
    speedY = random(-1, 0);
    speedX = random(-1, 1);
    maxSpeedY = random(-1, -.1f);
    size = random(10, 30);
  }
  public void update() {
    if(speedY > maxSpeedY) speedY -= .01f;
    speedX *= .99f;
    super.update();
  }
  public void draw() {
    noStroke();
    fill(0, alpha);
    ellipse(x, y, size, size);
  }
}

class ParticleWater extends Particle {

  boolean gravity = true;
  float size;

  ParticleWater(float x, float y, float speed, boolean gravity) {
    super(x, y);
    this.gravity = gravity;
    size = speed * random(2, 4)/2;
    alpha = 150 + (int)random(0, 100);
    float angle = random(-.5f, .5f) - PIHALF;
    speed *= random(.1f, 1);
    if (!gravity) angle += PI;
    speedX = speed * cos(angle);
    speedY = speed * sin(angle);
  }
  public void update() {
    if (gravity) {
      speedY += .5f;
    }
    else {
      speedY -= .5f;
    }

    super.update();
    float surface = statePlay.water.getValueAt((int)x);
    if ((gravity && speedY > 0 && y > surface) || (!gravity && speedY < 0 && y < surface)) {
      alpha = 0;
      dead = true;
    }
  }
  public void draw() {
    noStroke();
    fill(255, alpha);
    ellipse(x, y, size, size);
  }
}

class Praise {

  int mode; // slide in, stamp in, type in, etc
  int step = 0;
  int nextStepAt = 0;
  int alpha = 255;

  float x = 0;
  float y = 0;
  float rotation = 0;
  float size = 1;
  String[] choices = new String[] {
    "DIE HUMANS!", 
    "YUMMY\nGIBLETS!", 
    "FEEDING\nFRENZY", 
    "BOOM GOES\nTHE DYNAMITE", 
    "PREHISTORIC\nCARNAGE", 
    "EVOLUTIONARY\nPERFECTION", 
    "DELICIOUS,\nDERPY HUMANS!",
    "BIG-ASS\nMUTLIPLIER",  
    "MUTHA 'UCKIN\nRIDICULOUS", 
    "SLEEP WITH\nTHEM FISHES", 
    "CHUM-TASTIC!",
    "HATERS\nGONNA HATE"
  };
  String words;

  Praise() {
    int mult = statePlay.multiplier;
    words = choices[(int)random(choices.length)];
    mode = (int)random(0, 4);
    switch(mode) {
    case 0:
      y = height;
      break;
    case 1:
      x = -width;
      break;
    case 2:
      size = 0;
      break;
    case 3:
      rotation = PI;
      break;
    }
  }
  public void update() {

    if (statePlay.time > nextStepAt) {
      nextStepAt = statePlay.time + 1000;
      step++;
    }

    if (step == 1) {
      if (x != 0) x += (0 - x) * .2f;
      if (y != 0) y += (0 - y) * .2f;
      if (rotation != 0) rotation += (0 - rotation) * .1f;
      if (size != 1) size += (1 - size) * .1f;
    } 
    else if (step == 2) {
      alpha -= 5;
      if (alpha <= 0) alpha = 0;
    }
  }
  public void draw() {
    if(alpha <= 0) return;
    pushMatrix();
    translate(400, 250);
    scale(size, size);
    rotate(rotation);
    fill(255, alpha);
    textFont(fontBig, 80);
    textAlign(CENTER);
    text(words, x, y);
    popMatrix();
  }
}

class Shark extends Object {

  Enemy attackEnemy = null;
  float speed = 0;
  float speedLength;
  float speedR = 0;
  float accelR = .005f;
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
  public void update() {

    if (dead) {
      if (flipVertical) {
        speedR += (rotation > -PI && rotation < 0) ? .005f : -.005f;
      } 
      else {
        speedR += (rotation > -PI && rotation < 0) ? -.005f : .005f;
      }
      speedR *= .95f;
      rotation += speedR;
      if (rotation > PI) rotation -= PI2;
      if (rotation < -PI) rotation += PI2;

      super.update();
      return;
    }

    hurtTimer = 0;

    if (Keys.SPACE && !Keys.PREV_SPACE) speed += 1;
    speed *= .95f;

    if (Keys.LEFT) speedR -= .005f;
    if (Keys.RIGHT) speedR += .005f;

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
      if (Keys.LEFT) speedX -= .2f;
      if (Keys.RIGHT) speedX += .2f;
      if (!Keys.LEFT && !Keys.RIGHT) {
        float rotationTarget = atan2(speedY, speedX);
        float rotationDelta = rotation - rotationTarget;
        if (rotationDelta > PI) rotationTarget += PI2;
        if (rotationDelta < -PI) rotationTarget -= PI2;
        if (rotationTarget > rotation) speedR += .005f;
        if (rotationTarget < rotation) speedR -= .005f;
      }
    }

    if (speedR > .1f) speedR = .1f;
    if (speedR < -.1f) speedR = -.1f;
    rotation += speedR;
    speedR *= .95f;
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
  public void resetJump() {
    jumping = false;
  }
  public void jump() {
    if (jumping) return;
    audio.playJump();
    speedY = 0;
    jumping = true;
    speedY -= 10;
    jumpJuice = 15;
  }
  public void sharkAttack() {

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
  public boolean hurt(float amt) {
    boolean result = super.hurt(amt);
    if (result) audio.playHurt();
    return result;
  }
  public void heal(float amt) {
    hp += amt;
    if (hp > 100) hp = 100;
    audio.playFeed();
  }
  public void kill() {
    img = statePlay.imgSkele;
    bouyant = true;
    super.kill();
  }
  public void cueNextFrame() {
    if (!dead) flipVertical = !flipVertical;
  }
  public void draw() {
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

class Spear extends Object {
  float speed = 10;
  
  Spear(float x, float y){
    this.x = x;
    this.y = y;
    float dx = statePlay.hero.x - x;
    float dy = statePlay.hero.y - y;
    float angle = atan2(dy, dx) + random(-.1f, .1f);
    speedX = speed * cos(angle);
    speedY = speed * sin(angle);
    rotation = angle;
    img = statePlay.imgSpear;
    radius = 0;
  }
  public void update(){
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
class StateMenu {
  int alpha = 0;
  PImage imgTitle;
  PImage imgBG;
  
  StateMenu() {
    imgBG = loadImage("bg.png");
    imgTitle = loadImage("title.png");
  }
  public void update() {
    if(alpha < 255) alpha += 10;
    if(alpha >= 255) alpha = 255;
    
    if(Keys.ENTER && !Keys.PREV_ENTER) playGame();
    Keys.Update();
  }
  public void draw() {
    background(0);
    tint(255);
    image(imgBG, 0, 0);
    tint(255, alpha);
    image(imgTitle, 0, 0);
  }
}
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
  public void update() {
    if(Keys.ENTER && !Keys.PREV_ENTER) showMenu();
    Keys.Update();
  }
  public void draw() {
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
  public boolean isLoaded() {
    return (audio.loaded);
  }
  public void update() {
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
  public void draw() {
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
  public void drawUI() {
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
  public void drawPause() {
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
  public void drawFade() {
    if (!hero.dead) return;
    fade += 2;
    if (fade >= 255) fade = 255;
    noStroke();
    fill(0, fade);
    rect(0, 0, width, height);
  }
  public void drawLoading() {
    background(0);
    fill(255);
    textAlign(CENTER);
    text("LOADING...", width/2, height/2);
  }
  public void addScore(float score, boolean incrMult) {
    this.score += multiplier * score;
    if (incrMult) {
      multiplier ++;
      multiplierCounter = 100;
      if (multiplier > recordMult) recordMult = multiplier;
      if (multiplier % 5 == 0) praise = new Praise();
    }
  }
  public void splashAt(Object obj) {
    float speed = sqrt(obj.speedX * obj.speedX + obj.speedY * obj.speedY);
    for (int i = 0; i < 20; i ++) {
      boolean g = (i < 10);
      float y = obj.y + ((i < 10) ? -5 : 5);

      particles.add(new ParticleWater(obj.x, y, speed, g));
    }
  }
  public void gibsAt(Object obj) {
    for (int i = 0; i < 10; i ++) {
      particles.add(new ParticleGib(obj.x, obj.y));
    }
  }
  public void explosionAt(Object obj) {
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
  public float newEnemyX() {
    float x = random(-2, 2);
    if (x > 0 && x < 1) x = 1;
    if (x < 0 && x >-1) x = -1;
    return hero.x + x * width + random(-width/2, width/2);
  }
  public void newBoat() {
    enemies.add(new Boat(newEnemyX(), (random(1) < .2f)));
  }
  public void newHeli() {
    enemies.add(new Heli(newEnemyX()));
  }
  public void newSub() {
    enemies.add(new Sub(newEnemyX()));
  }
  public void newJelly() {
    enemies.add(new Food(newEnemyX()));
  }
}

class Sub extends Enemy {

  float pilotHeight;

  Sub(float x) {
    super(x);
    y = 500;
    setImg(statePlay.imgSub);
    pilotHeight = random(100, 1000);
    radius = 20;
    hp = 30;
  }
  public void update() {
    if (dead) {
      rotation += speedR;
      speedR *= .99f;
    } else {

      if (statePlay.hero.x > x + targetXOffset) speedX += .1f;
      if (statePlay.hero.x < x + targetXOffset) speedX -= .1f;

      float targetY = statePlay.hero.y; 
      float limitMinDepth = statePlay.water.base + statePlay.water.amp1 + statePlay.water.amp2 + pilotHeight;
      if (targetY < limitMinDepth) targetY = limitMinDepth;

      if (targetY > y + targetYOffset) speedY += .1f;
      if (targetY < y + targetYOffset) speedY -= .1f;
    }
    super.update();
  }
  public void kill() {
    img = statePlay.imgSubX;
    super.kill();
    statePlay.explosionAt(this);
    sinker = true;
    statePlay.addScore(200, true);
    speedR = random(-.05f, .05f);
  }
  public void draw() {
    flipHorizontal = !dead && speedX < 0;
    super.draw();
  }
}

class Water {

  float time = 0;
  float timeMult = 1/10.0f;
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
  public void update() {
    float time = statePlay.time;
    nearSurfacePrev = nearSurface;
    nearSurface = (statePlay.cam.screenToWorldY(0) < amp1 + amp2 + base + 100);
    time *= timeMult;

    if (nearSurface)this.time = time;
    amp2 = 5 + 5 * sin(this.time/100.0f);

    for (int i = 0; i < values.length; i++) {
      values[i] = generateValueAt(i + this.time + statePlay.cam.x);
    }
    wreck.update();
  }
  public float generateValueAt(float x) {
    return base + amp1 * sin(x / period1) + amp2 * sin(x / period2);
  }
  public void draw() {
    drawBottom();
    drawSurface();
  }
  public void drawBottom() {
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
  public void drawSurface() {
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
  public float getValueAt(int x) {
    x = (int) statePlay.cam.worldToScreenX(x);
    if (x < 0) x = 0;
    if (x >= values.length) x = values.length - 1;
    return values[x];
  }
  public float getSlopeAt(int x) {
    int x1 = x - 20;
    int x2 = x + 20;
    float y1 = getValueAt(x1);
    float y2 = getValueAt(x2);
    return atan2(y2 - y1, x2 - x1);
  }
}


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "SharkGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
