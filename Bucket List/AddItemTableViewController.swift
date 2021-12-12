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
    
    var itemEdit:String?
    var indexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTextField.text = itemEdit
  
    }

    @IBAction func CancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.CancelButtonPressed(by: self)
    }
    

    @IBAction func SaveButtonPressed(_ sender: UIBarButtonItem) {
        guard let text = itemTextField.text else {return}
        delegate?.ItemSaved(by: self, with :text ,at :indexPath)
    }
}
