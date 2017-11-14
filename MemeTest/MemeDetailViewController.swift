//
//  MemeDetailViewController.swift
//  MemeTest
//
//  Created by Chris Scheid on 10/25/17.
//  Copyright © 2017 Chris Scheid. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    var meme: Meme!
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageView!.image = meme.combinedImage
    }
}

