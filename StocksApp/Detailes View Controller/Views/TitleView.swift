//
//  TitleView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 30.11.2023.
//

import UIKit

final class TitleView: UIView {
    private let stockCompanyName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    private let stockCompanyTicker: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    init(frame: CGRect, stockCompanyName: String, stockCompanyTicker: String) {
        super.init(frame: frame)
        self.stockCompanyName.text = stockCompanyName
        self.stockCompanyTicker.text = stockCompanyTicker
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        labelStackView.addArrangedSubview(stockCompanyTicker)
        labelStackView.addArrangedSubview(stockCompanyName)
        addSubview(labelStackView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
