class SoftFloat
{
  float val;
  float target;
  float lastVal;
  float position;
  
  SoftFloat(float initialValue)
  {
    this.val = initialValue;
    this.target = initialValue;
    this.lastVal = initialValue;
    this.position = 0.0;
  }
  
  void setVal(float v)
  {
    this.target = v;
    this.lastVal = this.val;
    this.position = 0.0;
  }
  
  float getVal()
  {
    if (this.position <= 1)
    {
      this.position += 0.01;
      this.val = lerp(this.lastVal, this.target, this.position);
      return val;
    }
    else
    {
      return this.target;
    }
  }
}
