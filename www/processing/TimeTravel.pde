/* @pjs font="fonts/RobotoCondensed-Light.ttf"; */

PFont font;
PImage gps;
PImage gpsError;
float angleSpeed = -PI;
float angleTimeDilation = -PI;
SoftFloat speed = new SoftFloat(0.0);
int dilation = 0;
int exp = -16;
float radius = 290;
float fontMultiplier = 1;
float currentDilation;
boolean GPSOK = false;
boolean GPSError = false;
float progress = 0;

void setup()
{
  //size(360, 615);
  //size(320, 290);
  //size(displayWidth, displayHeight);
  //size($(window).width() , $(window).height());
  jProcessingJS(this, {fullscreen:true, mouseoverlay:true, optmath:true});
  
  font = createFont('fonts/RobotoCondensed-Light.ttf',200);
  smooth();
  
  if (width > height)
  {
    //LANDSCAPE
    radius = height * 0.7;
    fontMultiplier = map(height, 0, 1080, 0, 2.3);
  }
  else
  {
    //PORTRAIT
    radius = width * 0.7;
    fontMultiplier = map(width, 0, 1080, 0, 2.3);
  }
    
  gps = loadImage("images/gps.png");
  gpsError = loadImage("images/gpserror.png");
}

void draw()
{
  background(#F0F0F0);
             
  if (!GPSError)
  {
      if (GPSOK)
      {
          calculateAngles();
          drawTimeDilation();
          drawSpeed();
          drawText();
      }
      else
      {
          drawGPSLoading();
      }
  }
  else
  {
      drawGPSError();
  }
  drawInterface();
}

void mousePressed()
{
  //TESTING = MOUSE / TOUCH SETS THE SPEED
  //speed.setVal(map(mouseX, 0, width, 0, 1200));
}

void speedUpdate(float s)
{
    speed.setVal(s);
}

void calculateAngles()
{
  int currentSpeed = (int) speed.getVal();
  var d = td.timeDilationFactor(new Speed(currentSpeed, 'Km/h'));
  var dv = new TinyNumber(d - 1);
  dilation = dv.val;
  exp = dv.exp;
  angleTimeDilation = timeTravel.logMap(d, 1, 1.000000000000275, -PI, PI);
  angleSpeed = timeTravel.logMap(currentSpeed, 0, 800, -PI, 0);
}

void setGPSError()
{
    GPSError = true;
}

void unsetGPSError()
{
    GPSError = false;
}

void setGPSOK()
{
    GPSOK = true;
}

void drawGPSError()
{
  image(gpsError, width/2 - 100, height/2 - 200, 200, 200);
  fill(#666666);
  textFont(font, 30 * fontMultiplier);
  textAlign(CENTER, CENTER);
  text("GPS error...", width/2, height/2+100);
}

void drawGPSLoading()
{   
  image(gps, width/2 - 100, height/2 - 200, 200, 200);
    
  if (progress < 101)
  {
      progress++;
  }
  else
  {
      progress = 0;
  }
  stroke(255);
  strokeWeight(25);
  strokeCap(SQUARE);
  noFill();
  arc(width/2, height/2 - 126, 74, 74, -PI, map(progress, 0, 100, -PI, PI));
    
    
  fill(#666666);
  textFont(font, 30 * fontMultiplier);
  textAlign(CENTER, CENTER);
  text("Loading GPS", width/2, height/2+100);
}

void drawTimeDilation()
{
  noStroke();
  fill(255);
  arc(width/2, height/2, height*2, height*2, -PI, angleTimeDilation);
  fill(#F0F0F0);
  ellipse(width/2, height/2, radius + 5, radius + 5);
}

void drawSpeed()
{
  stroke(#0196FF);
  strokeWeight(5);
  strokeCap(SQUARE);
  noFill();
  arc(width/2, height/2, radius, radius, -PI, angleSpeed);
}

void drawText()
{
  //stroke(#F0F0F0);
  //strokeWeight(4);
  textFont(font, 72 * fontMultiplier);
  textAlign(RIGHT, CENTER);
  fill(#666666);
  text(dilation.toFixed(2) + " ", width/2 + 35 * fontMultiplier, height/2 - 30 * fontMultiplier);
  textAlign(LEFT, CENTER);
  text("s", width/2 + 20 * fontMultiplier, height/2 - 30 * fontMultiplier);
  textFont(font, 30 * fontMultiplier);
  textAlign(CENTER, LEFT);
  text(exp, width/2+(70 * fontMultiplier), height/2 - 40);
  fill(#666666);
  textAlign(RIGHT, CENTER);
  text("Speed: ", width/2, height/2 + 30 * fontMultiplier);
  fill(#0196FF);
  textFont(font, 30 * fontMultiplier);
  textAlign(LEFT, CENTER);
  text((int)speed.val + "Km/h", width/2, height/2 + 30 * fontMultiplier);
}

void drawInterface()
{
  fill(#666666);
  textFont(font, 30 * fontMultiplier);
  textAlign(CENTER, CENTER);
  text("<  Current time dilation  >", width/2, height - (60  * fontMultiplier));
}

void keyPressed()
{
  if (keyCode == 40)
  {
    angleSpeed = angleSpeed - 0.1;
    angleTimeDilation = angleTimeDilation - 0.2;
  }
  
  if (keyCode == 38)
  {
    angleSpeed = angleSpeed + 0.1;
    angleTimeDilation = angleTimeDilation + 0.2;
  }
}


