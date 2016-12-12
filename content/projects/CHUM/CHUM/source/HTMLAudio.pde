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
