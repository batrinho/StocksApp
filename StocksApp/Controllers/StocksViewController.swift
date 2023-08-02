//
//  ViewController.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

class StocksViewController: UIViewController {
    
    private var stocksTableView = StocksTableView()
    let networkingService = NetworkingService()
    
    override func viewDidLoad () {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView () {
        view.backgroundColor = .systemBackground
        view.addSubview(stocksTableView)
        stocksTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stocksTableView.topAnchor.constraint(equalTo: view.topAnchor),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    
}

