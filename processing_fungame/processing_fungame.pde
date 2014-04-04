int howManyBlocks = 78;
int blocksPerRow = 6;
int blockSize = 48;
Block[] blocks = new Block[howManyBlocks];
Player player;
 
void setup() {
  size(288, 576);
  for (int i=0; i<howManyBlocks; i++) {
    int sprite = int(random(0, 2));
    blocks[i] = new Block(i%blocksPerRow*blockSize, i/blocksPerRow*blockSize, sprite);
  }
  player = new Player();
  println("48*6=" + 48*6);
  println("48*12=" + 48*12);
}
 
void draw() {
  background(#eeddbb);
  for (int i=0; i<howManyBlocks; i++) {
    blocks[i].display();
  }
  player.x = mouseX - player.size/2;
  player.y = mouseY - player.size/2;
  player.display();
}
 
class Player {
  float x, y;
  int size = 24;
  Player(){
    x = width/2 - size/2;
    y = height - blockSize/2 - size/2;
  }
  void display(){
    fill(#99ddaa);
    stroke(#4c6d55);
    rect(x, y, size, size);
  }
}
  
class Block {
  int x, sprite, size;
  float y;
  Block(int _x, int _y, int _sprite) {
    x = _x;
    y = _y;
    sprite = _sprite;
    size = blockSize;
  }
  void display() {
    if (sprite>0) {
      fill(#cc8888);
      stroke(#664444);
      rect(x, y, size, size);
    }
    y += 0.5;
    if (y>=height) {
      y = -blockSize+1;
    }
  }
}
