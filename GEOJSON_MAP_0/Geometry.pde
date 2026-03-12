class Geometry {
  JSONArray  coordinates;
  String type;
  int elevation;
  String name = null;
  Line [] lines;
  MultiPolygon [] MultiPolygons;

  Geometry(String t, int ele, JSONArray c) {
    this.type = t;
    this.elevation = ele;
    this.coordinates = c;
    //println(this.elevation);
  }
  void loadCoordinates() {
    //println(this.coordinates);
    if (this.type.equals("MultiLineString")) {
      lines = new Line [this.coordinates.size()];
      if (this.elevation > 0) {
       // print("initial value:"+this.elevation);
        this.elevation = (int)map(this.elevation, minElevation, maxElevation, 0, maxMappedElevation );
       // println(", mapped value: "+this.elevation);
      }

      // println("numLines = "+this.coordinates.size());
      for (int i = 0; i<lines.length; i++) {
        JSONArray c = this.coordinates.getJSONArray(i);
        lines[i] = new Line(c.size());
        for (int j = 0; j<c.size(); j++) {
          lines[i].coordinates[j] = new PVector (c.getJSONArray(j).getFloat(0), c.getJSONArray(j).getFloat(1), this.elevation);
        }
      }
    } else if (this.type.equals("MultiPolygon")) {
      MultiPolygons = new MultiPolygon[this.coordinates.size()];
      for (int i = 0; i<this.coordinates.size(); i++) {
        MultiPolygons [i] = new MultiPolygon (this.coordinates.getJSONArray(i));
        MultiPolygons [i].parsePolygons();
      }
    }
  }
}
