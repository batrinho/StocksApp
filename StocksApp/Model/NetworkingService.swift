//
//  NetworkingService.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

protocol NetworkingServiceProtocol {
    func fetchCompanyLogo (logoUrl: String, completion: @escaping (UIImage?, String?) -> Void)
}

final class NetworkingService: NetworkingServiceProtocol {
    init () {
        Task {
            await getDataFromLocalJSONFile(name: StockData.localJsonFile)
        }
    }
    
    func fetchCompanyLogo (logoUrl: String, completion: @escaping (UIImage?, String?) -> Void) {
        if let image = StockData.logos[logoUrl] {
            completion(image, logoUrl)
        } else {
            Task {
                do {
                    guard let imageUrl = URL(string: logoUrl),
                          let fetchedImage = try await parseJSON(url: imageUrl) else {
                        completion(nil, nil)
                        return
                    }
                    
//                    StockData.logos[logoUrl] = fetchedImage
                    completion(fetchedImage, logoUrl)
                } catch {
                    completion(nil, nil)
                }
            }
        }
    }
    
    func parseJSON (url: URL) async throws -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("failed to fetch an image for a company logo")
            return nil
        }
    }
    
    func getDataFromLocalJSONFile (name: String) async {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                let decoder = JSONDecoder()
                
                    let decodedData = try decoder.decode([StockProfileData].self, from: data)
                    StockData.stockCompanies = decodedData
                    StockData.tickers.removeAll()
                    for decodedDatum in decodedData {
                        StockData.tickers.append(decodedDatum.ticker)
                    }
               
            }
        } catch {}
    }
}
