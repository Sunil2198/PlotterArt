
# 🖋️ Exporting SVG Files in Processing

This guide will help you set up Processing to export vector graphics as SVG files.

---

## 🛠️ Step 1: Install the SVG (PDF Export) Library

1. Open **Processing**.
2. Go to **Sketch → Import Library → Add Library...**
3. In the **Contribution Manager**, search for **"PDF"**.
4. Install the **"PDF Export"** library by Processing.org (this includes SVG support).

---

## 📄 Step 2: Use the SVG Export Functions

In your Processing sketch:

1. At the top of your code, import the SVG library:
   ```java
   import processing.svg.*;
   ```

2. Before drawing your shape, start recording:
   ```java
   beginRecord(SVG, "output.svg");
   ```

3. After drawing, stop recording:
   ```java
   endRecord();
   ```

This will save all the drawing commands between `beginRecord()` and `endRecord()` to a vector `.svg` file.

---

## 📂 Step 3: Find the Saved SVG

- The `.svg` file will be saved inside your sketch folder.
- Go to **Sketch → Show Sketch Folder** to locate it.

---

## ✅ You're Done!

You can now open the SVG in Illustrator, Inkscape, or a code editor for further editing.
