//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
class ToDoListViewController: UITableViewController  {
    
    var items = [Item]()
    var selectedCategory : Category?{
        didSet{
            self.loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       
             
    }

    //MARK: - Add new Items
    
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title:"Add Item", style: .default){
            action in
            //what will happen when clicks on the Add Item button
            print("success")
            if let safeTextField = textField.text {
                if !safeTextField.isEmpty {
                    
                    let newItem = Item(context: context)
                    newItem.title = safeTextField
                    newItem.done = false
                    newItem.parentCategory = self.selectedCategory
                    self.items.append(newItem)
                    self.saveItems()
                    self.tableView.reloadData()
                    print("saved")
                }
            }
        }
        alert.addTextField{
            alertTextField in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Table data insert
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // Configure the cell’s contents with the row and section number.
        // The Basic cell style guarantees a label view is present in textLabel.
        
        let item = items[indexPath.row]
        cell.textLabel!.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].done = !items[indexPath.row].done
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func saveItems(){
        do {
            try context.save()
        } catch {
            print("error saving")
        }
    }
    var predicateCategorySearch : NSCompoundPredicate?
    
    func loadItems(with request : NSFetchRequest<Item>  = Item.fetchRequest()) {
       
        //let predicate = NSPredicate (format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let safePredicate = predicateCategorySearch {
            request.predicate = safePredicate
        }
        else {
            let predicate = NSPredicate (format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        }
        do {
            print("trying to find")
            items = try context.fetch(request)
        } catch {
            print("Error writting Data")
        }
        tableView.reloadData()
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let predicateCategory = NSPredicate (format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        let predicateSearch = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        predicateCategorySearch = NSCompoundPredicate(type: .and, subpredicates: [predicateCategory, predicateSearch])
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate  = predicateCategorySearch
        //request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
       
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            predicateCategorySearch = nil
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
}
