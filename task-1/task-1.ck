// Set tempo
145.0 => float bpm;
60::second / bpm / 4.0 => dur sixteenth;

// Create tracks

Track bassDrumTrack;

[0.7, 0.0, 0.0, 0.3,
 0.0, 0.0, 1.0, 0.0,
 0.0, 0.0, 0.0, 0.0,
 0.0, 0.0, 0.0, 0.3] @=> bassDrumTrack.probabilities;

[0.6, 0.0, 0.0, 0.6,
 0.0, 0.0, 1.0, 0.0,
 0.0, 0.0, 0.0, 0.0,
 0.0, 0.0, 0.0, 0.4] @=> bassDrumTrack.gains;

Track snareDrumTrack;

[0.0, 0.0, 0.0, 0.0,
 0.9, 0.0, 0.0, 0.0,
 0.0, 0.0, 0.0, 0.0,
 0.9, 0.0, 0.0, 0.0] @=> snareDrumTrack.probabilities;

[0.0, 0.0, 0.0, 0.0,
 0.7, 0.0, 0.0, 0.0,
 0.0, 0.0, 0.0, 0.0,
 0.7, 0.0, 0.0, 0.0] @=> snareDrumTrack.gains;

// Create instruments
BassDrum bassDrum;
SnareDrum snareDrum;

// Sequenzer
0 => int step;
while (true)
{
  if (Math.rand2f(0.0, 1.0) < bassDrumTrack.probabilities[step % 16])
  {
    bassDrum.keyOn(bassDrumTrack.gains[step % 16]);
  }

  if (Math.rand2f(0.0, 1.0) < snareDrumTrack.probabilities[step % 16])
  {
    snareDrum.keyOn(snareDrumTrack.gains[step % 16]);
  }

  sixteenth => now;

  step++;
}

class Track
{
  float probabilities[16];
  float gains[16];
}

// Instruments

class BassDrum
{
  SinOsc oscB => ADSR envB => SinOsc oscA => ADSR envA => dac;

  65 => oscA.freq;
  1 => oscA.gain;
  2 => oscA.sync;

  envA.set(1::ms, 40::ms, 0, 0::ms);

  1 * oscA.freq() => oscB.freq;
  1 * oscB.freq() => oscB.gain;

  envB.set(1::ms, 30::ms, 0, 0::ms);

  public void keyOn(float gain)
  {
    gain => oscA.gain;
    envA.keyOn();
    envB.keyOn();
  }

  public void keyOff()
  {
    envA.keyOff();
    envB.keyOff();
  }
}

class SnareDrum
{
  SinOsc oscB => ADSR envB => Noise oscA => ADSR envA => dac;

  0.7 => oscA.gain;

  envA.set(1::ms, 40::ms, 0, 0::ms);

  1 * 130 => oscB.freq;
  1 * 130 => oscB.gain;

  envB.set(1::ms, 30::ms, 0, 0::ms);

  public void keyOn(float gain)
  {
    gain => oscA.gain;
    envA.keyOn();
    envB.keyOn();
  }

  public void keyOff()
  {
    envA.keyOff();
    envB.keyOff();
  }
}
