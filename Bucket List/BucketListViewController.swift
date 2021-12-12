//
//  ViewController.swift
//  Bucket List
//
//  Created by administrator on 12/12/2021.
//

import UIKit

class BucketListViewController: UITableViewController , AddItemTableViewControllerDelegate {
   
    

    var itemList:[String]=[String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemList.append("Go shopping 1")
        itemList.append("Go to the moon")
        itemList.append("Go the mall")
     
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemListCell", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row]
        
        return cell
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
//    }
//
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        itemList.remove(at: indexPath.row)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddItemSegue"{
            
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
            addItemTableViewController.delegate = self
            
        }else if segue.identifier == "EditItemSegue"{
            
            let navigationController = segue.destination as! UINavigationController
            let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
            addItemTableViewController.delegate = self
            
            guard let indexPath = sender as? NSIndexPath else{return}
            let item = itemList[indexPath.row]
            addItemTableViewController.itemEdit = item
            addItemTableViewController.indexPath = indexPath
            
        }
    }
    

    func ItemSaved(by controller: AddItemTableViewController, with text: String,  at indexPth : NSIndexPath? ) {
        
        if let editIndexPath = indexPth{
            
            itemList[editIndexPath.row] = text
            
        }else{
            
            itemList.append(text)
        }
       
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func CancelButtonPressed(by controller: AddItemTableViewController) {
        dismiss(animated: true, completion: nil)
    }
}

