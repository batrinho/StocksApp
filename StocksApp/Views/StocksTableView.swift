//
//  StocksTableViewController.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

class StocksTableView: UITableView {
    private let networkingService = NetworkingService()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.register(StocksTableViewCell.self, forCellReuseIdentifier: StockData().stocksCellIndentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StocksTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StockData.companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockData().stocksCellIndentifier, for: indexPath) as? StocksTableViewCell else {
            return UITableViewCell()
        }
        
        Task {
            do {
                guard let imageUrl = URL(string: StockData.companies[indexPath.row].logo),
                      let fetchedImage = try await networkingService.fetchCompanyLogo(url: imageUrl) else { return }
                
                let backgroundColor: UIColor?
                if indexPath.row % 2 == 0 {
                    backgroundColor = .systemBackground
                } else {
                    backgroundColor = .lightGray
                }
                
                DispatchQueue.main.async {
                    cell.updateView(newCompanySymbol: StockData.companies[indexPath.row].ticker, newCompanyTitle: StockData.companies[indexPath.row].name, newCompanyLogo: fetchedImage, cellBackgroundColor: backgroundColor!)
                }
            } catch {
                print("failed to update UI")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
