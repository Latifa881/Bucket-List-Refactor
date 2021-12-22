//
//  AddItemTableViewController.swift
//  Bucket List
//
//  Created by administrator on 12/12/2021.
//

import UIKit

class AddItemTableViewController: UITableViewController {
    
    @IBOutlet weak var itemTextField: UITextField!
    weak var delegate: AddItemTableViewControllerDelegate?
    //MARK: API
    var task: [TaskResult]?
    var currentTask: TaskResult?
    
    var itemEdit:String?
    //MARK: CoreData
    var indexPathCD: NSIndexPath?
    //MARK: API
    var indexPath: IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTextField.text = itemEdit
  
    }

    @IBAction func CancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.CancelButtonPressed(by: self)
    }
    

    @IBAction func SaveButtonPressed(_ sender: UIBarButtonItem) {
        
        guard let text = itemTextField.text else {return}
        //MARK: CoreData
        //delegate?.ItemSaved(by: self, with :text ,at :indexPathCD)
        //MARK: API
        delegate?.taskSaved(by: self, with : text ,at : indexPath)
        dismiss(animated: true, completion: nil)
        
    }
}
