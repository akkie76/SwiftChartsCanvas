# Graph Art with Charts API – Beyond Data Visualization

This project is a companion to the try! Swift Tokyo 2025 talk by Akihiko Sato.  
It explores the creative and artistic potential of [Swift Charts](https://developer.apple.com/documentation/charts) beyond traditional data visualization — treating it as a canvas for **graph-based art**.

## 🌟 What is Graph Art?

Graph Art is the use of mathematical equations, parametric functions, and plotting APIs to create expressive visual compositions. This project showcases how Swift Charts — specifically `LinePlot`, `AreaPlot`, and `RectanglePlot` — can be used to design vibrant, dynamic artwork.

---

## ✨ Artworks

### 1. Graph Garden 🌷

**Chart APIs**: `LinePlot`, `AreaPlot`  
**Math Concepts**:  
- Rose Curves (Petals & Leaves)  
- Sine + Arctangent Functions (Stem & Ground)

Graph Garden generates flower shapes using rose curve equations and places them on a stylized sine-arctangent ground. The elements are layered with scaling and shearing transformations to give a natural illustration-like result.

📄 Related files:
- `PinkFlowerPlot.swift`
- `PinkLeafPlot.swift`
- `PinkFlowerStemPlot.swift`
- `GroundPlot.swift`

---

### 2. Happy Metrics 😊

**Chart APIs**: `AreaPlot`, `LinePlot`  
**Math Concepts**:  
- Circle Equation for Face Outline  
- Arc Segments for Mouth and Dimples

A happy face drawn with math! The face is rendered using the circle equation in an `AreaPlot`, while the eyes and smile use `LinePlot`s to add personality. Gradient fills give it a soft and cheerful look.

📄 Related file:
- `HappyMetrics.swift`

---

### 3. One More Pixel 🖥

**Chart APIs**: `RectanglePlot`  
**Techniques**:  
- Pixel Grid Mapping  
- Dithering-style CSV Input

This is pixel art rendered entirely using `RectanglePlot`. Each square corresponds to a point from a CSV file defining pixel color and position. A SwiftUI-style gradient and aspect ratio polish the final display.

📄 Related file:
- `OneMorePixelView.swift`  
📁 CSV resource required: `pixels.csv`

---

## 🧪 Dependencies

- iOS 17+ / macOS 14+
- Swift Charts framework
- SwiftUI

> Note: Make sure to include `pixels.csv` in your bundle for `OneMorePixelView` to render correctly.

---

## 📽️ Presentation

This project was presented at **try! Swift Tokyo 2025**.  
The talk, *"Graph Art with Charts API – Beyond Data Visualization"*, demonstrated how to:

- Combine math and visualization
- Go beyond practical dashboards
- Treat code as art

---

## 👤 Author

**Akihiko Sato**  
Software Engineer at DeNA  
[@akkiee76](https://x.com/akkiee76)

---

## 🧠 Inspiration

Swift Charts is not only a data visualization tool — it’s a **creative playground**.  
What will you create?