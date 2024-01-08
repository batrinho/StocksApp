//
//  PriceStackView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 08.01.2024.
//

import UIKit

final class PriceStackView: UIStackView {
    private let currentPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: 28)
        return label
    }()
    
    private let changePrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        return label
    }()
    
    init (frame: CGRect, currentPrice: Double, changePrice: Double) {
        self.currentPrice.text = "$\(currentPrice)"
        self.changePrice.text = (changePrice < 0 ? "-$\(changePrice * -1)" : "+$\(changePrice)")
        self.changePrice.textColor = (changePrice < 0 ? .systemRed : .systemGreen)
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        alignment = .center
        spacing = 10
        axis = .vertical
        addSubviews()
    }
    
    private func addSubviews() {
        addArrangedSubview(currentPrice)
        addArrangedSubview(changePrice)
    }
}
