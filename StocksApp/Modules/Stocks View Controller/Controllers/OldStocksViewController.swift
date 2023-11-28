////
////  ViewController.swift
////  StocksApp
////
////  Created by Batyr Tolkynbayev on 01.08.2023.
////
//
//import UIKit
//
//// MARK: - Configurations
//final class sdofsfdStocksViewController: UIViewController {
//    private let presenter: StocksViewControllerOutput
//    
//    // MARK: - UI
//    private let searchBarView = SearchBarView()
//    private let showMoreView = ShowMoreView()
//    private let buttonsStackView: ButtonsStackView
//    private let stocksTableView: StocksTableView
//    private let requestsView: RequestsView
//    private var searchBarViewHeightConstraint: NSLayoutConstraint!
//    private var buttonsStackViewWidthConstraint: NSLayoutConstraint!
//    
//    init (presenter: StocksViewControllerOutput) {
//        self.presenter = presenter
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad () {
//        super.viewDidLoad()
//        configure()
//    }
//    
//    private func configure() {
//        stocksTableView.delegate = self
//        stocksTableView.dataSource = self
//        searchBarView.textField.delegate = self
//        
//        setupView()
//    }
//    
//    private func setupView () {
//        view.backgroundColor = .systemBackground
//        view.addSubview(searchBarView)
//        searchBarView.button.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
//        
//        view.addSubview(buttonsStackView)
//        view.addSubview(showMoreView)
//        view.addSubview(stocksTableView)
//        view.addSubview(searchView)
//        
//        setupRequestStackViews()
//        setupConstraints()
//        
//        searchView.isHidden = true
//        showMoreView.isHidden = true
//        
//        buttonsStackView.stocksButton.addTarget(self, action: #selector(showStocks), for: .touchUpInside)
//        buttonsStackView.favoritesButton.addTarget(self, action: #selector(showFavorites), for: .touchUpInside)
//        
//        showStocks()
//    }
//    
//    private func setupRequestStackViews () {
//        searchView.addSubview(popularRequestsView)
//        popularRequestsView.delegate = self
//        searchView.addSubview(recentRequestsView)
//        recentRequestsView.delegate = self
//        coreDataDatabaseManager.fetchRequests { [weak self] recentRequests in
//            guard let recentRequests = recentRequests, let self else { return }
//            for recentRequest in recentRequests {
//                guard let recentRequestTitle = recentRequest.requestTitle else { return }
//                if !recentRequestTitle.isEmpty {
//                    StockData.recentRequests.append(recentRequestTitle)
//                }
//            }
//            self.recentRequestsView.configure(label: "Recent Requests", array: StockData.recentRequests)
//        }
//    }
//    
//    private func setupConstraints () {
//        buttonsStackViewWidthConstraint = buttonsStackView.widthAnchor.constraint(equalToConstant: 220)
//        searchBarViewHeightConstraint = searchBarView.heightAnchor.constraint(equalToConstant: 48)
//        
//        NSLayoutConstraint.activate([
//            searchView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 10),
//            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            searchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            searchBarView.topAnchor.constraint(equalTo: view..topAnchor),
//            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            searchBarViewHeightConstraint,
//            
//            popularRequestsView.topAnchor.constraint(equalTo: searchView.topAnchor),
//            popularRequestsView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor),
//            popularRequestsView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
//            popularRequestsView.heightAnchor.constraint(equalToConstant: 170),
//            
//            recentRequestsView.topAnchor.constraint(equalTo: popularRequestsView.bottomAnchor),
//            recentRequestsView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor),
//            recentRequestsView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
//            recentRequestsView.heightAnchor.constraint(equalToConstant: 170),
//            
//            buttonsStackView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 10),
//            buttonsStackView.heightAnchor.constraint(equalToConstant: 40),
//            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            buttonsStackViewWidthConstraint,
//            
//            showMoreView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 10),
//            showMoreView.heightAnchor.constraint(equalToConstant: 40),
//            showMoreView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            showMoreView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            stocksTableView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 10),
//            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//        ])
//    }
//}
//
//// MARK: - HandleRequestButtonTapDelegate
//extension asdStocksViewController: RequestsViewDelegate {
//    func handleRequestButtonTap (name: String) {
//        self.searchBarView.textField.text = name
//        self.updateResults(text: name)
//    }
//    // for delegate
//}
//
//// MARK: - Search bar
//extension asStocksViewController: UITextFieldDelegate {
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        searchBarView.isClicked = true
//        searchBarView.toggleButton()
//        searchView.isHidden = false
//        buttonsStackView.isHidden = true
//        stocksTableView.isHidden = true
//        return true
//    }
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
//        updateResults(text: text)
//        return true
//    }
//    
//    func updateResults (text: String) {
//        if text.isEmpty {
//            searchView.isHidden = false
//            buttonsStackView.isHidden = true
//            showMoreView.isHidden = true
//            stocksTableView.isHidden = true
//        } else {
//            filterStocks(searchText: text)
//            searchView.isHidden = true
//            showMoreView.isHidden = false
//            stocksTableView.isHidden = false
//        }
//    }
//    
//    @objc func backButtonClicked () {
//        if searchBarView.isClicked {
//            searchBarView.button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
//            searchView.isHidden = true
//            buttonsStackView.isHidden = false
//            stocksTableView.isHidden = false
//            searchBarView.textField.resignFirstResponder()
//            (stocksTableView.isStocks ? showStocks() : showFavorites())
//        }
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        guard let text = textField.text else { return false }
//        if !text.isEmpty {
//            coreDataDatabaseManager.addRequest(request: text)
//            StockData.recentRequests.removeAll()
//            coreDataDatabaseManager.fetchRequests { recentRequests in
//                guard let recentRequests = recentRequests else { return }
//                for recentRequest in recentRequests {
//                    guard let recentRequestTitle = recentRequest.requestTitle else { return }
//                    if !recentRequestTitle.isEmpty {
//                        StockData.recentRequests.append(recentRequestTitle)
//                    }
//                }
//            }
//            recentRequestsView.updateStackView(array: StockData.recentRequests)
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    func filterStocks (searchText: String) {
//        StockData.companies = StockData.stockCompanies.filter({ stock in
//            let stockNameMatch = stock.name.lowercased().contains(searchText.lowercased())
//            let stockTickerMatch = stock.ticker.lowercased().contains(searchText.lowercased())
//            
//            return stockNameMatch || stockTickerMatch
//        })
//        stocksTableView.reloadData()
//    }
//}
//
//// MARK: - Buttons
//extension asdStocksViewController {
//    @objc private func showStocks () {
//        buttonsStackView.switchButtons(dominant: buttonsStackView.stocksButton, passive: buttonsStackView.favoritesButton)
//        DispatchQueue.main.async {
//            StockData.companies = StockData.stockCompanies
//            self.stocksTableView.isStocks = true
//            self.stocksTableView.reloadData()
//        }
//    }
//    
//    @objc private func showFavorites () {
//        buttonsStackView.switchButtons(dominant: buttonsStackView.favoritesButton, passive: buttonsStackView.stocksButton)
//        coreDataDatabaseManager.fetchStocks { [weak self] stockProfileDataArray in
//            guard let newArray = stockProfileDataArray, let self else { return }
//            DispatchQueue.main.async {
//                StockData.favoritesStockCompanies = newArray
//                StockData.companies = StockData.favoritesStockCompanies
//                self.stocksTableView.isStocks = false
//                self.stocksTableView.reloadData()
//            }
//        }
//    }
//}
//
//// MARK: - Table View Delegate
//extension asdStocksViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let cell = stocksTableView.cellForRow(at: indexPath) as? StocksTableViewCell else { return }
//        cell.selectedBackgroundView?.layer.cornerRadius = 25
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
//}
//
//// MARK: - UIScrollViewDelegate
//extension asdStocksViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let yOffset = scrollView.contentOffset.y
//        
//        if yOffset > 0 {
//            let maxHeight: CGFloat = 48
//            let newHeight = maxHeight - yOffset
//            searchBarViewHeightConstraint.constant = newHeight
//            searchBarView.layer.cornerRadius = 25 - yOffset / 2
//        } else {
//            searchBarViewHeightConstraint.constant = 48
//            searchBarView.layer.cornerRadius = 25
//        }
//    }
//}
//
//// MARK: - HandleButtonTapDelegate
//extension asdStocksViewController: StocksTableViewCellDelegate {
//    func handleFavoriteButtonTap(with indexPath: IndexPath, isFavorite: Bool, ticker: String, name: String, logoUrl: String) {
//        guard let cell = stocksTableView.cellForRow(at: indexPath) as? StocksTableViewCell else { return }
//        let stock = StockProfileData(name: name, logo: logoUrl, ticker: ticker)
//        cell.updateButtonImage(isFavorite: isFavorite)
//        if isFavorite == true {
//            self.coreDataDatabaseManager.addStock(stock: stock)
//        } else {
//            self.coreDataDatabaseManager.deleteStock(stock: stock)
//        }
//        DispatchQueue.main.async {
//            if self.stocksTableView.isStocks == false {
//                StockData.companies = StockData.favoritesStockCompanies
//            }
//            self.stocksTableView.reloadData()
//        }
//    }
////    the delegate for handling the "favorite button"
//}
//
//// MARK: - UITableViewDataSource
//extension asdStocksViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(StockData.companies.count)
//        return StockData.companies.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "stocksCell", for: indexPath) as? StocksTableViewCell else {
//            return UITableViewCell()
//        }
//        
//        let stock = StockData.companies[indexPath.row]
//        let color = getCellBackgroundColor(row: indexPath.row)
//        let isFavorite = coreDataDatabaseManager.getIsFavorite(ticker: stock.ticker)
//        
//        cell.selectedBackgroundView?.layer.cornerRadius = 25
//        cell.delegate = self
//        cell.configure(
//            ticker: stock.ticker,
//            name: stock.name,
//            color: color,
//            logoUrl: stock.logo,
//            isFavorite: isFavorite
//        )
//        
//        networkingService.fetchCompanyLogo(logoUrl: stock.logo) { [weak cell] image, logoUrl in
//            guard let image,
//                  let logoUrl,
//                  let cell else { return }
//            DispatchQueue.main.async {
//                cell.updateLogo(newCompanyLogo: image)
//                StockData.logos[logoUrl] = image
//            }
//        }
//        
//        stockDataManager.fetchPrice(stockSymbol: stock.ticker) { [weak cell] price in
//            guard let price,
//                  let cell else { return }
//            DispatchQueue.main.async {
//                cell.updatePrices(currentPrice: price.c, priceChange: price.d)
//                StockData.prices[stock.ticker] = price
//            }
//        }
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 90
//    }
//    
//    func getCellBackgroundColor (row: Int) -> UIColor {
//        return (row % 2 == 0) ? UIColor.backgroundGray : .clear
//    }
//}
//
//
