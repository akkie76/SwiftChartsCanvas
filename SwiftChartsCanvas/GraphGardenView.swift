//
//  GraphGardenView.swift
//  SwiftChartsCanvas
//
//  Created by Akihiko Sato on 2025/04/06.
//

import SwiftUI
import Charts

struct GraphGardenView: View {
  var body: some View {
    Chart {
      GroundPlot()
      YellowFlower()
      PinkFlower()
    }
    .chartXScale(domain: -100...100)
    .chartYScale(domain: -60...60)
    .chartPlotStyle { content in
      content
        .aspectRatio(contentMode: .fit)
    }
    .padding()
  }
}

struct YellowFlower: ChartContent {
  var body: some ChartContent {
    YellowFlowerStemPlot()
    YellowFlowerPlot()
    YellowLeafPlot()
  }
}

struct PinkFlower: ChartContent {
  var body: some ChartContent {
    PinkFlowerStemPlot()
    PinkFlowerPlot()
    PinkLeafPlot()
  }
}

#Preview {
  GraphGardenView()
}
