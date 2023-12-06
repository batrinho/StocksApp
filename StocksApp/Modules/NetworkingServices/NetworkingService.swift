//
//  NetworkingService.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

protocol NetworkingServiceProtocol {
    func fetchStockInformation(with stockModel: StockModel) async throws -> Stock?
    func stockDataFromLocalFile(with name: String) -> [StockModel]
    func fetchGraphData(with stockTicker: String, time: String) async throws -> StockGraphData?
}

final class NetworkingService: NetworkingServiceProtocol {
    private let yellowStar = UIImage(named: "star.yellow.fill")
    private let grayStar = UIImage(named: "star.gray.fill")
    enum Constants {
        static let baseUrlString = "https://finnhub.io/api/v1/quote"
        static let finnhubApiKey = "cj4ed09r01qlttl4q5bgcj4ed09r01qlttl4q5c0"
        static let alphaApiKey = "5422CWLSP5CA6FQ1"
    }
    
    func stockDataFromLocalFile(with name: String) -> [StockModel] {
        do {
            guard let filePath = Bundle.main.path(forResource: name, ofType: "json") else { return [] }

            let fileUrl = URL(fileURLWithPath: filePath)
            let data = try Data(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            return try decoder.decode([StockModel].self, from: data)
        } catch {
            print("Error getting data from local json file: \(error)")
            return []
        }
    }
    
    func fetchStockInformation(with stockModel: StockModel) async throws -> Stock? {
        guard let stockLogo = try await fetchStockLogo(from: stockModel.logo) else {
            print("Error fetching logo for \(stockModel.ticker)")
            return nil
        }
        guard let stockPriceModel = try await fetchPrice(stockTicker: stockModel.ticker) else {
            print("Error fetching price for \(stockModel.ticker)")
            return nil
        }
        return Stock(
            name: stockModel.name,
            ticker: stockModel.ticker,
            logoUrl: stockModel.logo,
            logo: stockLogo,
            currentPrice: stockPriceModel.c,
            changePrice: stockPriceModel.d
        )
    }
    
    func fetchGraphData(with stockTicker: String, time: String) async throws -> StockGraphData? {
        do {
            var urlString = String()
            switch time {
            case "D": urlString =             "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=\(stockTicker)&interval=30min&apikey=\(Constants.alphaApiKey)"
            case "W": urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(stockTicker)&apikey=\(Constants.alphaApiKey)"
            case "M": urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(stockTicker)&apikey=\(Constants.alphaApiKey)"
            case "6M": urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_WEEKLY&symbol=\(stockTicker)&apikey=\(Constants.alphaApiKey)"
            case "1Y": urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_WEEKLY&symbol=\(stockTicker)&apikey=\(Constants.alphaApiKey)"
            case "All": urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY&symbol=\(stockTicker)&apikey=\(Constants.alphaApiKey)"
            default: break
            }
            guard let url = URL(string: urlString) else { return nil }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let stockData = try decoder.decode(StockGraphData.self, from: data)
            return stockData
        } catch {
            throw error
        }
    }


    private func fetchStockLogo(from urlString: String) async throws -> UIImage? {
        guard let imageUrl = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            return UIImage(data: data)
        } catch {
            throw error
        }
    }

    private func fetchPrice(stockTicker: String) async throws -> StockPriceModel? {
        do {
            let queryParameters = [
                "symbol": stockTicker,
                "token": Constants.finnhubApiKey
            ]
            var urlComponents = URLComponents(string: Constants.baseUrlString)
            urlComponents?.queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            guard let theUrl = urlComponents?.url else { return nil }
            let (data, _) = try await URLSession.shared.data(from: theUrl)
            let decoder = JSONDecoder()
            return try decoder.decode(StockPriceModel.self, from: data)
        } catch {
            throw error
        }
    }
}
