//
//  ButtonsStackView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 06.10.2023.
//

import UIKit

class ButtonsStackView: UIStackView {
    
    private var buttonsStackViewWidthConstraint: NSLayoutConstraint!
    
    let stocksButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Stocks", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
        button.setTitleColor(.black, for: .normal)
        return button
    } ()
    
    let favoritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Favorites", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        button.setTitleColor(.lightGray, for: .normal)
        return button
    } ()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        spacing = 15
        distribution = .equalCentering
        alignment = .firstBaseline
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.2
//        layer.shadowOffset = CGSize(width: 0, height: 4)
//        layer.shadowRadius = 4
        
        addArrangedSubview(stocksButton)
        addArrangedSubview(favoritesButton)
    }
    
    func switchButtons (dominant: UIButton, passive: UIButton) {
        dominant.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
        dominant.setTitleColor(.black, for: .normal)
        
        passive.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        passive.setTitleColor(.lightGray, for: .normal)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
