//
//  OperationNetworkingService.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.01.2024.
//

import UIKit

final class OperationNetworkingService {
    private enum Constants {
        static let alphaBaseUrlString = "https://www.alphavantage.co/query?function=TIME_SERIES_"
        static let alphaApiKey = "5422CWLSP5CA6FQ1"
        static let finnhubBaseUrlString = "https://finnhub.io/api/v1/quote"
        static let finnhubApiKey = "cj4ed09r01qlttl4q5bgcj4ed09r01qlttl4q5c0"
        static let fileName = "stockModels"
    }
    
    private func stockModelsFromLocalFile(name: String) -> [StockModel] {
        guard let filePath = Bundle.main.path(forResource: name, ofType: "json") else { return [] }
        let fileUrl = URL(fileURLWithPath: filePath)
        let data = try! Data(contentsOf: fileUrl)
        let decoder = JSONDecoder()
        return try! decoder.decode([StockModel].self, from: data)
    }
}

extension OperationNetworkingService: NetworkingServiceProtocol {
    func fetchStocks(completion: @escaping ([Stock]) -> ()) {
        let stockModels = stockModelsFromLocalFile(name: Constants.fileName)
        let imageQueue = OperationQueue()
        let priceQueue = OperationQueue()
        let mutex = NSLock()
        let group = DispatchGroup()
        
        var imageDictionary = [String: UIImage]()
        var priceDictionary = [String: StockPriceModel]()

        for stockModel in stockModels {
            group.enter()
            let imageOperation = BlockOperation { [weak self] in
                guard let self else {
                    group.leave()
                    return
                }
                self.fetchStockLogo(from: stockModel.logo) { image in
                    guard let image else {
                        group.leave()
                        return
                    }
                    mutex.withLock {
                        imageDictionary[stockModel.ticker] = image
                    }
                    group.leave()
                }
            }
            imageQueue.addOperation(imageOperation)
            group.enter()
            let priceOperation = BlockOperation { [weak self] in
                guard let self else {
                    group.leave()
                    return
                }
                self.fetchPrice(stockTicker: stockModel.ticker) { price in
                    guard let price else {
                        group.leave()
                        return
                    }
                    mutex.withLock {
                        priceDictionary[stockModel.ticker] = price
                    }
                    group.leave()
                }
            }
            priceQueue.addOperation(priceOperation)
        }

        group.notify(queue: DispatchQueue.global()) {
            DispatchQueue.main.async {
                var resultingArray = [Stock]()
                for stockModel in stockModels {
                    guard let stockLogo = imageDictionary[stockModel.ticker],
                          let stockPriceModel = priceDictionary[stockModel.ticker] else {
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
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }.resume()
    }
    
    private func fetchPrice(stockTicker: String, completion: @escaping (StockPriceModel?) ->()) {
        let queryParameters = [
            "symbol": stockTicker,
            "token": Constants.finnhubApiKey
        ]
        var urlComponents = URLComponents(string: Constants.finnhubBaseUrlString)
        urlComponents?.queryItems = queryParameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        guard let url = urlComponents?.url else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else {
                completion(nil)
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(StockPriceModel.self, from: data)
                completion(result)
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    func fetchGraphData(
        stockTicker: String,
        state: DetailsPageViewControllerPresenter.State,
        completion: @escaping (StockGraphData?) -> ()
    ) {
        guard let url = URL(string: getUrlStringFor(stockTicker: stockTicker, state: state)) else {
            completion(nil)
            return
        }
        let queue = OperationQueue()
        let operation = BlockOperation {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data else {
                    completion(nil)
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(StockGraphData.self, from: data)
                    completion(result)
                } catch {
                    completion(nil)
                }
            }.resume()
        }
        queue.addOperation(operation)
    }
    
    private func getUrlStringFor(stockTicker: String, state: DetailsPageViewControllerPresenter.State) -> String {
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
        return urlString
    }
}
