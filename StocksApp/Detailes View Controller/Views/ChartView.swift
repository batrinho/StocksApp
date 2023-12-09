//
//  ChartView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 30.11.2023.
//

import UIKit
import DGCharts

final class ChartView: UIView, ChartViewDelegate {
    private let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.drawBordersEnabled = false
        chartView.animate(xAxisDuration: 2.5)
        return chartView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(chartView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: topAnchor),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func updateGraph(with data: LineChartData) {
        chartView.data = data
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}
