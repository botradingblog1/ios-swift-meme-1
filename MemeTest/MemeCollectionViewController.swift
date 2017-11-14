//
//  MemeHistoricCollectionViewController.swift
//  MemeTest
//
//  Created by Chris Scheid on 10/16/17.
//  Copyright © 2017 Chris Scheid. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    let reuseIdentifier = "MemeColCellIdentifier"
    var memes: [Meme]! = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isPortrait: Bool = true
    var selectedMeme: Meme! = nil
    var isShowing: Bool = false
    
    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: Life-cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the CollectionView delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let viewSize = CGSize(width:view.frame.size.width, height:view.frame.size.height);
        updateLayoutWithOrientation(viewSize: viewSize)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isShowing = true;
        
        // Get shared Meme array from AppDelegate
        memes = appDelegate.memes
        
        // Reload collection view
        if memes != nil && memes.count > 0 {
            collectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isShowing = false
    }
    
    func resizeCollectionItems( viewSize: CGSize, rows: CGFloat, columns: CGFloat){

        let space:CGFloat = 3.0
        let widthDimension = (viewSize.width - (2 * space)) / columns
        let heightDimension = (viewSize.height - (2 * space)) / rows
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
        
        // Trigger redrawing layout
        flowLayout.invalidateLayout()

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        updateLayoutWithOrientation(viewSize: size);
    }
    
    func updateLayoutWithOrientation(viewSize: CGSize){
        // Is the collection view showing?
        if !isShowing { return }
        
        // trigger layout change
        flowLayout.invalidateLayout()
        if UIDevice.current.orientation.isLandscape {
            resizeCollectionItems(viewSize: viewSize, rows: 3, columns: 6);
        } else {
            resizeCollectionItems(viewSize: viewSize, rows: 6, columns: 3);
        }
    }
    
    // MARK: Number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: Number of items in section
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if memes == nil {
            return 0;
        }
        else {
            return memes.count
        }
    }
    
    // MARK: Create new cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Create a custom table cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,for: indexPath) as! MemeCollectionViewCell
        
        // Set the properties
        cell.memeImage?.image = memes[indexPath.row].combinedImage;
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get selected Meme
        selectedMeme = memes[indexPath.row]
        
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeDetailVC = storyboard.instantiateViewController(withIdentifier: "MemeDetailViewController")as! MemeDetailViewController
        
        // Push the detail VC
        memeDetailVC.meme = selectedMeme
        navigationController?.pushViewController(memeDetailVC, animated: true)
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        // Get the oriantation
        switch UIDevice.current.orientation{
            case .portrait:
                isPortrait = true;
            case .portraitUpsideDown:
                isPortrait = true;
            case .landscapeLeft:
                isPortrait = false;
            case .landscapeRight:
                isPortrait = false;
            default:
                 isPortrait = true;
        }
    }
    
    // IB Actions
    @IBAction func onAddButtonClicked(_ sender: Any) {
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
