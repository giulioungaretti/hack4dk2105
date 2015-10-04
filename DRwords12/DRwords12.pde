import ddf.minim.*;
Minim minim;
AudioPlayer player;
int canvh,canvw;
PFont font, errorFont;
//24 frames pr second ved pf på 32
int offset;
int year, numberOfYears, takt, slag;
float starty,endy,ydiff;
Table mandater, statsministre,   regeringer_primo, regeringer_ultim, words;
int numberOfBubbles, blinkingBubbles, framesPrBeat;
String[] word;
int[] count;
int totalCount, numberOfFrames;
float[] bubblesize;
float[][] randomX, randomY;
float[] startX, startY;
float[] currentX, currentY;
float[][] Color;
int bubblesizeFactor, bubblesizeTreshold;
int word1, word2, word3, word4, word5, word6, word7, word8;
//for images
PImage img;
int round_year;
int prev_year;


void setup() 
{
  canvw = 1280;
  canvh = 800;
  
  bubblesizeFactor = 50; // 0-100
  bubblesizeTreshold = 20;
  
  numberOfBubbles = 14;
  blinkingBubbles = 4;
  framesPrBeat = 24; // framesPrBeat should be related to numberOf blinkingBubbles times 8 maybe

  //timeline
  starty = 1927;
  endy = 1985;
  ydiff = endy-starty;
  numberOfYears = 1985-1927+1+2;
  
  font = createFont("Helvetica", 24);
  errorFont = createFont("Courier", 48);
  textFont(font);
  textAlign(CENTER, CENTER);

  words = loadTable("words.csv");

  word = new String[numberOfBubbles];
  count = new int[numberOfBubbles];
  bubblesize = new float[numberOfBubbles];
  
  startX = new float[numberOfBubbles];
  startY = new float[numberOfBubbles];
  for (int i=0 ; i<numberOfBubbles; i++ )
  {
    startX[i] = 100 + (float(canvw)-200)*i/numberOfBubbles;
    if (i%2==0)
      startY[i] = 100;
    if (i%2==1)  
      startY[i] = (float(canvh)-300);
  }
  
  randomX = new float[numberOfYears][numberOfBubbles];
  randomY = new float[numberOfYears][numberOfBubbles];
  
  for (int i=0 ; i<numberOfYears ; i++ ) 
  {
    for (int j=0 ; j<numberOfBubbles ; j++ ) 
    {
      randomX[i][j] = random(-0.8,0.9);
      randomY[i][j] = random(-0.4,0.65);
    }
  }
  
  currentX = new float[numberOfBubbles];
  currentY = new float[numberOfBubbles];
  for (int i=0 ; i<numberOfBubbles ; i++ ) 
  {
    currentX[i] = startX[i] + random(-30,30);
    currentY[i] = startY[i] + random(-30,30);
  }

  Color = new float[numberOfBubbles][3];
  int[][] colors = {{232,226,235},
                      {124,204,20},
                      {217,127,27},
                      {234,82,129},
                      {173,125,215},
                      {34,244,222},
                      {246,235,141},
                      {60,187,213},
                      {151,138,58},
                      {235,194,40},
                      {205,121,87},
                      {184,112,133},
                      {252,196,95},
                      {178,234,81}};


  for (int i=0 ; i<numberOfBubbles ; i++ ) 
  {
      Color[i][0]=colors[i][0];
      Color[i][1]=colors[i][1];
      Color[i][2]=colors[i][2];
  }

  size(canvw, canvh, P3D);
  offset=millis();
}

void draw() {
  int ms=millis();
  if(frameCount==1) offset=ms;
  println("frame=" + frameCount + " millis=" + ms + " frames/sec " + (float)(frameCount-1)/(float)(ms-offset)*1000.0  + " ((millis()-offset)/1000.0)/((frameCount-1)/30.0)=" + ((ms-offset)/1000.0)/((frameCount-1)/30.0) );
  int r = frameCount/(blinkingBubbles*framesPrBeat);
  takt = year-1925;
  int s = frameCount%(blinkingBubbles*framesPrBeat);
  slag = (s-s%framesPrBeat)/framesPrBeat +1;
  numberOfFrames = blinkingBubbles*framesPrBeat;
  println("r=" + r + " s=" + s);
  //if (r>words.getRowCount()) {exit();}
  if (r>words.getRowCount()) {exit();}
  
  // --RAMME
  background(15);
  colorMode(RGB);
  println("test1");
//antal frames pr sekund sættes til 24 når pf=32

  year = words.getInt(r,0);
  for (int i=0 ; i<numberOfBubbles ; i++ ) 
  {
    word[i] = words.getString(r,i*2+2);
    count[i] = words.getInt(r,i*2+3);
  }
 
  for (int i=0 ; i<numberOfBubbles ; i++ )
  {
  bubblesize[i] = log(float(count[i]))*bubblesizeFactor;
  }


  println("bubblesize", int(bubblesize));  
  println("year=" + year + "word0=" + word[0] + " count0=" + count[0] + "word1=" + word[1] + " count1=" + count[1] + "word2=" + word[2] + " count2=" + count[2]
  + "word3=" + word[3] + " count3=" + count[3]);
  
  
  println(bubblesize[0]);  

//WORDS 1-15
for (int i=0; i<numberOfBubbles; i++)
if (bubblesize[i] > bubblesizeTreshold)
{
  currentX[i] = currentX[i] + randomX[r][i] + (startX[i] - currentX[i])/numberOfFrames;
  currentY[i] = currentY[i] + randomY[r][i] + (startY[i] - currentY[i])/numberOfFrames;
  fill(Color[i][0],Color[i][1],Color[i][2],60);
  // pop, vals, tango, salme, klassisk, blues 
  if ( i==7 || i==8 || i==10|| i==12 || i==13 || i==14)
  fill(Color[i][0],Color[i][1],Color[i][2],100-s%(framesPrBeat/3)*(40/float(framesPrBeat/3)));
  //ballet + rock 
  if((i==0 || i==5) && (s>=framesPrBeat && s<2*framesPrBeat) || s>=framesPrBeat*3)
  fill(Color[i][0],Color[i][1],Color[i][2],100-s%(framesPrBeat)*40/float(framesPrBeat));
  //polka + klokkespil + dansemusik
  if (i ==1 || i== 4 || i==3) fill(Color[i][0],Color[i][1],Color[i][2],100-s%framesPrBeat/2*40/float(framesPrBeat/2));
  //jazz
  if (i == 2 && s<framesPrBeat) fill(Color[i][0],Color[i][1],Color[i][2],100-s%framesPrBeat*30/float(framesPrBeat));
  //ouverture
  if (i == 11) fill(Color[i][0],Color[i][1],Color[i][2],100-s%framesPrBeat*40/float(framesPrBeat));
  ellipse(currentX[i],currentY[i],bubblesize[i],bubblesize[i]);
  fill(#ffffff,100);
  text(word[i],currentX[i],currentY[i]);
  noStroke();
}

if (year == 1934 || year == 1940 || year == 1941 || year==1965 || year == 1966 || year == 1967 || year == 1968)
{
  textFont(errorFont);
  fill(#FF0000,100);
  text("<ERROR: Data missing>",canvw/2,canvh/2);
  textFont(font);
}


colorMode(RGB);
fill(60,60,60); 
//text("Year: "+year+ " takt:" + takt + " slag:" + slag,canvw/2,25); 

//Timeline

stroke(255);
line(canvw/20,11*canvh/12,canvw-(canvw/20),11*canvh/12);

for(float i = 1930; i < 1990; i+=10) {
  line(ycoord(i),11*canvh/12,ycoord(i),11*canvh/12+20);
  text(int(i),ycoord(i),11*canvh/12+30);
  stroke(255);
}

for(float i = 1935; i < 1995; i+=10) {
  line(ycoord(i),11*canvh/12,ycoord(i),11*canvh/12+10);
  stroke(255);
}  


round_year = round(year/5)*5;

if(prev_year != round_year){
println(prev_year);
println(round_year);
println("frame");
println(frameCount);
img = loadImage("resizedImages/"+str(round_year)+"c.jpg");
tint(255, abs(sin(3.14*frameCount/480.0)*50));
image(img, 0, 0);
}
tint(255, abs(sin(3.14*frameCount/480.0)*50));

image(img, 0, 0);
prev_year = round_year;

if (r>1) 
{

fill(#ffffff);
noStroke();

rect(ycoord(float(year))-10, (11*canvh/12)-20, 20,10);
triangle(ycoord(float(year)), (11*canvh/12)-2, ycoord(float(year))-10, (11*canvh/12)-10, ycoord(float(year))+10, (11*canvh/12)-10);

fill(255,255,255);
stroke(0);


}
    String filename = "./film/"+nf(frameCount,4)+".tga";
    println(filename);
    saveFrame(filename);
}

float ycoord(float year) 
{
  return (canvw/20)+((year-starty)/ydiff)*(canvw-(canvw/20));
}
