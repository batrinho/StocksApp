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
    private let buttonsStackView = ButtonsStackView()
    private let stocksTableView = StocksTableView()
    private let searchBarView = SearchBarView()
    private var searchBarViewHeightConstraint: NSLayoutConstraint!
    private var buttonsStackViewWidthConstraint: NSLayoutConstraint!
    
    private let showMoreView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
}

// MARK: - Configurations

extension StocksViewController {
    
    override func viewDidLoad () {
        super.viewDidLoad()
        print(#function)
        print("\nThe frame of the table view: \(stocksTableView.frame)\n")
        // the frame is 0 because there is a space that was prepared for the table view, which is yet to be displayed
        configureStocksViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        print("\nThe frame of the table view: \(stocksTableView.frame)\n")
        // the frame is not 0 because the table view has been sketched, layed its constraints and is active
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print(#function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(#function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    private func configureStocksViewController () {
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        searchBarView.textField.delegate = self
        
        setupView()
    }
    
    private func setupView () {
        view.backgroundColor = .systemBackground
        view.addSubview(searchBarView)
        searchBarView.button.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
        view.addSubview(buttonsStackView)
        view.addSubview(showMoreView)
        view.addSubview(stocksTableView)
        view.addSubview(searchView)

        searchView.addSubview(popularRequestsView)
        popularRequestsView.addAction { stockRequest in
            self.searchBarView.textField.text = stockRequest
            self.updateResults(text: stockRequest)
        }
        searchView.addSubview(recentRequestsView)
        coreDataDatabaseManager.fetchRequests { recentRequests in
            guard let recentRequests = recentRequests else { return }
            for recentRequest in recentRequests {
                guard let recentRequestTitle = recentRequest.requestTitle else { return }
                if !recentRequestTitle.isEmpty {
                    StockData.recentRequests.append(recentRequestTitle)
                }
            }
            self.recentRequestsView.configure(label: "Recent Requests", array: StockData.recentRequests)
        }
        recentRequestsView.addAction { stockRequest in
            self.searchBarView.textField.text = stockRequest
            self.updateResults(text: stockRequest)
        }

        setupShowMoreView()
        setupConstraints()
        
        searchView.isHidden = true
        showMoreView.isHidden = true
        
        buttonsStackView.stocksButton.addTarget(self, action: #selector(showStocks), for: .touchUpInside)
        buttonsStackView.favoritesButton.addTarget(self, action: #selector(showFavorites), for: .touchUpInside)
        
        showStocks()
    }
    
    private func setupShowMoreView () {
        let labelOne = UILabel()
        let labelTwo = UILabel()
        labelOne.translatesAutoresizingMaskIntoConstraints = false
        labelTwo.translatesAutoresizingMaskIntoConstraints = false
        labelOne.text = "Stocks"
        labelOne.font = UIFont(name: "Montserrat-Bold", size: 18)
        labelOne.textColor = .black
        labelTwo.text = "Show more"
        labelTwo.font = UIFont(name: "Montserrat-Bold", size: 12)
        labelTwo.textColor = .black
        labelTwo.textAlignment = .right
        showMoreView.addSubview(labelOne)
        showMoreView.addSubview(labelTwo)
        
        NSLayoutConstraint.activate([
            labelOne.leadingAnchor.constraint(equalTo: showMoreView.leadingAnchor),
            labelOne.topAnchor.constraint(equalTo: showMoreView.topAnchor),
            labelOne.bottomAnchor.constraint(equalTo: showMoreView.bottomAnchor),
            labelOne.widthAnchor.constraint(equalToConstant: 100),
            labelOne.centerYAnchor.constraint(equalTo: showMoreView.centerYAnchor),
            
            labelTwo.trailingAnchor.constraint(equalTo: showMoreView.trailingAnchor),
            labelTwo.topAnchor.constraint(equalTo: showMoreView.topAnchor),
            labelTwo.bottomAnchor.constraint(equalTo: showMoreView.bottomAnchor),
            labelTwo.widthAnchor.constraint(equalToConstant: 100),
            labelTwo.centerYAnchor.constraint(equalTo: showMoreView.centerYAnchor),
        ])
    }
    
    private func setupConstraints () {
        buttonsStackViewWidthConstraint = buttonsStackView.widthAnchor.constraint(equalToConstant: 220)
        searchBarViewHeightConstraint = searchBarView.heightAnchor.constraint(equalToConstant: 48)
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 10),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchBarView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBarViewHeightConstraint,

            popularRequestsView.topAnchor.constraint(equalTo: searchView.topAnchor),
            popularRequestsView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor),
            popularRequestsView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
            popularRequestsView.heightAnchor.constraint(equalToConstant: 170),

            recentRequestsView.topAnchor.constraint(equalTo: popularRequestsView.bottomAnchor),
            recentRequestsView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor),
            recentRequestsView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
            recentRequestsView.heightAnchor.constraint(equalToConstant: 170),

            buttonsStackView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 10),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 40),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackViewWidthConstraint,
            
            showMoreView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 10),
            showMoreView.heightAnchor.constraint(equalToConstant: 40),
            showMoreView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showMoreView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stocksTableView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 10),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}

// MARK: - Search bar

extension StocksViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchBarView.isClicked = true
        searchBarView.toggleButton()
        searchView.isHidden = false
        buttonsStackView.isHidden = true
        stocksTableView.isHidden = true
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        updateResults(text: text)
        return true
    }
    
    func updateResults (text: String) {
        if text.isEmpty {
            searchView.isHidden = false
            buttonsStackView.isHidden = true
            showMoreView.isHidden = true
            stocksTableView.isHidden = true
        } else {
            filterStocks(searchText: text)
            searchView.isHidden = true
            showMoreView.isHidden = false
            stocksTableView.isHidden = false
        }
    }
    
    @objc func backButtonClicked () {
        if searchBarView.isClicked {
            searchBarView.button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            searchView.isHidden = true
            buttonsStackView.isHidden = false
            stocksTableView.isHidden = false
            searchBarView.textField.resignFirstResponder()
            (stocksTableView.isStocks ? showStocks() : showFavorites())
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        if !text.isEmpty {
            coreDataDatabaseManager.addRequest(request: text)
            StockData.recentRequests.removeAll()
            coreDataDatabaseManager.fetchRequests { recentRequests in
                guard let recentRequests = recentRequests else { return }
                for recentRequest in recentRequests {
                    guard let recentRequestTitle = recentRequest.requestTitle else { return }
                    if !recentRequestTitle.isEmpty {
                        StockData.recentRequests.append(recentRequestTitle)
                    }
                }
            }
            recentRequestsView.updateStackView(array: StockData.recentRequests)
            return true
        } else {
            return false
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

//extension StocksViewController: UISearchBarDelegate {
//    func initSearchController () {
////        self.searchController = UISearchController(searchResultsController: nil)
////        searchController.searchBar.delegate = self
////        searchController.searchResultsUpdater = self
////
////        searchController.hidesNavigationBarDuringPresentation = true
////
////        searchController.searchBar.sizeToFit()
////        searchController.searchBar.returnKeyType = UIReturnKeyType.search
////        searchController.searchBar.placeholder = "Find a Company or Ticker"
////        navigationItem.searchController = searchController
////        navigationItem.hidesSearchBarWhenScrolling = true
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
////        guard let searchText = self.searchBar.text else { return }
////
////        filterStocks(searchText: searchText)
////        buttonsStackView.isHidden = searchText.isEmpty
////
////        favoritesButton.isHidden = true
////        stocksButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
////        stocksButton.setTitleColor(.black, for: .normal)
////        stocksButton.isEnabled = false
////        buttonsStackViewWidthConstraint.isActive = false
////        buttonsStackViewWidthConstraint = buttonsStackView.widthAnchor.constraint(equalToConstant: 100)
////        buttonsStackViewWidthConstraint.isActive = true
////
////        stocksTableView.isHidden = searchText.isEmpty
////        searchView.isHidden = !searchText.isEmpty
//    }
//
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        self.searchBar.showsCancelButton = true
//        searchView.isHidden = false
//        buttonsStackView.isHidden = true
//        stocksTableView.isHidden = true
//        return true
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        DispatchQueue.main.async {
//            self.searchView.isHidden = true
//
//            self.stocksButton.isEnabled = true
//
//            self.favoritesButton.isHidden = false
//            self.stocksTableView.isHidden = false
//            self.buttonsStackView.isHidden = false
//
//            self.buttonsStackViewWidthConstraint.isActive = false
//            self.buttonsStackViewWidthConstraint = self.buttonsStackView.widthAnchor.constraint(equalToConstant: 270)
//            self.buttonsStackViewWidthConstraint.isActive = true
//
//            if self.stocksTableView.isStocks == true {
//                self.showStocks()
//            } else {
//                self.showFavorites()
//            }
//        }
//        self.searchBar.isUserInteractionEnabled = false
//        self.searchBar.isUserInteractionEnabled = true
//        self.searchBar.showsCancelButton = false
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        guard let searchBarText = self.searchBar.text else { return }
//        if !searchBarText.isEmpty {
//            coreDataDatabaseManager.addRequest(request: searchBarText)
//            StockData.recentRequests.removeAll()
//            coreDataDatabaseManager.fetchRequests { recentRequests in
//                guard let recentRequests = recentRequests else { return }
//                for recentRequest in recentRequests {
//                    guard let recentRequestTitle = recentRequest.requestTitle else { return }
//                    StockData.recentRequests.append(recentRequestTitle)
//                }
//            }
//            recentRequestsView.updateStackView(array: StockData.recentRequests)
//        }
//    }
//}

// MARK: - Buttons

extension StocksViewController {
    @objc private func showStocks () {
        buttonsStackView.switchButtons(dominant: buttonsStackView.stocksButton, passive: buttonsStackView.favoritesButton)
        DispatchQueue.main.async {
            StockData.companies = StockData.stockCompanies
            self.stocksTableView.isStocks = true
            self.stocksTableView.reloadData()
        }
    }
    
    @objc private func showFavorites () {
        buttonsStackView.switchButtons(dominant: buttonsStackView.favoritesButton, passive: buttonsStackView.stocksButton)
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

extension StocksViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
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
            guard let self = self else { return }
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
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.selectedBackgroundView?.layer.cornerRadius = 25
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if yOffset > 0 {
            let maxHeight: CGFloat = 48
            let newHeight = maxHeight - yOffset
            searchBarViewHeightConstraint.constant = newHeight
            searchBarView.layer.cornerRadius = 25 - yOffset / 4
        } else {
            searchBarViewHeightConstraint.constant = 48
            searchBarView.layer.cornerRadius = 25
        }
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
