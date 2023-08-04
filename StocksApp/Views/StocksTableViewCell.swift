//
//  StocksTableViewCell.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

class StocksTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    
    let companyLogo: UIImageView = {
        let image = UIImageView()
        
        image.image = UIImage(named: "loading")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        image.backgroundColor = .white
        
        return image
    } ()
    
    let companyTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textColor = .black
        return title
    } ()
    
    let companySymbol: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 30)
        title.textColor = .black
//        title.backgroundColor = .red
        title.lineBreakMode = .byClipping
        title.numberOfLines = 0
        return title
    } ()
    
    let companyFavorite: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Image-1"), for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    } ()
    
    let favoriteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
//        stackView.backgroundColor = .cyan
        return stackView
    } ()
    
    let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    } ()
    
    let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        //stackView.backgroundColor = .brown
        return stackView
    } ()
    
    // MARK: - Internal Methods

    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: StockData().stocksCellIndentifier)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.updateLogo(newCompanyLogo: UIImage(named: "loading.png")!)
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setupView () {
        let someView = UIView()
        someView.backgroundColor = .clear
        self.selectedBackgroundView = someView
        
        contentView.layer.cornerRadius = 16
        contentView.addSubview(cellStackView)
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        cellStackView.addArrangedSubview(companyLogo)
        NSLayoutConstraint.activate([
            companyLogo.topAnchor.constraint(equalTo: cellStackView.topAnchor),
            companyLogo.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor),
            companyLogo.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        cellStackView.addArrangedSubview(titleStackView)
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: cellStackView.topAnchor, constant: 15),
            titleStackView.bottomAnchor.constraint(equalTo: cellStackView.bottomAnchor, constant: -10)
        ])
        titleStackView.addArrangedSubview(favoriteStackView)
        favoriteStackView.addArrangedSubview(companySymbol)
        favoriteStackView.addArrangedSubview(companyFavorite)
        companyFavorite.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            companyFavorite.heightAnchor.constraint(equalToConstant: 20)
        ])
        titleStackView.addArrangedSubview(companyTitle)
    }
    
    func updateLabels (newCompanySymbol: String, newCompanyTitle: String, cellBackgroundColor: UIColor) {
        companySymbol.text = newCompanySymbol
        companyTitle.text = newCompanyTitle
        contentView.backgroundColor = cellBackgroundColor
    }
    
    func updateLogo (newCompanyLogo: UIImage) {
        companyLogo.image = newCompanyLogo
    }
    
    @objc func favoriteButtonPressed () {
        let currentImage = companyFavorite.imageView?.image
        companyFavorite.setImage(currentImage == UIImage(named: "Image") ? UIImage(named: "Image-1") : UIImage(named: "Image"), for: .normal)
    }
}
