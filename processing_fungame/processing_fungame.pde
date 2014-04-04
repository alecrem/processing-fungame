int howManyBlocks = 78;
int blocksPerRow = 6;
int blockSize = 48;
int playerSize = 24;
int difficulty = 60,
bonus = 94, 
lifeLoss = 20,
lifeBonus = 5;
float gameSpeed = 1.0,
gameSpeedIncrease = 0.002;
boolean globalHit = false;
Block[] blocks = new Block[howManyBlocks];
Player player;

void setup() {
  size(288, 576);
  for (int i=0; i<howManyBlocks; i++) {
    int sprite = int(random(0, 100));
    blocks[i] = new Block(i%blocksPerRow*blockSize, i/blocksPerRow*blockSize-height, sprite, i);
  }
  player = new Player();
}

void draw() {
  globalHit = false;
  background(#eeddbb);
  for (int i=0; i<howManyBlocks; i++) {
    blocks[i].display();
  }
  player.x = mouseX - player.size/2;
  player.y = mouseY - player.size/2;
  player.display();
  stroke(#440000);
  fill(#cc0000);
  rect(0, 0, 100, 10);
  fill(#cccc00);
  rect(0, 0, player.life/10, 10);
  fill(#220000);
  text(player.score, 110, 10);
}

class Player {
  float x, y;
  int size = playerSize;
  int life = 1000, score = 0;
  Player() {
    x = width/2 - size/2;
    y = height - blockSize/2 - size/2;
  }
  void display() {
    fill(#66dd88);
    if (globalHit) {
      fill(#113355);
    }
    stroke(#4c6d55);
    rect(x, y, size, size);
  }
}

class Block {
  int x, sprite, size, id;
  float y;
  Block(int _x, int _y, int _sprite, int _id) {
    x = _x;
    y = _y;
    id = _id;
    sprite = _sprite;
    size = blockSize;
  }
  void display() {
    boolean isHit = false;
    if (sprite>difficulty) {
      if (player.x<x+size && player.x+player.size>x && player.y<y+size && player.y+player.size>y) {
        isHit = true;
        globalHit = true;
        //text("touche " + id, width, height);
        //println("touche " + id);
        if (sprite>bonus) {
          player.life += lifeBonus;
        }
        else {
          player.life -= lifeLoss;
        }
        if (player.life>1000) {
          player.life=1000;
          sprite = 0;
        }
        if (player.life<0) {
          noLoop();
        }
      }
      if (isHit) {
        if (sprite>bonus) {
          fill(#88ff00);
        }
        else {
          fill(#773333);
        }
      }
      else {
        if (sprite>bonus) {
          fill(#88cc22);
        }
        else {
          fill(#cc8888);
        }
      }
      stroke(#664444);
      rect(x, y, size, size);
    }
    y += gameSpeed;
    if (y>=height) {
      y = -blockSize+1;
      sprite = int(random(0, 100));
      player.score ++;
      gameSpeed += gameSpeedIncrease;
    }
  }
}
