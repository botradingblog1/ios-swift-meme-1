//
//  Meme.swift
//  MemeTest
//
//  Created by Chris Scheid on 10/7/17.
//  Copyright © 2017 Chris Scheid. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Meme class defintion
struct Meme {
    var topTextStr = ""
    var bottomTextStr = ""
    var originalImage: UIImage
    var combinedImage: UIImage
    
    init(topText: String, bottomText: String, orgImage: UIImage, memeImage: UIImage) {
        topTextStr = topText
        bottomTextStr = bottomText
        originalImage = orgImage
        combinedImage = memeImage
    }
}
