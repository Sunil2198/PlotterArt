int numAttractors = 3;
PVector[] attractors;

int numParticles = 10;
Particle[] particles;

PVector center;
float outerRadius;
float influenceRadius = 300;
float strength = 0.19;
int stepsPerParticle = 80000;

// Export settings
float exportAlpha = 30;        // Alpha value for export lines
float exportStrokeWeight = 2;  // Stroke weight for export lines
float yellowInfluence = 4.0;   // Multiplier for yellow color influence (higher = more yellow)

// Color settings
color greyColor = color(255);                // White instead of grey
color yellowBase = color(244, 180, 0);       // Yellow target
color bgColor = color(170);                  // Light grey background

float yellowFadeFactor = 0.0; // 0 = vivid yellow always, 1 = subtle near attractors

// High-res settings
int highResSize = 4000;
int previewSize = 800;
PGraphics highResCanvas;
int exportCounter = 0;
boolean isExporting = false;

void setup() {
  size(800, 800); // Must be first line and use literal values
  surface.setLocation(100, 100); // Position window on screen
  
  // Create high-resolution canvas
  highResCanvas = createGraphics(highResSize, highResSize);
  
  // Set up coordinates based on high-res dimensions
  center = new PVector(highResSize / 2, highResSize / 2);
  outerRadius = highResSize * 0.45;
  
  // Scale influence radius for high-res
  influenceRadius = 300 * (highResSize / 1000.0);
  
  // Attractors
  attractors = new PVector[numAttractors];
  for (int i = 0; i < numAttractors; i++) {
    float angle = random(TWO_PI);
    float radius = random(outerRadius * 0.5);
    attractors[i] = PVector.fromAngle(angle).mult(radius).add(center);
  }

  // Particles
  particles = new Particle[numParticles];
  for (int i = 0; i < numParticles; i++) {
    float angle = random(TWO_PI);
    float radius = sqrt(random(1)) * outerRadius;
    PVector pos = PVector.fromAngle(angle).mult(radius).add(center);
    particles[i] = new Particle(pos);
  }

  drawHighResOrbits();
  println("Finished drawing. Press 'e' to export PNG, 'r' to regenerate.");
  noLoop();
}

void draw() {
  // Display scaled-down version of high-res canvas
  background(bgColor);
  
  // Calculate scale factor for preview
  float scale = (float)previewSize / (float)highResSize;
  
  // Draw scaled version
  pushMatrix();
  scale(scale);
  image(highResCanvas, 0, 0);
  popMatrix();
}

void keyPressed() {
  if (key == 'e' || key == 'E') {
    exportHighRes();
  } else if (key == 'r' || key == 'R') {
    regenerate();
  }
}

void regenerate() {
  println("Regenerating...");
  
  // Clear the high-res canvas
  highResCanvas.beginDraw();
  highResCanvas.clear();
  highResCanvas.endDraw();
  
  // Generate new attractors
  for (int i = 0; i < numAttractors; i++) {
    float angle = random(TWO_PI);
    float radius = random(outerRadius * 0.5);
    attractors[i] = PVector.fromAngle(angle).mult(radius).add(center);
  }

  // Generate new particles
  for (int i = 0; i < numParticles; i++) {
    float angle = random(TWO_PI);
    float radius = sqrt(random(1)) * outerRadius;
    PVector pos = PVector.fromAngle(angle).mult(radius).add(center);
    particles[i] = new Particle(pos);
  }
  
  drawHighResOrbits();
  redraw(); // Update the preview
  println("Regenerated. Press 'e' to export PNG, 'r' to regenerate again.");
}

void exportHighRes() {
  if (isExporting) return;
  
  isExporting = true;
  println("Exporting high-resolution PNG...");
  
  // Create a new transparent canvas and redraw just the orbits
  PGraphics exportCanvas = createGraphics(highResSize, highResSize);
  exportCanvas.beginDraw();
  exportCanvas.clear(); // Transparent background
  exportCanvas.noFill();
  exportCanvas.smooth(8);
  
  // Redraw orbits on transparent canvas
  for (Particle p : particles) {
    p.exportOrbit(exportCanvas);
  }
  
  exportCanvas.endDraw();
  
  // Generate filename with auto-incrementing number
  String filename = "orbit_export_" + nf(exportCounter, 4) + ".png";
  String sketchPath = sketchPath(filename);
  exportCanvas.save(sketchPath);
  
  println("Exported to: " + sketchPath);
  exportCounter++;
  isExporting = false;
}

void drawHighResOrbits() {
  highResCanvas.beginDraw();
  highResCanvas.background(bgColor);
  highResCanvas.noFill();
  highResCanvas.smooth(8);
  
  for (Particle p : particles) {
    p.orbit(highResCanvas);
  }
  
  highResCanvas.endDraw();
}

class Particle {
  PVector pos;
  PVector vel = new PVector();

  Particle(PVector start) {
    pos = start.copy();
  }

  void orbit(PGraphics g) {
    PVector lastPos = pos.copy();

    for (int i = 0; i < stepsPerParticle; i++) {
      PVector force = getTotalForce(pos);
      vel.add(force);
      vel.limit(2 * (highResSize / 1000.0)); // Scale velocity limit
      pos.add(vel);

      if (PVector.dist(pos, center) > outerRadius) break;

      // Blend white to yellow based on force magnitude
      float forceMag = constrain(force.mag() * 10 * yellowInfluence, 0, 1);
      float yellowIntensity = forceMag * (1 - yellowFadeFactor);

      // Lerp white and yellow
      color trailColor = lerpColor(greyColor, yellowBase, yellowIntensity);
      g.stroke(trailColor, 30);

      g.line(lastPos.x, lastPos.y, pos.x, pos.y);
      lastPos = pos.copy();
    }
  }

  void exportOrbit(PGraphics g) {
    // Create a temporary particle with same starting position
    PVector tempPos = pos.copy();
    PVector tempVel = new PVector();
    PVector lastPos = tempPos.copy();

    // Set stroke weight for export
    g.strokeWeight(exportStrokeWeight);

    for (int i = 0; i < stepsPerParticle; i++) {
      PVector force = getTotalForce(tempPos);
      tempVel.add(force);
      tempVel.limit(2 * (highResSize / 1000.0)); // Scale velocity limit
      tempPos.add(tempVel);

      if (PVector.dist(tempPos, center) > outerRadius) break;

      // Blend white to yellow based on force magnitude
      float forceMag = constrain(force.mag() * 10 * yellowInfluence, 0, 1);
      float yellowIntensity = forceMag * (1 - yellowFadeFactor);

      // Lerp white and yellow
      color trailColor = lerpColor(greyColor, yellowBase, yellowIntensity);
      g.stroke(trailColor, exportAlpha);

      g.line(lastPos.x, lastPos.y, tempPos.x, tempPos.y);
      lastPos = tempPos.copy();
    }
  }

  PVector getTotalForce(PVector p) {
    PVector total = new PVector();
    for (PVector attractor : attractors) {
      float d = PVector.dist(p, attractor);
      if (d < influenceRadius) {
        PVector f = PVector.sub(attractor, p);
        f.normalize();
        f.mult(strength / (d * 0.5));
        total.add(f);
      }
    }
    return total;
  }
}
