//
//  ButtonsStackView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 06.10.2023.
//

import UIKit

protocol ButtonsStackViewProtocol: AnyObject {
    func handleButtonStackViewButtonTap(isStocks: Bool)
}

class ButtonsStackView: UIStackView {
    private var isStocks: Bool = true
    weak var delegate: ButtonsStackViewProtocol?
    
    // MARK: - UI
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
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .horizontal
        spacing = 15
        distribution = .equalCentering
        alignment = .firstBaseline
        addSubviews()
    }
    
    private func addSubviews() {
        addArrangedSubview(stocksButton)
        addArrangedSubview(favoritesButton)
        stocksButton.addTarget(self, action: #selector(anyButtonClicked), for: .touchUpInside)
        favoritesButton.addTarget(self, action: #selector(anyButtonClicked), for: .touchUpInside)
    }
    
    @objc
    private func anyButtonClicked() {
        isStocks.toggle()
        if isStocks {
            switchButtons(dominant: stocksButton, passive: favoritesButton)
        } else {
            switchButtons(dominant: favoritesButton, passive: stocksButton)
        }
        delegate?.handleButtonStackViewButtonTap(isStocks: isStocks)
    }
    
    private func switchButtons(dominant: UIButton, passive: UIButton) {
        dominant.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
        dominant.setTitleColor(.black, for: .normal)
        
        passive.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        passive.setTitleColor(.lightGray, for: .normal)
    }
}
