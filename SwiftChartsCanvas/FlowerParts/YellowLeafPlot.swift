//
//  YellowLeafPlot.swift
//  SwiftChartsCanvas
//
//  Created by Akihiko Sato on 2025/03/05.
//

import SwiftUI
import Charts

struct YellowLeafPlot: ChartContent {
  var body: some ChartContent {
    LinePlot(
      x: "x", y: "y", t: "t",
      domain: 144...180
    ) { t in
      calculateLeafCurvePoint(
        angle: t,
        size: 40.0,
        leafFactor: 5.0,
        scale: 0.5,
        specificAngle: 0.45,
        curve: 6.0
      )
    }
    .lineStyle(.init(lineWidth: 2))
    .foregroundStyle(.green)
  }
}

private func calculateLeafCurvePoint(angle: Double, size: Double, leafFactor: Double, scale: Double, specificAngle: Double, curve: Double) -> (Double, Double) {
  // Convert angle (degrees) to radians
  let rad = Double(angle) * .pi / 180
  
  // Rose curve parameters
  let a = size // Overall size of the petal
  let k = 5.0  // Affects number of petals (2k petals if using sine)
  
  // Rose Curve: r = a * sin(kθ)
  let r = a * sin(k * rad)
  
  // First, calculate the standard rose curve coordinates (x0, y0)
  let x0 = r * cos(rad)
  let y0 = r * sin(rad)
  
  // 1) Apply vertical compression to create a wider impression
  let scaleY = scale  // The smaller the value, the more vertically squashed the shape becomes
  let yScaled = y0 * scaleY
  
  // 2) Apply shear transformation to give a slanted effect
  //    x' = x0 + alpha * yScaled
  //    y' = yScaled
  let alpha = 0.0
  let xSheared = x0 + alpha * yScaled
  let ySheared = yScaled
  
  // Overlay the parametric center onto the stem
  let (startX, startY) = getYellowFlowerStemPoint(angle: specificAngle, curve: curve)
  
  return (x: xSheared + startX, y: ySheared + startY)
}

#Preview {
  Chart {
    YellowLeafPlot()
  }
  .chartXScale(domain: -100...100)
  .chartYScale(domain: -60...60)
  .chartPlotStyle { content in
    content
      .aspectRatio(contentMode: .fit)
  }
  .padding()
}
