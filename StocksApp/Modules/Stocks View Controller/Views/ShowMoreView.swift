//
//  ShowMoreView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 09.11.2023.
//

import UIKit

protocol ShowMoreViewDelegate: AnyObject {
    func handleShowMoreButtonTap()
}

final class ShowMoreView: UIView {
    weak var delegate: ShowMoreViewDelegate?
    
    // MARK: - UI
    private let labelOne: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Stocks"
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.textColor = .black
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show more", for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 12)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .right
        return button
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
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    private func addSubviews() {
        addSubview(labelOne)
        addSubview(button)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            labelOne.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            labelOne.topAnchor.constraint(equalTo: self.topAnchor),
            labelOne.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            labelOne.widthAnchor.constraint(equalToConstant: 100),
            labelOne.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    @objc
    func buttonPressed() {
        delegate?.handleShowMoreButtonTap()
    }
}
    
