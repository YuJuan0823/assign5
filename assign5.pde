PImage bg1,bg2;
int bgx=0;

PImage start1,start2,end1,end2;
PImage hp;
float speed=6;
float blood=38.8;
int gameState;
final int GAME_START=1, GAME_RUN=2,GAME_OVER=3;

PImage fighter,treasure;
float treasureX,treasureY;
float fighterX,fighterY;

PImage enemy;
int enemyCount = 8;

int[] enemyX = new int[enemyCount];
int[] enemyY = new int[enemyCount];

int enemyMode;
int enemyWave=0;
final int STRAIGHT=0, SLOPE=1, DIAMOND=2;
//shoot
PImage shoot;
int numFire=5;
float shootX[]=new float [numFire];
float shootY[]=new float [numFire];
int shootCount=-1;

boolean upPressed=false;
boolean downPressed=false;
boolean leftPressed=false;
boolean rightPressed=false;

int score=0;
float enemyChange;
int k,enemyID;
void setup () {
    size(640, 480) ;
   
    //treasure locate
    treasureX=floor(random(0,599));
    treasureY=floor(random(0,439));
    fighterX=589;
    fighterY=235;
    
    gameState=GAME_START;
    shootCount=-1;

    //image loading
    start1=loadImage("img/start1.png");
    start2=loadImage("img/start2.png");
    end1=loadImage("img/end1.png");
    end2=loadImage("img/end2.png");
    enemy = loadImage("img/enemy.png");
    fighter=loadImage("img/fighter.png");
    treasure=loadImage("img/treasure.png");
    hp=loadImage("img/hp.png");
    bg1=loadImage("img/bg1.png");
    bg2=loadImage("img/bg2.png");
    shoot=loadImage("img/shoot.png");
    addEnemy(0);
}

void draw(){
  switch(gameState){
    
   case GAME_START:
    image(start2,0,0);
    if (mouseX<441 && mouseX>208 && mouseY>379 && mouseY<411){
    image(start1,0,0);
     if (mousePressed){
      gameState=GAME_RUN;
     }
    }
    break; //GAME_START end
    
   case GAME_RUN:
    //scrolling background
    bgx=bgx%1280;
    bgx++;
    image(bg1,bgx,0);
    image(bg2,bgx-640,0);
    image(bg1,bgx-1280,0);
    
    //score
    String scoring= "score : "+score;
    fill(255);
    textSize(30);
    text(scoring, 0,470);
    //enemy
    
    for (int i = 0; i < enemyCount; ++i) {
     if (enemyX[i] != -1 || enemyY[i] != -1) {
      image(enemy, enemyX[i], enemyY[i]);
 
      enemyX[i]+=5; 

     }
    }
    

    enemyChange+=5;
    if(enemyChange>=width){
    enemyWave++;
    if(enemyWave%3==1){
    addEnemy(1);
    }else if(enemyWave%3==2){
    addEnemy(2);
    }else{
    addEnemy(0);
    }
    }
    for(int i=0; i<enemyCount; i++){
      if(enemyX[i]!=-1&&enemyY[i]!=-1){
    if(isHit(fighterX,fighterY,fighter.width,fighter.height,enemyX[i],enemyY[i],enemy.width,enemy.height)){
    enemyX[i]=-1;
    enemyY[i]=-1;
    blood-=38.8;
    }
      }
    }

    
   

    
    //fighter 
    if(fighterX<0){
    fighterX=0;
    }
    if(fighterX>589){
    fighterX=589;
    }
    if(fighterY<0){
    fighterY=0;
    }
    if(fighterY>429){
    fighterY=429;
    }
    image(fighter,fighterX,fighterY);
    
    //treasure
    image(treasure,treasureX,treasureY);
    //blood
    fill(255,0,0);
    rect(13,3,blood,20);
    //hp
    image(hp,0,0);
   
    //fighter get treasure
    if (isHit(fighterX,fighterY,fighter.width,fighter.height,treasureX,treasureY,treasure.width,treasure.height)){
    treasureX=floor(random(0,599));
    treasureY=floor(random(0,439));
    blood+=19.4;
    }
    
    //blood upper bound 
    if (blood>=194.0){
    blood=194.0;
    }
    
    //fire
    if(enemyChange+381>0){
    for(int j=0; j<enemyCount; j++){
    for(int i=0; i<numFire; i++){
     if(enemyX[j]!=-1&&enemyY[j]!=-1){
     if(isHit(enemyX[j],enemyY[j],enemy.width,enemy.height,shootX[i],shootY[i],shoot.width,shoot.height)){
    scoreChange(20);
    enemyX[j]=-1;
    enemyY[j]=-1;
    shootX[i]=-100;
    shootY[i]=-100;
     }
     }
    }
    }
    }
   
    if(shootCount>=-1){
      for(int i=0; i<numFire; i++){
    shootX[i]-=speed;
    image(shoot,shootX[i],shootY[i]);
    enemyID=closestEnemy(i,i);
    if(shootX[i]>enemyChange){
    if(shootY[i]<enemyY[enemyID]){
    shootY[i]+=2;
    }
    if(shootY[i]>enemyY[enemyID]){
    shootY[i]-=2;
    }
    }
    
    }

    if(shootX[0]+31<0.0){
    shootCount--;
    
    }
    }
    if(shootCount<=-1){
    shootCount=-1;
    }
    
    
   
   
    
   
    
    
    break;//GAME_RUN end
    
    case GAME_OVER:
    image(end2,0,0);
    if (mouseX<431 && mouseX>208 && mouseY>312 && mouseY<345){
     image(end1,0,0);
     if (mousePressed){
     gameState=GAME_RUN;
     shootCount=-1;
     treasureX=floor(random(0,599));
     treasureY=floor(random(0,439));
     fighterX=588;
     fighterY=245;
     blood=38.8;
     enemyWave=0;
     addEnemy(0);
     score=0;
     for(int i=0; i<numFire; i++){
     shootX[i]=-100;
     shootY[i]=-100;
     }
     }
    }
    break;//GAME_OVER end
    
}//switch gameState end

   //game over
   if(int (blood)<=0){
   gameState=GAME_OVER;
   }
   
   
   //fighter control
   if(upPressed){
   fighterY-=speed;
   }
   if(downPressed){
   fighterY+=speed;
   }
   if(leftPressed){
   fighterX-=speed;
   }
   if(rightPressed){
   fighterX+=speed;
   }
}//draw end

void addEnemy(int type)
{  for (int i = 0; i < enemyCount; ++i) {
    enemyX[i] = -1;
    enemyY[i] = -1;
    }
  
  switch (type) {
    case 0:
      addStraightEnemy();
      enemyChange=enemyX[0]-400;
      break;
    case 1:
      addSlopeEnemy();
      enemyChange=enemyX[0]-400;
      break;
    case 2:
      addDiamondEnemy();
      enemyChange=enemyX[0]-400;
      break;
  }
  
}

void addStraightEnemy()
{
  float t = random(height - enemy.height);
  int h = int(t);
  for (int i = 0; i < 5; ++i) {

    enemyX[i] = (i+1)*-80;
    enemyY[i] = h;
    
  }

    
}
void addSlopeEnemy()
{
  float t = random(height - enemy.height * 5);
  int h = int(t);
  for (int i = 0; i < 5; ++i) {

    enemyX[i] = (i+1)*-80;
    enemyY[i] = h + i * 40;
  }
  
}
void addDiamondEnemy()
{
  float t = random( enemy.height * 3 ,height - enemy.height * 3);
  int h = int(t);
  int x_axis = 1;
  for (int i = 0; i < 8; ++i) {
    if (i == 0 || i == 7) {
      enemyX[i] = x_axis*-80;
      enemyY[i] = h;
      x_axis++;
    }
    else if (i == 1 || i == 5){
      enemyX[i] = x_axis*-80;
      enemyY[i] = h + 1 * 40;
      enemyX[i+1] = x_axis*-80;
      enemyY[i+1] = h - 1 * 40;
      i++;
      x_axis++;
      
    }
    else {
      enemyX[i] = x_axis*-80;
      enemyY[i] = h + 2 * 40;
      enemyX[i+1] = x_axis*-80;
      enemyY[i+1] = h - 2 * 40;
      i++;
      x_axis++;
    }
  }
    
}

void keyPressed(){
  if(key==CODED){
  switch(keyCode){
  case UP:
    upPressed=true;
    break;
  case DOWN:
    downPressed=true;
    break;
  case LEFT:
    leftPressed=true;
    break;
  case RIGHT:
    rightPressed=true;
    break;
  }
  }
  
  if(keyCode==' '&&shootCount<4){
  shootCount++;
  if(shootCount>4){
    shootCount=4;
    }
  if(shootCount>=0){
  shootX[shootCount]=fighterX;
  shootY[shootCount]=fighterY+12;
  }
  }

}
void keyReleased(){
if(key==CODED){
  switch(keyCode){
  case UP:
    upPressed=false;
    break;
  case DOWN:
    downPressed=false;
    break;
  case LEFT:
    leftPressed=false;
    break;
  case RIGHT:
    rightPressed=false;
    break;
  }
  }

}

boolean isHit(float ax,float ay,int aw,int ah,float bx,float by,int bw,int bh){
if(ax<bx+bw&&ax+aw>bx&&ay<by+bh&&ay+ah>by){
return true;
}else{
return false;
}
}

void scoreChange(int value){
score+=value;
}

int closestEnemy(int x, int y){
float min=dist(enemyX[0]+30.5,enemyY[0]+30.5,shootX[x]+15.5,shootY[y]+13.5);
for(int i=0; i<enemyCount; i++){
if(enemyX[i]!=-1&&enemyY[i]!=-1){
if(dist(enemyX[i],enemyY[i],x,y)<=min){
min=dist(enemyX[i],enemyY[i],x,y);
k=i;
}
}
}
return k;
}

