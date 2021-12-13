//
//  ViewController.swift
//  Bucket List
//
//  Created by administrator on 12/12/2021.
//

import UIKit
import CoreData

class BucketListViewController: UITableViewController , AddItemTableViewControllerDelegate {
   
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemList = [ItemListEntity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ItemSegue", sender: sender)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemListCell", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row].name
        
        return cell
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
//    }
//
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = itemList[indexPath.row]
        managedObjectContext.delete(item)
                
                do {
                    try managedObjectContext.save()
                   
                }catch{
                    print(error.localizedDescription)
                }
        itemList.remove(at: indexPath.row)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "ItemSegue", sender: indexPath)
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sender is UIBarButtonItem {
            
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
            addItemTableViewController.delegate = self
            
        }else if sender is IndexPath{
            
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
            addItemTableViewController.delegate = self
            
            guard let indexPath = sender as? NSIndexPath else{return}
            let item = itemList[indexPath.row]
            addItemTableViewController.itemEdit = item.name
            addItemTableViewController.indexPath = indexPath
            
        }
    }
    
    func fetchAllItems(){
            
            let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemListEntity")
            do {
                let results = try managedObjectContext.fetch(itemRequest)
                itemList = results as! [ItemListEntity]
            } catch {
                print("\(error)")
            }
            tableView.reloadData()
        }
    
    func ItemSaved(by controller: AddItemTableViewController, with text: String,  at indexPth : NSIndexPath? ) {
       
      
        
        if let editIndexPath = indexPth{
            
            let item = itemList[editIndexPath.row]
            item.name = text
          
        }else{
            
            let thing = NSEntityDescription.insertNewObject(forEntityName: "ItemListEntity", into: managedObjectContext) as! ItemListEntity
                        thing.name = text
            itemList.append(thing)
        }
        
        if managedObjectContext.hasChanges{
                    do {
                        try managedObjectContext.save()
                       
                    }catch{
                        print(error.localizedDescription)
                    }
                }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func CancelButtonPressed(by controller: AddItemTableViewController) {
        dismiss(animated: true, completion: nil)
    }
}

