//
//  ViewController.swift
//  Bucket List
//
//  Created by administrator on 12/12/2021.
//

import UIKit
import CoreData

class BucketListViewController: UITableViewController , AddItemTableViewControllerDelegate {

    
    //MARK: CoreData
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemList = [ItemListEntity]()
    
    //MARK: API
    var task:[TaskResult]?

    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: API
        self.getDataFromAPI()
        
        //MARK: CoreData
       // fetchAllItemsCoreData()
        
    }
   
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ItemSegue", sender: sender)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemListCell", for: indexPath)
        cell.textLabel?.text = task?[indexPath.row].objective
        
        return cell
    }
    
   
    //MARK: Edit Functionality
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //MARK: CoreData
      // deleteItemCoreData(IndexPath: indexPath)
        //MARK: API
        guard let item = task?[indexPath.row].id  else { return }
        TaskModel.deleteTaskWithObjective(id: item, completionHandler:  {
                    // see: Swift closure expression syntax
                    data, response, error in
                    
                    print("in here DELETE")
                    print(data ?? "no data DELETE")
                   

                        DispatchQueue.main.async {
                            self.task = self.getDataFromAPI()
                            self.tableView.reloadData()
                        }
                        
                    
                })
                tableView.dataSource = self
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "ItemSegue", sender: indexPath)
    
    }
    //MARK: If we are using two seques
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
//    }
//
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
        addItemTableViewController.delegate = self
       
        if let sender = sender as? IndexPath {
                  
            addItemTableViewController.itemEdit = task?[sender.row].objective
            addItemTableViewController.indexPath = sender
            
              }
    }
    //MARK: CoreData
    func fetchAllItemsCoreData(){
            
            let itemRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemListEntity")
            do {
                let results = try managedObjectContext.fetch(itemRequest)
                itemList = results as! [ItemListEntity]
            } catch {
                print("\(error)")
            }
            tableView.reloadData()
        }
    
    func passDataToEditItemCoreData(for segue: UIStoryboardSegue, sender: Any?){
        //Table Row is tapped
        let navigationController = segue.destination as! UINavigationController
        let addItemTableViewController = navigationController.topViewController as! AddItemTableViewController
        addItemTableViewController.delegate = self
        
        guard let indexPath = sender as? NSIndexPath else{return}
        let item = itemList[indexPath.row]
        addItemTableViewController.itemEdit = item.name
        addItemTableViewController.indexPathCD = indexPath
    }
    func deleteItemCoreData(IndexPath indexPath:IndexPath){
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
    func  saveEditItemCoreData(by controller: AddItemTableViewController, with text: String,  at indexPth : NSIndexPath?){
        if let editIndexPath = indexPth{
            //edit core data
            let item = itemList[editIndexPath.row]
            item.name = text
          
        }else{
            //Save to coredata
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
    //MARK: API
    func getDataFromAPI() -> [TaskResult] {
            var jsonResult = [TaskResult]()
        
            TaskModel.getAllTasks(completionHandler: {
                // see: Swift closure expression syntax
                data, response, error in
                print("in here get")
                
                // see: Swift nil coalescing operator (double questionmark)
                print(data ?? "no data get") // the "no data" is a default value to use if data is nil
                
                guard let myData = data else { return }
                do {
                    
                    let decoder = JSONDecoder()
                    jsonResult = try decoder.decode([TaskResult].self, from: myData)
                    
                    DispatchQueue.main.async {
                        self.task = jsonResult
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            })
         
        
            tableView.dataSource = self
            
            return jsonResult
        }
    func postData(objective: String) {
            
            TaskModel.addTaskWithObjective(objective: objective , completionHandler:  {
                
                // see: Swift closure expression syntax
                data, response, error in
                print("in here Post ")
                
                // see: Swift nil coalescing operator (double questionmark)
                print(data ?? "no data Post") // the "no data" is a default value to use if data is nil
                
                guard let myData = data else { return }
                do {
                    
                    let realData = try JSONDecoder().decode(TaskResult.self, from: myData)
                    print(realData)
                    DispatchQueue.main.async {
                        self.task = self.getDataFromAPI()
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print(error)
                }
            })
            tableView.dataSource = self
        }
    //MARK: Delegate Funnctions
    //MARK: Delegate Funnctions-API
    func taskSaved(by controller: AddItemTableViewController, with objective: String, at indexPth: IndexPath?) {
        if let editIndexPath = indexPth {
                   
                   guard var item = task?[editIndexPath.row] else {return}
                   item.objective = objective
                   
                   TaskModel.updateTaskWithObjective(id: item.id , objective: objective , completionHandler:  {
                   
                                   data, response, error in
                                   print("in here Edit ")
               
                                   print(data ?? "no data Edit")
                       guard let myData = data else { return }
                       do {
            
                           let realData = try JSONDecoder().decode(TaskResult.self, from: myData)
                           DispatchQueue.main.async {
                               self.task?[editIndexPath.row] = realData
                               self.tableView.reloadData()
                           }
                           
                       } catch {
                           print(error)
                       }
                 
                               })
                       }else{

                           postData(objective: objective)
                           
                       }
               tableView.dataSource = self
    }
    //MARK: Delegate Funnctions-CoreData
    func ItemSaved(by controller: AddItemTableViewController, with text: String,  at indexPth : NSIndexPath? ) {
        //MARK: save/edit item with coredata
        //saveEditItemCoreData(by: controller, with: text, at: indexPth)
      
    }
    
    func CancelButtonPressed(by controller: AddItemTableViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

