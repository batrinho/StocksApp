//
//  StocksTableViewController.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

final class StocksTableView: UITableView {
    var isStocks = true
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    private func setupTableView () {
        separatorStyle = UITableViewCell.SeparatorStyle.none
        showsVerticalScrollIndicator = false
        register(StocksTableViewCell.self, forCellReuseIdentifier: StockData.stocksCellIndentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
