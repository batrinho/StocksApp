//
//  DetailsPageViewControllerPresenter.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 30.11.2023.
//

import UIKit
import DGCharts

final class DetailsPageViewControllerPresenter {
    private enum Constants {
        static let yellowStar = UIImage(named: "star.yellow.fill")!
        static let grayStar = UIImage(named: "star.gray.fill")!
        static let buttonNames: [String] = ["D", "W", "M", "6M", "1Y", "All"]
    }
    
    enum State: String {
        case day = "D"
        case week = "W"
        case month = "M"
        case sixMonths = "6M"
        case year = "1Y"
        case all = "All"
    }
    
    weak var input: DetailsPageViewControllerInput?
    
    private var state: State = .all {
        didSet {
            print("details page state changed from \(oldValue) to \(state)")
            updateGraphData()
            input?.stateChangedTo(state)
        }
    }
    private let networkingService: NetworkingServiceProtocol
    private let coreDataDatabaseManager: CoreDataDatabaseManagerProtocol
    private let stock: Stock
    
    init(networkingService: NetworkingServiceProtocol, coreDataDatabaseManager: CoreDataDatabaseManagerProtocol, stock: Stock) {
        self.networkingService = networkingService
        self.coreDataDatabaseManager = coreDataDatabaseManager
        self.stock = stock
    }
}

extension DetailsPageViewControllerPresenter: DetailsPageViewControllerOutput {
    func viewIsReady() {
        state = .day
    }
    
    private func fillEntriesArray(with data: [String: StockGraphDatum]) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        for (index, entry) in data.enumerated() {
            let closeValue = Double(entry.value.close)!
            var breakpoint: Int = -1
            entries.append(ChartDataEntry(x: Double(index), y: closeValue))
            switch state {
            case .day:
                breakpoint = 47
            case .week:
                breakpoint = 7
            case .month:
                breakpoint = 30
            case .sixMonths:
                breakpoint = 24
            case .year:
                breakpoint = 48
            default:
                break
            }
            if index == breakpoint {
                break
            }
        }
        return entries
    }
    
    func updateGraphData() {
        Task {
            do {
                guard let stockGraphData = try await networkingService.fetchGraphData(stockTicker: stock.ticker, state: state) else {
                    return
                }
                DispatchQueue.main.async {
                    var entries = [ChartDataEntry]()
                    var data: [String: StockGraphDatum]?
                    switch self.state {
                    case .day:
                        data = stockGraphData.intraDaySeriesData
                    case .week, .month:
                        data = stockGraphData.dailySeriesData
                    case .sixMonths, .year:
                        data = stockGraphData.weeklySeriesData
                    default:
                        data = stockGraphData.intraDaySeriesData
                    }
                    guard let data else { return }
                    entries = self.fillEntriesArray(with: data)
                    let chartData = LineChartData()
                    chartData.dataSets.append(self.makeLineDataSet(entries: entries))
                    chartData.setDrawValues(false)
                    self.input?.updateGraph(with: chartData)
                }
            } catch {
                print("Error in fetching graph data: \(error)")
            }
        }
    }
    
    private func makeLineDataSet(entries: [ChartDataEntry]) -> LineChartDataSet {
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.colors = [NSUIColor.black]
        dataSet.lineWidth = 3
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.setDrawHighlightIndicators(true)
        return dataSet
    }
    
    func getButtonNames() -> [String] {
        return Constants.buttonNames
    }
    
    func backButtonPressed() {
        input?.popViewController()
    }
    
    func favoriteButtonPressed() {
        let isFavorite = coreDataDatabaseManager.getIsFavorite(ticker: stock.ticker)
        if isFavorite {
            coreDataDatabaseManager.deleteStock(stock: StockModel(name: stock.name, logo: stock.logoUrl, ticker: stock.ticker))
        } else {
            coreDataDatabaseManager.addStock(stock: StockModel(name: stock.name, logo: stock.logoUrl, ticker: stock.ticker))
        }
        input?.updateFavoriteButtonImage(with: !isFavorite ? Constants.yellowStar : Constants.grayStar)
    }
    
    func handleChartButtonTap(name: String) {
        switch name {
        case "D":
            state = .day
        case "W":
            state = .week
        case "M":
            state = .month
        case "6M":
            state = .sixMonths
        case "1Y":
            state = .year
        default:
            state = .all
        }
    }
    
    func handleBuyButtonTap(price: String) {
        input?.presentPurchaseAlertViewController(price: price)
    }
}
