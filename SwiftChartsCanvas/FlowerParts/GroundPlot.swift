//
//  GroundPlot.swift
//  SwiftChartsCanvas
//
//  Created by Akihiko Sato on 2025/03/03.
//

import SwiftUI
import Charts

struct GroundPlot: ChartContent {
  let startY: Double = -35.0
  let endY: Double = -50.0
  let scaleValue: Double = 30.0
  
  var body: some ChartContent {
    AreaPlot(
      x: "x",
      yStart: "yStart",
      yEnd: "yEnd",
      domain: -90...90
    ) { x in
      let t = x / scaleValue
      let y = sShapedY(for: t)
      return (yStart: y + startY, yEnd: endY)
    }
    .foregroundStyle(.green.opacity(0.5))
    
    LinePlot(
      x: "x",
      y: "y",
      t: "t",
      domain: -3.0...3.0
    ) { t in
      let x = scaleValue * t
      let y = sShapedY(for: t)
      return (x, y + startY)
    }
    .lineStyle(.init(lineWidth: 2))
    .foregroundStyle(.green)
  }
  
  /// Computes the y-value for the S-shaped curve given a scaled x-value.
  /// Equation: y = 2 * (sin(t) + atan(t))
  nonisolated func sShapedY(for t: Double) -> Double {
    return 2 * (sin(t) + atan(t))
  }
}

#Preview {
  Chart {
    GroundPlot()
  }
}
