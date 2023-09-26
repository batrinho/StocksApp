//
//  RecentRequest+CoreDataProperties.swift
//  StocksApp
//
//  Created by Batyr Tolkynbayev on 21.09.2023.
//
//

import Foundation
import CoreData


extension RecentRequest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentRequest> {
        return NSFetchRequest<RecentRequest>(entityName: "RecentRequest")
    }

    @NSManaged public var requestTitle: String?

}

extension RecentRequest : Identifiable {

}
