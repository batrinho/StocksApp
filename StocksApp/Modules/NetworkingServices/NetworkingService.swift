//
//  NetworkingService.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

protocol NetworkingServiceProtocol {
    func fetchStocksAsync(completion: @escaping ([Stock]) -> ())
    func fetchStocksGCD(completion: @escaping ([Stock]) -> ())
    func fetchGraphData(stockTicker: String, state: DetailsPageViewControllerPresenter.State) async throws -> StockGraphData?
}

final class NetworkingService {
    enum Constants {
        static let alphaBaseUrlString = "https://www.alphavantage.co/query?function=TIME_SERIES_"
        static let alphaApiKey = "5422CWLSP5CA6FQ1"
        static let finnhubBaseUrlString = "https://finnhub.io/api/v1/quote"
        static let finnhubApiKey = "cj4ed09r01qlttl4q5bgcj4ed09r01qlttl4q5c0"
        static let fileName = "stockModels"
    }
    
    private var imageDictionary = [String: UIImage]()
    private var priceDictionary = [String: StockPriceModel]()
    
    private func stockModelsFromLocalFile(name: String) -> [StockModel] {
        guard let filePath = Bundle.main.path(forResource: name, ofType: "json") else { return [] }
        let fileUrl = URL(fileURLWithPath: filePath)
        let data = try! Data(contentsOf: fileUrl)
        let decoder = JSONDecoder()
        return try! decoder.decode([StockModel].self, from: data)
    }
}

extension NetworkingService: NetworkingServiceProtocol {
    
    // MARK: - Fetch Stocks async/await
    func fetchStocksAsync(completion: @escaping ([Stock]) -> ()) {
        let stockModels = stockModelsFromLocalFile(name: Constants.fileName)
        let group = DispatchGroup()
        
        for stockModel in stockModels {
            group.enter()
            fetchStockLogo(from: stockModel.logo) { [weak self] logo in
                guard let logo,
                      let self
                else {
                    group.leave()
                    return
                }
                self.imageDictionary[stockModel.ticker] = logo
                group.leave()
            }
            group.enter()
            fetchPrice(stockTicker: stockModel.ticker) { [weak self] stockPriceModel in
                guard let stockPriceModel,
                      let self
                else {
                    group.leave()
                    return
                }
                self.priceDictionary[stockModel.ticker] = stockPriceModel
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else {
                return
            }
            var resultingArray = [Stock]()
            for stockModel in stockModels {
                guard let stockLogo = self.imageDictionary[stockModel.ticker],
                      let stockPriceModel = self.priceDictionary[stockModel.ticker] else {
                    continue
                }
                resultingArray.append(
                    Stock(
                        name: stockModel.name,
                        ticker: stockModel.ticker,
                        logoUrl: stockModel.logo,
                        logo: stockLogo,
                        currentPrice: stockPriceModel.c,
                        changePrice: stockPriceModel.d
                    )
                )
            }
            completion(resultingArray)
        }
    }
    
    // MARK: - Fetch Stocks GCD
    func fetchStocksGCD(completion: @escaping ([Stock]) -> ()) {
        let stockModels = stockModelsFromLocalFile(name: Constants.fileName)
        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async { [weak self] in
            guard let self else {
                return
            }
            var resultingArray = [Stock]()
            let group = DispatchGroup()
            for stockModel in stockModels {
                group.enter()
                self.fetchStockLogo(from: stockModel.logo) { logo in
                    guard let logo else {
                        group.leave()
                        return
                    }
                    self.imageDictionary[stockModel.ticker] = logo
                    group.leave()
                }
                group.enter()
                self.fetchPrice(stockTicker: stockModel.ticker) { stockPriceModel in
                    guard let stockPriceModel else {
                        group.leave()
                        return
                    }
                    self.priceDictionary[stockModel.ticker] = stockPriceModel
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                for stockModel in stockModels {
                    guard let stockLogo = self.imageDictionary[stockModel.ticker],
                          let stockPriceModel = self.priceDictionary[stockModel.ticker] else {
                        continue
                    }
                    resultingArray.append(
                        Stock(
                            name: stockModel.name,
                            ticker: stockModel.ticker,
                            logoUrl: stockModel.logo,
                            logo: stockLogo,
                            currentPrice: stockPriceModel.c,
                            changePrice: stockPriceModel.d
                        )
                    )
                }
                completion(resultingArray)
            }
        }
    }
    
    private func fetchStockLogo(from urlString: String, completion: @escaping (UIImage?) -> ()) {
        guard let imageUrl = URL(string: urlString) else {
            completion(nil)
            return
        }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: imageUrl)
                completion(UIImage(data: data))
            } catch {
                completion(nil)
                return
            }
        }
    }

    private func fetchPrice(stockTicker: String, completion: @escaping (StockPriceModel?) -> ()) {
        let queryParameters = [
            "symbol": stockTicker,
            "token": Constants.finnhubApiKey
        ]
        var urlComponents = URLComponents(string: Constants.finnhubBaseUrlString)
        urlComponents?.queryItems = queryParameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        guard let theUrl = urlComponents?.url else {
            completion(nil)
            return
        }
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: theUrl)
                let decoder = JSONDecoder()
                let result = try decoder.decode(StockPriceModel.self, from: data)
                completion(result)
            } catch {
                completion(nil)
                return
            }
        }
    }
        
    func fetchGraphData(
        stockTicker: String,
        state: DetailsPageViewControllerPresenter.State
    ) async throws -> StockGraphData? {
        do {
            var urlString = Constants.alphaBaseUrlString
            switch state {
            case .day:
                urlString += "INTRADAY&interval=30min"
            case .week, .month:
                urlString += "DAILY"
            case .sixMonths, .year:
                urlString += "WEEKLY"
            case .all:
                urlString += "MONTHLY"
            }
            urlString += "&symbol=\(stockTicker)&apikey=\(Constants.alphaApiKey)"
            guard let url = URL(string: urlString) else { return nil }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let stockData = try decoder.decode(StockGraphData.self, from: data)
            return stockData
        } catch {
            throw error
        }
    }
}
