//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anastasia Lenina on 14.04.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategories()

     
    }
    
   
    
    //MARK: - Table data insert
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Ask for a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        let category = categories[indexPath.row]
        cell.textLabel!.text = category.name
        
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
            destinationVC.selectedCategory = categories[indexPath.row]
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
                    
                    let newCategory = Category(context: context)
                    newCategory.name = safeTextField
                    self.categories.append(newCategory)
                    self.saveCategories()
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
    
    func loadCategories(with request : NSFetchRequest<Category>  = Item.fetchRequest()) {
      
        do {
            print("trying to find")
            categories = try context.fetch(request)
        } catch {
            print("Error writting Data")
        }
        tableView.reloadData()
    }
    
    func saveCategories(){
        do {
            try context.save()
        } catch {
            print("error saving category")
        }
    }
   
   
}
