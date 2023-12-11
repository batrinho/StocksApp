//
//  RequestButton.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 13.09.2023.
//

import UIKit

protocol ChartButtonDelegate: AnyObject {
    func handleChartButtonTap(name: String?)
}

final class ChartButton: UIButton {
    weak var delegate: ChartButtonDelegate?
    
    override var backgroundColor: UIColor? {
        didSet {
            label.textColor = (backgroundColor == .black ? .white : .black)
        }
    }
    
    var labelText: String? {
        get {
            return label.text
        }
    }
    
    // MARK: - UI
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        return label
    }()
    
    init(frame: CGRect, name: String) {
        self.label.text = name
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
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UIColor.backgroundGray
        
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
        delegate?.handleChartButtonTap(name: label.text)
    }
}
