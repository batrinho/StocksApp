//
//  FavoriteStock+CoreDataProperties.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 16.08.2023.
//
//

import Foundation
import CoreData


extension FavoriteStock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteStock> {
        return NSFetchRequest<FavoriteStock>(entityName: "FavoriteStock")
    }

    @NSManaged public var ticker: String?
    @NSManaged public var logo: String?
    @NSManaged public var name: String?

}

extension FavoriteStock : Identifiable {

}
