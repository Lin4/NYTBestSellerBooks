//
//  BookService.swift
//  NYT Best Seller Books
//
//  Created by Lingeswaran Kandasamy on 1/6/18.
//  Copyright © 2018 Lingeswaran Kandasamy. All rights reserved.
//

import Foundation
import UIKit
class BookService: NSObject {
    
    lazy var endPoint: String = {
        return "https://api.nytimes.com/svc/books/v3/lists/2016-12-11/animals.json?api-key=92c2940599c54dadb9bd2517a8d82226"
    }()
    func getDataWith(completion: @escaping (result<[[String: AnyObject]]>) -> Void) {
        let urlString = endPoint
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
           
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let jsonArray = jsonResult.value(forKey: "results") as? [String: AnyObject]
                guard let booksArray = jsonArray!["books"] as? [[String: AnyObject]] else {
                    return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                }
                DispatchQueue.main.async {
                    completion(.Success(booksArray))
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
        }.resume()
    }
}

enum result<T> {
    case Success(T)
    case Error(String)
}
