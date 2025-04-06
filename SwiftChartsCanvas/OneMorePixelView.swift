//
//  OneMorePixelView.swift
//  SwiftChartsCanvas
//
//  Created by Akihiko Sato on 2025/03/15.
//

import SwiftUI
import Charts

struct PixelData: Identifiable {
  let id = UUID()
  let x: String
  let y: String
  let color: Color
  let index: Int
}

struct OneMorePixelView: View {
  @State private var pixelData: [PixelData] = []
  private let pixelDataAspectRatio: CGFloat = 1.5
  
  var body: some View {
    Chart {
      RectanglePlot(
        pixelData,
        x: .value("X", \.x),
        y: .value("Y", \.y),
        width: .ratio(1.0),
        height: .ratio(1.0)
      )
      .foregroundStyle(by: .value("Index", \.index))
    }
    .chartXAxis(.hidden)
    .chartYAxis(.hidden)
    .chartLegend(.hidden)
    .chartForegroundStyleScale(
      range: Gradient(colors: pixelData.map { $0.color })
    )
    .chartPlotStyle { content in
      content.aspectRatio(pixelDataAspectRatio, contentMode: .fit)
    }
    .onAppear {
      loadPixelData()
    }
    .padding()
  }
  
  /// Loads pixel data from the "pixels.csv" file.
  private func loadPixelData() {
    guard let csvURL = Bundle.main.url(forResource: "pixels", withExtension: "csv") else { return }
    pixelData = loadCSV(from: csvURL)
  }
  
  /// Parses the CSV file at the given URL into an array of PixelData.
  func loadCSV(from url: URL) -> [PixelData] {
    guard let content = try? String(contentsOf: url, encoding: .utf8) else { return [] }
    var result: [PixelData] = []
    let lines = content.components(separatedBy: .newlines)
    for (index, line) in lines.dropFirst().enumerated() {
      let columns = line.components(separatedBy: ",")
      if columns.count == 5 {
        if let x = Int(columns[0]),
           let y = Int(columns[1]),
           let r = Double(columns[2]),
           let g = Double(columns[3]),
           let b = Double(columns[4]) {
          let color = Color(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0
          )
          result.append(
            PixelData(x: "\(x)", y: "\(y)", color: color, index: index)
          )
        }
      }
    }
    return result
  }
}

#Preview {
  OneMorePixelView()
}
