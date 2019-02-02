# iOS Meme App developed in iOS Swift
## Overview

This app let's you pick photos from your device Photos collection and then add a top and bottom meme title.
Once you are done, the memes can be shared via the normal social media share options. All memes are stored in the app and can be edited.

## Getting Started
Open the .xcodeproject file in a recent version of XCode. Then clean, build and run on a device or emulator.

## Prerequisites
Apple Mac OSX laptop, XCode 8+

## Building
1. Double-click on the .xcodeproj or open the project from within XCode
2. In XCode IDE, select Produce / Clean and then Build from the top menu
3. Use the 'Play' (>) button to launch the app on a device or emulator

## Installing & Deployment
1. The program can be run immediately on an XCode simulator. 
2. In order to run the program on an actual Apple device, an Apple developer membership and a provisioning profile for the device is needed.

## Usage
1. When the app is started, select the plus (+) button on the top right to add a new Meme
2. On the Meme Editor page, select the bottom right picture button to add a picture from your Photos library or
3. select the bottom left camera button to take an ad hoc picture.
4. Click on the top and bottom title to add a Meme title.
5. Use the top left upload button to share the image or save it to your Photos library.
6. The new Meme is saved and can be displayed either in a list view or a colleciton view.

## Implementation
* We are using two View Controllers - one for a UITableView and one for a UICollectionView to display the data.
* The Memes are stored in the Meme model.
* The MemeEditorViewController is used to build the Meme. It uses the standard UIImagePickerController to get an image from either the camera or the photoLibrary.
* For the share action we are using a standard UIActivityViewController and passing the image to share.
* As temporary data storage, we are just using a Meme array in the AppDelegate. In the future, the app could be extended to use persistent data storage.

## Versioning
Version 1.0

## Authors
Christian Scheid - (https://justmobiledev.com)[https://justmobiledev.com]

## License
This project is licensed under the MIT License - see the LICENSE.md file for details

## Screenshots
![Meme 1](screenshots/meme-ss-1.png?raw=true "Meme 1")

![Meme 2](screenshots/meme-ss-2.png?raw=true "Meme 1")

![Meme 3](screenshots/meme-ss-3.png?raw=true "Meme 1")
