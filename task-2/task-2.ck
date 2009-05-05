3::second => dur bufferLength;
float buffer[(bufferLength / samp) $ int];

300::samp => dur grainLength;
1 => float speed;
1 => float pitch;

adc => blackhole;

function void record()
{
  now => time startTime;
  for (0 => int position; now < startTime + bufferLength; position++)
  {
    adc.last() => buffer[position];
    1::samp => now;
  }
}

function void keyboardTracker()
{
  Hid hid;
  hid.openKeyboard(0);
  HidMsg hidMsg;

  while (true)
  {
    hid => now;

    while (hid.recv(hidMsg))
    {
      if (hidMsg.isButtonDown())
      {
        if (hidMsg.ascii == 82) // r
        {
          spork ~ record();
        }
        else if (hidMsg.ascii == 65) // a
        {
          0.1 -=> speed;
        }
        else if (hidMsg.ascii == 68) // d
        {
          0.1 +=> speed;
        }
        else if (hidMsg.ascii == 87) // w
        {
          0.1 -=> pitch;
        }
        else if (hidMsg.ascii == 83) // s
        {
          0.1 +=> pitch;
        }
      }
    }
  }
}

spork ~ keyboardTracker();

function void playGrain(int start)
{
  Impulse generator => ADSR envelope => dac;
  envelope.set(30::samp, 0::samp, 0.9, 30::samp);

  (grainLength / samp) $ int => int length;

  envelope.keyOn();
  for (start => int position; position < start + length + 30; position++)
  {
    buffer[position] => generator.next;

    if (position > start + length)
    {
      envelope.keyOff();
    }

    pitch * 1::samp => now;
  }
}

while (true)
{
  0 => int position;
  while (position < buffer.cap() - (grainLength / samp) $ int)
  {
    spork ~ playGrain(position);
    Math.floor((grainLength / samp) $ int * speed) $ int +=> position;
    grainLength => now;
  }
}
