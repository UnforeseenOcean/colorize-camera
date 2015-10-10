class PixelBlockArray {
  ArrayList<PixelBlock> pixel_blocks;

  PixelBlockArray(int col_size, int row_size) {
    pixel_blocks = new ArrayList();
    for (int y = 0; y < height; y += row_size) {
      for (int x = 0; x < width; x += col_size) {
        // (rectMode is CENTER)
        pixel_blocks.add(new PixelBlock(x+col_size/2, y+row_size/2, col_size, row_size));  //  [Brizo]
      }
    }
  }

  //  Atualiza e desenha os PixelBlocks
  void updateAndDraw()
  {
    for (int i = 0; i < pixel_blocks.size(); i ++) {
      if(pixel_blocks.get(i).isOn)
      {
        pixel_blocks.get(i).grab();
        pixel_blocks.get(i).analyze();
        //if (frameCount % 15 == 0) {
        pixel_blocks.get(i).play();
        //}
        pixel_blocks.get(i).display();
      }
    }
  }

  void play() {
  }
  
  int getSize() {
    return pixel_blocks.size(); 
  }
    
  //  Retorna true se a posicao (x,y) eh interna ao bloco indexado por aBlock. Senao, retorna false
  //  Checks wether the position (x,y) is inside the block indexed by aBlock.
  boolean isInsideBlock(int aBlock, float x, float y) {
    return pixel_blocks.get(aBlock).isInside(x, y);
  }
  
  boolean isBlockOn(int aBlock) {
    return pixel_blocks.get(aBlock).isOn;
  }
  
  void switchBlockOnState(int aBlock) {
    pixel_blocks.get(aBlock).switchOnState();
  }
}


color RED   = 0xFF000000;
color GREEN = 0x00FF0000;
color BLUE  = 0x0000FF00;
color GRAY_ = 0x000000FF;
class PixelBlock {
  int x, y,  // posicao 
    w, h;  //  largura, altura
  float r, g, b, a, //  red, green, blue, alpha
    hh, ss, bb;  //  hue, saturation, brightness (nao estao sendo usados)
  //PGraphics pg;   not being used by now
  //PImage img;     not being used by now
  /*String*/int block_color, previous_block_color;  // [Brizo] changed to int
  color grabbedColor;  //  cor do pixel inspecionado
  boolean isOn;  //  true: ligado. false: desligado

  PixelBlock(int _x, int _y, int _w, int _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    a = 255;
    isOn = true;
    grab();
    analyze();
  }

  // [Brizo] Bypassing. This code was taking a block of image but just 
  //using its first pixel. While it is this way, makes no sense. Better
  //use buffer.get(x,y) directly in analyze()
  void grab() {
    /*img = buffer.get(x, y, w, h);
    pg = createGraphics(1, 1);
    pg.beginDraw();
    pg.image(img, 0, 0, 1, 1);
    pg.endDraw();
    pg.loadPixels();*/
  }

  //  - Analisa a cor do pixel investigado (centro do PixelBlock), separando-a em
  //suas componentes R, G, B
  //  - Colore o PixelBlock com a componente mais intensa das tres
  //  * Analizes the color of the investigated pixel (center of the PixelBlock), 
  //separating it in its R, G, B components
  //  * Colorizes the PixelBlock with the most intense component
  void analyze() {
    grabbedColor = xFlippedBuffer.get(x,y); //  why is xFlippedBuffer.pixels[y*width + x] giving null?
    r = grabbedColor >> 16 & 0xFF; //faster than red(pg.pixels[0]);
    g = grabbedColor >> 8 & 0xFF;  //faster than green(pg.pixels[0]);
    b = grabbedColor & 0xFF;       //faster than blue(pg.pixels[0]);
    //println("rgb: " + r + " " + g + " " + b);

    previous_block_color = block_color;

    if (r > b && r > g) {
      block_color = RED;
    }
    else if (b > r && b > g) {
      block_color = BLUE;
    }
    else if (g > r && g > b) {
      block_color = GREEN;
    }
    else {
      block_color = GRAY_;
    }
  }

  //  Se a cor do PixelBlock mudou, toca o som correspondente 'a nova cor. O som tem
  //sua oitava, duracao e ganho parametrizados pela intensidade da componente e pela
  //posicao do PixelBlock na tela
  //  If PixelBlock's color changed, plays the sound corresponding to the new color.
  //The sound has its octave, duration and gain parameterized by the component's
  //intensity and the PixelBlock's position on the screen 
  void play() {
    if (block_color != previous_block_color) {
      if (block_color == RED) {
        red.updateValues(r, x, y);
        red.play();
      }
      else if (block_color == BLUE) {
        blue.updateValues(b, x, y);
        blue.play();
      }
      if (block_color == GREEN) {
        green.updateValues(g, x, y);
        green.play();
      }
    }
  }

  void display() {
    
    //  Mostrando os PixelBlocks
    //  Displaying the PixelBlocks  
    if (block_color != previous_block_color) {
      a = 255;
    }
    noStroke();
    if (block_color == RED) {
      fill(r, 0, 0, a);
    }
    else if (block_color == BLUE) {
      fill(0, 0, b, a);
    }
    else if (block_color == GREEN) {
      fill(0, g, 0, a);
    }
    else {
      fill(10, 10, 10, a);
    }

    if(isOn) {
      rect(x, y, w, h);
    }
    
    a--;
  }
  
  //  Retorna true se (x,y) eh uma posicao dentro do PixelBlock. Senao, retorna false
  //  Returns true if (x,y) is a position inside this PixelBlock. Otherwise, returns false
  boolean isInside(float X, float Y)
  {
    return ( X > x - w/2 && X < x + w/2
          && Y > y - h/2 && Y < y + h/2 );
  }
  
  //  Alterna estado (ligado <-> desligado)
  //  Alternates on/off state
  void switchOnState() {
    isOn = !isOn;
  }
  
}

