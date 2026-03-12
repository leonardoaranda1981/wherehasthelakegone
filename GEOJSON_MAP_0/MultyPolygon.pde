class MultiPolygon {
  JSONArray  polygonsArray;
  Polygon [] polygons ;

  MultiPolygon( JSONArray mp) {
    this.polygonsArray = mp;
  }
  void parsePolygons() {
    this.polygons = new Polygon [this.polygonsArray.size()];
    for (int i =0; i<this.polygonsArray.size(); i++) {
      this.polygons[i] = new Polygon (this.polygonsArray.getJSONArray(i).size());
      for (int j = 0; j<this.polygons[i].coordinates.length; j++) {
        JSONArray vec = this.polygonsArray.getJSONArray(i).getJSONArray(j);
        this.polygons[i].coordinates[j] = new PVector (vec.getFloat(0), vec.getFloat(1) );
      }
    }
  }
  void drawPolygon(Color c) {
    
    fill(c.getRed(), c.getGreen(), c.getBlue(), 255);
    noStroke();
    if (polygons.length == 1) {
     
      beginShape();
      for (int i = 0; i<this.polygons[0].coordinates.length; i++) {
        float nx = (float) lonToX(this.polygons[0].coordinates[i].x);
        float ny = (float) latToY(this.polygons[0].coordinates[i].y);
        float screenX = map(nx, (float)minLongMercator, (float)maxLongMercator, 0, width);
        float screenY = map(ny, (float)minLatMercator, (float)maxLatMercator, 0, height);
        vertex(screenX, screenY, this.polygons[0].coordinates[i].z);
      }
      endShape(CLOSE);
    } else {
      
      beginShape();
      

      for (int i = 0; i<this.polygons[0].coordinates.length; i++) {
        float nx = (float) lonToX(this.polygons[0].coordinates[i].x);
        float ny = (float) latToY(this.polygons[0].coordinates[i].y);
        float screenX = map(nx, (float)minLongMercator, (float)maxLongMercator, 0, width);
        float screenY = map(ny, (float)minLatMercator, (float)maxLatMercator, 0, height);
        vertex(screenX, screenY, this.polygons[0].coordinates[i].z);
      }
      for (int i =1; i<this.polygons.length; i++) {
        beginContour();
        for (int j = 0; j< this.polygons[i].coordinates.length;  j++ ) {
       // for (int j = this.polygons[i].coordinates.length-1; j>0; j-- ) {
          float nx = (float) lonToX(this.polygons[i].coordinates[j].x);
          float ny = (float) latToY(this.polygons[i].coordinates[j].y);
          float screenX = map(nx, (float)minLongMercator, (float)maxLongMercator, 0, width);
          float screenY = map(ny, (float)minLatMercator, (float)maxLatMercator, 0, height);
          vertex(screenX, screenY, this.polygons[i].coordinates[j].z);
        }
        endContour();
      }
      endShape(CLOSE);
    }
  }
}
