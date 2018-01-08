//
//  ViewController.swift
//  NYT Best Seller Books
//
//  Created by Lingeswaran Kandasamy on 1/6/18.
//  Copyright © 2018 Lingeswaran Kandasamy. All rights reserved.
//

import UIKit
import CoreData

class BestSellerListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: BookList.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "list_name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        updateTableContent()
        }
    
    func updateTableContent() {
        do {
            try self.fetchedhResultController.performFetch()
         //   print("COUNT FETCHED FIRST: \(self.fetchedhResultController.sections?[0].numberOfObjects)")
        } catch let error  {
            print("ERROR: \(error)")
        }
        let service = BookApiService()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookListCell", for: indexPath) as! BookListCell
        
        if let bookList = fetchedhResultController.object(at: indexPath) as? BookList {
            cell.setBookListCellWith(bookList: bookList)
        }
        return cell
    }
    
    
    private func createBookListEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let bookListEntity = NSEntityDescription.insertNewObject(forEntityName: "BookList", into: context) as? BookList {
            bookListEntity.list_name = dictionary["list_name"] as? String
            bookListEntity.display_name = dictionary["display_name"] as? String
            return bookListEntity
        }
        return nil
    }
    
    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createBookListEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func clearData() {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: BookList.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let category = fetchedhResultController.object(at: indexPath) as? BookList {
            BestSellerListName.instance.bestSellerListName = category.list_name
        }
        
        performSegue(withIdentifier: "toBookVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBookVC" {
            let destination = segue.destination as? BookDetailVC
            destination?.bestSellerList = BestSellerListName.instance.bestSellerListName
        }
    }
}

extension BestSellerListVC: NSFetchedResultsControllerDelegate {
    
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













