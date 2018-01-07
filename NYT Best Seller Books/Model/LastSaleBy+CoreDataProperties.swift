//
//  LastSaleBy+CoreDataProperties.swift
//  NYT Best Seller Books
//
//  Created by Lingeswaran Kandasamy on 1/6/18.
//  Copyright © 2018 Lingeswaran Kandasamy. All rights reserved.
//
//

import Foundation
import CoreData


extension LastSaleBy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastSaleBy> {
        return NSFetchRequest<LastSaleBy>(entityName: "LastSaleBy")
    }

    @NSManaged public var sell_by: String?
    @NSManaged public var book_title: String?

}
