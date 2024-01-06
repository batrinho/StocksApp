//
//  NetworkingService.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

final class GCDNetworkingService {
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

extension GCDNetworkingService: NetworkingServiceProtocol {
    func fetchStocks(completion: @escaping ([Stock]) -> ()) {
        let stockModels = stockModelsFromLocalFile(name: Constants.fileName)
        let group = DispatchGroup()
        let mutex = NSLock()
        
        var imageDictionary = [String: UIImage]()
        var priceDictionary = [String: StockPriceModel]()
        
        for stockModel in stockModels {
            group.enter()
            self.fetchStockLogo(from: stockModel.logo) { logo in
                guard let logo else {
                    group.leave()
                    return
                }
                mutex.withLock {
                    imageDictionary[stockModel.ticker] = logo
                    group.leave()
                }
            }
            group.enter()
            self.fetchPrice(stockTicker: stockModel.ticker) { stockPriceModel in
                guard let stockPriceModel else {
                    group.leave()
                    return
                }
                mutex.withLock {
                    priceDictionary[stockModel.ticker] = stockPriceModel
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
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
