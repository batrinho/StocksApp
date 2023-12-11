//
//  DetailsPageViewControllerInput.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 30.11.2023.
//

import UIKit
import DGCharts

protocol DetailsPageViewControllerInput: AnyObject {
    func stateChangedTo(_ state: DetailsPageViewControllerPresenter.State)
    
    func updateGraph(with data: LineChartData)
    
    func updateFavoriteButtonImage(with image: UIImage)
    
    func popViewController()
    
    func presentPurchaseAlertViewController(price: String)
}

