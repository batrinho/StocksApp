//
//  AsyncNetworkingService.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 31.12.2023.
//

import UIKit

final class AsyncNetworkingService {
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

extension AsyncNetworkingService: NetworkingServiceProtocol {
    func fetchStocks(completion: @escaping ([Stock]) -> ()) {
        Task {
            let stockModels = stockModelsFromLocalFile(name: Constants.fileName)
            async let imageDictionary = withTaskGroup(
                of: (String, UIImage?).self,
                returning: [String: UIImage].self
            ) { [weak self] group in
                guard let self else {
                    return [:]
                }
                var dictionary = [String: UIImage]()
                for stockModel in stockModels {
                    group.addTask {
                        return (stockModel.ticker, await self.fetchStockLogo(from: stockModel.logo))
                    }
                }
                for await (stockTicker, stockLogo) in group {
                    dictionary[stockTicker] = stockLogo
                }
                return dictionary
            }
            async let priceDictionary = withTaskGroup(
                of: (String, StockPriceModel?).self,
                returning: [String: StockPriceModel].self
            ) { [weak self] group in
                guard let self else {
                    return [:]
                }
                var dictionary = [String: StockPriceModel]()
                for stockModel in stockModels {
                    group.addTask {
                        return (stockModel.ticker, await self.fetchPrice(stockTicker: stockModel.ticker))
                    }
                }
                for await (stockTicker, stockPriceModel) in group {
                    dictionary[stockTicker] = stockPriceModel
                }
                return dictionary
            }
            var resultingArray = [Stock]()
            let (stockLogoDictionary, stockPriceModelDictionary) = await (imageDictionary, priceDictionary)
            for stockModel in stockModels {
                guard let stockLogo = stockLogoDictionary[stockModel.ticker],
                      let stockPriceModel = stockPriceModelDictionary[stockModel.ticker] else {
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
    
    private func fetchStockLogo(from urlString: String) async -> UIImage? {
        do {
            guard let url = URL(string: urlString) else {
                return nil
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
    private func fetchPrice(stockTicker: String) async -> StockPriceModel? {
        do {
            let queryParameters = [
                "symbol": stockTicker,
                "token": Constants.finnhubApiKey
            ]
            var urlComponents = URLComponents(string: Constants.finnhubBaseUrlString)
            urlComponents?.queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            guard let url = urlComponents?.url else {
                return nil
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let result = try decoder.decode(StockPriceModel.self, from: data)
            return result
        } catch {
            return nil
        }
    }
    
    func fetchGraphData(
        stockTicker: String,
        state: DetailsPageViewControllerPresenter.State,
        completion: @escaping (StockGraphData?) -> ()
    ) {
        Task {
            guard let url = URL(string: getUrlStringFor(stockTicker: stockTicker, state: state)) else {
                completion(nil)
                return
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let result = try decoder.decode(StockGraphData.self, from: data)
            completion(result)
        }
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
