//
//  PriceMarkerView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 11.12.2023.
//

import UIKit
import DGCharts

protocol PriceMarkerViewDelegate: AnyObject {
    func formattedDateForPriceMarker(atIndex index: Int) -> String?
}

final class PriceMarkerView: MarkerView {
    weak var delegate: PriceMarkerViewDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        return label
    }()
    
    private let date: UILabel = {
        let date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.textColor = UIColor.gray
        date.textAlignment = .center
        date.font = UIFont(name: "Montserrat-Medium", size: 12)
        return date
    }()
    
    private let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.black
        layer.cornerRadius = 20
        addSubview(label)
        addSubview(date)
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        label.text = "$\(entry.y)"
        date.text = delegate?.formattedDateForPriceMarker(atIndex: Int(entry.x))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 0, y: 7.5, width: bounds.width, height: bounds.height / 2)
        date.frame = CGRect(x: 0, y: bounds.height / 2 - 3, width: bounds.width, height: bounds.height / 2)
    }
    
    override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        var offset = self.offset
        if point.x <= (self.chartView?.bounds.width)! / 2 {
            offset.x = 0
        } else {
            offset.x = -self.bounds.size.width
        }
        
        self.offset = offset
        return super.offsetForDrawing(atPoint: point)
    }
}
