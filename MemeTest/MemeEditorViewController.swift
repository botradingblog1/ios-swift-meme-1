//
//  ViewController.swift
//  MemeTest
//
//  Created by Chris Scheid on 10/6/17.
//  Copyright © 2017 Chris Scheid. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate  {
    
    // MARK: Properties
    private var isTopTextField = false
    private var memeImage: UIImage!
    public var editMeme: Meme! = nil
    
    // MARK: - Outlet definitions
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: - ViewController life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // In case of edit action, load the meme
        if editMeme != nil
        {
            // Set top and bottom text fields
            prepareTextField(textField: topTextField, defaultText:editMeme.topTextStr)
            prepareTextField(textField: bottomTextField, defaultText:editMeme.bottomTextStr)
            // Set the image
            imageView.image = editMeme.originalImage
        }
        else {
            // New Meme
            prepareTextField(textField: topTextField, defaultText:"TOP")
            prepareTextField(textField: bottomTextField, defaultText:"BOTTOM")
            
            // Disable share button until an image is selected
            shareButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - UI Control functions
    func prepareTextField(textField: UITextField, defaultText: String) {
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "impact", size: 38)!,
            NSStrokeWidthAttributeName: -3.0]
        
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        // Clear the text field
        textField.text = "";
        isTopTextField = false
        if textField == topTextField{
            isTopTextField = true
        }
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // hide the keyboard
        textField.resignFirstResponder();
        return true;
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        shareButton.isEnabled = true
        
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        shareButton.isEnabled = false
        
        self.dismiss(animated: true)
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, orgImage: imageView.image!, memeImage: memeImage)
        
        // Add Meme to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Event Handling
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        // Don't move the top text field up
        if isTopTextField { return }
        
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if isTopTextField { return }
        
        view.frame.origin.y = 0
    }

    // MARK: - IBAction definitions    
    @IBAction func cancelButtonAction(_ sender: Any) {
        // Reset to initial state
        imageView.image = nil;
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        // disable share button
        shareButton.isEnabled = false
        
        // Navigate back to Sent Memes
        self.navigationController?.popToRootViewController(animated: true)

    }
    @IBAction func cameraButtonAction(_ sender: Any) {
        pickImage(sourceType: .camera)
    }

    @IBAction func albumButtonAction(_ sender: Any) {
        pickImage(sourceType: .photoLibrary)
    }
    
    func pickImage(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    

    @IBAction func shareButtonAction(_ sender: Any) {
        // Generate the Meme
        memeImage = generateMemedImage()
        
        let imageToShare = [ memeImage! ]
        let activityVC = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityVC.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityVC, animated: true, completion: nil)
        
        // Register completion handler
        activityVC.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed {
                // Save the Meme
                self.save()
                
            }
        }
    }
    
    // MARK: - Utility functions
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
        
        //navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Hide bottom buttons
        cameraButton.isHidden = true
        albumButton.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let composedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Show bottom buttons
        cameraButton.isHidden = false
        albumButton.isHidden = false
        
        return composedImage
    }
}

