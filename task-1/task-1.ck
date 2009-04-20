BassDrum bassDrum;

while (true)
{
  bassDrum.keyOn();
  500::ms => now;
  bassDrum.keyOff();
}

public class BassDrum
{
  SinOsc oscB => ADSR envB => SinOsc oscA => ADSR envA => dac;
  
  65 => oscA.freq;
  1 => oscA.gain;
  2 => oscA.sync;
  
  envA.set(1::ms, 40::ms, 0, 0::ms);
  
  1 * oscA.freq() => oscB.freq;
  1 * oscB.freq() => oscB.gain;
  
  envB.set(1::ms, 30::ms, 0, 0::ms);
  
  public void keyOn()
  {
    envA.keyOn();
    envB.keyOn();
  }
  
  public void keyOff()
  {
    envA.keyOff();
    envB.keyOff();
  }
}