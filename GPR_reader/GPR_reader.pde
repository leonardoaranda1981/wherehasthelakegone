import java.util.Collections;

int lineCount = -1;
int rowCount = 0;
ArrayList<ArrayList<Integer>> dynamic2DList = new ArrayList<>();
int offset = 1776;
int scale = 4;

int frame = 0;

color c1 = color(68, 147, 126);//verde
color c2 = color(35, 68, 139);//azul
color c3 = color(218, 190, 81);//amarillo
color c4 = color(214, 100, 137);//rosa
PImage bkg;

int no_of_samples = 256;
int max_amplitude = 12000;

int xGraph, yGraph, wGraph, hGraph;

FFT ffTransformer = new FFT();

int colorThreshold = 155;


void setup() {
  size(1920, 1024, P3D);

  bkg = createImage(width, height, RGB);
  setGradient(  c1, c2 );

  xGraph = 0;
  yGraph = height/2;
  wGraph = width;
  hGraph = height/2;

  byte b[] = loadBytes("DATA.GPR");
  //dynamic2DList.add(new ArrayList<>());
  println("Analyzing data");
  // Print each value, from 0 to 255
  for (int i = 0; i < b.length; i+=2) {
    if (i % 512 == 0) {
      dynamic2DList.add(new ArrayList<>());
      lineCount++;
    }
    // bytes are from -128 to 127, this converts to 0 to 255
    byte byte1 = b[i]; // Example byte value
    byte byte2 = b[i+1];
    int intValue = (int) ((byte1 << 8) | (byte2 & 0xFF));
    dynamic2DList.get(lineCount).add(intValue);
  }
  // Print a blank line at the end
  println("Complete analyzing");
  println("number of lines: "+dynamic2DList.size());
  println("Starting FFT");

  for (int i = 0; i < dynamic2DList.size(); i++) {
    int no_of_samples = dynamic2DList.get(i).size();
    //print(no_of_samples+",");
    ArrayList <Double> real = new ArrayList<Double>();
    ArrayList <Double> imag = new ArrayList<Double>();
    //int[] samples =  new int[dynamic2DList.get(i).size()];

    for ( int j =0; j< no_of_samples; j++) {
      real.add((double)dynamic2DList.get(i).get(j));
      imag.add( (double) 0.0);
    }
    ffTransformer.compute(real, imag, no_of_samples);
    ffTransformer.complexToMagnitude(real, imag, no_of_samples);
    dynamic2DList.get(i).clear();
    for (int n = 0; n<real.size(); n++) {
      double  depth_corrected_amplitude = real.get(n) * exp(n * 0.025);
      int scaled_amplitude = (int)(depth_corrected_amplitude * 255.0 / max_amplitude);
      if (scaled_amplitude > 255) scaled_amplitude = 255;
      dynamic2DList.get(i).add(scaled_amplitude);
    }

    // dynamic2DList.get(i).addAll(real);

    //println(samples.length);
  }


  //Arraylist
  ///ffTransformer


  println("number of represented lines: "+(dynamic2DList.size()-offset));
}

void draw() {
//  background(0);
  background(bkg);
  // println(dynamic2DList.size()-offset);


  for (int i = 0; i < int(dynamic2DList.size()/scale); i++) {
    for (int j = 0; j < dynamic2DList.get(i).size(); j++) {
      // print(i);
      int index;
      if (offset+i+frame < dynamic2DList.size()-1) {
        index = offset+i+frame;
      } else {
        index = offset+((offset+i+frame)-(dynamic2DList.size()-1));
      }
      int val = dynamic2DList.get(index).get(j);
      color c;
      if (val < colorThreshold) {
        float inter = map(val, 0, colorThreshold, 0, 1);
        c = lerpColor(c2, c1, inter);
      } else {
        float inter = map(val, colorThreshold, 255, 0, 1);
        c = lerpColor(c4, c3, inter);
      }
      /*
      noFill();
      stroke(c);
      strokeWeight(wGraph/(dynamic2DList.size()-offset)*scale);
      point(xGraph+map(offset+i, offset, offset+dynamic2DList.size()/scale, 0, wGraph), yGraph+j*(hGraph/256));
      */
     
      
      noStroke();
      fill(c);
      rect(xGraph+map(offset+i, offset, offset+dynamic2DList.size()/scale, 0, wGraph), yGraph+j*(hGraph/256),wGraph/(dynamic2DList.size()-offset)*scale, hGraph/256 );
      
      
    }
  }
  if (offset+frame < dynamic2DList.size()-1) {
    frame++;
  } else {
    frame = 0;
  }
}
void setGradient( color c1, color c2 ) {
  for (int i = 0; i <bkg.width; i++) {
    for (int j = 0; j <bkg.height; j++) {
      float inter = map(j, 0, height, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      bkg.set(i, j, c);
    }
  }
}
