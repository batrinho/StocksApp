//
//  ViewController.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

class StocksViewController: UIViewController {
<<<<<<< HEAD
=======
    private var stocksTableView = StocksTableView()
    private let coreDataDatabaseFetchManager: CoreDataDatabaseManagerFetchProtocol = CoreDataDatabaseManager()
    private let coreDataDatabaseManager: CoreDataDatabaseManagerProtocol = CoreDataDatabaseManager()
>>>>>>> a3a4c03cd9b98dd79e4cd58982705730b17d83b1
    
    // MARK: - Variables
    
    private let networkingService: NetworkingServiceProtocol = NetworkingService()
    private let stockDataManager: StockDataManagerProtocol = StockDataManager()
    private let coreDataDatabaseManager = CoreDataDatabaseManager()
    
    private var searchController: UISearchController = UISearchController()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalCentering
        stackView.alignment = .firstBaseline
        return stackView
    } ()
    
    private var stocksTableView: StocksTableView = {
        let tableView = StocksTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
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

// MARK: - Configurations

extension StocksViewController {
    override func viewDidLoad () {
        super.viewDidLoad()
        configureStocksViewController()
    }
    
    private func configureStocksViewController () {
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        
        initSearchController()
        
        DispatchQueue.main.async {
            self.setupView()
        }
    }
    
    private func setupView () {
        view.backgroundColor = .systemBackground
        
        view.addSubview(buttonsStackView)
        view.addSubview(stocksTableView)
        
        stocksTableView.coreDatabaseManager = self.coreDataDatabaseManager as? CoreDataDatabaseManager
        
        buttonsStackView.addArrangedSubview(stocksButton)
        buttonsStackView.addArrangedSubview(favoritesButton)
        
        stocksButton.addTarget(self, action: #selector(showStocks), for: .touchUpInside)
        favoritesButton.addTarget(self, action: #selector(showFavorites), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -140),
            
            stocksTableView.topAnchor.constraint(equalTo: buttonsStackView.layoutMarginsGuide.bottomAnchor),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        showStocks()
    }
}

// MARK: - Search bar

extension StocksViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func initSearchController () {
        self.searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        searchController.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.returnKeyType = UIReturnKeyType.search
        searchController.searchBar.placeholder = "Find a Company or Ticker"
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let searchText = searchBar.text {
            filterStocks(searchText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if stocksTableView.isStocks == true {
            showStocks()
        } else {
            showFavorites()
        }
    }
    
    func filterStocks (searchText: String) {
        StockData.companies = StockData.stockCompanies.filter({ stock in
            let stockNameMatch = stock.name.lowercased().contains(searchText.lowercased())
            let stockTickerMatch = stock.ticker.lowercased().contains(searchText.lowercased())
            
            return stockNameMatch || stockTickerMatch
        })
        stocksTableView.reloadData()
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
    
    @objc private func showStocks () {
        switchButtons(dominant: stocksButton, passive: favoritesButton)
        DispatchQueue.main.async {
            StockData.companies = StockData.stockCompanies
            self.stocksTableView.isStocks = true
            self.stocksTableView.reloadData()
        }
    }
    
    @objc private func showFavorites () {
        switchButtons(dominant: favoritesButton, passive: stocksButton)
        coreDataDatabaseFetchManager.fetchStocks { stockProfileDataArray in
            if let newArray = stockProfileDataArray {
                DispatchQueue.main.async {
                    StockData.favoritesStockCompanies = newArray
                    StockData.companies = StockData.favoritesStockCompanies
                    self.stocksTableView.isStocks = false
                    self.stocksTableView.reloadData()
                }
            }
        }
    }
}

// MARK: - Table View Delegate, DataSource

extension StocksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StockData.companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockData.stocksCellIndentifier, for: indexPath) as? StocksTableViewCell else {
            return UITableViewCell()
        }
        
        let stock = StockData.companies[indexPath.row]
        let cellBackground = indexPath.row % 2 == 0 ? StockData.cellBackgroundColor : .systemBackground
        let currentIsFavorite = coreDataDatabaseManager.getIsFavorite(ticker: stock.ticker)
        
        cell.configure(newCompanySymbol: stock.ticker, newCompanyTitle: stock.name, cellBackgroundColor: cellBackground, logo: stock.logo, isFavorite: currentIsFavorite) { currentFavoriteState in
            if currentFavoriteState == true {
                self.coreDataDatabaseManager.addStock(stock: stock)
            } else {
                self.coreDataDatabaseManager.deleteStock(stock: stock)
            }
            DispatchQueue.main.async {
                if self.stocksTableView.isStocks == false {
                    StockData.companies = StockData.favoritesStockCompanies
                }
                self.stocksTableView.reloadData()
            }
        }
        
        networkingService.fetchCompanyLogo(logoUrl: stock.logo) { image in
            DispatchQueue.main.async {
                if let newImage = image {
                    cell.updateLogo(newCompanyLogo: newImage)
                }
            }
        }
        
        stockDataManager.fetchPrice(stockSymbol: stock.ticker) { price in
            DispatchQueue.main.async {
                if let newPrice = StockData.prices[stock.ticker] {
                    cell.updatePrices(currentPrice: newPrice.c, priceChange: newPrice.d)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

