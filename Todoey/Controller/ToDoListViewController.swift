//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework
class ToDoListViewController: SwipeTableViewController  {
    
    let realm = try! Realm()
    var items : Results<Item>?
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory : Category?{
        didSet{
            self.loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        searchBar.tintColor = .white
        searchBar.searchTextField.leftView?.tintColor = .white
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let safeTitle = selectedCategory?.name{
            title = safeTitle
        }
        if let stringColor = selectedCategory?.color {
            if let color = UIColor(hexString: stringColor){
                
                navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = color
                searchBar.barTintColor = color
                navigationController?.navigationBar.tintColor = ContrastColorOf(color, returnFlat: true)
                navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(color, returnFlat: true) ]
                addButton.tintColor = ContrastColorOf(color, returnFlat: true)
                print("sasas")
            }
        }
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
                    if let currentCategory = self.selectedCategory {
                        do{
                            try self.realm.write{
                                let newItem = Item()
                                newItem.title = safeTextField
                                newItem.done = false
                                newItem.date = Date()
                                currentCategory.items.append(newItem)
                                self.realm.add(newItem)
                            }
                        } catch{
                            print("error adding new item \(error)")
                        }
                    }
                    self.tableView.reloadData()
                    
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
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row]{
            cell.textLabel!.text = item.title
            if let categoryColorString = selectedCategory?.color {
                if let color = UIColor(hexString: categoryColorString){
                    cell.backgroundColor = color.darken(byPercentage: CGFloat(indexPath.row ) / CGFloat(items!.count ))
                    //cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                    cell.textLabel?.textColor = .white
                    cell.textLabel?.font = UIFont.init(name: "Helvetica-bold", size: 18)
                    
                }
                
                
            }
            
            
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel!.text = "No Item was added yet"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            } catch {
                print("Error changing done status, \(error)")
            }
        }
        tableView.reloadData()
    }
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title").sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        do{
            try self.realm.write{
                if let itemsSafe = self.items {
                    self.realm.delete(itemsSafe[indexPath.row])
                }
            }
        }catch{
            print("error deleting")
        }
    }
    
}

//MARK: - Search methods
extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        items = items?.filter( "title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "date", ascending: false)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}



