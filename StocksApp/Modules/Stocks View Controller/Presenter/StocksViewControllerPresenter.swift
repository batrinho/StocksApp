//
//  StocksViewControllerPresenter.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 09.11.2023.
//

import UIKit

final class StocksViewControllerPresenter {
    private enum Constants {
        static let yellowStar = UIImage(named: "star.yellow.fill")!
        static let grayStar = UIImage(named: "star.gray.fill")!
        static let magnifyingGlass = UIImage(systemName: "magnifyingglass")!
        static let backArrow = UIImage(named: "returnIcon")!
        static let heightForCell: Double = 90.0
    }
    
    enum State {
        case displayingStocks
        case displayingFavorites
        case searching
        case typing
    }
    
    weak var input: StocksViewControllerInput?
    private var lastTextInput: String?
    private var previousState: State = .displayingStocks
    private var state: State = .displayingStocks {
        didSet {
            switch oldValue {
            case .displayingStocks, .displayingFavorites:
                previousState = oldValue
            default: break
            }
            input?.stateChangedTo(state)
        }
    }
    
    private var filteredStocks = [Stock]()
    private var stocks = [Stock]()
    
    private let networkingService: NetworkingServiceProtocol
    private let coreDataDatabaseManager: CoreDataDatabaseManagerProtocol
    
    init(networkingService: NetworkingServiceProtocol, coreDataDatabaseManager: CoreDataDatabaseManagerProtocol) {
        self.networkingService = networkingService
        self.coreDataDatabaseManager = coreDataDatabaseManager
    }
}

extension StocksViewControllerPresenter: StocksViewControllerOutput {
    func viewIsReady() {
        displayStocks()
    }
    
    func viewDidAppear() {
        filterStocks(with: lastTextInput)
        input?.updateUI()
    }
    
    func getHeightForCell() -> Double {
        return Constants.heightForCell
    }
    
    func startedEditingTextField(with searchText: String) {
        lastTextInput = searchText
        if searchText.isEmpty {
            state = .searching
        } else {
            state = .typing
            filterStocks(with: searchText)
        }
        input?.replaceTextFieldButtonImage(with: Constants.backArrow)
    }
    
    func handleShowMoreButtonTap() {
        input?.updateSearchBarView(text: "")
        input?.textFieldResignFirstResponder()
        input?.replaceTextFieldButtonImage(with: Constants.magnifyingGlass)
        input?.switchButtonsDominance(isStocksPrior: true)
        displayStocks()
    }
    
    func handleButtonStackViewTap() {
        switch state {
        case .displayingStocks:
            displayFavorites()
            input?.switchButtonsDominance(isStocksPrior: false)
        case .displayingFavorites:
            displayStocks()
            input?.switchButtonsDominance(isStocksPrior: true)
        default: 
            break
        }
    }
    
    func handleTextFieldButtonTap() {
        lastTextInput = nil
        switch previousState {
        case .displayingStocks:
            displayStocks()
        case .displayingFavorites:
            displayFavorites()
        default: break
        }
        input?.updateSearchBarView(text: "")
        input?.replaceTextFieldButtonImage(with: Constants.magnifyingGlass)
        input?.textFieldResignFirstResponder()
    }
    
    func handleFavoriteButtonTap(with indexPath: IndexPath) {
        let selectedStock = filteredStocks[indexPath.row]
        let isFavorite = coreDataDatabaseManager.getIsFavorite(ticker: selectedStock.ticker)
        if isFavorite {
            coreDataDatabaseManager.deleteStock(stock: StockModel(name: selectedStock.name, logo: selectedStock.logoUrl, ticker: selectedStock.ticker))
        } else {
            coreDataDatabaseManager.addStock(stock: StockModel(name: selectedStock.name, logo: selectedStock.logoUrl, ticker: selectedStock.ticker))
        }
        filterStocks()
        input?.updateUI()
    }
    
    func handleRequestButtonTap(name: String) {
        state = .typing
        filterStocks(with: name)
        input?.updateSearchBarView(text: name)
    }
    
    func handleEnter(text: String) {
        coreDataDatabaseManager.addRequest(request: text)
        guard let recentRequests = coreDataDatabaseManager.fetchRecentRequests() else { return }
        input?.addRequestToStackView(request: text, upper: recentRequests.count % 2 == 0)
    }
    
    func handleCellSelection(at indexPath: IndexPath) {
        let selectedStock = filteredStocks[indexPath.row]
        let secondVCPresenter = DetailsPageViewControllerPresenter(
            networkingService: networkingService,
            coreDataDatabaseManager: coreDataDatabaseManager,
            stock: selectedStock
        )
        let secondVC = DetailsPageViewController(
            presenter: secondVCPresenter,
            stockCompanyName: selectedStock.name,
            stockCompanyTicker: selectedStock.ticker,
            favoriteButtonImage: buttonImageForStock(with: selectedStock.ticker),
            priceModel: StockPriceModel(c: selectedStock.currentPrice, d: selectedStock.changePrice)
        )
        secondVCPresenter.input = secondVC
        input?.displaySecondViewController(secondVC)
    }
    
    func displayStocks() {
        state = .displayingStocks
        guard stocks.isEmpty else {
            filterStocks()
            return
        }
        getStocks()
    }
    
    func displayFavorites() {
        state = .displayingFavorites
        filterStocks()
    }
    
    private func getStocks() {
        networkingService.fetchStocks { [weak self] stocks in
            guard let self else {
                return
            }
            DispatchQueue.main.async {
                self.stocks = stocks
                self.filterStocks()
            }
        }
    }
    
    func getStockInformation(with id: Int) -> Stock? {
        return filteredStocks[id]
    }
    
    func getStocksCount() -> Int {
        return filteredStocks.count
    }
    
    func getPopularRequestsArray() -> [String] {
        return ["Apple","Amazon","Google","Tesla","Microsoft","Facebook","Alibaba","Yandex","Mastercard","Booking","Firstsolar"]
    }
    
    func getRecentRequestsArray() -> [String] {
        guard let recentRequests = coreDataDatabaseManager.fetchRecentRequests() else { return [] }
        return recentRequests
    }
    
    func buttonImageForStock(with ticker: String) -> UIImage {
        return coreDataDatabaseManager.getIsFavorite(ticker: ticker) ? Constants.yellowStar : Constants.grayStar
    }
    
    private func filterStocks(with searchText: String? = nil) {
        switch state {
        case .displayingStocks:
            filteredStocks = stocks
        case .displayingFavorites:
            filteredStocks = stocks.filter({ stock in
                return coreDataDatabaseManager.getIsFavorite(ticker: stock.ticker)
            })
        case .typing:
            guard let searchText else { return }
            filteredStocks = stocks.filter({ stock in
                let stockNameMatch = stock.name.lowercased().contains(searchText.lowercased())
                let stockTickerMatch = stock.ticker.lowercased().contains(searchText.lowercased())
                
                return stockNameMatch || stockTickerMatch
            })
        default: break
        }
        input?.updateUI()
    }
}
