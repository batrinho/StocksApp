//
//  StocksViewControllerPresenter.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 09.11.2023.
//

import UIKit

final class StocksViewControllerPresenter: StocksViewControllerOutput {
    enum Constants {
        static let yellowStar = UIImage(named: "star.yellow.fill")
        static let grayStar = UIImage(named: "star.gray.fill")
        static let magnifyingGlass = UIImage(systemName: "magnifyingglass")
        static let backArrow = UIImage(named: "returnIcon")
    }
    
    enum State {
        case displayingStocks
        case displayingFavorites
        case searching
        case typing
    }
    
    weak var input: StocksViewControllerInput?
    private var onStocks: Bool = true
    private var state: State = .displayingStocks
    private var displayingStocks: [Stock] = []
    private var stocks: [Stock] = []
    private var backUpStocks: [Stock] = []
    private var favoriteStocks: [Stock] = []
    
    private let networkingService: NetworkingServiceProtocol
    private let coreDataDatabaseManager: CoreDataDatabaseManagerProtocol
    
    init(networkingService: NetworkingServiceProtocol, coreDataDatabaseManager: CoreDataDatabaseManagerProtocol) {
        self.networkingService = networkingService
        self.coreDataDatabaseManager = coreDataDatabaseManager
    }
    
    func handleTextFieldChanges(text: String) {
        switch text.isEmpty {
        case true:
            state = .searching
            stocks = backUpStocks
        case false:
            state = .typing
            filterStocks(searchText: text)
        }
        input?.stateChangedTo(state: state)
        input?.updateTextFieldButtonImage(with: Constants.backArrow!)
    }
    
    func filterStocks(searchText: String) {
        stocks = stocks.filter({ stock in
            let stockNameMatch = stock.name.lowercased().contains(searchText.lowercased())
            let stockTickerMatch = stock.ticker.lowercased().contains(searchText.lowercased())
            
            return stockNameMatch || stockTickerMatch
        })
        displayingStocks = stocks
        input?.reloadTableView()
    }
    
    func handleTextFieldButton() {
        if onStocks {
            openStocks()
        } else {
            openFavorites()
        }
        input?.stateChangedTo(state: state)
        input?.updateTextFieldButtonImage(with: Constants.magnifyingGlass!)
        input?.textFieldResignFirstResponder()
    }
    
    func handleFavoriteButtonTap(with indexPath: IndexPath) {
        let selectedStock = displayingStocks[indexPath.row]
        let isFavorite = coreDataDatabaseManager.getIsFavorite(ticker: selectedStock.ticker)
        if let selectedIndex = stocks.firstIndex(where: { $0.ticker == selectedStock.ticker }) {
            stocks[selectedIndex].favoriteButtonImage = (isFavorite ? Constants.grayStar : Constants.yellowStar)!
            input?.updateFavoriteButton(with: indexPath, buttonImage: stocks[selectedIndex].favoriteButtonImage)
        }
        
        if isFavorite {
            coreDataDatabaseManager.deleteStock(stock: StockModel(name: selectedStock.name, logo: selectedStock.logoUrl, ticker: selectedStock.ticker))
        } else {
            coreDataDatabaseManager.addStock(stock: StockModel(name: selectedStock.name, logo: selectedStock.logoUrl, ticker: selectedStock.ticker))
        }
        
        if state == .displayingStocks {
            openStocks()
        } else {
            openFavorites()
        }
    }
    
    func handleRequestButtonTap(name: String) {
        state = .typing
        filterStocks(searchText: name)
        input?.stateChangedTo(state: state)
        input?.updateSearchBarView(text: name)
    }
    
    func openStocks() {
        onStocks = true
        state = .displayingStocks
        guard stocks.isEmpty else {
            DispatchQueue.main.async {
                self.displayingStocks = self.stocks
                self.input?.reloadTableView()
            }
            return
        }
        let stockModels = networkingService.stockDataFromLocalFile(with: "stockProfiles (1)")
        let group = DispatchGroup()
        for stockModel in stockModels {
            group.enter()
            Task {
                do {
                    guard let stockLogo = try await networkingService.fetchStockLogo(from: stockModel.logo) else {
                        print("Error fetching logo for \(stockModel.ticker)")
                        return
                    }
                    guard let stockPriceModel = try await networkingService.fetchPrice(stockTicker: stockModel.ticker) else {
                        print("Error fetching price for \(stockModel.ticker)")
                        return
                    }
                    DispatchQueue.main.async {
                        let isFavorite = self.coreDataDatabaseManager.getIsFavorite(ticker: stockModel.ticker)
                        let stock = Stock(
                            name: stockModel.name,
                            ticker: stockModel.ticker, 
                            logoUrl: stockModel.logo,
                            logo: stockLogo,
                            favoriteButtonImage: ((isFavorite ? Constants.yellowStar : Constants.grayStar)!),
                            currentPrice: stockPriceModel.c,
                            changePrice: stockPriceModel.d
                        )
                        self.stocks.append(stock)
                        self.displayingStocks = self.stocks
                        self.backUpStocks = self.stocks
                    }
                } catch {
                    print("Error in openStocks: \(error)")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.input?.reloadTableView()            
        }
    }
    
    func openFavorites() {
        onStocks = false
        state = .displayingFavorites
        guard let favoriteStockModels = coreDataDatabaseManager.fetchFavoriteStocks() else { return }
        favoriteStocks.removeAll()
        for favoriteStockModel in favoriteStockModels {
            if let foundStock = stocks.first(where: { $0.ticker == favoriteStockModel.ticker }) {
                favoriteStocks.append(foundStock)
            }
        }
        DispatchQueue.main.async {
            self.displayingStocks = self.favoriteStocks
            self.input?.reloadTableView()
        }
    }
    
    func getStockInformation(with id: Int) -> Stock? {
        return displayingStocks[id]
    }
    
    func getStocksCount() -> Int {
        return displayingStocks.count
    }
    
    func getPopularRequestsArray() -> [String] {
        return ["Apple","Amazon","Google","Tesla","Microsoft","Facebook","Alibaba","Yandex","Mastercard","Booking","Firstsolar"]
    }
    
    func getRecentRequestsArray() -> [String] {
        guard let recentRequests = coreDataDatabaseManager.fetchRecentRequests() else { return [] }
        return recentRequests
    }
}
