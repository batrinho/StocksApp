//
//  DetailsPageViewController.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 30.11.2023.
//

import UIKit
import DGCharts

final class DetailsPageViewController: UIViewController {
    private let presenter: DetailsPageViewControllerOutput
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "returnIcon"), for: .normal)
        return button
    }()
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let stockCompanyName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Montserrat-Bold", size: 12)
        return label
    }()
    private let stockCompanyTicker: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        return label
    }()
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 7.5
        return stackView
    }()
    private let chartView: ChartView = {
        let view = ChartView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let bubbleView: BubbleView = {
        let view = BubbleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let buyButton: BuyButton
    private lazy var chartButtonStackView: ChartButtonStackView = {
        let view = ChartButtonStackView(frame: .zero, buttons: presenter.getButtons())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(
        presenter: DetailsPageViewControllerOutput,
        stockCompanyName: String,
        stockCompanyTicker: String,
        favoriteButtonImage: UIImage,
        stockCurrentPrice: String
    ) {
        self.presenter = presenter
        self.stockCompanyName.text = stockCompanyName
        self.stockCompanyTicker.text = stockCompanyTicker
        self.buyButton = BuyButton(frame: .zero, price: stockCurrentPrice)
        self.favoriteButton.setImage(favoriteButtonImage, for: .normal)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        presenter.viewIsReady()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        addSubviews()
        addConstraints()
        navigationItem.titleView = labelStackView
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        chartView.delegate = self
        chartButtonStackView.delegate = self
        buyButton.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(chartView)
        view.addSubview(chartButtonStackView)
        view.addSubview(buyButton)
        view.addSubview(bubbleView)
        labelStackView.addArrangedSubview(stockCompanyTicker)
        labelStackView.addArrangedSubview(stockCompanyName)
        bubbleView.isHidden = true
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartView.heightAnchor.constraint(equalToConstant: 400),
            
            chartButtonStackView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 30),
            chartButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (view.frame.width - 330)/2),
            chartButtonStackView.widthAnchor.constraint(equalToConstant: 326),
            chartButtonStackView.heightAnchor.constraint(equalToConstant: 44),
            
            buyButton.topAnchor.constraint(equalTo: chartButtonStackView.bottomAnchor, constant: 20),
            buyButton.leadingAnchor.constraint(equalTo: chartButtonStackView.leadingAnchor),
            buyButton.widthAnchor.constraint(equalToConstant: 330),
            buyButton.heightAnchor.constraint(equalToConstant: 56),
            
            bubbleView.heightAnchor.constraint(equalToConstant: 70),
            bubbleView.widthAnchor.constraint(equalToConstant: 90),
        ])
    }
    
    @objc
    func backButtonPressed() {
        presenter.backButtonPressed()
    }
    
    @objc
    func favoriteButtonPressed() {
        presenter.favoriteButtonPressed()
    }
}

// MARK: - ChartButtonStackViewDelegate
extension DetailsPageViewController: ChartButtonStackViewDelegate {
    func handleChartButtonTap(state: DetailsPageViewControllerPresenter.State) {
        presenter.handleChartButtonTap(state: state)
    }
}

// MARK: - BuyButtonDelegate
extension DetailsPageViewController: BuyButtonDelegate {
    func handleBuyButtonTap(price: String?) {
        guard let price else { return }
        presenter.handleBuyButtonTap(price: price)
    }
}

// MARK: - StocksChartViewDelegate
extension DetailsPageViewController: StocksChartViewDelegate {
    func chartValueSelected(at position: CGPoint, entry: ChartDataEntry) {
        presenter.chartValueSelected(at: position, entry: entry)
    }
    
    func chartValueNotSelected() {
        bubbleView.isHidden = true
    }
}

// MARK: - DetailsPageViewControllerInput
extension DetailsPageViewController: DetailsPageViewControllerInput {
    func stateChangedTo(_ state: DetailsPageViewControllerPresenter.State) {
        for case let chartButton as ChartButton in chartButtonStackView.subviews {
            guard let chartButtonLabelText = chartButton.labelText else { return }
            if chartButtonLabelText == state.rawValue {
                chartButton.backgroundColor = .black
            } else {
                chartButton.backgroundColor = UIColor.backgroundGray
            }
        }
    }
    
    func updateGraph(with data: LineChartData) {
        chartView.updateGraph(with: data)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func updateFavoriteButtonImage(with image: UIImage) {
        favoriteButton.setImage(image, for: .normal)
    }
    
    func moveBubbleViewTo(x: CGFloat, y: CGFloat, price: String, date: String) {
        bubbleView.isHidden = false
        print(x)
        print(chartView.bounds.width)
        print(chartView.frame.width)
        bubbleView.transform = CGAffineTransform(translationX: min(max(0, x - 45), chartView.frame.width - 90), y: y + 90)
        bubbleView.changeLabels(price: price, date: date)
    }
    
    func presentPurchaseAlertViewController(price: String) {
        let alertController = UIAlertController(
            title: "\(price)?",
            message: nil,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        alertController.addAction(cancelAction)
        let purchaseAction = UIAlertAction(title: "Yes", style: .default)
        alertController.addAction(purchaseAction)
        present(alertController, animated: true)
    }
}
