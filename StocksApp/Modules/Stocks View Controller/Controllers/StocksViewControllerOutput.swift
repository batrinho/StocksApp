//
//  StocksViewControllerOutput.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 09.11.2023.
//

import UIKit

protocol StocksViewControllerOutput {
    func viewIsReady()
    
    func startedEditingTextField(with searchText: String)
    
    func handleButtonStackViewTap()

    func handleTextFieldButtonTap()
    
    func handleFavoriteButtonTap(with indexPath: IndexPath)
    
    func handleRequestButtonTap(name: String)
    
    func handleEnter(text: String)
    
    func handleShowMoreButtonTap()
    
    func handleCellSelection(at indexPath: IndexPath)
    
    func displayStocks()
    
    func displayFavorites()
    
    func getStockInformation(with id: Int) -> Stock?
    
    func getStocksCount() -> Int
    
    func getHeightForCell() -> Double
    
    func getPopularRequestsArray() -> [String]
    
    func getRecentRequestsArray() -> [String]
    
    func buttonImageForStock(with ticker: String) -> UIImage
}
