//
//  SearchCollectionView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 09.09.2023.
//

import UIKit

class SearchCollectionView: UICollectionView {

    init () {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: StockData.collectionViewCellIndentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
