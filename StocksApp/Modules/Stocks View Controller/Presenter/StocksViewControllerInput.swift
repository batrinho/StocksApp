//
//  StocksViewControllerInput.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 09.11.2023.
//

import UIKit

protocol StocksViewControllerInput: AnyObject {
    func stateChangedTo(state: StocksViewControllerPresenter.State)
    
    func updateFavoriteButton(with indexPath: IndexPath, buttonImage: UIImage)
    
    func updateTextFieldButtonImage(with image: UIImage)
    
    func updateSearchBarView(text: String)
    
    func reloadTableView()
    
    func textFieldResignFirstResponder()
}
