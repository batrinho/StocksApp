//
//  RequestButton.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 13.09.2023.
//

import UIKit

protocol RequestButtonDelegate: AnyObject {
    func handleRequestButtonTap(name: String)
}

final class RequestButton: UIButton {
    weak var delegate: RequestButtonDelegate?
    
    // MARK: - UI
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        return label
    } ()
    
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
        layer.cornerRadius = 20
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
    
    override var intrinsicContentSize: CGSize {
        let labelSize = label.intrinsicContentSize
        return CGSize(width: labelSize.width + 32, height: labelSize.height + 24)
    }
    
    @objc 
    private func buttonPressed() {
        delegate?.handleRequestButtonTap(name: label.text ?? "")
    }
}
