//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Anastasia Lenina on 14.04.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories : Results<Category>?
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategories()
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaultColor : UIColor = .systemPink
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = defaultColor
        navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white ]
        addButton.tintColor = .white
        
    }
    
    
    //MARK: - Table data insert
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            cell.textLabel!.text = category.name
            if let colorCategory = UIColor(hexString: category.color){
                cell.backgroundColor = colorCategory
                cell.textLabel?.textColor = .white
                cell.textLabel?.font = UIFont.init(name: "Helvetica-bold", size: 18)
            }
            
        }
        else{
            cell.textLabel!.text = "No Category was added yet"
            //cell.backgroundColor = UIColor.randomFlat()
        }
        
        return cell
    }
    
    
    // MARK: - Select Row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Here go to another screen
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
                    newCategory.color = UIColor.randomFlat().hexValue()
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
    //MARK: - Delete Daa From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
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
    
}


