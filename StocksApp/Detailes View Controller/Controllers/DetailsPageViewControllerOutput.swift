//
//  DetailsPageViewControllerOutput.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 30.11.2023.
//

import UIKit
import DGCharts

protocol DetailsPageViewControllerOutput {
    func handleChartButtonTap(state: DetailsPageViewControllerPresenter.State)
    
    func handleBuyButtonTap(price: String)
    
    func backButtonPressed()
    
    func favoriteButtonPressed()
    
    func getButtons() -> [DetailsPageViewControllerPresenter.State]
    
    func formattedDateForPriceMarker(atIndex index: Int) -> String?
    
    func chartValueSelected(at position: CGPoint, entry: ChartDataEntry)
    
    func viewIsReady()
}
