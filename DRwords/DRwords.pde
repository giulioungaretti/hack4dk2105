import ddf.minim.*;
Minim minim;
AudioPlayer player;
int canvh,canvw;
PFont font, errorFont, exitFont;
int offset;
int year, numberOfYears, takt, slag;
float starty,endy,ydiff;
Table mandater, statsministre,   regeringer_primo, regeringer_ultim, words;
int numberOfBubbles, beatPrMeasure, framesPrBeat;
String[] word;
int[] count;
int totalCount, framesPrMeasure;
float[] bubblesize;
float[][] randomX, randomY;
float[] startX, startY;
float[] currentX, currentY;
float[][] Color;
int bubblesizeFactor, bubblesizeTreshold;
//for images
PImage img;
int round_year;
int prev_year;


void setup() 
{
  canvw = 1280;
  canvh = 800;
  
  bubblesizeFactor = 50; // 0-100
  bubblesizeTreshold = 0;
  
  numberOfBubbles = 15;
  beatPrMeasure = 4;
  framesPrBeat = 24; // framesPrBeat should be related to numberOf beatPrMeasure times 8 maybe

  //timeline
  starty = 1925;
  endy = 1985;
  ydiff = endy-starty;
  numberOfYears = 1982-1925+10;
  
  font = createFont("Helvetica", 24);
  errorFont = createFont("Courier Bold", 48);
  exitFont = createFont("Avenir", 48);
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
                      {205,121,87},
                      {124,150,40},
                      {60,187,213},//klokkespil
                      {246,235,141},
                      {34,244,222},
                      {173,125,215},
                      {217,127,27},//vals
                      {235,194,40},
                      {252,196,95},
                      {184,112,133},
                      {124,204,20},
                      {178,234,81},
                      {234,82,129},
                      {151,138,58}};


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
  int r = frameCount/(beatPrMeasure*framesPrBeat);
  takt = year-1925;
  int s = frameCount%(beatPrMeasure*framesPrBeat);
  slag = (s-s%framesPrBeat)/framesPrBeat +1;
  framesPrMeasure = beatPrMeasure*framesPrBeat;
  println("r=" + r + " s=" + s);
  if (r>words.getRowCount()) {exit();}
  
  // --RAMME
  background(15);
  colorMode(RGB);
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


//WORDS 1-15
for (int i=0; i<numberOfBubbles; i++)
if (bubblesize[i] > bubblesizeTreshold)
{
  currentX[i] = currentX[i] + randomX[r][i] + (startX[i] - currentX[i])/framesPrMeasure;
  currentY[i] = currentY[i] + randomY[r][i] + (startY[i] - currentY[i])/framesPrMeasure;
  fill(Color[i][0],Color[i][1],Color[i][2],60);
  // pop, vals, tango, salme, klassisk, blues (0,8,16,...,88) (0-95)
  if ( i==7 || i==8 || i==10|| i==12 || i==13 || i==14)
  fill(Color[i][0],Color[i][1],Color[i][2],100-(s%(framesPrBeat/3))*(40/float(framesPrBeat/3)));
  //ballet + rock  (24, 72) (0-95)
  if((i==0 || i==5) && ((s>=framesPrBeat && s<2*framesPrBeat) || s>=3*framesPrBeat))
  fill(Color[i][0],Color[i][1],Color[i][2],100-s%(framesPrBeat)*40/float(framesPrBeat));
  //polka + klokkespil + dansemusik (0,12,24,..,84) (0-95)
  if (i ==1 || i== 4 || i==3)
  fill(Color[i][0],Color[i][1],Color[i][2],100-(s%(framesPrBeat/2))*40/float(framesPrBeat/2));
  //jazz - kun på 0 (0-95)
  if (i == 2) fill(Color[i][0],Color[i][1],Color[i][2],100-(s%(4*framesPrBeat))*40/float(4*framesPrBeat));
  //ouverture (på 0,24,48,72) (0-95)
  if (i == 11) fill(Color[i][0],Color[i][1],Color[i][2],100-(s%framesPrBeat)*40/float(framesPrBeat));
  noStroke();
  ellipse(currentX[i],currentY[i],bubblesize[i],bubblesize[i]);
  fill(#ffffff,100);
  text(word[i],currentX[i],currentY[i]);
}

if (year == 1934 || year == 1940 || year == 1941 || year==1965 || year == 1966 || year == 1967 || year == 1968)
{
  textFont(errorFont);
  fill(#FF0000,100);
  text("<ERROR: Data missing>",canvw/2,canvh/2);
  textFont(font);
}

if (year > 1982 && year <= 1984)
{
  textAlign(LEFT, CENTER);
  textFont(exitFont);
  fill(255,60);
  text("Created at Hach4dk 2015 by using DR program data. ",canvw/16,canvh*1/6);
  text("Analyzing the occurrence of words used in daily   ",canvw/16,canvh*2/6);
  text("programs in DR in the period 1925 to 1983, in May.",canvw/16,canvh*3/6);
  text("We look at the changes over time and convert this ",canvw/16,canvh*4/6);
  text("into algorithmic music and visual art.            ",canvw/16,canvh*5/6);
}

if (year > 1984)
{
  textAlign(LEFT, CENTER);
  textFont(exitFont);
  fill(255,60);
  text("by                          ",canvw/4,canvh*1/7);
  text("Anders Bjørn Rørbæk Pedersen",canvw/4,canvh*2/7);
  text("Giulio Ungaretti            ",canvw/4,canvh*3/7);  
  text("Claus Jørgensen             ",canvw/4,canvh*4/7);
  text("Henri Suominen              ",canvw/4,canvh*5/7);
  text("Ulf Rørbæk Pedersen         ",canvw/4,canvh*6/7);  
}



colorMode(RGB);
fill(60,60,60); 

//Timeline
textFont(font);
stroke(255,60);
line(canvw/20,11*canvh/12,canvw-(canvw/20),11*canvh/12);

textAlign(CENTER, CENTER);
for(float i = 1930; i < 1990; i+=10) {
  line(ycoord(i),11*canvh/12,ycoord(i),11*canvh/12+20);
  fill(255,60);
  text(int(i),ycoord(i),11*canvh/12+30);
}

for(float i = 1925; i <= 1985; i+=10) {
  line(ycoord(i),11*canvh/12,ycoord(i),11*canvh/12+10);
}  

round_year = round(year/5)*5;

//Images
if(prev_year != round_year)
{
  println(prev_year);
  println(round_year);
  println("frame");
  println(frameCount);
  img = loadImage("resizedImages/"+str(round_year)+"c.jpg");
  tint(255, pow(abs(sin(3.14*frameCount/480.0)),0.8)*50);
if (year<1985) image(img, 0, 0);
}
tint(255, pow(abs(sin(3.14*frameCount/480.0)),0.8)*50);

println(pow(abs(sin(3.14*frameCount/480.0)),0.8)*50);
if (year<1985) image(img, 0, 0);
prev_year = round_year;

fill(#ffffff);
noStroke();

stroke(#7E0000);fill(#7E0000);
if (year<1986)
  triangle(ycoord(float(year)), (11*canvh/12)-2, ycoord(float(year))-7, (11*canvh/12)-10, ycoord(float(year))+7, (11*canvh/12)-10);

    String filename = "./film/"+nf(frameCount,4)+".tga";
    println(filename);
    //saveFrame(filename);
}

float ycoord(float year) 
{
  return (canvw/20)+((year-starty)/ydiff)*(canvw-2*(canvw/20));
}
