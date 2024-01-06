//
//  NetworkingServiceProtocol.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 31.12.2023.
//

import UIKit

protocol NetworkingServiceProtocol {
    func fetchStocks(completion: @escaping ([Stock]) -> ())
    func fetchGraphData(stockTicker: String, state: DetailsPageViewControllerPresenter.State, completion: @escaping (StockGraphData?) -> ())
}
