// ===== TUNE THESE VARIABLES =====
float WAVE_AMPLITUDE   = 50.0;  // Height of waves
float BASE_FREQ        = 0.04;  // Starting frequency (smaller = wider waves)
float FREQ_INCREMENT   = 0.0001; // How much frequency changes per layer
float FREQ_NOISE       = 0.001; // Random noise added to frequency increment
float NOISE_AMOUNT     = 0.01;  // Strength of Perlin noise on waves
int   NUM_LAYERS       = 80;    // Number of ribbons
float LAYER_SPACING    = 2.5;   // Vertical gap between ribbons
boolean ANIMATE        = false; // Animate over time?

// ===== RIBBON GENERATOR =====
void setup() {
  size(800, 600);
  smooth();
  noFill();
  stroke(0, 50);
  background(255);
  if (!ANIMATE) drawRibbon();
}

void draw() {
  if (ANIMATE) {
    background(255);
    drawRibbon();
  }
}

void drawRibbon() {
  for (int layer = 0; layer < NUM_LAYERS; layer++) {
    // Calculate frequency for this layer: base + progressive increment + noise
    float layerFreq = BASE_FREQ + (layer * FREQ_INCREMENT) + random(-FREQ_NOISE, FREQ_NOISE);
    
    beginShape();
    for (float x = 0; x <= width; x += 1) {
      // Add subtle frequency drift over x-axis
      float freq = layerFreq + 0.005 * sin(x * 0.01 + (ANIMATE ? frameCount * 0.0000001 : 0));
      
      // Base sine wave + Perlin noise
      float sineY = sin(x * freq) * WAVE_AMPLITUDE;
      float noiseY = noise(x * 0.05, layer * 10) * NOISE_AMOUNT;
      
      // Position vertically
      float y = height/2 + sineY + noiseY + (layer * LAYER_SPACING - NUM_LAYERS * LAYER_SPACING/2);
      curveVertex(x, y);
    }
    endShape();
  }
}

void keyPressed() {
  if (key == ' ') {
    background(255);
    drawRibbon();
  }
  if (key == 's') save("frequency_drift_ribbon.png");
}
