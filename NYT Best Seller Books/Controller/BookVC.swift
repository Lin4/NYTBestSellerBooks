//
//  BookVC.swift
//  NYTimes Bestseller
//
//  Created by Lingeswaran Kandasamy on 1/5/18.
//  Copyright © 2018 Lingeswaran Kandasamy. All rights reserved.
//

import UIKit

class BookVC: UIViewController {
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitleLbl: UILabel!
    @IBOutlet weak var authorNameLbl: UILabel!
    @IBOutlet weak var bookDetailDesc: UILabel!

    
    
    var amazonLink: String?
    var reviewLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func setBooks(books: Books) {
        DispatchQueue.main.async {
            self.bookTitleLbl.text = books.book_title
            self.authorNameLbl.text = books.author
            self.bookDetailDesc.text = books.book_description
            self.amazonLink = books.anazon_link
            self.reviewLink = books.review_link
            print("review Link", books.review_link!)
            
            if let url = books.image_url {
                self.bookImage.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
            }
        }
    }
    
    @IBAction func amazonBtnPressed(_ sender: Any) {
       guard amazonLink != nil else { return }
        open(scheme: amazonLink!)
    }

    @IBAction func nYTReviewBtnPressed(_ sender: Any) {
        guard reviewLink != nil else { return }
        open(scheme: reviewLink!)
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
}
