//
//  CircleMarker.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 19.12.2023.
//

import UIKit
import DGCharts

final class CircleMarker: MarkerImage {
    private var fillColor: UIColor
    private var borderColor: UIColor
    private let radius: CGFloat = 4
    private let borderWidth: CGFloat = 3
    
    init(fillColor: UIColor, borderColor: UIColor) {
        self.fillColor = fillColor
        self.borderColor = borderColor
        super.init()
    }
    
    override func draw(context: CGContext, point: CGPoint) {
        let filledCircleRect = CGRect(
            x: point.x - radius,
            y: point.y - radius,
            width: radius * 2,
            height: radius * 2
        )
        context.setFillColor(fillColor.cgColor)
        context.fillEllipse(in: filledCircleRect)
        
        let borderCircleRect = CGRect(
            x: point.x - radius - borderWidth/2,
            y: point.y - radius - borderWidth/2,
            width: (radius + borderWidth / 2) * 2,
            height: (radius + borderWidth / 2) * 2
        )
        context.setStrokeColor(borderColor.cgColor)
        context.setLineWidth(borderWidth)
        context.strokeEllipse(in: borderCircleRect)
        
        context.restoreGState()
    }
    
    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        
    }
}

