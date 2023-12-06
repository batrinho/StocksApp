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
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        
        chartView.xAxis.drawLabelsEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false

        chartView.marker = nil
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


}
