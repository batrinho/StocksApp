//
//  ViewController.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

class StocksViewController: UIViewController {
    private var stocksTableView = StocksTableView()
    private let coreDataDatabaseFetchManager: CoreDataDatabaseManagerFetchProtocol = CoreDataDatabaseManager()
    private let coreDataDatabaseManager: CoreDataDatabaseManagerProtocol = CoreDataDatabaseManager()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    } ()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalCentering
        stackView.alignment = .firstBaseline
        return stackView
    } ()
    
    private let stocksButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Stocks", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: .heavy)
        button.setTitleColor(.black, for: .normal)
        return button
    } ()
    
    private let favoritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Favorites", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        button.setTitleColor(.lightGray, for: .normal)
        return button
    } ()
}

// MARK: - Methods

extension StocksViewController {
    override func viewDidLoad () {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView () {
        view.backgroundColor = .systemBackground
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(buttonsStackView)
        mainStackView.addArrangedSubview(stocksTableView)
        
        stocksTableView.coreDatabaseManager = self.coreDataDatabaseManager as? CoreDataDatabaseManager
        
        buttonsStackView.addArrangedSubview(stocksButton)
        buttonsStackView.addArrangedSubview(favoritesButton)
        
        stocksButton.addTarget(self, action: #selector(stocksBigger), for: .touchUpInside)
        favoritesButton.addTarget(self, action: #selector(favoritesBigger), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -140),
            
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        stocksBigger()
    }
}

// MARK: - Buttons

extension StocksViewController {
    private func switchButtons (dominant: UIButton, passive: UIButton) {
        dominant.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: .heavy)
        dominant.setTitleColor(.black, for: .normal)
        
        passive.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        passive.setTitleColor(.lightGray, for: .normal)
    }
    
    @objc private func stocksBigger () {
        switchButtons(dominant: stocksButton, passive: favoritesButton)
        DispatchQueue.main.async {
            StockData.companies = StockData.stockCompanies
            self.stocksTableView.reloadData()
        }
    }
    
    @objc private func favoritesBigger () {
        switchButtons(dominant: favoritesButton, passive: stocksButton)
        coreDataDatabaseFetchManager.fetchStocks { stockProfileDataArray in
            if let newArray = stockProfileDataArray {
                DispatchQueue.main.async {
                    StockData.favoritesStockCompanies = newArray
                    StockData.companies = StockData.favoritesStockCompanies
                    self.stocksTableView.reloadData()
                }
            }
        }
    }
}
