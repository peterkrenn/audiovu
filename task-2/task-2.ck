3::second => dur bufferLength;

adc => LiSa buffer => dac;
bufferLength => buffer.duration;

function void record()
{
  1 => buffer.record;
  bufferLength => now;
  0 => buffer.record;
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
  1 => buffer.play;
  bufferLength => now;
}
