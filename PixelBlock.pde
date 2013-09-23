class PixelBlockArray {
  ArrayList<PixelBlock> pixel_blocks;

  PixelBlockArray(int col_size, int row_size) {
    pixel_blocks = new ArrayList();
    for (int y = 0; y < height; y += row_size) {
      for (int x = 0; x < width; x += col_size) {
        pixel_blocks.add(new PixelBlock(x, y, col_size, row_size));
      }
    }
  }

  void display() {   
    for (int i = 0; i < pixel_blocks.size(); i ++) {
      pixel_blocks.get(i).grab();
      pixel_blocks.get(i).analyze();
      pixel_blocks.get(i).display();
    }
  }
  
  void play() {
    
    
  }
}



class PixelBlock {
  int x, y, w, h;
  float r, g, b, hh, ss, bb;
  PGraphics pg;
  PImage img;

  PixelBlock(int _x, int _y, int _w, int _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    grab();
    analyze();
  }

  void grab() {
    img = buffer.get(x, y, w, h);
    pg = createGraphics(1, 1);
    pg.beginDraw();
    pg.image(img, 0, 0, 1, 1);
    pg.endDraw();
    pg.loadPixels();
  }

  void analyze() {
    r = red(pg.pixels[0]);
    g = green(pg.pixels[0]);
    b = blue(pg.pixels[0]);
  }

  void display() {
    noStroke();
    if (r > b && r > g) {
      fill(r, 0, 0, 100);
    }
    else if (b > r && b > g) {
      fill(0, 0, b, 100);
    }
    else if (g > r && g > b) {
      fill(0, g, 0, 100);
    }
    else {
      fill(10, 10, 10, 100);
    }

    //fill(r, g, b);

    rect(x, y, w, h);
  }
}

