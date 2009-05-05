second / samp => float sampleRate;
3::second => dur bufferLength;
float buffer[(bufferLength / samp) $ int];

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
        if (hidMsg.ascii == 82)
        {
          spork ~ record();
        }
      }
    }
  }
}

spork ~ keyboardTracker();

while (true)
{
  for (0 => int position; position < buffer.cap(); position++)
  {
    buffer[position] => dac.next;
    1::samp => now;
  }
}
