//
//  Books.swift
//  NYTimes Bestseller
//
//  Created by Lingeswaran Kandasamy on 1/4/18.
//  Copyright © 2018 Lingeswaran Kandasamy. All rights reserved.
//

import Foundation
struct books: Decodable {
    private(set) public var bookName: String!
    private(set) public var authorName: String!
    private(set) public var rank: Int!
    private(set) public var weeksOnList: Int!
    private(set) public var description: String!
    private(set) public var amazonURL: String!
    private(set) public var reviewURL: String!
    private(set) public var bookImageURL: String!
    
    init(bookName: String, authorName: String, rank: Int, weeksOnList: Int, description: String, amazonURL: String, reviewURL: String, bookImageURL: String) {
        self.bookName = bookName
        self.authorName = authorName
        self.rank = rank
        self.weeksOnList = weeksOnList
        self.description = description
        self.amazonURL = amazonURL
        self.reviewURL = reviewURL
        self.bookImageURL = bookImageURL
    }
}
