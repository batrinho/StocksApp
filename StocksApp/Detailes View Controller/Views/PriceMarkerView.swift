//
//  PriceMarkerView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 11.12.2023.
//

import UIKit
import DGCharts

final class PriceMarkerView: MarkerView {
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        return label
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
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        label.text = "$\(entry.y)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
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
