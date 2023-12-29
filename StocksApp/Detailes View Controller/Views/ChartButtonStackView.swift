//
//  ChartButtonStackView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 30.11.2023.
//

import UIKit

protocol ChartButtonStackViewDelegate: AnyObject {
    func handleChartButtonTap(state: DetailsPageViewControllerPresenter.State)
}

final class ChartButtonStackView: UIStackView {
    weak var delegate: ChartButtonStackViewDelegate?
    private var buttons: [DetailsPageViewControllerPresenter.State]
    
    init(frame: CGRect, buttons: [DetailsPageViewControllerPresenter.State]) {
        self.buttons = buttons
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .horizontal
        distribution = .fillEqually
        spacing = 10
        addSubviews()
    }
    
    private func addSubviews() {
        for i in 0...5 {
            let button = ChartButton(frame: .zero, state: buttons[i])
            button.delegate = self
            addArrangedSubview(button)
        }
    }
}

extension ChartButtonStackView: ChartButtonDelegate {
    func handleChartButtonTap(state: DetailsPageViewControllerPresenter.State) {
        delegate?.handleChartButtonTap(state: state)
    }
}
