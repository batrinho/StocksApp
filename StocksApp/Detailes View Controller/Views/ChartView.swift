//
//  ChartView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 30.11.2023.
//

import UIKit
import DGCharts

protocol StocksChartViewDelegate: AnyObject {
    func chartValueSelected(at position: CGPoint, entry: ChartDataEntry)
    func chartValueNotSelected()
}

final class ChartView: UIView, ChartViewDelegate {
    weak var delegate: StocksChartViewDelegate?
    
    private let marker = CircleMarker(fillColor: .black, borderColor: .white)
    private let chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.drawBordersEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        return chartView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        chartView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        marker.chartView = chartView
        chartView.marker = marker
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
        chartView.animate(xAxisDuration: 1.5)
        chartView.data = data
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let position = CGPointMake(highlight.xPx, highlight.yPx)
        let superViewPosition = chartView.convert(position, to: chartView.superview)
        delegate?.chartValueSelected(at: superViewPosition, entry: entry)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        delegate?.chartValueNotSelected()
    }
}
