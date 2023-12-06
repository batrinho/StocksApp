//
//  DetailsPageViewControllerOutput.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 30.11.2023.
//

import UIKit

protocol DetailsPageViewControllerOutput {
    func handleChartButtonTap(name: String)
    
    func backButtonPressed()
    
    func favoriteButtonPressed()
    
    func getButtonNames() -> [String]
    
    func viewIsReady()
}
