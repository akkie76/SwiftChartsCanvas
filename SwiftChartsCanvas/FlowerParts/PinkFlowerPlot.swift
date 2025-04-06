//
//  PinkFlowerPlot.swift
//  SwiftChartsCanvas
//
//  Created by Akihiko Sato on 2025/03/05.
//

import SwiftUI
import Charts

private let (centerX, centerY): (Double, Double) = (40, 35)
private let flowerSize: Double = 40.0
/// Number of petals (2k petals in the case of sin)
private let petalCount: Double = 6.0

struct PinkFlowerPlot: ChartContent {
  var body: some ChartContent {
    LinePlot(
      x: "x", y: "y", t: "t",
      domain: 0...360
    ) { t in
      calculatePinkFlowerCurvePoint(angle: t)
    }
    .lineStyle(.init(lineWidth: 2))
    .foregroundStyle(.pink)
  }
}

func calculatePinkFlowerCurvePoint(angle: Double) -> (Double, Double) {
  /// Angle (degrees) → Radians
  let rad = angle * .pi / 180
  let a = flowerSize
  let k = petalCount
  /// Rose Curve: r = a * sin(kθ)
  let r = a * sin(k * rad)
  /// Standard Rose Curve (x0, y0)
  let x0 = r * cos(rad)
  let y0 = r * sin(rad)
  /// Scale Y-axis
  let scaleY = 0.45
  let yScaled = y0 * scaleY  
  /// Tilt using shear transformation (Shear)
  let alpha = -0.4
  let xFinal = x0 + alpha * yScaled
  let yFinal = yScaled
  return (xFinal + centerX, yFinal + centerY)
}

#Preview {
  Chart {
    PinkFlowerPlot()
  }
  .chartXScale(domain: -100...100)
  .chartYScale(domain: -60...60)
  .chartPlotStyle { content in
    content
      .aspectRatio(contentMode: .fit)
  }
  .padding()
}
