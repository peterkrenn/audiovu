// Set tempo
170.0 => float bpm;
60::second / bpm / 4.0 => dur sixteenth;

// Create tracks

Track bassDrumTrack;

[0.7, 2.0, 0.0, 0.3,
 0.0, 0.0, 1.0, 0.0,
 0.6, 0.5, 0.0, 0.0,
 0.0, 0.0, 0.0, 0.3] @=> bassDrumTrack.probabilities;

[0.6, 0.4, 0.0, 0.6,
 0.0, 0.0, 1.0, 0.0,
 0.4, 0.2, 0.0, 0.0,
 0.0, 0.0, 0.0, 0.3] @=> bassDrumTrack.gains;

Track snareDrumTrack;

[0.0, 0.0, 0.0, 0.0,
 0.9, 0.2, 0.0, 0.6,
 0.0, 0.0, 0.0, 0.0,
 0.9, 0.2, 0.0, 0.0] @=> snareDrumTrack.probabilities;

[0.0, 0.0, 0.0, 0.0,
 0.7, 0.4, 0.0, 0.6,
 0.0, 0.0, 0.0, 0.0,
 0.7, 0.4, 0.0, 0.0] @=> snareDrumTrack.gains;

Track hiHatTrack;

[0.9, 0.3, 0.3, 0.3,
 0.9, 0.3, 0.3, 0.3,
 0.9, 0.3, 0.3, 0.3,
 0.9, 0.3, 0.7, 0.3] @=> hiHatTrack.probabilities;

[0.3, 0.1, 0.3, 0.1,
 0.3, 0.1, 0.3, 0.1,
 0.3, 0.1, 0.3, 0.1,
 0.3, 0.1, 0.3, 0.1] @=> hiHatTrack.gains;

// Create instruments
BassDrum bassDrum;
SnareDrum snareDrum;
HiHat hiHat;

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

  if (Math.rand2f(0.0, 1.0) < hiHatTrack.probabilities[step % 16])
  {
    hiHat.keyOn(hiHatTrack.gains[step % 16]);
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
  SinOsc oscB => ADSR envB => SinOsc oscA => ADSR envA => Gain amp => dac;
  amp => Delay delay => amp;
  60::second / bpm / 4.0 => delay.delay;
  0.05 => delay.gain;

  65 => oscA.freq;
  1 => oscA.gain;
  2 => oscA.sync;

  envA.set(1::ms, 50::ms, 0, 0::ms);

  240 => oscB.freq;
  10 * oscB.freq() => oscB.gain;

  envB.set(1::ms, 50::ms, 0, 0::ms);

  public void keyOn(float gain)
  {
    gain => oscA.gain;
    envA.keyOn();
    envB.keyOn();
  }
}

class SnareDrum
{
  SinOsc oscB => ADSR envB => SinOsc oscA => ADSR envA => Gain amp => dac;
  amp => Delay delay => amp;
  60::second / bpm / 4.0 => delay.delay;
  0.07 => delay.gain;

  288 => oscA.freq;
  0.7 => oscA.gain;
  2 => oscA.sync;

  envA.set(1::ms, 40::ms, 0, 0::ms);

  654 => oscB.freq;
  15 * oscB.freq() => oscB.gain;

  envB.set(1::ms, 40::ms, 0, 0::ms);

  public void keyOn(float gain)
  {
    gain => oscA.gain;
    envA.keyOn();
    envB.keyOn();
  }
}

class HiHat
{
  SinOsc oscB => ADSR envB => SinOsc oscA => ADSR envA => Gain amp => dac;
  amp => Delay delay => amp;
  60::second / bpm / 4.0 => delay.delay;
  0.05 => delay.gain;

  500 => oscA.freq;
  0.7 => oscA.gain;
  2 => oscA.sync;

  envA.set(1::ms, 30::ms, 0, 0::ms);

  1500 => oscB.freq;
  60 * oscB.freq() => oscB.gain;

  envB.set(1::ms, 30::ms, 0, 0::ms);

  public void keyOn(float gain)
  {
    gain => oscA.gain;
    envA.keyOn();
    envB.keyOn();
  }
}
