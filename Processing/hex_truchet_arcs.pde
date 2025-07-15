// === CONFIGURATION ===
float radius = 50;           // Hexagon radius
float arcSpacing = 5;        // Gap between concentric arcs
int arcCount = 13;            // Number of concentric arcs
float arcWeight = 1;         // Arc stroke weight
float outlineWeight = 1;     // Hexagon outline stroke weight

color arcColorStart = color(0, 128, 192);   // Inner/central arc
color arcColorEnd = color(220, 192, 0);   // Outer arcs

void setup() {
  size(1200, 800);
  noLoop();         // Prevent draw() from looping automatically
  drawPattern();    // Draw once at start
}

void draw() {
  // Nothing needed here — drawPattern() is called manually
}

void keyPressed() {
  if (key == ' ') {
    drawPattern();  // Generate new pattern
    redraw();       // Refresh the screen (important when using noLoop)
  }
}

void drawPattern() {
  randomSeed(millis());  // New seed each time for variation
  background(255);       // Plain white background

  float hexWidth = 2 * radius;
  float hexHeight = sqrt(3) * radius;

  for (float y = 0; y < height + hexHeight; y += hexHeight) {
    for (float x = 0; x < width + hexWidth; x += hexWidth * 0.75) {
      float currentX = x;
      float currentY = y;

      if (int(x / (hexWidth * 0.75)) % 2 == 1) {
        currentY += hexHeight / 2;
      }

      pushMatrix();
      translate(currentX, currentY);

      int choice = int(random(2));
      rotate(choice * PI / 3);

      drawHexagonTile(0, 0, radius);

      popMatrix();
    }
  }
}

void drawHexagonTile(float centerX, float centerY, float radius) {
  drawHexagonOutline(centerX, centerY, radius);
  drawConcentricVertexArcs(centerX, centerY, radius);
}

void drawHexagonOutline(float centerX, float centerY, float radius) {
  stroke(200);
  strokeWeight(outlineWeight);
  noFill();

  beginShape();
  for (int i = 0; i < 6; i++) {
    float angle = PI / 3 * i;
    float x = centerX + cos(angle) * radius;
    float y = centerY + sin(angle) * radius;
    vertex(x, y);
  }
  endShape(CLOSE);
}

void drawConcentricVertexArcs(float centerX, float centerY, float radius) {
  noFill();

  for (int i = 0; i < 3; i++) {
    float vertexAngle = PI / 3 + (i * 2 * PI / 3);
    float arcCenterX = centerX + cos(vertexAngle) * radius;
    float arcCenterY = centerY + sin(vertexAngle) * radius;

    float axisAngle = vertexAngle + PI;
    float startAngle = axisAngle - PI / 3;
    float endAngle = axisAngle + PI / 3;

    int mid = arcCount / 2;

    for (int j = 0; j < arcCount; j++) {
      int offset = j - mid;
      float arcR = radius + offset * arcSpacing;

      // Interpolate color between arcColorStart and arcColorEnd
      float t = arcCount <= 1 ? 0 : (float)j / (arcCount - 1);
      stroke(lerpColor(arcColorStart, arcColorEnd, t));
      strokeWeight(arcWeight);

      arc(arcCenterX, arcCenterY, arcR, arcR, startAngle, endAngle);
    }
  }
}
