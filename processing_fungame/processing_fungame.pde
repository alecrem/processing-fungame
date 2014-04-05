int howManyBlocks = 78, blocksPerRow = 6, blockSize = 48, playerSize = 24, 
difficulty = 60, bonus = 94, lifeLoss = 20, lifeBonus = 5, 
bgR = 255, bgG = 0, bgB = 0, bgRSign = +1, bgGSign = -1;
float gameSpeed = 1.0, gameSpeedIncrease = 0.002;
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
  initBackground();
}

void draw() {
  updateBackground();
  globalHit = false;
  for (int i=0; i<howManyBlocks; i++) {
    blocks[i].display();
  }
  player.display();
  printScore();
}

void printScore() {
  stroke(68, 0, 0, 200);
  fill(204, 0, 0, 150);
  rect(0, 0, 100, 10);
  fill(230, 230, 0, 150);
  rect(0, 0, player.life/10, 10);
  fill(34, 0, 0);
  text(player.score, 110, 10);
}

void initBackground(){
  bgR = int(random(127, 256));
  bgG = int(random(127, 256));
  bgB = int(255 - bgR/2 - bgG/2);
}
void updateBackground(){
  if (bgR>=255 || bgR<=0) {
    bgRSign *= -1;
  }
  bgR += bgRSign;
  if (bgG>=255 || bgG<=0) {
    bgGSign *= -1;
  }
  bgG += bgGSign;
  bgB = int(255 - bgR/2 - bgG/2);
  background(255 - (255-bgR)/4, 255 - (255-bgG)/4, 255 - (255-bgB)/4);
}

class Player {
  float x, y;
  int size = playerSize, life = 1000, score = 0;
  Player() {
    x = width/2 - size/2;
    y = height - blockSize/2 - size/2;
  }
  void display() {
    player.x = mouseX - player.size/2;
    player.y = mouseY - player.size/2;
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
  boolean isHit = false;
  Block(int _x, int _y, int _sprite, int _id) {
    x = _x;
    y = _y;
    id = _id;
    sprite = _sprite;
    size = blockSize;
  }
  void display() {
    isHit = false;
    if (sprite>difficulty) {
      hitCheck();
      if (isHit) {
        if (sprite>=bonus) {
          getLife();
          displayMatrix(bonusBlock(), int(x), int(y), 16, 16);
          fill(136, 255, 0, 80);
        }
        else {
          loseLife();
          displayMatrix(brickBlock(), int(x), int(y), 16, 16);
          fill(119, 51, 51, 80);
        }
      }
      else {
        if (sprite>=bonus) {
          displayMatrix(bonusBlock(), int(x), int(y), 16, 16);
          fill(136, 204, 34, 80);
        }
        else {
          displayMatrix(brickBlock(), int(x), int(y), 16, 16);
          fill(204, 136, 136, 80);
        }
      }
      //stroke(#664444);
      noStroke();
      rect(x, y, size, size);
    }
    move();
  }
  void move() {
    y += gameSpeed;
    if (y>=height) {
      y = -blockSize+1;
      if (sprite>difficulty && sprite<bonus) {
        player.score ++;
      }
      sprite = int(random(0, 100));
      gameSpeed += gameSpeedIncrease;
    }
  }
  void hitCheck() {
    if (player.x<x+size && player.x+player.size>x && player.y<y+size && player.y+player.size>y) {
      isHit = true;
      globalHit = true;
    }
  }
  void getLife() {
    player.life += lifeBonus;
    if (player.life>1000) {
      player.life=1000;
      sprite = 0;
    }
  }
  void loseLife() {
    player.life -= lifeLoss;
    if (player.life<0) {
      noLoop();
    }
  }
}

void displayMatrix(int[][] matrix, int x, int y, int imax, int jmax) {
  int rectSize = 3;
  for (int i=0; i<imax; i++) {
    for (int j=0;j<jmax; j++) {
      if (matrix[i][j] > 0) {
        noStroke();
        fill(map(matrix[i][j], 0, 3, 255, 0), 220);
        rect(x+i*rectSize, y+j*rectSize, rectSize, rectSize);
      }
    }
  }
}

int[][] brickBlock() {
  int[][] matrix = {
    {
      0, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 1, 1, 0
    }
    , 
    {
      1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 1, 1
    }
    , 
    {
      1, 2, 2, 2, 1, 1, 1, 2, 2, 2, 1, 1, 1, 3, 3, 1
    }
    , 
    {
      1, 2, 2, 1, 1, 1, 1, 1, 2, 1, 1, 2, 2, 1, 3, 3
    }
    , 
    {
      2, 2, 1, 2, 2, 2, 2, 3, 1, 1, 2, 2, 2, 2, 1, 3
    }
    , 
    {
      2, 1, 1, 2, 2, 2, 2, 3, 3, 2, 2, 2, 2, 2, 2, 3
    }
    , 
    {
      2, 1, 2, 2, 2, 2, 2, 2, 3, 3, 2, 2, 2, 2, 2, 3
    }
    , 
    {
      2, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 2, 2, 3, 3
    }
    , 
    {
      2, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 2, 2, 3, 1, 3
    }
    , 
    {
      1, 2, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 1, 3
    }
    , 
    {
      1, 2, 2, 1, 1, 2, 2, 2, 2, 3, 3, 1, 2, 3, 1, 3
    }
    , 
    {
      1, 2, 2, 2, 3, 1, 2, 2, 3, 3, 1, 2, 2, 3, 1, 3
    }
    , 
    {
      2, 2, 2, 2, 2, 3, 2, 3, 3, 1, 1, 2, 3, 2, 1, 3
    }
    , 
    {
      3, 2, 2, 2, 3, 3, 1, 1, 1, 1, 2, 3, 3, 2, 1, 3
    }
    , 
    {
      3, 2, 3, 3, 3, 1, 1, 2, 2, 2, 3, 3, 2, 2, 1, 3
    }
    , 
    {
      0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0
    }
  };
  return matrix;
} 

int[][] bonusBlock() {
  int[][] matrix = {
    {
      0, 1, 2, 1, 0, 2, 1, 0, 2, 1, 2, 0, 1, 2, 1, 0
    }
    , 
    {
      1, 1, 2, 1, 0, 2, 1, 0, 2, 1, 2, 0, 1, 2, 1, 1
    }
    , 
    {
      2, 2, 2, 1, 0, 2, 1, 0, 2, 1, 2, 0, 1, 2, 2, 2
    }
    , 
    {
      1, 1, 1, 1, 0, 2, 1, 0, 2, 1, 2, 0, 1, 1, 1, 1
    }
    , 
    {
      0, 0, 0, 0, 0, 2, 1, 0, 2, 1, 2, 0, 0, 0, 0, 0
    }
    , 
    {
      2, 2, 2, 2, 2, 2, 1, 0, 2, 1, 2, 2, 2, 2, 2, 2
    }
    , 
    {
      1, 1, 1, 1, 1, 1, 1, 0, 2, 1, 1, 1, 1, 1, 1, 1
    }
    , 
    {
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    }
    , 
    {
      2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 2
    }
    , 
    {
      1, 1, 1, 1, 1, 1, 1, 0, 2, 1, 1, 1, 1, 1, 1, 1
    }
    , 
    {
      2, 2, 2, 2, 2, 2, 1, 0, 2, 1, 2, 2, 2, 2, 2, 2
    }
    , 
    {
      0, 0, 0, 0, 0, 2, 1, 0, 2, 1, 2, 0, 0, 0, 0, 0
    }
    , 
    {
      1, 1, 1, 1, 0, 2, 1, 0, 2, 1, 2, 0, 1, 1, 1, 1
    }
    , 
    {
      2, 2, 2, 1, 0, 2, 1, 0, 2, 1, 2, 0, 1, 2, 2, 2
    }
    , 
    {
      1, 1, 2, 1, 0, 2, 1, 0, 2, 1, 2, 0, 1, 2, 1, 1
    }
    , 
    {
      0, 1, 2, 1, 0, 2, 1, 0, 2, 1, 2, 0, 1, 2, 1, 0
    }
  };
  return matrix;
} 
