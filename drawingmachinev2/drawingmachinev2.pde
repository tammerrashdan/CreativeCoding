float red;
float green;
float blue;

float drawX;
float drawY;

float sizeX;
float sizeY;

float randomMouseDraw;
float randomMouseSize;

int shapeSelect = 1;

void setup()
{
  size(800, 600);
  background(227, 207, 87);

  red = random (200, 255);
  green = random(100, 110);
  blue = random(30, 50);

  drawX = random(0, (width - 1));
  drawY = random(0, (height - 1));
}

void draw()
{
  noStroke();
  rectMode(CENTER);
  ellipseMode(CENTER);
  red = random (200, 255);
  green = random(100, 110);
  blue = random(30, 50);

  randomMouseSize = map(mouseX, 0, (width - 1), 0, 40);

  sizeX = random(5 + randomMouseSize, 15 + randomMouseSize);
  sizeY = random(5 + randomMouseSize, 15 + randomMouseSize);

  fill(red, green, blue);
  if (shapeSelect == 1)
  {
    ellipse(drawX, drawY, sizeX, sizeY);
  } else if (shapeSelect == 2)
  {
    rect(drawX, drawY, sizeX, sizeY);
  } else if (shapeSelect == 3)
  {
    triangle(drawX, drawY - (sizeY/2), drawX - (sizeX/2), drawY + (sizeY/2), drawX + (sizeX/2), drawY + (sizeY/2));
  }
  randomMouseDraw = map(mouseY, 0, (height - 1), 20, 5);

  drawX = (drawX + random(-randomMouseDraw, randomMouseDraw));
  drawY = (drawY + random(-randomMouseDraw, randomMouseDraw));

  if (drawX > width)
  {
    drawX = 0;
  } else if (drawX < 0)
  {
    drawX = width - 1;
  }
  if (drawY > height)
  {
    drawY = 0;
  } else if (drawY < 0)
  {
    drawY = height - 1;
  }
}

void keyPressed()
{
  if (key == ' ')
  {
    background(227, 207, 87);
  } else if (key == '1')
  {
    shapeSelect = 1;
  } else if (key == '2')
  {
    shapeSelect = 2;
  } else if (key == '3')
  {
    shapeSelect = 3;
  }
}

