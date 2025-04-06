//
//  PinkFlowerStemPlot.swift
//  SwiftChartsCanvas
//
//  Created by Akihiko Sato on 2025/03/05.
//

import SwiftUI
import Charts

private let (initialX, initialY): (Double, Double) = (0.0, -35.0)

struct PinkFlowerStemPlot: ChartContent {
  let startStemDomain: Double = 60.0
  let endStemDomain: Double = 90.0
  
  var body: some ChartContent {
    LinePlot(
      x: "x", y: "y", t: "t",
      domain: 0.0...1.0
    ) { t in
      let (stemX, stemY) = getPinkFlowerStemPoint(startDomain: startStemDomain, endDomain: endStemDomain, angle: t, curve: -6.0)
      return (stemX, stemY)
    }
    .lineStyle(.init(lineWidth: 2))
    .foregroundStyle(.green)
  }
}

func getPinkFlowerStemPoint(startDomain: Double = 0.0, endDomain: Double = 0.0, angle: Double, curve: Double) -> (Double, Double) {
  // Starting point (x0, y0) = (0, -35)
  // Ending point (x1, y1) = (-30, 20)
  let x0 = initialX
  let y0 = initialY
  let (endX, endY) = getPinkFlowerStemEndPoint(startDomain: startDomain, endDomain: endDomain)
  
  // A) First, calculate the base coordinates using linear interpolation.
  let baseX = x0 + (endX - x0) * angle // 0 + (-30)*u
  let baseY = y0 + (endY - y0) * angle  // -35 + (55)*u
  
  // B) Add a wavy effect (e.g., sin(u * π)).
  //    At u = 0 and u = 1, sin(0)=0 and sin(π)=0, so the endpoints remain unchanged.
  //    Increasing the value makes the curve more pronounced.
  let curveAmount = curve * sin(angle * .pi)
  
  // Slightly offset the x coordinate (alternatively, the y coordinate could be offset)
  let stemX = baseX + curveAmount
  let stemY = baseY  // The y coordinate remains unchanged
  
  return (stemX, stemY)
}

func getPinkFlowerStemEndPoint(startDomain: Double, endDomain: Double) -> (x: Double, y: Double) {
  let leafAngles = stride(from: startDomain, through: endDomain, by: 0.1)
  var pts = [(x: Double, y: Double)]()
  
  for angle in leafAngles {
    let (rx, ry) = calculatePinkFlowerCurvePoint(angle: angle)
    pts.append((rx, ry))
  }
  
  pts.sort { $0.y > $1.y }
  
  return pts.last!
}

#Preview {
  Chart {
    PinkFlowerStemPlot()
  }
  .chartXScale(domain: -100...100)
  .chartYScale(domain: -60...60)
  .chartPlotStyle { content in
    content
      .aspectRatio(contentMode: .fit)
  }
  .padding()
}
