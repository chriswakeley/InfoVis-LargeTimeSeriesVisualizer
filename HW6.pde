// CS5764 InfoVis 
// Some sample code for HW6.
// You are free to use or modify as much of this as you want.

// data parameters:
int maxI = 1073741824;  // a big number
//int maxI = 1048576;  // a big number
int treeD;

//camera params
int maxX;
int wheelVal;
int wheelRange;
float zoomFactor;
float zoomRange;
float camX;
float camY;
int dataRangeX;
float dataRangeY;
float totalYRange;
float oldMouseX;
float oldMouseY;

//drawing temp variables
float oldX;
float oldY;
float currentX;
float currentY;
float minDataX;
float maxDataX;
float minDataY;
float maxDataY;

float[] data = new float[maxI];
float minD, maxD;

//ArrayList<float[]> datatree;

void setup() {
  size(1000, 800);
  treeD = 20;
  //for(int i = 0;i< treeD;i++){
  //  datatree.add(i,new float[(int)(maxI/Math.pow(2,i))]);
  //}
  // simulate some timeseries data, y = f(t)
  data[0] = 0.0;
  //float oldval = 0;
  //float newval = 0;
  for (int i=1; i<maxI; i++){
    /*newval = oldval + random(-1.0, 1.0);
    for(int j = 0;j < treeD; j++){
      datatree.get(j)[(int)(i/Math.pow(2,j))] += newval;
      if(i%Math.pow(2,j)==0){
        datatree.get(j)[(int)(i/Math.pow(2,j))] = (float)(datatree.get(j)[(int)(i/Math.pow(2,j))]/Math.pow(2,j));
      }
    }*/
      
  data[i] = data[i-1] + random(-1.0, 1.0);
    
  //oldval = newval;
  }
  minD = min(data);
  maxD = max(data);
  //minD = min(datatree.get(0));
  //maxD = max(datatree.get(0));
  float oldminD = minD;
  minD = minD - (maxD - minD);
  maxD = maxD + (maxD - oldminD);
  totalYRange = maxD - minD;
  
  camX = maxI/2;
  camY = totalYRange/2 + minD;
  
  maxX = maxI/1;
  zoomRange = (float)(Math.log(maxX/width)/Math.log(2));
  wheelRange = 100;
  wheelVal = 0;  
  zoomFactor = map(wheelVal, 0, wheelRange, 0, zoomRange);
  dataRangeX = (int)(maxX/(Math.pow(2,zoomFactor)));
  dataRangeY = (float)(totalYRange/(Math.pow(2,zoomFactor)));
  minDataX = camX - dataRangeX/2;
  maxDataX = camX + dataRangeX/2;
  minDataY = camY - dataRangeY/2;
  maxDataY = camY + dataRangeY/2;
  
  
}

void draw() {
  background(255);
  // very simple timeseries visualization, VERY slow
  stroke(0);
  //println(minDataX, maxDataX, minDataY, maxDataY, dataRangeY, totalYRange);
  
  oldX = 0;
  oldY = map(data[0], minD, maxD, height-1, 0.0);
  for (int i=1; i<width; i++) {
    //float x = map(i, 0, 2000, 0, width-1);
    currentX = i;
    currentY = map(data[(int)(map(i,0, width, minDataX, maxDataX))], minDataY, maxDataY, height-1, 0.0);
    //currentY = map(datatree.get((int)(map(zoomFactor, 0, zoomRange, 0, treeD)))[(int)(map(i,0, width, minDataX, maxDataX/Math.pow(2,map(zoomFactor, 0, zoomRange, 0, treeD))))], minDataY, maxDataY, height-1, 0.0);
    line(oldX, oldY, currentX, currentY);
    oldX = currentX;
    oldY = currentY;
  }
  oldMouseX = map(mouseX, 0, width, minDataX, maxDataX);
  oldMouseY = map(mouseY, height-1, 0, minDataY, maxDataY);
  //println(oldMouseX, oldMouseY);
  //rect(mouseX, mouseY, 20, 20);

  pushMatrix();
  scale(0.5);
  translate(width/2, height/1.1);
  fill(255, 255, 255,min(map(zoomFactor, 0, zoomRange/6, 0, 255), 255) );
  stroke(0, 0, 0, min(map(zoomFactor, 0, zoomRange/6, 0, 255), 255));
  rect(0, height*2/3, width, height/3);
  
  translate(0, height/3);
  oldX = 0;
  oldY = map(data[0], minD, maxD, height-1, 0);
  //oldY = map(datatree.get(0)[0], minD, maxD, height-1, 0);
  for (int i=1; i<width; i++) {
    //float x = map(i, 0, 2000, 0, width-1);
    currentX = i;
    currentY = map(data[(int)(map(i,0, width, 0, maxX))], minD, maxD, height-1, 0);
    //currentY = map([(int)(map(i,0, width, 0, maxX))], minD, maxD, height-1, 0);
    line(oldX, oldY, currentX, currentY);
    oldX = currentX;
    oldY = currentY;
  }
  noFill();
  rect(map(minDataX, 0, maxX, 0, width), map(maxDataY, minD, maxD, height-1/3, 0), 
       map(dataRangeX, 0, maxX, 0, width), map(dataRangeY, 0, totalYRange, 0, height-1));
  line(map(camX, 0, maxX, 0, width), height/3, map(camX, 0, maxX, 0, width), height*2/3);
  line(0, map(camY, minD, maxD,  height-1, 0), width, map(camY, minD, maxD,  height-1, 0));
  popMatrix();

}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  wheelVal = max(0, min((wheelVal - ((int)(e))), wheelRange));
  zoomFactor = map(wheelVal, 0, wheelRange, 0, zoomRange);
  dataRangeX = (int)(maxX/(Math.pow(2,zoomFactor)));
  dataRangeY = (float)(totalYRange/(Math.pow(2,zoomFactor)));
  minDataX = camX - dataRangeX/2;
  maxDataX = camX + dataRangeX/2;
  minDataY = camY - dataRangeY/2;
  maxDataY = camY + dataRangeY/2;
  
  //move camera coordinates so that points stay stationary on mouse location
  float newMouseX = map(mouseX, 0, width, minDataX, maxDataX);
  float newMouseY = map(mouseY, height - 1, 0, minDataY, maxDataY);
  float camDifX = oldMouseX - newMouseX;
  float camDifY = (oldMouseY - newMouseY);
  
  if(minDataX + camDifX < 0){
    camDifX = 0 - minDataX;
  }
  else if(maxDataX + camDifX >= maxI){
    camDifX = maxI - maxDataX;
  }
  minDataX = minDataX + camDifX;
  maxDataX = maxDataX + camDifX;
  camX = camX + camDifX;
  
  if(minDataY + camDifY < minD){
    camDifY = minD - minDataY;
  }
  else if(maxDataY + camDifY >= maxD){
    camDifY = maxD - maxDataY;
  }
  minDataY = minDataY + camDifY;
  maxDataY = maxDataY + camDifY;
  camY = camY + camDifY;

  //println(wheelVal, zoomFactor,dataRangeX);
}

void mouseDragged() 
{
  float newMouseX = map(mouseX, 0, width, minDataX, maxDataX);
  float newMouseY = map(mouseY, height - 1, 0, minDataY, maxDataY);
  
  float camDifX = oldMouseX - newMouseX;
  float camDifY = (oldMouseY - newMouseY);
  
  if(minDataX + camDifX < 0){
    camDifX = 0 - minDataX;
  }
  else if(maxDataX + camDifX >= maxI){
    camDifX = maxI - maxDataX;
  }
  minDataX = minDataX + camDifX;
  maxDataX = maxDataX + camDifX;
  camX = camX + camDifX;
  
  if(minDataY + camDifY < minD){
    camDifY = minD - minDataY;
  }
  else if(maxDataY + camDifY >= maxD){
    camDifY = maxD - maxDataY;
  }
  minDataY = minDataY + camDifY;
  maxDataY = maxDataY + camDifY;
  camY = camY + camDifY;
  
  oldMouseX = map(mouseX, 0, width, minDataX, maxDataX);
  oldMouseY = map(mouseY, height-1, 0, minDataY, maxDataY);
  
}