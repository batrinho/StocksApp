//
//  RequestButton.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 13.09.2023.
//

import UIKit

final class RequestButton: UIButton {
    var action: ((String) -> Void)?
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        sizeToFit()
        layer.cornerRadius = 22.5
        layer.masksToBounds = true
        backgroundColor = StockData.cellBackgroundColor
    }
    
    override var intrinsicContentSize: CGSize {
        let labelSize = label.intrinsicContentSize
        return CGSize(width: labelSize.width + 32, height: labelSize.height + 24)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabel (newName: String) {
        label.text = newName
    }
    
    func addAction(_ action: ((String) -> Void)?) {
        self.action = action
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc private func buttonPressed () {
        action?(label.text!)
    }
    
}
