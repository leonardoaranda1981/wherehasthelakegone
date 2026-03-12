class Layer {
  Geometry [] features;

  Layer(int numFeatures) {
    features = new Geometry [numFeatures];
  }
  void plot(Color c, int sW) {
    strokeWeight(sW);
    
    for (int i = 0; i<this.features.length; i++) {
      if (this.features[i].type.equals("MultiLineString")) {
        noFill();
        
        for (int j = 0; j<features[i].lines.length; j++ ) {
          //stroke(255, random(255) ,random(255));
          
          features[i].lines[j].drawLine(c);
          
          
        }
         
      } else if (this.features[i].type.equals("MultiPolygon")) {
        
        for (int j = 0; j<features[i].MultiPolygons.length; j++ ) {
          features[i].MultiPolygons[j].drawPolygon(c);
        }
      }
    }
  }
}
