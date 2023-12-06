//
//  ViewController.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.08.2023.
//

import UIKit

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
    private lazy var requestsView: RequestsView = {
        return RequestsView(
            frame: .zero,
            popularRequestsArray: presenter.getPopularRequestsArray(),
            recentRequestsArray: presenter.getRecentRequestsArray()
        )
    }()
    
    init(presenter: StocksViewControllerOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        presenter.viewIsReady()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        presenter.viewIsReady()
    }
    
    private func configure() {
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        searchBarView.delegate = self
        buttonsStackView.delegate = self
        requestsView.delegate = self
        showMoreView.delegate = self
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        addSubviews()
        addConstraints()
        navigationItem.titleView = searchBarView
        stocksTableView.contentInsetAdjustmentBehavior = .automatic
    }
    
    private func addSubviews() {
        view.addSubview(showMoreView)
        view.addSubview(buttonsStackView)
        view.addSubview(stocksTableView)
        view.addSubview(requestsView)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBarView.heightAnchor.constraint(equalToConstant: 48),
            searchBarView.widthAnchor.constraint(equalToConstant: view.frame.width - 30),
            
            showMoreView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            showMoreView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showMoreView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            showMoreView.heightAnchor.constraint(equalToConstant: 40),
            
            buttonsStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -160),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 40),

            stocksTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            requestsView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            requestsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            requestsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            requestsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 340),
        ])
    }
}

// MARK: - Search Bar View delegate
extension StocksViewController: SearchBarViewDelegate {
    func handleEnter(text: String) {
        presenter.handleEnter(text: text)
    }
    
    func handleTextFieldButton() {
        presenter.handleTextFieldButtonTap()
    }
    
    func handleTextFieldChanges(text: String) {
        presenter.startedEditingTextField(with: text)
    }
}

// MARK: - StocksVC Input
extension StocksViewController: StocksViewControllerInput {
    func stateChangedTo(_ state: StocksViewControllerPresenter.State) {
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
    
    func switchButtonsDominance(isStocksPrior: Bool) {
        buttonsStackView.switchButtonsPriority(isStocksPrior: isStocksPrior)
    }
    
    func replaceTextFieldButtonImage(with image: UIImage) {
        searchBarView.updateTextFieldButtonImage(with: image)
    }
    
    func textFieldResignFirstResponder() {
        searchBarView.textFieldResignFirstResponder()
    }
    
    func updateSearchBarView(text: String) {
        searchBarView.updateTextField(text: text)
    }
    
    func addRequestToStackView(request: String, upper: Bool) {
        requestsView.addRequest(request: request, upper: upper)
    }
    
    func updateFavoriteButton(with indexPath: IndexPath, buttonImage: UIImage) {
        guard let cell = stocksTableView.cellForRow(at: indexPath) as? StocksTableViewCell else { return }
        cell.updateButtonImage(with: buttonImage)
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.stocksTableView.reloadData()
        }
    }
    
    func displaySecondViewController(_ secondVC: UIViewController) {
        navigationController?.pushViewController(secondVC, animated: true)
    }
}

// MARK: - Stocks Table View Cell Delegate
extension StocksViewController: StocksTableViewCellDelegate {
    func handleFavoriteButtonTap(with indexPath: IndexPath) {
        presenter.handleFavoriteButtonTap(with: indexPath)
    }
}

// MARK: - Table View DataSource
extension StocksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.handleCellSelection(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getStocksCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.getHeightForCell()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StocksTableViewCell.identifier,
            for: indexPath
        ) as? StocksTableViewCell, let stock = presenter.getStockInformation(with: indexPath.row) else {
            return UITableViewCell()
        }
        cell.delegate = self
        DispatchQueue.main.async {
            cell.configure(
                ticker: stock.ticker,
                name: stock.name,
                color: (indexPath.row % 2 == 0) ? UIColor.backgroundGray : .clear,
                logo: stock.logo,
                favoriteButtonImage: self.presenter.buttonImageForStock(with: stock.ticker),
                currentPrice: stock.currentPrice,
                changePrice: stock.changePrice
            )
        }
        return cell
    }
}

// MARK: - Buttons Stack View Delegate
extension StocksViewController: ButtonsStackViewProtocol {
    func handleButtonStackViewButtonTap() {
        presenter.handleButtonStackViewTap()
    }
}

// MARK: - Requests View Delegate
extension StocksViewController: RequestsViewDelegate {
    func handleRequestButtonTap(name: String) {
        presenter.handleRequestButtonTap(name: name)
    }
}

// MARK: - Show More View Delegate
extension StocksViewController: ShowMoreViewDelegate {
    func handleShowMoreButtonTap() {
        presenter.handleShowMoreButtonTap()
    }
}
