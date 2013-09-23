import processing.video.*;

class CameraCapture {
  Capture cam;

  CameraCapture(PApplet applet) {
    String[] cameras = Capture.list();

    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } 
    else {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
        println(cameras[i]);
      }
      cam = new Capture(applet, cameras[0]);
      cam.start();
    }
  }

  void read() {
    if (cam.available() == true) {
      cam.read();
    }
  }

  PImage toImage() {
    return cam;
  }
}

