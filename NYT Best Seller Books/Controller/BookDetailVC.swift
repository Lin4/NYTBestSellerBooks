//
//  BookDetailVC.swift
//  NYT Best Seller Books
//
//  Created by Lingeswaran Kandasamy on 1/6/18.
//  Copyright © 2018 Lingeswaran Kandasamy. All rights reserved.
//

import UIKit
import CoreData

class BookDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Books.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rank", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    @IBOutlet weak var tableView: UITableView!
  
    @IBOutlet weak var bookSortSegment: UISegmentedControl!
    
    var bestSellerList: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let URL = "\(BASE_URL_FOR_BOOK_DETAILS)\(bestSellerList!)\(URL_ENDPOINT_BOOK_DETAILS)"
        BestSellerListName.instance.URL = URL.replacingOccurrences(of: " ", with: "-")
        
        view.backgroundColor = .white
        view.backgroundColor = .white
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCells
        
        if let books = fetchedhResultController.object(at: indexPath) as? Books {
            cell.setBooksCellWith(books: books)
        }
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width - 50 //100 = sum of labels height + height of divider line
    }
    
    private func createBookEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let bookEntity = NSEntityDescription.insertNewObject(forEntityName: "Books", into: context) as? Books {
            bookEntity.book_title = dictionary["title"] as? String
            bookEntity.author = dictionary["author"] as? String
            bookEntity.rank =   ((dictionary["rank"]) as? Int64)!
            bookEntity.week_on_list = ((dictionary["weeks_on_list"]) as? Int64)!
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
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}



