import processing.svg.*;

int numShapes = 120;
float baseRadius = 60;
float circleSpacing = 2.5;

float centerOrbitRadius = 70;  //  how far the centers orbit from the canvas center

float sineAmplitude = 50;  // size of the modulating sine wave
float noiseAmplitude = 15; // size of the modulating Perlin noise
float noiseScale = 1.5; // scale affects how jagged the noise is

int circleResolution = 360;

void setup() {
  size(1200, 1000);

  beginRecord(SVG, "circular_orbiting_shapes.svg");

  background(50,100,120); // RGB values for canvas colour
  noFill();
  stroke(160,190,0); // RGB values for stroke colour

  for (int i = 0; i < numShapes; i++) {
    float r = baseRadius + i * circleSpacing;

    // Circular motion for center drift
    float angle = TWO_PI * i / numShapes;
    float cx = width/2 + cos(angle) * centerOrbitRadius;
    float cy = height/2 + sin(angle) * centerOrbitRadius;

    drawWavyShape(cx, cy, r, i * 0.1);  // offsetSeed = i * 0.1
  }

  endRecord();
  println("SVG saved to sketch folder.");
  noLoop();
}

void drawWavyShape(float cx, float cy, float radius, float offsetSeed) {
  pushMatrix();
  translate(cx, cy);
  beginShape();
  for (int i = 0; i <= circleResolution; i++) {
    float angle = TWO_PI * i / circleResolution;

    float sineMod = sin(angle * 6.0) * sineAmplitude;

    // 2D Perlin noise in circular domain
    float nx = cos(angle) * noiseScale + offsetSeed;
    float ny = sin(angle) * noiseScale + offsetSeed;
    float noiseMod = (noise(nx, ny) - 0.5) * 2 * noiseAmplitude;

    float r = radius + sineMod + noiseMod;
    float x = r * cos(angle);
    float y = r * sin(angle);
    vertex(x, y);
  }
  endShape(CLOSE);
  popMatrix();
}
