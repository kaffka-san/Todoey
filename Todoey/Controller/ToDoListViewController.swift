//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var items = [Item]()
    //let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        let newItem = Item(title: "Find Mike", done: false)
        items.append(newItem)
        let newItem2 = Item(title: "Find Mike", done: false)
        items.append(newItem2)
        self.loadItems()
        
        //   if let itemsSafe = defaults.object(forKey: "TodoListArray") as? [Item]{
        //   items = itemsSafe
        //}
        // Do any additional setup after loading the view.
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
                    let newItem = Item(title: safeTextField, done: false)
                    self.items.append(newItem)
                    print("saved")
                    self.saveItems()
                    
                    // trying User Deafaults. It's good only for small portion of data
                    //self.defaults.set(self.items, forKey: "TodoListArray")
                    
                   
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
        //print("\(items[indexPath.row])")
        items[indexPath.row].done = !items[indexPath.row].done
        saveItems()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // NS COder
    func saveItems(){
        let encoder = PropertyListEncoder()
        do {
            let data =  try encoder.encode(items)
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding")
        }
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([Item].self, from: data)
                
            } catch {
                print("Error decode")
            }
        }
        
    }
}


