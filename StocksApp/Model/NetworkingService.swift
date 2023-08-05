//
//  NetworkingService.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

protocol NetworkingServiceProtocol {
    func fetchCompanyLogo (url: URL) async throws -> UIImage?
}

final class NetworkingService: NetworkingServiceProtocol {
    init () {
        Task {
            await getDataFromLocalJSONFile(name: StockData.localJsonFile)
        }
    }
    
    func fetchCompanyLogo (url: URL) async throws -> UIImage? {
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
                do {
                    let decodedData = try decoder.decode([StockProfileData].self, from: data)
                    StockData.stockCompanies = decodedData
                } catch {}
            }
        } catch {}
    }
}
