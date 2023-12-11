//
//  RequestButton.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 13.09.2023.
//

import UIKit

protocol BuyButtonDelegate: AnyObject {
    func handleBuyButtonTap(price: String?)
}

final class BuyButton: UIButton {
    weak var delegate: BuyButtonDelegate?
    
    // MARK: - UI
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        return label
    }()
    
    init(frame: CGRect, price: String) {
        self.label.text = "Buy for \(price)"
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        sizeToFit()
        layer.cornerRadius = 15
        layer.masksToBounds = true
        backgroundColor = .black
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(label)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    @objc
    private func buttonPressed() {
        delegate?.handleBuyButtonTap(price: label.text)
    }
}
