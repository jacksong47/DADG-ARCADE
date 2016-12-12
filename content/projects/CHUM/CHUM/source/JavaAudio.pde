
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
  void setVolume(float amt) {
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
  void playFeed() {
    feed.trigger();
  }
  void playJump() {
    jump.trigger();
  }
  void playHurt() {
    hurt.trigger();
  }
  void playMusic() {
    music.loop();
  }
  void playPowerup() {
    powerup.trigger();
  }
  void playExplosion() {
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
  void stop() {
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

