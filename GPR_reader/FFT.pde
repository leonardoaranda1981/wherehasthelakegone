class FFT {
  double _oneOverSamples = 0.0;
  
  FFT(){
  
  }
  public void compute (ArrayList<Double> vReal, ArrayList<Double> vImag, int samples) {
    //println("vImage size:"+vImag.size());
    //println("vReal size:"+vReal.size());
    double oneOverSamples = this._oneOverSamples;
    if (oneOverSamples == this._oneOverSamples) {
      oneOverSamples = 1.0 / samples;
    }
    // Reverse bits
    int j = 0;
    for (int i = 0; i < (samples - 1); i++) {
      if (i < j) {
        Collections.swap(vReal, i, j);
        Collections.swap(vImag, i, j);
      }
      int k = samples >> 1;
      while (k <= j) {
        j -= k;
        k >>= 1;
      }
      j += k;
    }
    // Compute the FFT
    double c1 = -1.0;
    double c2 = 0.0;
    int l2 = 1;
    int power = exponent(samples);
    for (int l = 0; l < power; l++) {
      int l1 = l2;
      l2 <<= 1;
      double u1 = 1.0;
      double u2 = 0.0;
      for (j = 0; j < l1; j++) {
        for (int i = j; i < samples; i += l2) {
          int i1 = i + l1;
          double t1 = u1 * vReal.get(i1) - u2 * vImag.get(i1);
          double t2 = u1 * vImag.get(i1) + u2 * vReal.get(i1);
          vReal.set(i1, vReal.get(i) - t1)  ;
          vImag.set(i1, vImag.get(i) - t2);
          vReal.set(i, vReal.get(i)+ t1 ) ;
          vImag.set(i, vImag.get(i)+ t2 ) ;
        }
        double z = (u1 * c1) - (u2 * c2);
        u2 = (u1 * c2) + (u2 * c1);
        u1 = z;
      }
      double  cTemp = 0.5 * c1;
      c2 = Math.sqrt(0.5 - cTemp);
      c1 = Math.sqrt(0.5 + cTemp);
      c2 = -c2;
    }
  }

  public void complexToMagnitude(ArrayList<Double> vReal, ArrayList<Double> vImag, int samples) {
   // println("vImage size:"+vImag.size());
    //println("vReal size:"+vReal.size());
    for (int i = 0; i < (samples >> 1) + 1; i++) {
      double t = Math.sqrt((vReal.get(i)*vReal.get(i)) + (vImag.get(i)*vImag.get(i)));
      vReal.set(i, t);
    }
  }
  private int exponent(int value) {
    // Calculates the base 2 logarithm of a value
    int result = 0;
    while (value > 1) {
      value >>= 1;
      result++;
    }
    return result;
  }
}
