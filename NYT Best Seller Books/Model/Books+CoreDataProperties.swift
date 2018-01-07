//
//  Books+CoreDataProperties.swift
//  NYT Best Seller Books
//
//  Created by Lingeswaran Kandasamy on 1/6/18.
//  Copyright © 2018 Lingeswaran Kandasamy. All rights reserved.
//
//

import Foundation
import CoreData


extension Books {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Books> {
        return NSFetchRequest<Books>(entityName: "Books")
    }

    @NSManaged public var book_title: String?
    @NSManaged public var author: String?
    @NSManaged public var rank: String?
    @NSManaged public var week_on_list: String?
    @NSManaged public var anazon_link: String?
    @NSManaged public var review_link: String?
    @NSManaged public var book_description: String?
    @NSManaged public var image_url: String?
    

}
