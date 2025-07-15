// === CONFIGURATION ===
float radius = 60;           // Hexagon radius
float arcSpacing = 5;        // Gap between concentric arcs
int arcCount = 13;            // Number of concentric arcs
float arcWeight = 1;         // Arc stroke weight
float outlineWeight = 1;     // Hexagon outline stroke weight

float bezierCurveBend = 0.7; // From 0 (straight line) to ~0.8+ for more wiggle

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

      float t = arcCount <= 1 ? 0 : (float)j / (arcCount - 1);
      stroke(lerpColor(arcColorStart, arcColorEnd, t));
      strokeWeight(arcWeight);

      // Arc endpoints
      float x1 = arcCenterX + cos(startAngle) * arcR / 2;
      float y1 = arcCenterY + sin(startAngle) * arcR / 2;
      float x2 = arcCenterX + cos(endAngle) * arcR / 2;
      float y2 = arcCenterY + sin(endAngle) * arcR / 2;

      // Interpolate a point between start and end
      float cxMid = (x1 + x2) / 2;
      float cyMid = (y1 + y2) / 2;

      // Vector from the midpoint toward the center of the hexagon
      float toCenterX = centerX - cxMid;
      float toCenterY = centerY - cyMid;

      // Scale it by bezierCurveBend
      toCenterX *= bezierCurveBend;
      toCenterY *= bezierCurveBend;

      // Compute two control points offset toward the center
      float cx1 = lerp(x1, x2, 0.33) + toCenterX;
      float cy1 = lerp(y1, y2, 0.33) + toCenterY;
      float cx2 = lerp(x1, x2, 0.66) + toCenterX;
      float cy2 = lerp(y1, y2, 0.66) + toCenterY;

      bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2);
    }
  }
}
