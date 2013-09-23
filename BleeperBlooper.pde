import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.ugens.*;

class BleeperBlooper {

  //default instrument note names
  String [][] pianoNotes = {
    {
      "C1", "C#1", "D1", "D#1", "E1", "F1", "F#1", "G1", "G#1", "A1", "A#1", "B1"
    }
    , 
      {
        "C2", "C#2", "D2", "D#2", "E2", "F2", "F#2", "G2", "G#2", "A2", "A#2", "B2"
      }
    , 
      {
        "C3", "C#3", "D3", "D#3", "E3", "F3", "F#3", "G3", "G#3", "A3", "A#3", "B3"
      }
    , 
      {
        "C4", "C#4", "D4", "D#4", "E4", "F4", "F#4", "G4", "G#4", "A4", "A#4", "B4"
      }
    , 
      {
        "C5", "C#5", "D5", "D#5", "E5", "F5", "F#5", "G5", "G#5", "A5", "A#5", "B5"
      }
    , 
      {
        "C6", "C#6", "D6", "D#6", "E6", "F6", "F#6", "G6", "G#6", "A6", "A#6", "B6"
      }
    , 
      {
        "C7", "C#7", "D7", "D#7", "E7", "F7", "F#7", "G7", "G#7", "A7", "A#7", "B7"
      }
  };
  float duration; 
  float startTime;  
  float g;
  int [] scaleDegrees; 
  int octave;
  PinkNoise p;

  //constructor 
  BleeperBlooper (float _startTime, int _octave, int[] _scaleDegrees, float _duration) 
  {
    startTime = _startTime;
    octave =_octave;
    duration = _duration;
    scaleDegrees = _scaleDegrees;
    g = 3;
  } 

  //modify to reflect passed in rgb values 
  void setOctave(int _o)
  {
    octave = _o;//int(map(mouseX, 0, width, 0,6));
  }

  //modify to reflect passed in rgb vaules
  void setDuration(float _d)
  {
    duration = _d;//map(mouseY, 0, height, 0.125, 0.5);
  }

  void setPinkNoise(float _p) {
    p = new PinkNoise(_p);
  }

  void setGain(float _g) {
    g = _g;
  }


  //modify to reflect passed in rgb values  
  void play()
  {
    //out.removeSignal(p);
    //p = new PinkNoise(map(mouseX, 0, width, 0, 0.015)); 
    int j = int(random(11));  
    for (int i = 0; i < scaleDegrees.length; i++){
      if (j == scaleDegrees[i]){ 
        //out.setGain(map(mouseX, 0, width, 0, -12)); 
        out.setGain(g); 
        println(out.getGain());
        out.playNote(startTime, duration, pianoNotes[octave][j]);
        //out.addSignal(p); 
      }
    }
  }
}

