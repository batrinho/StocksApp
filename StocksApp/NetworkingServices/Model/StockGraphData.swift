//
//  StockGraphData.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 05.12.2023.
//

import UIKit
import DGCharts

struct StockGraphDatum: Codable {
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String

    private enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}

struct StockGraphData: Codable {
    let intraDaySeriesData: [String: StockGraphDatum]?
    let dailySeriesData: [String: StockGraphDatum]?
    let weeklySeriesData: [String: StockGraphDatum]?
    let monthlySeriesData: [String: StockGraphDatum]?
    private enum CodingKeys: String, CodingKey {
        case intraDaySeriesData = "Time Series (30min)"
        case dailySeriesData = "Time Series (Daily)"
        case weeklySeriesData = "Weekly Time Series"
        case monthlySeriesData = "Monthly Time Series"
    }
}
