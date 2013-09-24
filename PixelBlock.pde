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
      //if (frameCount % 15 == 0) {
      pixel_blocks.get(i).play();
      //}
      pixel_blocks.get(i).display();
    }
  }

  void play() {
  }
}



class PixelBlock {
  int x, y, w, h, a;
  float r, g, b, hh, ss, bb;
  PGraphics pg;
  PImage img;
  String block_color, previous_block_color;

  PixelBlock(int _x, int _y, int _w, int _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    a = 255;
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
    previous_block_color = block_color;

    if (r > b && r > g) {
      block_color = "red";
    }
    else if (b > r && b > g) {
      block_color = "blue";
    }
    else if (g > r && g > b) {
      block_color = "green";
    }
    else {
      block_color = "gray";
    }
  }

  void play() {
    if (block_color != previous_block_color) {
      if (block_color == "red") {
        red.updateValues(r, x, y);
        red.play();
      }
      else if (block_color == "blue") {
        blue.updateValues(b, x, y);
        blue.play();
      }
      if (block_color == "green") {
        green.updateValues(g, x, y);
        green.play();
      }
    }
  }

  void display() {
    if (block_color != previous_block_color) {
      a = 255;
    }
    noStroke();
    if (block_color == "red") {
      fill(r, 0, 0, a);
    }
    else if (block_color == "blue") {
      fill(0, 0, b, a);
    }
    else if (block_color == "green") {
      fill(0, g, 0, a);
    }
    else {
      fill(10, 10, 10, a);
    }

    //fill(r, g, b);
    rect(x, y, w, h);
    
    a--;
  }
}

