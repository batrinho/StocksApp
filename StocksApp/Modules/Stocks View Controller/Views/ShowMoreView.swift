//
//  ShowMoreView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 09.11.2023.
//

import UIKit

class ShowMoreView: UIView {
    // MARK: - UI
    private let labelOne: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Stocks"
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.textColor = .black
        return label
    }()
    
    private let labelTwo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Show more"
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        addSubview(labelOne)
        addSubview(labelTwo)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            labelOne.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelOne.topAnchor.constraint(equalTo: self.topAnchor),
            labelOne.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            labelOne.widthAnchor.constraint(equalToConstant: 100),
            labelOne.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            labelTwo.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelTwo.topAnchor.constraint(equalTo: self.topAnchor),
            labelTwo.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            labelTwo.widthAnchor.constraint(equalToConstant: 100),
            labelTwo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
