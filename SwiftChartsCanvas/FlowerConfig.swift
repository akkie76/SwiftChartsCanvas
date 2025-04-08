//
//  FlowerConfig.swift
//  SwiftChartsCanvas
//
//  Created by Akihiko Sato on 2025/04/08.
//

import SwiftUI
import Charts

// MARK: - Flower Configuration

/// Configuration for a flower (used for both Pink and Yellow variants).
struct FlowerConfig {
  let center: CGPoint          // Flower center offset
  let flowerSize: Double       // Overall flower (rose) size
  let petalCount: Double       // Rose curve parameter (affects number of petals)
  let scaleY: Double           // Vertical scaling factor
  let alpha: Double            // Shear factor (horizontal offset proportional to y)
  let rotationAngle: Double    // Rotation angle (radians); set to 0 if not used
  let spreadCoefficient: Double// Coefficient for horizontal spread modulation (0 if not used)
}

// Configuration for Pink variant.
let pinkFlowerConfig = FlowerConfig(
  center: CGPoint(x: 40, y: 35),
  flowerSize: 40.0,
  petalCount: 6.0,
  scaleY: 0.45,
  alpha: -0.4,
  rotationAngle: 0,
  spreadCoefficient: 0
)

// Configuration for Yellow variant.
let yellowFlowerConfig = FlowerConfig(
  center: CGPoint(x: -35, y: 20),
  flowerSize: 35.0,
  petalCount: 4.0,
  scaleY: 0.3,
  alpha: 0.5,
  rotationAngle: .pi / 4,
  spreadCoefficient: 0.3
)

// MARK: - Common Helper Functions

struct FlowerArtHelper {
  // Common initial point for stem calculations.
  static let stemInitial = CGPoint(x: 0, y: -35)
  
  /// Calculates a point on a rose curve for a given angle (in degrees) using the specified flower configuration.
  static func calculateFlowerCurvePoint(angle: Double, config: FlowerConfig) -> CGPoint {
    let rad = angle * .pi / 180
    // Rose Curve: r = a * sin(kθ)
    let r = config.flowerSize * sin(config.petalCount * rad)
    var x = r * cos(rad)
    var y = r * sin(rad)
    
    // Apply horizontal spread if specified.
    if config.spreadCoefficient != 0 {
      let spreadFactor = 1.0 + config.spreadCoefficient * cos(2 * rad)
      x *= spreadFactor
    }
    // Apply rotation if needed.
    if config.rotationAngle != 0 {
      let ca = cos(config.rotationAngle), sa = sin(config.rotationAngle)
      let xRot = x * ca - y * sa
      let yRot = x * sa + y * ca
      x = xRot; y = yRot
    }
    
    // Apply vertical scaling and shear.
    y *= config.scaleY
    x += config.alpha * y
    
    return CGPoint(x: x + config.center.x, y: y + config.center.y)
  }
  
  /// Samples the rose curve over the specified domain and returns the point with the smallest y value.
  static func getStemEndPoint(startDomain: Double, endDomain: Double, config: FlowerConfig) -> CGPoint {
    let angles = stride(from: startDomain, through: endDomain, by: 0.1)
    var pts = [CGPoint]()
    for angle in angles {
      pts.append(calculateFlowerCurvePoint(angle: angle, config: config))
    }
    pts.sort { $0.y > $1.y }
    return pts.last!
  }
  
  /// Calculates a stem point by linearly interpolating between an initial point and an endpoint,
  /// then adding a sine-based offset (wavy effect).
  static func calculateStemPoint(initial: CGPoint, endpoint: CGPoint, factor t: Double, curve: Double) -> CGPoint {
    let baseX = initial.x + (endpoint.x - initial.x) * t
    let baseY = initial.y + (endpoint.y - initial.y) * t
    let curveAmount = curve * sin(t * .pi)
    return CGPoint(x: baseX + curveAmount, y: baseY)
  }
  
  /// Convenience: computes the stem offset for a given specific angle and stem domain.
  static func getStemOffset(specificAngle: Double, curve: Double, stemDomain: (Double, Double), config: FlowerConfig) -> CGPoint {
    let endpoint = getStemEndPoint(startDomain: stemDomain.0, endDomain: stemDomain.1, config: config)
    return calculateStemPoint(initial: stemInitial, endpoint: endpoint, factor: specificAngle, curve: curve)
  }
  
  /// Calculates a leaf curve point by computing a rose curve for the leaf shape,
  /// then overlaying the stem offset to align the leaf with the stem.
  static func calculateLeafCurvePoint(angle: Double, size: Double, scale: Double, specificAngle: Double, curve: Double, stemDomain: (Double, Double), config: FlowerConfig) -> CGPoint {
    let rad = angle * .pi / 180
    let a = size
    let k = 5.0  // Fixed value for leaf shape
    let r = a * sin(k * rad)
    let x0 = r * cos(rad)
    let y0 = r * sin(rad)
    let yScaled = y0 * scale  // Vertical compression for a wider appearance
    let leafPoint = CGPoint(x: x0, y: yScaled)
    
    let stemOffset = getStemOffset(specificAngle: specificAngle, curve: curve, stemDomain: stemDomain, config: config)
    return CGPoint(x: leafPoint.x + stemOffset.x, y: leafPoint.y + stemOffset.y)
  }
}

// MARK: - Pink Variants

struct PinkFlowerPlot: ChartContent {
  var body: some ChartContent {
    LinePlot(
      x: "x", y: "y", t: "t",
      domain: 0...360
    ) { t in
      let pt = FlowerArtHelper.calculateFlowerCurvePoint(angle: t, config: pinkFlowerConfig)
      return (pt.x, pt.y)
    }
    .lineStyle(.init(lineWidth: 2))
    .foregroundStyle(.pink)
  }
}

struct PinkFlowerStemPlot: ChartContent {
  // Domain for sampling the rose curve to determine the stem endpoint.
  let stemDomain: (Double, Double) = (60.0, 90.0)
  
  var body: some ChartContent {
    LinePlot(
      x: "x", y: "y", t: "t",
      domain: 0.0...1.0
    ) { t in
      let endpoint = FlowerArtHelper.getStemEndPoint(startDomain: stemDomain.0, endDomain: stemDomain.1, config: pinkFlowerConfig)
      let pt = FlowerArtHelper.calculateStemPoint(initial: FlowerArtHelper.stemInitial, endpoint: endpoint, factor: t, curve: -6.0)
      return (pt.x, pt.y)
    }
    .lineStyle(.init(lineWidth: 2))
    .foregroundStyle(.green)
  }
}

struct PinkLeafPlot: ChartContent {
  let stemDomain: (Double, Double) = (60.0, 90.0)
  
  var body: some ChartContent {
    LinePlot(
      x: "x", y: "y", t: "t",
      domain: 0...36
    ) { t in
      let pt = FlowerArtHelper.calculateLeafCurvePoint(
        angle: t,
        size: 55.0,
        scale: 0.5,
        specificAngle: 0.45,
        curve: -6.0,
        stemDomain: stemDomain,
        config: pinkFlowerConfig
      )
      return (pt.x, pt.y)
    }
    .lineStyle(.init(lineWidth: 2))
    .foregroundStyle(.green)
  }
}

// MARK: - Yellow Variants

struct YellowFlowerPlot: ChartContent {
  var body: some ChartContent {
    LinePlot(
      x: "x", y: "y", t: "t",
      domain: 0...360
    ) { t in
      let pt = FlowerArtHelper.calculateFlowerCurvePoint(angle: t, config: yellowFlowerConfig)
      return (pt.x, pt.y)
    }
    .lineStyle(.init(lineWidth: 2))
    .foregroundStyle(.orange)
  }
}

struct YellowFlowerStemPlot: ChartContent {
  let stemDomain: (Double, Double) = (46.0, 90.0)
  
  var body: some ChartContent {
    LinePlot(
      x: "x", y: "y", t: "t",
      domain: 0.0...1.0
    ) { t in
      let endpoint = FlowerArtHelper.getStemEndPoint(startDomain: stemDomain.0, endDomain: stemDomain.1, config: yellowFlowerConfig)
      let pt = FlowerArtHelper.calculateStemPoint(initial: FlowerArtHelper.stemInitial, endpoint: endpoint, factor: t, curve: 6.0)
      return (pt.x, pt.y)
    }
    .lineStyle(.init(lineWidth: 2))
    .foregroundStyle(.green)
  }
}

struct YellowLeafPlot: ChartContent {
  let stemDomain: (Double, Double) = (46.0, 90.0)
  
  var body: some ChartContent {
    LinePlot(
      x: "x", y: "y", t: "t",
      domain: 144...180
    ) { t in
      let pt = FlowerArtHelper.calculateLeafCurvePoint(
        angle: t,
        size: 40.0,
        scale: 0.5,
        specificAngle: 0.45,
        curve: 6.0,
        stemDomain: stemDomain,
        config: yellowFlowerConfig
      )
      return (pt.x, pt.y)
    }
    .lineStyle(.init(lineWidth: 2))
    .foregroundStyle(.green)
  }
}

// MARK: - Ground Plot

struct GroundPlot: ChartContent {
  let startY: Double = -35.0
  let endY: Double = -50.0
  let scaleValue: Double = 30.0
  
  var body: some ChartContent {
    AreaPlot(
      x: "x", yStart: "yStart", yEnd: "yEnd",
      domain: -90...90
    ) { x in
      let t = x / scaleValue
      let y = sShapedY(for: t)
      return (yStart: y + startY, yEnd: endY)
    }
    .foregroundStyle(.green.opacity(0.5))
    
    LinePlot(
      x: "x", y: "y", t: "t",
      domain: -3.0...3.0
    ) { t in
      let x = scaleValue * t
      let y = sShapedY(for: t)
      return (x, y + startY)
    }
    .lineStyle(.init(lineWidth: 2))
    .foregroundStyle(.green)
    
  }
  
  /// Computes the y-value for the S-shaped curve for a given scaled x-value.
  /// Equation: y = 2 * (sin(t) + atan(t))
  nonisolated func sShapedY(for t: Double) -> Double {
    return 2 * (sin(t) + atan(t))
  }
}
