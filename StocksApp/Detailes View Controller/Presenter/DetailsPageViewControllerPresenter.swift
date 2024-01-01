//
//  DetailsPageViewControllerPresenter.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 30.11.2023.
//

import UIKit
import DGCharts

final class DetailsPageViewControllerPresenter {
    enum State: String {
        case day = "D"
        case week = "W"
        case month = "M"
        case sixMonths = "6M"
        case year = "1Y"
        case all = "All"
    }
    
    private enum Constants {
        static let yellowStar = UIImage(named: "star.yellow.fill")!
        static let grayStar = UIImage(named: "star.gray.fill")!
        static let buttons: [State] = [.day, .week, .month, .sixMonths, .year, .all]
    }
    
    weak var input: DetailsPageViewControllerInput?
    
    private var data: [String: StockGraphDatum]?
    private var breakpoint: Int?
    private var state: State = .all {
        didSet {
            updateGraphData()
            input?.stateChangedTo(state)
            switch state {
            case .day:
                self.breakpoint = 47
            case .week:
                self.breakpoint = 7
            case .month:
                self.breakpoint = 30
            case .sixMonths:
                self.breakpoint = 24
            default:
                self.breakpoint = 48
            }
        }
    }
    private let networkingService: NetworkingServiceProtocol
    private let coreDataDatabaseManager: CoreDataDatabaseManagerProtocol
    private let stock: Stock
    
    init(
        networkingService: NetworkingServiceProtocol,
        coreDataDatabaseManager: CoreDataDatabaseManagerProtocol,
        stock: Stock
    ) {
        self.networkingService = networkingService
        self.coreDataDatabaseManager = coreDataDatabaseManager
        self.stock = stock
    }
}

extension DetailsPageViewControllerPresenter: DetailsPageViewControllerOutput {
    func viewIsReady() {
        state = .all
    }
    
    func updateGraphData() {
        networkingService.fetchGraphData(stockTicker: stock.ticker, state: state) { [weak self] data in
            guard let data, let self else {
                return
            }
            DispatchQueue.main.async { 
                self.data = self.dataForState(self.state, data: data)
                guard let selfData = self.data else { return }
                let chartData = LineChartData()
                chartData.dataSets.append(
                    self.makeLineDataSet(entries: self.fillEntriesArray(with: selfData) as [ChartDataEntry])
                )
                chartData.setDrawValues(false)
                self.input?.updateGraph(with: chartData)
            }
        }
    }
    
    private func dataForState(_ state: State, data: StockGraphData) -> [String: StockGraphDatum]? {
        switch state {
        case .day:
            return data.intraDaySeriesData
        case .week, .month:
            return data.dailySeriesData
        case .sixMonths, .year:
            return data.weeklySeriesData
        default:
            return data.monthlySeriesData
        }
    }

    private func fillEntriesArray(with data: [String: StockGraphDatum]) -> [ChartDataEntry] {
        var entries = [ChartDataEntry]()
        let sortedKeys = data.keys.sorted { $0 < $1 }
        for (index, key) in sortedKeys.enumerated() {
            guard let stockGraphDatum = data[key] else { return [] }
            let chartDataEntry = ChartDataEntry(x: Double(index), y: Double(stockGraphDatum.close)!)
            entries.append(chartDataEntry)
        }
        return entries.suffix(breakpoint!)
    }

    private func makeLineDataSet(entries: [ChartDataEntry]) -> LineChartDataSet {
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.colors = [NSUIColor.black]
        dataSet.lineWidth = 1.75
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.setDrawHighlightIndicators(false)
        let gradientColors = [UIColor.darkGray.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        dataSet.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
        dataSet.drawFilledEnabled = true
        return dataSet
    }
    
    func getButtons() -> [State] {
        return Constants.buttons
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
    
    func handleChartButtonTap(state: DetailsPageViewControllerPresenter.State) {
        self.state = state
    }
    
    func handleBuyButtonTap(price: String) {
        input?.presentPurchaseAlertViewController(price: price)
    }
    
    func chartValueSelected(at position: CGPoint, entry: ChartDataEntry) {        
        input?.moveBubbleViewTo(
            x: position.x,
            y: position.y,
            price: String("$\(entry.y)"),
            date: formattedDateForPriceMarker(atIndex: Int(entry.x))!
        )
    }
    
    func formattedDateForPriceMarker(atIndex index: Int) -> String? {
        guard let data = data else { return nil }
        let sortedKeys = data.keys.sorted {$0 < $1}
        let dateString: String = sortedKeys.suffix(breakpoint!)[index]
        switch state {
        case .day:
            return String(dateString.suffix(8))
        default:
            return formatDate(inputDateString: dateString, state: state)
        }
    }
    
    private func formatDate(inputDateString: String, state: State) -> String? {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatterInput.date(from: inputDateString) else {
            return nil
        }
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.dateFormat = "d MMMM yyyy"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM"
        let month = monthFormatter.string(from: date)
        let formattedDate = dateFormatterOutput.string(from: date)
        return formattedDate.replacingOccurrences(of: month, with: month.prefix(3).lowercased())
    }
}
