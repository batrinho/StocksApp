//
//  StocksViewControllerOutput.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 09.11.2023.
//

import UIKit

protocol StocksViewControllerOutput {
    func handleTextFieldChanges(text: String)
    
    func handleTextFieldButton()
    
    func handleFavoriteButtonTap(with indexPath: IndexPath)
    
    func handleRequestButtonTap(name: String)
    
    func openStocks()
    
    func openFavorites()
    
    func getStockInformation(with id: Int) -> Stock?
    
    func getStocksCount() -> Int
    
    func getPopularRequestsArray() -> [String]
    
    func getRecentRequestsArray() -> [String]
}
