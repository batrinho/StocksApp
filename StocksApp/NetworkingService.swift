//
//  NetworkingService.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

final class NetworkingService {
    
    init () {
        getDataFromLocalJSONFile(name: "stockProfiles")
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
    
    func getDataFromLocalJSONFile (name: String) {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                do {
                    let decodedData = try JSONDecoder().decode([StockProfileData].self, from: data)
                    StockData.companies = decodedData
                } catch {
                    print("error: \(error)")
                }
            }
        } catch {
            print("error: \(error)")
        }
    }
    
}
