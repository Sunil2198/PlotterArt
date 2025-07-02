
// === Import SVG library ===
import processing.svg.*;

// === Adjustable Parameters ===
color bgColor = color(150, 150, 150);       // Background color
color fgColor = color(255, 255, 255);    // Wave (foreground) color
int waveSpacing = 30;                     // Vertical space between waves in pixels
float waveThickness = 5.0;               // Stroke thickness of the waves
float baseDotSpacing = 2.0;              // Minimum dot spacing after mid-screen
float maxDotSpacing = 30.0;              // Maximum spacing for far right
float baseFrequency = 0.015;             // Base frequency of sine wave
float baseAmplitude = 50;                // Base amplitude of sine wave
float xPhaseOffset = 0;             // Phase offset between waves
float noiseScale = 0.001;                // Perlin noise scale for x
float freqNoiseStrength = 0.00;          // Frequency variation range
float ampNoiseStrength = 3.0;           // Amplitude variation range


boolean exporting = true;  // Set to true to export SVG

// === Setup ===
void setup() {
  size(800, 800);

  if (exporting) {
    beginRecord(SVG, "waves_export.svg");
  }

  background(bgColor);
  stroke(fgColor);
  strokeWeight(waveThickness);
  noFill();
  
  drawSineWaves();

  if (exporting) {
    endRecord();
    println("SVG export complete.");
    noLoop();
  }
}

// === Main Drawing Function ===
void drawSineWaves() {
  int waveIndex = 0;
  for (int y = waveSpacing; y < height; y += waveSpacing) {
    float phase = waveIndex * xPhaseOffset;
    float prevX = 0;
    float prevYOffset = sin(prevX * baseFrequency + phase) * baseAmplitude;
    
    float x = 0;
    while (x < width) {
      float n = noise(x * noiseScale);
      float currentFreq = baseFrequency + (n - 0.5) * 2 * freqNoiseStrength;
      float currentAmp = baseAmplitude + (n - 0.5) * 2 * ampNoiseStrength;
      float yOffset = sin(x * currentFreq + phase) * currentAmp;

      if (x < width / 3) {
        line(prevX, y + prevYOffset, x, y + yOffset);
        prevX = x;
        prevYOffset = yOffset;
        x += 1;
      } else {
        float dotSpacing = map(x, width / 3, width, baseDotSpacing, maxDotSpacing);
        point(x, y + yOffset);
        x += dotSpacing;
      }
    }
    waveIndex++;
  }
}
