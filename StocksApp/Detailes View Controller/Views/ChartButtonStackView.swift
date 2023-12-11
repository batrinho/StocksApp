//
//  ChartButtonStackView.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 30.11.2023.
//

import UIKit

protocol ChartButtonStackViewDelegate: AnyObject {
    func handleChartButtonTap(name: String?)
}

final class ChartButtonStackView: UIStackView {
    weak var delegate: ChartButtonStackViewDelegate?
    private var names: [String]
    
    init(frame: CGRect, names: [String]) {
        self.names = names
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
            let button = ChartButton(frame: .zero, name: names[i])
            button.delegate = self
            addArrangedSubview(button)
        }
    }
}

extension ChartButtonStackView: ChartButtonDelegate {
    func handleChartButtonTap(name: String?) {
        delegate?.handleChartButtonTap(name: name)
    }
}
