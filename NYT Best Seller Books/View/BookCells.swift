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
            //self.bookImage.downloadedFrom(link: books.image_url!)
            
        }
    }
}
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
