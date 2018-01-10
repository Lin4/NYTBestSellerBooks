//
//  BookListCellTableViewCell.swift
//  NYT Best Seller Books
//
//  Created by Lingeswaran Kandasamy on 1/6/18.
//  Copyright © 2018 Lingeswaran Kandasamy. All rights reserved.
//

import UIKit

class BookListCell: UITableViewCell {
    
    @IBOutlet weak var bookListImage: UIImageView!
    @IBOutlet weak var bestSellerListLbl: UILabel!
    
    func setBookListCellWith(bookList: BookList) {
        DispatchQueue.main.async {
            self.bestSellerListLbl.text = bookList.list_name
            self.bookListImage.image = UIImage(named: (bookList.display_name?.removingWhitespaces())!)
        }
    }
}
extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
