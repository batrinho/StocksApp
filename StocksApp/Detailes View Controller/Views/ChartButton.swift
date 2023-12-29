//
//  RequestButton.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 13.09.2023.
//

import UIKit

protocol ChartButtonDelegate: AnyObject {
    func handleChartButtonTap(state: DetailsPageViewControllerPresenter.State)
}

final class ChartButton: UIButton {
    weak var delegate: ChartButtonDelegate?
    
    override var backgroundColor: UIColor? {
        didSet {
            label.textColor = (backgroundColor == .black ? .white : .black)
        }
    }
    
    var labelText: String? {
        get {
            return label.text
        }
    }
    
    private let buttonState: DetailsPageViewControllerPresenter.State
    
    // MARK: - UI
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Montserrat-Medium", size: 12)
        label.text = buttonState.rawValue
        return label
    }()
        
    init(frame: CGRect, state: DetailsPageViewControllerPresenter.State) {
        self.buttonState = state
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        sizeToFit()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = UIColor.backgroundGray
        
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(label)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    @objc
    private func buttonPressed() {
        delegate?.handleChartButtonTap(state: buttonState)
    }
}
