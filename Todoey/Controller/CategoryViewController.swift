//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anastasia Lenina on 14.04.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategories()
        tableView.rowHeight = 80

     
    }
    
   
    
    //MARK: - Table data insert
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        if let category = categories?[indexPath.row]{
            cell.textLabel!.text = category.name
        }
        else{
            cell.textLabel!.text = "No Category was added yet"
        }
        cell.delegate = self
        return cell
    }
    
   
    // MARK: - Select Row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Here go to another screen
    
        //context.delete(categories[indexPath.row])
        //categories.remove(at: indexPath.row)
        //saveCategories()
        
        performSegue(withIdentifier: "GoToItems", sender: self)
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
 //MARK: - New Category added
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title:"Add Category", style: .default){
            action in
            //what will happen when clicks on the Add Item button
            print("success adding category")
            if let safeTextField = textField.text {
                if !safeTextField.isEmpty {
                    
                    let newCategory = Category()
                    newCategory.name = safeTextField
                    self.saveCategories(object: newCategory)
                    self.tableView.reloadData()
                    print("saved new category")
                }
            }
        }
        alert.addTextField{
            alertTextField in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data manipulation
    
    func loadCategories() {
      
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func saveCategories(object: Category){
        do{
            try realm.write{
                realm.add(object)
            }
        }catch{
            print("error save category")
        }
    }

}

extension CategoryViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Item deleted")
            do{
                try self.realm.write{
                    if let categoriesSafe = self.categories {
                        self.realm.delete(categoriesSafe[indexPath.row])
                    }
                }
            }catch{
                print("error deleting")
            }
            
        }
        var indicatorView = UIActivityIndicatorView(frame: .zero)
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}

