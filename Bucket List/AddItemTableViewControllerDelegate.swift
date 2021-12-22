//
//  AddItemTableViewControllerDelegate.swift
//  Bucket List
//
//  Created by administrator on 12/12/2021.
//

import Foundation

protocol AddItemTableViewControllerDelegate: AnyObject {
    //MARK: For API
    func taskSaved(by controller: AddItemTableViewController, with objective:String , at indexPth : IndexPath?)
    //MARK: For CoreData
    func ItemSaved(by controller:AddItemTableViewController, with text:String , at indexPth : NSIndexPath?)
    func CancelButtonPressed(by controller : AddItemTableViewController)
    
    
    
}
