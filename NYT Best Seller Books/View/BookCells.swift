//
//  BookCells.swift
//  NYT Best Seller Books
//
//  Created by Lingeswaran Kandasamy on 1/7/18.
//  Copyright © 2018 Lingeswaran Kandasamy. All rights reserved.
//

import UIKit

class BookCells: UITableViewCell {
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var weekOnListLbl: UILabel!
    @IBOutlet weak var rankLbl: UILabel!

    func setBooksCellWith(books: Books) {
        DispatchQueue.main.async {
            self.weekOnListLbl.text = String(books.week_on_list)
            self.rankLbl.text = String(books.rank)
          //  print("LIN IMAGE SUCKS", books.toImage)
            if let url = books.image_url {
                self.bookImage.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
        }

    }
}
