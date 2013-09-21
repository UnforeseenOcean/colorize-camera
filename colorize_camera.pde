PGraphics buffer;
CameraCapture cam;
PixelBlockArray pixel_blocks;

void setup() {
  size(640, 480); 
  buffer = createGraphics(width, height);
  cam = new CameraCapture(this);
  pixel_blocks = new PixelBlockArray(width / 20, height / 20);
}

void draw() {
  cam.read();
  buffer.set(0, 0, cam.toImage());
  set(0, 0, cam.toImage());
  pixel_blocks.display();
}
