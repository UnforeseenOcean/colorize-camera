//  Tiago Brizolara da Rosa, 2013
//  after https://github.com/antiboredom/colorize-camera
//  forked at https://github.com/brizolara/colorize-camera
//
//  Plays sounds according to the color variations on the 
//captured video.
//  User can toggle on/off sectors of the screen by mouse click
//  Video inverted horizontally to provide better usability
//  -Extensively commented because of educational use
//
//  Toca sons de acordo com as variacoes de cor no video capturado.
//  O usuario pode ligar/desligar setores da tela com o click do mouse.
//  Video invertido horizontalmente para melhorar a experiencia do usuario
//  -Extensivamente comentado em razao de uso educacional
//

//video objects
PGraphics buffer;
PGraphics xFlippedBuffer;
CameraCapture cam;
PixelBlockArray pixelBlocks;

//audio objects
Minim minim = new Minim( this );
AudioOutput out = minim.getLineOut();
int [] scaleR = {0, 4, 7, 11};
int [] scaleG = {2, 6, 9};
int [] scaleB = {0, 2, 4, 6, 7, 9, 11}; 

BleeperBlooper red = new BleeperBlooper(.5,    0, scaleR, 0.25);
BleeperBlooper green = new BleeperBlooper(.25, 0, scaleG, 0.25);
BleeperBlooper blue = new BleeperBlooper(0,    0, scaleB, 0.25);


void setup() {
//  frameRate();
  size(640, 480); 
  rectMode(CENTER);  //  [Brizo]
  buffer = createGraphics(width, height);
  xFlippedBuffer = createGraphics(width, height);
  cam = new CameraCapture(this);
  pixelBlocks = new PixelBlockArray(width / 4, height / 4);
}

void draw() {
  background(255);
  cam.read();
  //  old way: buffer and displayed image without x-flipping
  //buffer.set(0, 0, cam.toImage());
  //set(0, 0, cam.toImage());
  //  [Brizo] Flipping the image horizontally, so the work gets more intuitive to use
  //  Aqui invertemos em x a imagem (tanto na hora de guardar em xFlippedBuffer quanto ]
  //na hora de desenhar na tela). Caso contrario, nao eh intuitivo de operar
  pushMatrix();
    scale(-1,1);
    image(cam.toImage(), -width, 0);
  popMatrix();
  xFlippedBuffer.copy(get(), 0, 0, width, height, 0, 0, width, height);

  pixelBlocks.updateAndDraw();
  
  //  Pequenos retangulos indicam o centro dos PixelBlocks e se eles estao ligados
  //  Small rects indicate the center of the PixelBlocks and if they're on or off
  stroke(0);
  fill(255, 64); // transparent white
  for(int i=0; i<4; i++) {
    for(int j=0; j<4; j++) {
      if(pixelBlocks.isBlockOn(j*4 + i)) { 
        rect(i*width/4+width/8, j*height/4+height/8, 4, 4);
      } 
    } 
  }
  
}

//  Click do mouse sobre um bloco o liga/desliga
//  Clicking over the region of a PixelBlock switches it on or off
void mouseReleased() {
  for(int i=0; i<pixelBlocks.getSize(); i++) {
    if( pixelBlocks.isInsideBlock(i, mouseX, mouseY) ) {
      pixelBlocks.switchBlockOnState(i);
    }
  }
}

void stop()
{
  // always close Minim audio classes when you are finished with them
  out.close();
  minim.stop();
 
  super.stop();
}

