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
    }
    
    enum State {
        case d
        case w
        case m
        case hy
        case y
        case all
    }
    
    weak var input: DetailsPageViewControllerInput?
    
    private var state: State = .all {
        didSet {
            print("details page state changed from \(oldValue) to \(state)")
            input?.stateChangedTo(state)
        }
    }
    private let networkingService: NetworkingServiceProtocol
    private let coreDataDatabaseManager: CoreDataDatabaseManagerProtocol
    private let stock: Stock
    private let names: [String] = ["D", "W", "M", "6M", "1Y", "All"]
    
    init(networkingService: NetworkingServiceProtocol, coreDataDatabaseManager: CoreDataDatabaseManagerProtocol, stock: Stock) {
        self.networkingService = networkingService
        self.coreDataDatabaseManager = coreDataDatabaseManager
        self.stock = stock
    }
}

extension DetailsPageViewControllerPresenter: DetailsPageViewControllerOutput {
    func viewIsReady() {
        state = .d
        updateGraphData(with: "D")
    }
    
    private func fillEntriesArray(with data: [String: StockGraphDatum]) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        for (index, entry) in data.enumerated() {
            let closeValue = Double(entry.value.close)!
            var breakpoint: Int = -1
            entries.append(ChartDataEntry(x: Double(index), y: closeValue))
            switch state {
            case .d:
                breakpoint = 47
            case .w:
                breakpoint = 7
            case .m:
                breakpoint = 30
            case .hy:
                breakpoint = 24
            case .y:
                breakpoint = 48
            default: print("OK")
            }
            if index == breakpoint {
                break
            }
        }
        return entries
    }
    
    func updateGraphData(with time: String) {
        Task {
            do {
                guard let stockGraphData = try await networkingService.fetchGraphData(with: stock.ticker, time: time) else {
                    return
                }
                DispatchQueue.main.async {
                    var entries = [ChartDataEntry]()
                    var data: [String: StockGraphDatum]?
                    switch time {
                    case "D":
                        data = stockGraphData.intraDaySeriesData
                    case "W", "M":
                        data = stockGraphData.dailySeriesData
                    case "6M":
                        data = stockGraphData.weeklySeriesData
                    case "1Y":
                        data = stockGraphData.weeklySeriesData
                    default:
                        data = stockGraphData.monthlySeriesData
                    }
                    guard let data else { return }
                    entries = self.fillEntriesArray(with: data)
                    entries.reverse()
                    let line1 = LineChartDataSet(entries: entries)
                    line1.colors = [NSUIColor.black]
                    line1.drawCirclesEnabled = false
                    line1.mode = .cubicBezier
                    line1.drawValuesEnabled = false
                    let chartData = LineChartData()
                    chartData.dataSets.append(line1)
                    self.input?.updateGraph(with: chartData)
                }
            } catch {
                print("Error in fetching graph data: \(error)")
            }
        }
    }
    
    func getButtonNames() -> [String] {
        return names
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
        updateGraphData(with: name)
        switch name {
        case "D":
            state = .d
        case "W":
            state = .w
        case "M":
            state = .m
        case "6M":
            state = .hy
        case "1Y":
            state = .y
        default:
            state = .all
        }
    }
}
