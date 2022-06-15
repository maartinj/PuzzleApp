//
//  ChooseSourceViewController.swift
//  PuzzleApp
//
//  Created by Marcin Jędrzejak on 28/12/2021.
//

import UIKit
import AVFoundation
import Photos

class ChooseSourceViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    
    
    //MARK: - Parameters
    
    var imagePieces: [UIImage]!
    var screenshotImage = UIImage()
    
    var picker = UIImagePickerController()
    var libraryImage: UIImage?
    var cameraImage: UIImage?
    
    var imagesArray: [UIImage] = [
        UIImage(named: "IMG_0001")!,
        UIImage(named: "IMG_0002")!,
        UIImage(named: "IMG_0003")!,
        UIImage(named: "IMG_0004")!,
        UIImage(named: "IMG_0005")!,
        UIImage(named: "IMG_0006")!
    ]
    
    //MARK: - IBActions
    
    @IBAction func cameraPressed(_ sender: Any) {
        displayCamera()
    }
    
    @IBAction func libraryPressed(_ sender: Any) {
        displayLibrary()
    }
    
    //MARK: - Setup Elements
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        picker.delegate = self
        
        cameraButton.modify()
        libraryButton.modify()
    }
    
    // MARK: - Access camera
    
    /// Ask the user the authorization to use the camera.
    /// User can redirect to Settings if authorization not granted.
    /// Call Image Picker if authorization has already been granted.
    ///
    /// - Parameters:
    ///   - status: Authorization status to use Camera
    ///   - noPermissionMessage: Message to display if authorization not granted
    func displayCamera() {
        let sourceType = UIImagePickerController.SourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            let noPermissionMessage = "Gridy is not able to access your camera! Please check your settings."
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {(granted) in
                    if granted {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionMessage)
            @unknown default:
                fatalError(noPermissionMessage)
            }
        } else {
            troubleAlert(message: "it looks like we can't access the camera. Please try again later.")
        }
    }
    
    // MARK: - Access library
    
    /// Ask the user the authorization to use the photo library.
    /// User can redirect to Settings if authorization not granted.
    /// Call Image Picker if authorization has already been granted.
    ///
    /// - Parameters:
    ///   - status: Authorization status to use PhotoLibrary
    ///   - noPermissionMessage: Message to display if authorization not granted
    func displayLibrary() {
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let status = PHPhotoLibrary.authorizationStatus()
            let noPermissionStatusMessage = "Gridy is not able to access the Photo Library! Please check your settings."
            switch status {
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    if newStatus == .authorized {
                        self.presentImagePicker(sourceType: sourceType)
                    } else {
                        self.troubleAlert(message: noPermissionStatusMessage)
                    }
                })
            case .authorized:
                self.presentImagePicker(sourceType: sourceType)
            case .denied, .restricted:
                self.troubleAlert(message: noPermissionStatusMessage)
            @unknown default:
                self.presentImagePicker(sourceType: sourceType)
            }
        } else {
            troubleAlert(message: "Sincere apologise, it looks like we can't access your photo library at this time")
        }
    }
    
    ///   User can go the Settings from here if wanted
    ///
    /// - Parameter message: Description about why user needs to go to Settings
    //    func openSettingsWithUIAlert(message: String?) {
    //      let alertController = UIAlertController (title: "Oops...", message: message, preferredStyle: .alert)
    //
    //      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    //      let settingsAction = UIAlertAction.init(title: "Settings", style: .default) {
    //        _ in
    //        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString)
    //          else { return }
    //        if UIApplication.shared.canOpenURL(settingsUrl) {
    //          UIApplication.shared.open(settingsUrl, completionHandler: nil)
    //        }
    //      }
    //
    //      alertController.addAction(cancelAction)
    //      alertController.addAction(settingsAction)
    //
    //      present(alertController, animated: true, completion: nil)
    //    }
    
    // MARK: - Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameViewControllerSegue" {
            let gameVC = segue.destination as! GameViewController
            gameVC.imageRecieved = self.imagePieces
            gameVC.popUpImage = self.screenshotImage
        }
    }
}

extension ChooseSourceViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionviewcellid", for: indexPath) as? CollectionViewCell {
            cell.imageView.image = imagesArray[indexPath.item]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            //            print("I'm tapping the \(indexPath.item)")
            
            let chosenPictureAlert = UIAlertController(title: "Chosen picture", message: "Do you want to use this photo?", preferredStyle: .alert)
            chosenPictureAlert.customImageAlert(image: cell.imageView.image!)
            chosenPictureAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            chosenPictureAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] (_) in
                
                let alert = UIAlertController(title: "Camera image?", message: "This image is created from Your camera?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                    //Yes Action
                    let tmpImages = self.slice(screenshot: cell.imageView.image!, into: 4)
                    
                    var newImages: [UIImage] = []
                    newImages.append(tmpImages[12])
                    newImages.append(tmpImages[8])
                    newImages.append(tmpImages[4])
                    newImages.append(tmpImages[0])
                    newImages.append(tmpImages[13])
                    newImages.append(tmpImages[9])
                    newImages.append(tmpImages[5])
                    newImages.append(tmpImages[1])
                    newImages.append(tmpImages[14])
                    newImages.append(tmpImages[10])
                    newImages.append(tmpImages[6])
                    newImages.append(tmpImages[2])
                    newImages.append(tmpImages[15])
                    newImages.append(tmpImages[11])
                    newImages.append(tmpImages[7])
                    newImages.append(tmpImages[3])
                    
                    self.imagePieces = newImages
                    self.screenshotImage = cell.imageView.image!
                    self.performSegue(withIdentifier: "GameViewControllerSegue", sender: self)
                }))
                alert.addAction(UIAlertAction(title: "No",
                                              style: .default,
                                              handler: {(_: UIAlertAction!) in
                    //No Action
                    self.imagePieces = self.slice(screenshot: cell.imageView.image!, into: 4)
                    self.screenshotImage = cell.imageView.image!
                    self.performSegue(withIdentifier: "GameViewControllerSegue", sender: self)
                }))
                self.present(alert, animated: true, completion: nil)
            } ))
            self.present(chosenPictureAlert, animated: true, completion: nil)
        }
    }
}

// MARK: - ImagePicker
extension ChooseSourceViewController: UIImagePickerControllerDelegate {
    /// Present image picker
    ///
    /// - Parameter sourceType: Camera or photo library
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        dismiss(animated: true, completion: nil)
        
        imagesArray.append(newImage)
        collectionView.reloadData()
        troubleAlert(message: "Picture added to the list!")
        //        print("Added")
    }
}

// MARK: - Helper methods
extension ChooseSourceViewController {
    
    /// Slice image - Slice image into puzzle pieces
    ///
    /// - Parameters:
    ///   - image: The original image.
    ///   - howMany: How many rows/columns to slice the image up into.
    ///
    /// - Returns: An array of images.
    ///
    /// - Note: The order of the images that are returned will correspond
    ///         to the `imageOrientation` of the image. If the image's
    ///         `imageOrientation` is not `.up`, take care interpreting
    ///         the order in which the tiled images are returned.
    func slice(screenshot: UIImage, into howMany: Int) -> [UIImage] {
        let width: CGFloat
        let height: CGFloat
        
        switch screenshot.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = screenshot.size.height
            height = screenshot.size.width
        default:
            width = screenshot.size.width
            height = screenshot.size.height
        }
        
        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))
        
        let scale = Int(screenshot.scale)
        var images = [UIImage]()
        let cgImage = screenshot.cgImage!
        
        var adjustedHeight = tileHeight
        
        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCGImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCGImage, scale: screenshot.scale, orientation: screenshot.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }
    
    /// Popup an alert message
    ///
    /// - Parameter message: Description of the issue
    func troubleAlert(message: String?) {
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Got it", style: .cancel)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}
