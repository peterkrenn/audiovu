3::second => dur bufferLength;

adc => LiSa buffer => dac;
bufferLength => buffer.duration;

function void record()
{
  1 => buffer.record;
  bufferLength => now;
  0 => buffer.record;
}

record();

1 => buffer.play;

bufferLength => now;
