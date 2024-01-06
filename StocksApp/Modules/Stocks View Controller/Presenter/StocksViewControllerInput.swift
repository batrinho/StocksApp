//
//  StocksViewControllerInput.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 09.11.2023.
//

import UIKit

protocol StocksViewControllerInput: AnyObject {
    func stateChangedTo(_ state: StocksViewControllerPresenter.State)
    
    func updateFavoriteButton(with indexPath: IndexPath, buttonImage: UIImage)
    
    func replaceTextFieldButtonImage(with: UIImage)

    func updateSearchBarView(text: String)
    
    func updateUI()
    
    func textFieldResignFirstResponder()
    
    func addRequestToStackView(request: String, upper: Bool)
    
    func switchButtonsDominance(isStocksPrior: Bool)
    
    func displaySecondViewController(_ secondVC: UIViewController)
}
