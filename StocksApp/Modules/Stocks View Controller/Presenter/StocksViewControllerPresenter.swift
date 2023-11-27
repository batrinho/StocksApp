//
//  StocksViewControllerPresenter.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 09.11.2023.
//

import UIKit

final class StocksViewControllerPresenter {
    private let yellowStar = UIImage(named: "star.yellow.fill")!
    private let grayStar = UIImage(named: "star.gray.fill")!
    private let magnifyingGlass = UIImage(systemName: "magnifyingglass")!
    private let backArrow = UIImage(named: "returnIcon")!
    private let fileName = "stockModels"
    
    enum State {
        case displayingStocks
        case displayingFavorites
        case searching
        case typing
    }
    
    weak var input: StocksViewControllerInput?
    
    private var previousState: State = .displayingStocks
    private var state: State = .displayingStocks {
        didSet {
            switch oldValue {
            case .displayingStocks, .displayingFavorites:
                previousState = oldValue
            default:
                print("")
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
    
    func getHeightForCell() -> Double {
        return 90.0
    }
    
    func startedEditingTextField(with searchText: String) {
        if searchText.isEmpty {
            state = .searching
        } else {
            state = .typing
            filterStocks(with: searchText)
        }
        input?.replaceTextFieldButtonImage(with: backArrow)
    }
    
    func handleShowMoreButtonTap() {
        input?.updateSearchBarView(text: "")
        input?.textFieldResignFirstResponder()
        input?.replaceTextFieldButtonImage(with: magnifyingGlass)
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
            print("Button Stack View can only be called when displaying stocks or favorite stocks")
        }
    }
    
    func handleTextFieldButtonTap() {
        switch previousState {
        case .displayingStocks:
            displayStocks()
        case .displayingFavorites:
            displayFavorites()
        default:
            print("previousState can only be .displayingStocks or .displayingFavorites")
        }
        input?.updateSearchBarView(text: "")
        input?.replaceTextFieldButtonImage(with: magnifyingGlass)
        input?.textFieldResignFirstResponder()
    }
    
    func handleFavoriteButtonTap(with indexPath: IndexPath) {
        let selectedStock = filteredStocks[indexPath.row]
        let isFavorite = coreDataDatabaseManager.getIsFavorite(ticker: selectedStock.ticker)
        
        if let selectedIndex = stocks.firstIndex(where: { $0.ticker == selectedStock.ticker }) {
            stocks[selectedIndex].favoriteButtonImage = (isFavorite ? grayStar : yellowStar)
            input?.updateFavoriteButton(with: indexPath, buttonImage: (isFavorite ? grayStar : yellowStar))
        }
        
        if isFavorite {
            coreDataDatabaseManager.deleteStock(stock: StockModel(name: selectedStock.name, logo: selectedStock.logoUrl, ticker: selectedStock.ticker))
        } else {
            coreDataDatabaseManager.addStock(stock: StockModel(name: selectedStock.name, logo: selectedStock.logoUrl, ticker: selectedStock.ticker))
        }
        
        if state == .displayingFavorites {
            filterStocks(with: "")
        }
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
    
    func displayStocks() {
        state = .displayingStocks
        guard stocks.isEmpty else {
            filterStocks(with: "")
            return
        }
        let stockModels = networkingService.stockDataFromLocalFile(with: fileName)
        let group = DispatchGroup()
        for stockModel in stockModels {
            group.enter()
            Task {
                do {
                    guard let stock = try await networkingService.fetchStockInformation(
                        with: stockModel,
                        isFavorite: coreDataDatabaseManager.getIsFavorite(ticker: stockModel.ticker)
                    ) else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.stocks.append(stock)
                        self.filteredStocks = self.stocks
                    }
                } catch {
                    print("Error in openStocks: \(error)")
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.input?.updateUI()
        }
    }
    
    func displayFavorites() {
        state = .displayingFavorites
        filterStocks(with: "")
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
    
    private func filterStocks(with searchText: String) {
        switch state {
        case .displayingStocks:
            filteredStocks = stocks
        case .displayingFavorites:
            filteredStocks = stocks.filter({ stock in
                return coreDataDatabaseManager.getIsFavorite(ticker: stock.ticker)
            })
        case .typing:
            filteredStocks = stocks.filter({ stock in
                let stockNameMatch = stock.name.lowercased().contains(searchText.lowercased())
                let stockTickerMatch = stock.ticker.lowercased().contains(searchText.lowercased())
                
                return stockNameMatch || stockTickerMatch
            })
        default:
            print("Irrelevant state to call filterStocks()")
        }
        input?.updateUI()
    }
}
