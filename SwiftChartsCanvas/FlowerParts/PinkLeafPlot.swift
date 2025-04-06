//
//  PinkLeafPlot.swift
//  SwiftChartsCanvas
//
//  Created by Akihiko Sato on 2025/04/06.
//

import SwiftUI
import Charts

struct PinkLeafPlot: ChartContent {
  var body: some ChartContent {
    LinePlot(
      x: "x", y: "y", t: "t",
      domain: 0...36
    ) { t in
      calculateLeafCurvePoint(
        angle: t,
        size: 55.0,
        leafFactor: 5.0,
        scale: 0.5,
        specificAngle: 0.45,
        curve: -6.0
      )
    }
    .lineStyle(.init(lineWidth: 2))
    .foregroundStyle(.green)  // Petal color
  }
}

/// Calculates a point on the leaf curve.
/// - Parameters:
///   - angle: The angle (in degrees) for the current point.
///   - size: The overall size of the petal.
///   - leafFactor: Factor influencing the leaf shape.
///   - scale: Vertical scaling factor (smaller values compress the vertical dimension more).
///   - specificAngle: Angle used to align the leaf with the stem.
///   - curve: The amount of curvature to apply.
/// - Returns: A tuple containing the x and y coordinates for the leaf curve point.
private func calculateLeafCurvePoint(angle: Double, size: Double, leafFactor: Double, scale: Double, specificAngle: Double, curve: Double) -> (Double, Double) {
  // Convert angle from degrees to radians.
  let rad = Double(angle) * .pi / 180
  
  // Parameters for the rose curve.
  let a = size       // Overall size of the petal
  let k = 5.0        // Influences the number of petals (using sine, yields 2k petals)
  
  // Rose Curve: r = a * sin(kθ)
  let r = a * sin(k * rad)
  
  // Calculate the standard rose curve coordinates (x0, y0).
  let x0 = r * cos(rad)
  let y0 = r * sin(rad)
  
  // 1) Apply vertical compression to give a wider appearance.
  let scaleY = scale  // Smaller values compress the vertical dimension more.
  let yScaled = y0 * scaleY
  
  // 2) Apply a shear transformation to add a slanted effect.
  //    x' = x0 + alpha * yScaled
  //    y' = yScaled
  let alpha = 0.0
  let xSheared = x0 + alpha * yScaled
  let ySheared = yScaled
  
  // Overlay the parametric center with the stem.
  let (startX, startY) = getPinkFlowerStemPoint(angle: specificAngle, curve: curve)
  
  return (x: xSheared + startX, y: ySheared + startY)
}

#Preview {
  Chart {
    PinkLeafPlot()
  }
  .chartXScale(domain: -100...100)
  .chartYScale(domain: -60...60)
  .chartPlotStyle { content in
    content
      .aspectRatio(contentMode: .fit)
  }
  .padding()
}
