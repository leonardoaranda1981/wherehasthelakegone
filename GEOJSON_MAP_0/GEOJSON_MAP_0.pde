import java.io.*;
import java.awt.Color;
import processing.opengl.*;

File [] JSONfiles ;
ArrayList <JSONObject> archivosGeoJSON;
ArrayList <Layer> layers  = new ArrayList<Layer>();
Color [] colorPalette;

double maxLong = -98.6242;
double minLong = -99.8076;
double minLat = 19.9159;
double maxLat = 19.0451;

int minElevation = 2300;
int maxElevation = 3900;

int maxMappedElevation = 140; 

double maxLongMercator, minLongMercator, maxLatMercator, minLatMercator;
int indexLayer = 0;
float xRotation = .75;
float Ycamera;

PImage img;

void setup() {
  size(1280, 768, P3D);
   
  //smooth();
  maxLongMercator = lonToX(maxLong);
  minLongMercator = lonToX (minLong);
  maxLatMercator = latToY (maxLat);
  minLatMercator = latToY(minLat);

  Color cyan = new Color (0, 255, 255);

  File directory = new File(dataPath(""));
  FileFilter filter = new FileFilter() {
    public boolean accept(File f)
    {
      return f.getName().endsWith("geojson");
    }
  };
  if (directory.exists() && directory.isDirectory()) {
    JSONfiles = directory.listFiles(filter);
  }
  if (JSONfiles != null) {

    colorPalette = new Color [JSONfiles.length];
    for (int i = 0; i<colorPalette.length; i++) {
      GeoJSON2vec(i);
    }
    colorPalette[0] = new Color (0, 0, 0);
    colorPalette[1] = new Color (255, 0, 0);
    colorPalette[2] = new Color (164, 81, 54);
    colorPalette[3] = cyan;
    colorPalette[4] = cyan;
    colorPalette[5] = new Color (255, 255, 255);
    colorPalette[6] = cyan;
  }
  Ycamera  = height/2;
}

void draw() {
  background(0);
  strokeWeight(1);
  stroke(0, 0, 255);
  //  beginCamera();
  ambientLight(102, 102, 102);
 // camera(width/2.0, height/2, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  pushMatrix();
  rotateX(xRotation);
  for (int i = 0; i < layers.size(); i++) {
    Layer l = layers.get(i);
    l.plot(colorPalette[i], 1);
  }
  popMatrix();
  camera(width/2,height/2, (height/2.0) / tan(PI*30.0 / 180.0), width/2, height/2, 0, 0, 1, 0);
  Ycamera-=5;
  println(Ycamera);
}

void GeoJSON2vec(int index) {
  JSONObject json = loadJSONObject(JSONfiles[index].getName());
  JSONArray features = json.getJSONArray("features");
  layers.add( new Layer(features.size()));
  for (int i = 0; i < features.size(); i++) {
    int ele = 0;
    JSONArray coordinates = features.getJSONObject(i).getJSONObject("geometry").getJSONArray("coordinates");
    if ( features.getJSONObject(i).getJSONObject("properties").isNull("elevacion") == false) {
      ele = features.getJSONObject(i).getJSONObject("properties").getInt("elevacion");
    }

    layers.get(indexLayer).features[i] = new Geometry(features.getJSONObject(i).getJSONObject("geometry").getString("type"), ele, coordinates);
    layers.get(indexLayer).features[i].loadCoordinates();
  }
  indexLayer++;
}

double latToY(double latitude) {
  double y  = Math.log(Math.tan(Math.PI / 4 + Math.toRadians(latitude) / 2));
  return y;
}
double lonToX(double longitude) {
  double x = Math.toRadians(longitude);
  return x;
}
