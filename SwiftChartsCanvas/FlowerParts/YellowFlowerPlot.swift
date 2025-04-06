//
//  YellowFlowerPlot.swift
//  SwiftChartsCanvas
//
//  Created by Akihiko Sato on 2025/03/04.
//

import SwiftUI
import Charts

private let (centerX, centerY): (Double, Double) = (-35, 20)
private let flowerSize: Double = 35.0
/// Number of petals (2k petals in the case of sin)
private let petalCount: Double = 4.0

struct YellowFlowerPlot: ChartContent {
  var body: some ChartContent {
    LinePlot(
      x: "x", y: "y", t: "t",
      domain: 0...360
    ) { t in
      calculateYellowFlowerCurvePoint(angle: t)
    }
    .lineStyle(.init(lineWidth: 2))
    .foregroundStyle(.orange)
  }
}

func calculateYellowFlowerCurvePoint(angle: Double) -> (Double, Double) {
  /// Angle (degrees) → Radians
  let rad = angle * .pi / 180
  let a = flowerSize
  let k = petalCount
  /// Rose Curve: r = a * sin(kθ)
  let r = a * sin(k * rad)
  /// Standard Rose Curve (x0, y0)
  let x0 = r * cos(rad)
  let y0 = r * sin(rad)
  /// Apply horizontal scaling, rotation, shear, offset, etc.
  let spreadFactor = 1.0 + 0.3 * cos(2 * rad)
  let xSpread = x0 * spreadFactor
  let ySpread = y0
  /// Rotation
  let rotationAngle = Double.pi / 4
  let xRot = xSpread * cos(rotationAngle) - ySpread * sin(rotationAngle)
  let yRot = xSpread * sin(rotationAngle) + ySpread * cos(rotationAngle)
  /// Scale Y-axis
  let scaleY = 0.3
  let yScaled = yRot * scaleY
  /// Tilt using shear transformation (Shear)
  let alpha = 0.5
  let xFinal = xRot + alpha * yScaled
  let yFinal = yScaled
  
  return (xFinal + centerX, yFinal + centerY)
}

#Preview {
  Chart {
    YellowFlowerPlot()
  }
  .chartXScale(domain: -100...100)
  .chartYScale(domain: -60...60)
  .chartPlotStyle { content in
    content
      .aspectRatio(contentMode: .fit)
  }
  .padding()
}
