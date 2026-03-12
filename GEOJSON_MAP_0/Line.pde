class Line {
  PVector [] coordinates ;

  Line( int numVec) {
    this.coordinates = new PVector [numVec];
  }
   void drawLine(Color c) {
    float[] hsbvals = new float[3];
    Color.RGBtoHSB(c.getRed(), c.getBlue(), c.getGreen(), hsbvals);
    float brightness = hsbvals[2]*map (this.coordinates[0].z, 0, maxMappedElevation, .25, 1);
    int rgbFromHSB = Color.HSBtoRGB(hsbvals[0], hsbvals[1], brightness);
    Color MappedColor = new Color(rgbFromHSB);
    
    //println(hsbvals);
    stroke(MappedColor.getRGB());
    beginShape();
    for (int i = 0; i<this.coordinates.length; i++) {
      float nx = (float) lonToX(this.coordinates[i].x);
      float ny = (float) latToY(this.coordinates[i].y);
      float screenX = map(nx, (float)minLongMercator, (float)maxLongMercator, 0, width);
      float screenY = map(ny, (float)minLatMercator, (float)maxLatMercator, 0, height);
      vertex(screenX, screenY, this.coordinates[i].z);
    }
   endShape();
  }
 
}
