//
//  Array.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 01.11.2023.
//

import UIKit

extension Array {
    func split() -> (left: [Element], right: [Element]) {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}

