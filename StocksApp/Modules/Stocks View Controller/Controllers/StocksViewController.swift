//
//  ViewController.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

// MARK: - Init, Configurations
final class StocksViewController: UIViewController {
    private let presenter: StocksViewControllerOutput
    
    // MARK: - UI
    private let showMoreView: ShowMoreView = {
        let view = ShowMoreView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let searchBarView: SearchBarView = {
        let view = SearchBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let buttonsStackView: ButtonsStackView = {
        let view = ButtonsStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let stocksTableView: StocksTableView = {
        let view = StocksTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let requestsView: RequestsView
    
    init(presenter: StocksViewControllerOutput) {
        self.presenter = presenter
        self.requestsView = RequestsView(
            frame: .zero,
            popularRequestsArray: presenter.getPopularRequestsArray(),
            recentRequestsArray: presenter.getRecentRequestsArray()
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        searchBarView.delegate = self
        buttonsStackView.delegate = self
        requestsView.delegate = self
        setupView()
        
        presenter.openStocks()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(searchBarView)
        view.addSubview(showMoreView)
        view.addSubview(buttonsStackView)
        view.addSubview(stocksTableView)
        view.addSubview(requestsView)
        
        showMoreView.isHidden = true
        requestsView.isHidden = true
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBarView.heightAnchor.constraint(equalToConstant: 48),
            
            showMoreView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 5),
            showMoreView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showMoreView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showMoreView.heightAnchor.constraint(equalToConstant: 40),
            
            buttonsStackView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 5),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -160),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 40),

            stocksTableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 50),
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            requestsView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 5),
            requestsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            requestsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            requestsView.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 340),
        ])
    }
}

// MARK: - Search Bar View delegate
extension StocksViewController: SearchBarViewDelegate {
    func handleTextFieldButton() {
        presenter.handleTextFieldButton()
    }
    
    func handleTextFieldChanges(text: String) {
        presenter.handleTextFieldChanges(text: text)
    }
}

// MARK: - StocksVC Input
extension StocksViewController: StocksViewControllerInput {
    func textFieldResignFirstResponder() {
        searchBarView.textFieldResignFirstResponder()
    }
    
    func updateTextFieldButtonImage(with image: UIImage) {
        searchBarView.updateTextFieldButtonImage(with: image)
    }
    
    func updateFavoriteButton(with indexPath: IndexPath, buttonImage: UIImage) {
        guard let cell = stocksTableView.cellForRow(at: indexPath) as? StocksTableViewCell else { return }
        cell.updateButtonImage(with: buttonImage)
    }
    
    func stateChangedTo(state: StocksViewControllerPresenter.State) {
        switch state {
        case .displayingStocks, .displayingFavorites:
            buttonsStackView.isHidden = false
            showMoreView.isHidden = true
            requestsView.isHidden = true
            stocksTableView.isHidden = false
        case .searching:
            buttonsStackView.isHidden = true
            showMoreView.isHidden = true
            requestsView.isHidden = false
            stocksTableView.isHidden = true
        case .typing:
            buttonsStackView.isHidden = true
            showMoreView.isHidden = false
            requestsView.isHidden = true
            stocksTableView.isHidden = false
        }
    }
    
    func updateSearchBarView(text: String) {
        searchBarView.updateTextField(text: text)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.stocksTableView.reloadData()
        }
    }
}

// MARK: - Table View
// MARK: - Stocks Table View Cell Delegate
extension StocksViewController: StocksTableViewCellDelegate {
    func handleFavoriteButtonTap(with indexPath: IndexPath) {
        presenter.handleFavoriteButtonTap(with: indexPath)
    }
}

// MARK: - Table View Delegate
extension StocksViewController: UITableViewDelegate {
    
}

// MARK: - Table View DataSource
extension StocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getStocksCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "stockCell",
            for: indexPath
        ) as? StocksTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        guard let stock = presenter.getStockInformation(with: indexPath.row) else { return UITableViewCell() }
        DispatchQueue.main.async {
            cell.configure(
                ticker: stock.ticker,
                name: stock.name,
                color: (indexPath.row % 2 == 0) ? UIColor.backgroundGray : .clear,
                logo: stock.logo,
                favoriteButtonImage: stock.favoriteButtonImage,
                currentPrice: stock.currentPrice,
                changePrice: stock.changePrice
            )
        }
        return cell
    }
}

// MARK: - Buttons Stack View Delegate
extension StocksViewController: ButtonsStackViewProtocol {
    func handleButtonStackViewButtonTap(isStocks: Bool) {
        switch isStocks {
        case true:
            presenter.openStocks()
        case false:
            presenter.openFavorites()
        }
        reloadTableView()
    }
}

// MARK: - Requests View Delegate
extension StocksViewController: RequestsViewDelegate {
    func handleRequestButtonTap(name: String) {
        presenter.handleRequestButtonTap(name: name)
    }
}
