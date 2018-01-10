//
//  Images+CoreDataProperties.swift
//  NYT Best Seller Books
//
//  Created by Lingeswaran Kandasamy on 1/8/18.
//  Copyright © 2018 Lingeswaran Kandasamy. All rights reserved.
//
//

import Foundation
import CoreData


extension Images {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images")
    }

    @NSManaged public var image: NSObject?
    @NSManaged public var toBooks: Books?

}
