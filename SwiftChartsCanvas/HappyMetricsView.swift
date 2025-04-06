//
//  HappyMetricsView.swift
//  SwiftChartsCanvas
//
//  Created by Akihiko Sato on 2025/04/06.
//

import SwiftUI
import Charts

private let outlineRadius: Double = 70.0

struct HappyMetricsView: View {
  
  // Face gradient for the entire face
  private var faceGradient: RadialGradient {
    RadialGradient(
      gradient: Gradient(stops: [
        .init(color: Color(red: 1.0, green: 1.0, blue: 0.8), location: 0.0),
        .init(color: Color(red: 1.0, green: 0.95, blue: 0.4), location: 0.35),
        .init(color: Color(red: 1.0, green: 0.9, blue: 0.0), location: 0.6),
        .init(color: Color(red: 1.0, green: 0.7, blue: 0.0), location: 1.0)
      ]),
      center: UnitPoint(x: 0.5, y: 0.2),
      startRadius: 0,
      endRadius: 180
    )
  }
  
  // Common radial gradient for face color accents (left and right)
  private var faceColorGradient: RadialGradient {
    RadialGradient(
      gradient: Gradient(stops: [
        .init(color: Color.orange.opacity(0.6), location: 0.0),
        .init(color: Color.orange.opacity(0.4), location: 0.3),
        .init(color: Color.orange.opacity(0.2), location: 0.6),
        .init(color: Color.clear, location: 1.0)
      ]),
      center: .center,
      startRadius: 0,
      endRadius: 40
    )
  }
  
  var body: some View {
    Chart {
      // Face outline
      CircleAreaPlot(radius: outlineRadius)
        .foregroundStyle(faceGradient)
      
      // Face color accents on the left and right
      ForEach([(-45.0, -5.0), (45.0, -5.0)], id: \.0) { (cx, cy) in
        CircleAreaPlot(radius: 25.0, centerX: cx, centerY: cy)
          .foregroundStyle(faceColorGradient)
      }
      
      // Eyes (left and right)
      ForEach([23.0, -23.0], id: \.self) { cx in
        EyeAreaPlot(radius: 12.0, centerX: cx, centerY: 15.0)
          .foregroundStyle(.black)
      }
      
      // Mouth - Main Line
      LinePlot(
        x: "x", y: "y", t: "t",
        domain: 215...325
      ) { t in
        let (x, y) = calculateCirclePoint(angle: t, radius: 40)
        return (x: x, y: y + 5)
      }
      .lineStyle(.init(lineWidth: 7.0, lineCap: .round))
      .foregroundStyle(.black)
      
      // Mouth - Sub Line
      LinePlot(
        x: "x", y: "y", t: "t",
        domain: 218...322
      ) { t in
        let (x, y) = calculateCirclePoint(angle: t, radius: 40)
        return (x: x, y: y + 4)
      }
      .lineStyle(.init(lineWidth: 2.0, lineCap: .round))
      .foregroundStyle(.black)
      
      // Mouth - Left curve
      LinePlot(
        x: "x", y: "y", t: "t",
        domain: 38...46
      ) { t in
        let (x, y) = calculateCirclePoint(angle: t, radius: 45.0)
        return (x: x, y: y - 48.0)
      }
      .lineStyle(.init(lineWidth: 8.0, lineCap: .round))
      .foregroundStyle(.black)
      
      // Dimple - Right
      LinePlot(
        x: "x", y: "y", t: "t",
        domain: 134...142
      ) { t in
        let (x, y) = calculateCirclePoint(angle: t, radius: 45.0)
        return (x: x, y: y - 48.0)
      }
      .lineStyle(.init(lineWidth: 8.0, lineCap: .round))
      .foregroundStyle(.black)
    }
    .chartXScale(domain: -100...100)
    .chartYScale(domain: -100...100)
    .chartPlotStyle { content in
      content
        .aspectRatio(contentMode: .fit)
    }
    .padding()
  }
}

func calculateCirclePoint(angle: Double, radius: Double) -> (x: Double, y: Double) {
  let rad = angle * .pi / 180.0
  return (radius * cos(rad), radius * sin(rad))
}

struct CircleAreaPlot: ChartContent {
  let radius: Double
  let domain: ClosedRange<Double>
  let centerX: Double
  let centerY: Double
  
  init(radius: Double, centerX: Double = 0.0, centerY: Double = 0.0) {
    self.radius = radius
    self.centerX = centerX
    self.centerY = centerY
    self.domain = (-radius + centerX)...(radius + centerX)
  }
  
  var body: some ChartContent {
    AreaPlot(
      x: "x", yStart: "yStart", yEnd: "yEnd",
      domain: domain
    ) { x in
      let yStart = calculateY(for: x, isUpper: true)
      let yEnd = calculateY(for: x, isUpper: false)
      return (yStart + centerY, yEnd + centerY)
    }
  }
  
  nonisolated func calculateY(for angle: Double, isUpper: Bool) -> Double {
    let actualAngle = angle - centerX
    let sign: Double = isUpper ? 1 : -1
    return sqrt(max(0, radius * radius - actualAngle * actualAngle)) * sign
  }
}

struct EyeAreaPlot: ChartContent {
  let radius: Double
  let domain: ClosedRange<Double>
  let scale: Double
  let centerX: Double
  let centerY: Double
  
  init(radius: Double, centerX: Double, centerY: Double, scale: Double = 1.0) {
    self.radius = radius
    self.centerX = centerX
    self.centerY = centerY
    self.scale = scale
    self.domain = (-radius + centerX)...(radius + centerX)
  }
  
  var body: some ChartContent {
    AreaPlot(
      x: "x", yStart: "yStart", yEnd: "yEnd",
      domain: domain
    ) { x in
      let yStart = calculateY(for: x, ellipseScale: scale, isUpper: true)
      let yEnd = calculateY(for: x, ellipseScale: scale, isUpper: false)
      return (yStart + centerY, yEnd + centerY)
    }
    
    LinePlot(
      x: "x", y: "y", t: "t",
      domain: 110...150
    ) { t in
      let (x, y) = calculateCirclePoint(angle: t, radius: 6.0)
      return (x: x + centerX, y: y + centerY)
    }
    .lineStyle(.init(lineWidth: 8.0, lineCap: .round))
    .foregroundStyle(.white)
  }
  
  nonisolated func calculateY(for angle: Double, ellipseScale: Double, isUpper: Bool) -> Double {
    let actualAngle = angle - centerX
    let sign: Double = isUpper ? 1 : -1
    return sqrt(max(0, radius * radius - actualAngle * actualAngle) / ellipseScale) * sign
  }
}

#Preview {
  HappyMetricsView()
}
