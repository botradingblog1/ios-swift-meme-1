# iOS Meme App developed in iOS Swift
## Overview

This app let's you pick photos from your device Photos collection and then add a top and bottom meme title.
Once you are done, the memes can be shared via the normal social media share options. All memes are stored in the app and can be edited.

## Implementation
* We are using two View Controllers - one for a UITableView and one for a UICollectionView to display the data.
* The Memes are stored in the Meme model
* The MemeEditorViewController is used to build the Meme. It uses the standard UIImagePickerController to get an image from either the camera or the photoLibrary.
* For the share action we are using a standard UIActivityViewController and passing the image to share.
* As temporary data storage, we are just using a Meme array in the AppDelegate. In the future, the app could be extended to use persistent data storage.

## Usage
1. When the app is started, select the plus (+) button on the top right to add a new Meme
2. On the Meme Editor page, select the bottom right picture button to add a picture from your Photos library or
3. select the bottom left camera button to take an ad hoc picture.
4. Click on the top and bottom title to add a Meme title.
5. Use the top left upload button to share the image or save it to your Photos library.
6. The new Meme is saved and can be displayed either in a list view or a colleciton view.

## Screenshots
![Meme 1](screenshots/meme-ss-1.png?raw=true "Meme 1")

![Meme 2](screenshots/meme-ss-2.png?raw=true "Meme 1")

![Meme 3](screenshots/meme-ss-3.png?raw=true "Meme 1")
