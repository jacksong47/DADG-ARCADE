import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

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


void setup() {
  size(800, 600);

  minim = new Minim(this);
  audio = new JavaAudio();
  audio.setVolume(.5);

  font = createFont("Arial", 20);
  fontBig = createFont("Arial Bold Italic", 100);

  showMenu();
}
void draw() {
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

void showMenu() {
  stateOver = null;
  stateMenu = new StateMenu();
}
void gameOver(int score, int level, int life, int kills, int mult, int air, int snacks) {
  statePlay = null;
  stateOver = new StateOver(score, level, life, kills, mult, air, snacks);
}
void playGame() {
  stateMenu = null;
  statePlay = new StatePlay();
}
void stop() {
  audio.stop();
  minim.stop();
  super.stop();
}

