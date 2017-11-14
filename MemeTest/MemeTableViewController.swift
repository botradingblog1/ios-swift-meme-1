//
//  MemeHistoricListViewController.swift
//  MemeTest
//
//  Created by Chris Scheid on 10/16/17.
//  Copyright © 2017 Chris Scheid. All rights reserved.
//

import Foundation
import UIKit


class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    let cellReuseIdentifier = "MemeTableCellIdentifier"
    var memes: [Meme]! = nil
    var selectedMeme: Meme! = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life-cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the TableView delegate
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Get shared Meme array from AppDelegate
        memes = appDelegate.memes
        
        // Reload tableview
        if memes != nil && memes.count > 0 {
            tableView.reloadData()
        }
    }
    
    // MARK: Get the row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Implement method to return the correct number of rows.
        if memes == nil {
            return 0;
        }
        else {
            return memes.count
        }
    }
    
    // MARK: Create new cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Create a custom table cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MemeTableViewCell
        
        // Set the properties
        cell.title?.text = memes[indexPath.row].topTextStr + " - "+memes[indexPath.row].bottomTextStr;
        cell.memeImage?.image = memes[indexPath.row].combinedImage;
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get selected Meme
        selectedMeme = memes[indexPath.row]
        
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeDetailVC = storyboard.instantiateViewController(withIdentifier: "MemeDetailViewController")as! MemeDetailViewController
        
        // Push the detail VC
        memeDetailVC.meme = selectedMeme
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    // MARK: IBActions
    @IBAction func OnAddButtonClicked(_ sender: Any) {
        
        // Push the Editor VC
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController")as! MemeEditorViewController
        
        // Push
        navigationController?.pushViewController(memeEditorVC, animated: true)
    }
    
    @IBAction func OnEditButtonClicked(_ sender: Any) {
        // Check if a Meme was selected
        if selectedMeme == nil
        {
            // Show warning
            let alertController = UIAlertController(title: "Alert", message:
                "Please select a Meme before using the Edit button", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        // Push the Editor VC
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeEditorVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController")as! MemeEditorViewController
        
        // Set the selected Meme
        memeEditorVC.editMeme = selectedMeme
        
        // Push
        navigationController?.pushViewController(memeEditorVC, animated: true)
    }
}
