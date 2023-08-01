//
//  StocksTableViewCell.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

class StocksTableViewCell: UITableViewCell {
    
    let companyTitle: UILabel = {
        let title = UILabel()
        title.textColor = .systemBlue
        return title
    } ()

    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Data().stocksCellIndentifier)
        setupView()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView () {
        contentView.addSubview(companyTitle)
        companyTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            companyTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            companyTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            companyTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            companyTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func updateView (newCompanyTitle: String) {
        companyTitle.text = newCompanyTitle
    }
}
