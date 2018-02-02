
// Cell attributes
int cellSize = 10;
int optimalDistance = 6;

// initial shape
int radius = 200;
int num = 100;
int max = 10000;

// details
int steps = 6;
int picks = 100;
float angle = TWO_PI / float(num);

cell[] cellObj = new cell[num];

void setup(){
  size(1000,1000);
  // draw circle
  for (int i = 0; i < num; i++){
    cellObj[i] = new cell(width/2+radius*sin(angle*i),height/2+radius*cos(angle*i),0,0);
  }
}
// function to return proper coords within array length range
int coord(float a) {
  a = a / float(num);
  a = a - floor(a);
  a = a * num;
  return int(a);
}
void draw(){
  background(255);

  for (int i = 0; i < num; i++){
    // Keep distance to closest cells
    for (int s = 1; s < steps; s++){
      cellObj[i].keepDistance(cellObj[coord(float(i)-s)],0.0001-0.0001*(float(s)/steps), s*optimalDistance);
      cellObj[i].keepDistance(cellObj[coord(float(i)+s)],0.0001-0.0001*(float(s)/steps), s*optimalDistance);
    }
    
    // move away from certain amount (picks) of random other cells
    // random other cell is choosen differently in every frame
    // Way more efficent than looping thrue all other cells and equally effective
    for (int s = 1; s < picks; s++){
      int index = int(random(0,num-2*steps));
      // Avoid moving away from neigbouring cells
      if( index >= i-steps){
        index += 2*steps;
      }
      cellObj[i].avoid(cellObj[index],0.0008-0.0008*(float(s)/steps));
      cellObj[i].avoid(cellObj[index],0.0008-0.0008*(float(s)/steps));
    }
    cellObj[i].update();
    cellObj[i].display();
  }
  
  // Introduce new cells at random locations
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
    //fill(0);
    strokeWeight(1);
    stroke(0);
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