//
//  NetworkingService.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

final class NetworkingService {
    
    init () {
        getDataFromLocalJSONFile(forName: "stockProfiles")
    }
    
    func getDataFromLocalJSONFile (forName name: String) {
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
