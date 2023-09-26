//
//  ViewController.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

final class StocksViewController: UIViewController {
    // MARK: - Variables
    
    private let networkingService: NetworkingServiceProtocol = NetworkingService()
    private let stockDataManager: StockDataManagerProtocol = StockDataManager()
    private let coreDataDatabaseManager = CoreDataDatabaseManager()
    
    private var buttonsStackViewWidthConstraint: NSLayoutConstraint!
    
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
    } ()
    
    private var searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private var popularRequestsView: RequestsView = {
        let requestsView = RequestsView()
        requestsView.translatesAutoresizingMaskIntoConstraints = false
        requestsView.configure(label: "Popular Requests", array: StockData.popularStocks)
        return requestsView
    } ()
    
    private var recentRequestsView: RequestsView = {
        let requestsView = RequestsView()
        requestsView.translatesAutoresizingMaskIntoConstraints = false
        return requestsView
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

// MARK: - Configurations

extension StocksViewController {
    override func viewDidLoad () {
        super.viewDidLoad()
        configureStocksViewController()
    }
    
    private func configureStocksViewController () {
        view.backgroundColor = .systemBackground
        
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        
        initSearchController()
        
        setupView()
    }
    
    private func setupView () {
        view.addSubview(stocksTableView)
        view.addSubview(buttonsStackView)
        
        view.addSubview(searchView)

        searchView.addSubview(popularRequestsView)
        popularRequestsView.addAction { stockRequest in
            self.searchController.searchBar.text = stockRequest
        }
        searchView.addSubview(recentRequestsView)
        coreDataDatabaseManager.fetchRequests { recentRequests in
            guard let recentRequests = recentRequests else { return }
            for recentRequest in recentRequests {
                guard let recentRequestTitle = recentRequest.requestTitle else { return }
                StockData.recentRequests.append(recentRequestTitle)
            }
            self.recentRequestsView.configure(label: "Recent Requests", array: StockData.recentRequests)
        }
        recentRequestsView.addAction { stockRequest in
            self.searchController.searchBar.text = stockRequest
        }
        
        setupConstraints()
        
        searchView.isHidden = true
        
        buttonsStackView.addArrangedSubview(stocksButton)
        buttonsStackView.addArrangedSubview(favoritesButton)
        
        stocksButton.addTarget(self, action: #selector(showStocks), for: .touchUpInside)
        favoritesButton.addTarget(self, action: #selector(showFavorites), for: .touchUpInside)
        
        showStocks()
    }
    
    private func setupConstraints () {
        buttonsStackViewWidthConstraint = buttonsStackView.widthAnchor.constraint(equalToConstant: 270)
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            popularRequestsView.topAnchor.constraint(equalTo: searchView.topAnchor),
            popularRequestsView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor),
            popularRequestsView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
            popularRequestsView.heightAnchor.constraint(equalToConstant: 170),

            recentRequestsView.topAnchor.constraint(equalTo: popularRequestsView.bottomAnchor),
            recentRequestsView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor),
            recentRequestsView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
            recentRequestsView.heightAnchor.constraint(equalToConstant: 170),

            buttonsStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackViewWidthConstraint,
            
            stocksTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 60),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}

// MARK: - Search bar

extension StocksViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func initSearchController () {
        self.searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        searchController.hidesNavigationBarDuringPresentation = true
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.returnKeyType = UIReturnKeyType.search
        searchController.searchBar.placeholder = "Find a Company or Ticker"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchView.isHidden = false
        buttonsStackView.isHidden = true
        stocksTableView.isHidden = true
        
        return true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let searchText = searchBar.text else { return }
        
        filterStocks(searchText: searchText)
        buttonsStackView.isHidden = searchText.isEmpty
        
        favoritesButton.isHidden = true
        stocksButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        stocksButton.setTitleColor(.black, for: .normal)
        stocksButton.isEnabled = false
        buttonsStackViewWidthConstraint.isActive = false
        buttonsStackViewWidthConstraint = buttonsStackView.widthAnchor.constraint(equalToConstant: 100)
        buttonsStackViewWidthConstraint.isActive = true

        stocksTableView.isHidden = searchText.isEmpty
        searchView.isHidden = !searchText.isEmpty
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.searchView.isHidden = true
            
            self.stocksButton.isEnabled = true
            
            self.favoritesButton.isHidden = false
            self.stocksTableView.isHidden = false
            self.buttonsStackView.isHidden = false
            
            self.buttonsStackViewWidthConstraint.isActive = false
            self.buttonsStackViewWidthConstraint = self.buttonsStackView.widthAnchor.constraint(equalToConstant: 270)
            self.buttonsStackViewWidthConstraint.isActive = true
            
            if self.stocksTableView.isStocks == true {
                self.showStocks()
            } else {
                self.showFavorites()
            }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else { return }
        if !searchBarText.isEmpty {
            coreDataDatabaseManager.addRequest(request: searchBarText)
            StockData.recentRequests.removeAll()
            coreDataDatabaseManager.fetchRequests { recentRequests in
                guard let recentRequests = recentRequests else { return }
                for recentRequest in recentRequests {
                    guard let recentRequestTitle = recentRequest.requestTitle else { return }
                    StockData.recentRequests.append(recentRequestTitle)
                }
            }
            recentRequestsView.updateStackView(array: StockData.recentRequests)
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
        coreDataDatabaseManager.fetchStocks { stockProfileDataArray in
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
        let cellBackground = indexPath.row % 2 == 0 ? StockData.cellBackgroundColor : .clear
        let currentIsFavorite = coreDataDatabaseManager.getIsFavorite(ticker: stock.ticker)
        
        cell.configure(newCompanySymbol: stock.ticker, newCompanyTitle: stock.name, cellBackgroundColor: cellBackground, logo: stock.logo, isFavorite: currentIsFavorite) { [weak self] currentFavoriteState in
            guard let self = self else {return}
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

// MARK: - Array split method

extension Array {
    func split() -> (left: [Element], right: [Element]) {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}

extension UIStackView {
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
}
