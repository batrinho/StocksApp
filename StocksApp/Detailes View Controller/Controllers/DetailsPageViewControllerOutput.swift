//
//  DetailsPageViewControllerOutput.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 30.11.2023.
//

import UIKit
import DGCharts

protocol DetailsPageViewControllerOutput {
    func handleChartButtonTap(name: String)
    
    func handleBuyButtonTap(price: String)
    
    func backButtonPressed()
    
    func favoriteButtonPressed()
    
    func getButtonNames() -> [String]
    
    func viewIsReady()
}
