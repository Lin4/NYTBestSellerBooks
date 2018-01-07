//
//  BookDetailVC.swift
//  NYT Best Seller Books
//
//  Created by Lingeswaran Kandasamy on 1/6/18.
//  Copyright © 2018 Lingeswaran Kandasamy. All rights reserved.
//

import UIKit
import CoreData

class BookDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Books.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rank", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var bookSortSegment: UISegmentedControl!
    
    var bestSellerList: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        view.backgroundColor = .white
        print(bestSellerList)
        let URL = "\(BASE_URL_FOR_DETAILS)\(bestSellerList!)\(URL_ENDPOINT)"
        BestSellerListName.instance.URL = URL.replacingOccurrences(of: " ", with: "-")
      //  BookService.instance.downloadBestSellerBooks()
      //  self.Product
         //self.initBooks()
        
        
        updateTableContent()
        
    }




    func updateTableContent() {
        do {
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(self.fetchedhResultController.sections?[0].numberOfObjects)")
        } catch let error  {
            print("ERROR: \(error)")
        }
        let service = BookService()
        service.getDataWith { (result) in
            switch result {
            case .Success(let data):
                self.clearData()
                self.saveInCoreDataWith(array: data)
            case .Error(let message):
                DispatchQueue.main.async {
                    self.showAlertWith(title: "Error", message: message)
                }
            }
        }
    }


    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
        if let books = fetchedhResultController.object(at: indexPath) as? Books {
             cell.setBooksCellWith(books: books)
        }
        return cell
    }
    
    private func createBookEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let bookEntity = NSEntityDescription.insertNewObject(forEntityName: "Books", into: context) as? Books {
            bookEntity.book_title = dictionary["title"] as? String
            bookEntity.author = dictionary["author"] as? String
            bookEntity.rank =   dictionary["rank"] as? String
            bookEntity.week_on_list = dictionary["weeks_on_list"] as? String
            bookEntity.anazon_link = dictionary["amazon_product_url"] as? String
            bookEntity.review_link = dictionary["sunday_review_link"] as? String
            bookEntity.book_description = dictionary["description"] as? String
            bookEntity.image_url = dictionary["book_image"] as? String
            return bookEntity
        }
        return nil
    }
    
    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createBookEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func clearData() {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Books.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }

    
    @IBAction func bookSortSegmentChange(_ sender: Any) {
    }
}

extension BookDetailVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.bookCollectionView.insertItems(at: [newIndexPath!])
        case .delete:
            self.bookCollectionView.insertItems(at: [indexPath!])
        default:
            break
        }
    }
    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        self.bookCollectionView.endUpdates()
//    }
//    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        bookCollectionView.beginUpdates()
//    }
}


