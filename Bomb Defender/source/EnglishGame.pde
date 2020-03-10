import ddf.minim.*;
Minim minim;
AudioPlayer bgMusic;
AudioPlayer explosionSound;

PFont font;

PImage bgImg;
PImage bombImg;
PImage missileImg;
PImage launcherImg;
PImage explosionImg;

int points = 0;
int highscore = 0;

int[] bombX;
int[] bombY;

float missileX;
float missileY;

int n = 1;
float v = 255;

float missileSpeed = 7;
float speedBombsY = 4;
float speedBombsX = 0;

float missileSpeedY = 0;
float missileSpeedX = 0;

float mouseClickX;
float mouseClickY;

boolean dead = false;
boolean sound = false;

void setup() {
  size(1280, 720);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);

  bombX = new int[n];
  bombY = new int[n];
  for (int i = 0; i < n; i++) {
    setBombs(i);
  }
  bombY[0] = height+200;
  minim = new Minim(this);
  bgMusic = minim.loadFile("amadeus-legendary.mp3");
  bgMusic.play();
  explosionSound = minim.loadFile("Explosion.mp3");

  font = createFont("joystix monospace.ttf", 10);
  textFont(font);

  bgImg = loadImage("background.png");
  bombImg = loadImage("bomb.png");
  missileImg = loadImage("missile.png");
  launcherImg = loadImage("launcher.png");
  explosionImg = loadImage("explosionWave.png");

  missileX = width/2;
  missileY = height-46;
}

void draw() {
  background(bgImg);
  drawBombs();
  drawMissiles();

  moveBombs();
  moveMissils();

  hitTarget();

  drawForground();
}


void drawForground() {
  image(launcherImg, width/2, height-46);
  noFill();
  strokeWeight(10);
  rect(0, 0, width, height);

  textSize(55);
  fill(0);
  text(points, width/2, 50);

  textSize(30);
  fill(0);
  textAlign(LEFT, CENTER);
  text("Highscore: " + highscore, 30, 20);
  textAlign(CENTER, CENTER);
}

void drawBombs() {
  for (int i = 0; i < n; i++) {
    fill(255, 0, 0);
    noStroke();
    image(bombImg, bombX[i]+random(2)-1, bombY[i]);
  }
}

void drawMissiles() {
  translate(missileX, missileY);
  rotate(atan(-(mouseClickX-width/2)/(mouseClickY-(height-46))));
  image(missileImg, 0, 0);
  rotate(-atan(-(mouseClickX-width/2)/(mouseClickY-(height-46))));
  translate(-missileX, -missileY);
  //stroke(0);
  //strokeWeight(5);
  //fill(255, 255, 0);
  //ellipse(missileX, missileY, 20, 20);
}

void setBombs(int i) {
  bombX[i] = floor(random(0 + 117/2 + 150, width - 117/2 - 150));
  //bombY[i] = floor(random(-height + 125/2, 0 - 125/2));
  bombY[i] = -125;
}

void moveBombs() {
  for (int i = 0; i < n; i++) {
    bombY[i] += speedBombsY;

    if (bombY[i] > height + 50) {
      dead();
    }
  }
}

void moveMissils() {
  //width/2, height-46
  if (mousePressed && missileX == width/2 && missileY == height-46 && !dead) {
    mouseClickX = mouseX;
    mouseClickY = mouseY;
    missileSpeedX = (mouseClickX-width/2)/(dist(mouseClickX, mouseClickY, width/2, height-46)/missileSpeed);
    missileSpeedY = (mouseClickY-(height-46))/(dist(mouseClickX, mouseClickY, width/2, height-46)/missileSpeed);
  }
  missileX += missileSpeedX;
  missileY += missileSpeedY;
}

void dead() {
  fill(255, v);
  if (v > 0){
    v -= 2.5;
  }
  rect(-1, -1, width+1, height+1);
  if (sound == false) {
    bgMusic.pause();
    explosionSound.rewind();
    explosionSound.play();
    sound = true;
  }
  textSize(82);
  fill(0);
  text("Click to retry!", width/2, height/2);
  textSize(80);
  fill(255);
  text("Click to retry!", width/2, height/2);

  //textWithOutline("Click to play!", 80, width/2, height/2, 255, 0);

  if (mousePressed) {
    for (int i = 0; i < n; i++) {
      setBombs(i);
      missileX = width/2;
      missileY = height-46;
      missileSpeedX = 0;
      missileSpeedY = 0;
      dead = true;
      points = 0;
      speedBombsY = 4;
      speedBombsX = 0;
      bgMusic.rewind();
      bgMusic.play();
      sound = false;
      v = 255;
    }
  }
}

void mouseReleased() {
  dead = false;
}

void hitTarget() {
  for (int i = 0; i < n; i++) {
    if (dist(missileX, missileY, bombX[i]-30, bombY[i]+30) < 40 || dist(missileX, missileY, bombX[i]+15, bombY[i]-15) < 35) {
      image(explosionImg, bombX[i], bombY[i]);
      setBombs(i);
      missileX = width/2;
      missileY = height-46;
      missileSpeedX = 0;
      missileSpeedY = 0;
      points += 25;
      speedBombsY += 0.4;
      speedBombsX -= 0.2;
      if (points > highscore) {
        highscore = points;
      }
    }
  }
}
