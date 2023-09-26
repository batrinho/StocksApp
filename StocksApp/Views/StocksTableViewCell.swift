//
//  StocksTableViewCell.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

final class StocksTableViewCell: UITableViewCell {
    // MARK: - Variables
    
    private var logo = String()
    var isFavorite: Bool?
    var didSelectIsFavorite: ((Bool) -> (Void))?
    
    var originalBackgroundColor: UIColor?
    
    private let companyLogo: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "")
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        
        return image
    } ()
    
    private let companyTitle: UILabel = {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 17)
        title.lineBreakMode = .byTruncatingTail
        
        return title
    } ()
    
    private let companySymbol: UILabel = {
        let title = UILabel()
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        title.lineBreakMode = .byTruncatingTail
        
        title.numberOfLines = 0
        
        return title
    } ()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(StockData.emptyStar, for: .normal)
        
        return button
    } ()
    
    private let favoriteButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        
        return label
    } ()
    
    private let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .systemGreen
        label.textAlignment = .right
        
        return label
    } ()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .trailing
        
        return stackView
    } ()
    
    private let symbolStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        return stackView
    } ()
    
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 15
        
        return stackView
    } ()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        
        return stackView
    } ()
    
    private let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    // MARK: - Internal Methods
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: StockData.stocksCellIndentifier)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.updateLogo(newCompanyLogo: UIImage())
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure (newCompanySymbol: String, newCompanyTitle: String, cellBackgroundColor: UIColor, logo: String, isFavorite: Bool, callback: @escaping (Bool) -> Void) {
        self.isFavorite = isFavorite
        self.didSelectIsFavorite = callback
        self.updateLabels(newCompanySymbol: newCompanySymbol, newCompanyTitle: newCompanyTitle, cellBackgroundColor: cellBackgroundColor, logo: logo)
        setupView()
    }
    
    // MARK: - Setting up the View
    
    func setupView () {
        layer.cornerRadius = 16
        
        contentView.addSubview(companyLogo)
        contentView.addSubview(titleStackView)
        
        titleStackView.addArrangedSubview(symbolStackView)
        
        symbolStackView.addArrangedSubview(companySymbol)
        symbolStackView.addArrangedSubview(favoriteButtonView)
        
        favoriteButtonView.addSubview(favoriteButton)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        
        titleStackView.addArrangedSubview(companyTitle)
        
        contentView.addSubview(priceStackView)
        
        priceStackView.addArrangedSubview(currentPriceLabel)
        priceStackView.addArrangedSubview(priceChangeLabel)
        
        NSLayoutConstraint.activate([
            companyLogo.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            companyLogo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            companyLogo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            companyLogo.widthAnchor.constraint(equalToConstant: 65),
            
            titleStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            titleStackView.leadingAnchor.constraint(equalTo: companyLogo.trailingAnchor, constant: 15),
            titleStackView.widthAnchor.constraint(equalToConstant: 150),
            
            favoriteButton.topAnchor.constraint(equalTo: favoriteButtonView.topAnchor, constant: 7.5),
            favoriteButton.bottomAnchor.constraint(equalTo: favoriteButtonView.bottomAnchor, constant: -7.5),
            favoriteButton.widthAnchor.constraint(equalToConstant: 20),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor),
            
            priceStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            priceStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            priceStackView.leadingAnchor.constraint(equalTo: titleStackView.trailingAnchor, constant: 10),
            priceStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    // MARK: - Cell modifications
    
    func updateLabels (newCompanySymbol: String, newCompanyTitle: String, cellBackgroundColor: UIColor, logo: String) {
        companySymbol.text = newCompanySymbol
        companyTitle.text = newCompanyTitle
        backgroundColor = cellBackgroundColor
        originalBackgroundColor = cellBackgroundColor
        if let isFavorite = isFavorite {
            favoriteButton.setImage(isFavorite ? StockData.filledStar : StockData.emptyStar, for: .normal)
        }
        self.logo = logo
    }
    
    func updateLogo (newCompanyLogo: UIImage) {
        companyLogo.image = newCompanyLogo
    }
    
    func updatePrices (currentPrice: Double, priceChange: Double) {
        currentPriceLabel.text = "$\(currentPrice)"
        priceChangeLabel.text = (priceChange < 0 ? "-$\(priceChange * -1)" : "+$\(priceChange)")
        priceChangeLabel.textColor = (priceChange < 0 ? .systemRed : .systemGreen)
    }
    
    func setButtonImage (newImage: UIImage) {
        favoriteButton.setImage(newImage, for: .normal)
    }
    
    @objc func favoriteButtonPressed () {
        isFavorite?.toggle()
        if let newFavoriteState = isFavorite {
            didSelectIsFavorite?(newFavoriteState)
        }
    }
}
