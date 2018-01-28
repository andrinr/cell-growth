int cellSize = 6;
int radius = 200;
int num = 100;
int max = 10000;
int steps = 3;
int picks = 50;
float angle = TWO_PI / float(num);
int optimalDistance = 6;

cell[] cellObj = new cell[num];
void setup(){
  size(1000,1000);
  for (int i = 0; i < num; i++){
    cellObj[i] = new cell(width/2+radius*sin(angle*i),height/2+radius*cos(angle*i),0,0);
  }
    
}
int coord(float a) {
  a = a / float(num);
  a = a - floor(a);
  a = a * num;
  return int(a);
}
void draw(){
  background(0,0.01);
  print("   fps: ");
  print(int(frameRate));
  for (int i = 0; i < num; i++){
    for (int s = 1; s < steps; s++){
      cellObj[i].keepDistance(cellObj[coord(float(i)-s)],0.0001-0.0001*(float(s)/steps), s*optimalDistance);
      cellObj[i].keepDistance(cellObj[coord(float(i)+s)],0.0001-0.0001*(float(s)/steps), s*optimalDistance);
    }
    
    for (int s = 1; s < picks; s++){
      int index = int(random(0,num-2*steps));
      if( index >= i-steps){
        index += 2*steps;
      }
      cellObj[i].avoid(cellObj[index],0.0008-0.0008*(float(s)/steps));
      cellObj[i].avoid(cellObj[index],0.0008-0.0008*(float(s)/steps));
    }
    
    cellObj[i].update();
    cellObj[i].display();

  }
  
  if(num < max && frameCount % 1 == 0){
    int index = int(random(0,num));
    float xP = cellObj[coord(float(index)-1.0)].getX();
    float yP = cellObj[coord(float(index)-1.0)].getY();
    float xN = cellObj[index].getX();
    float yN = cellObj[index].getY();
    
    xP -= xN;
    yP -= yP;
    xP *= 0.5;
    yP *= 0.5;
    
    cell ins = new cell(xN + yP, yN + yP,0,0);
    cellObj = (cell[])splice(cellObj,ins,index);
    //cellObj = splice(cellObj, ins, index);
    num += 1;
  }
}
class cell {
  float x;
  float y;
  float ax;
  float ay;
  
  cell(float posX,float posY, float accX,float accY){
    x = posX;
    y = posY;
    ax = accX;
    ay = accY;
  }
  
  float getX(){
    return x;
  }
  float getY(){
    return y;
  }
  
  void display(){
    fill(255);
    strokeWeight(0);
    ellipse(x,y,cellSize, cellSize);
  }
  
  void update(){
    x += ax;
    y += ay;
    ax *= 0.96;
    ay *= 0.96;
  }
  
  void keepDistance(cell cellObj, float s, int d){
    float targetX = cellObj.getX();
    float targetY = cellObj.getY();
    targetX -= x;
    targetY -= y;
    float l = sqrt(targetX*targetX + targetY*targetY);
    l = +s*(l-d);
    ax += l * targetX;
    ay += l * targetY;
  }
  
  void avoid(cell cellObj, float s){
    float targetX = cellObj.getX();
    float targetY = cellObj.getY();
    targetX -= x;
    targetY -= y;
    float l = sqrt(targetX*targetX + targetY*targetY);
    if ( l < 40){
      l = s*(1.0/l);
      ax += l * targetX;
      ay += l * targetY;
    }
  }
    
}