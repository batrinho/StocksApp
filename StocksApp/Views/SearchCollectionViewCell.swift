//
//  SearchCollectionViewCell.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 09.09.2023.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        backgroundColor = StockData.cellBackgroundColor
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    func updateLabel (newLabel: String) {
        label.text = newLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
