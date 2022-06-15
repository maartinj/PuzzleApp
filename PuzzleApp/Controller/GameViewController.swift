//
//  GameViewController.swift
//  PuzzleApp
//
//  Created by Marcin Jędrzejak on 03/01/2022.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var backGameButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var movesCountLabel: UILabel!
    
    @IBOutlet weak var playfieldOne: UICollectionView!
    @IBOutlet weak var playfieldTwo: UICollectionView!
    @IBOutlet weak var playfieldPopUp: UIImageView!
    
    //MARK: - Parameters
    
    var interactionCount: Int = 0
    var scoreData: Int = 0
    var indexPath: IndexPath?
    var imageRecieved = [UIImage]()
    var popUpImage = UIImage()
    var imageArrayOne :[UIImage]!
    var imageArrayTwo = [UIImage]()
    var mixedImages = [UIImage(named: "Gridy-lookup")]

    // To see -> https://www.youtube.com/watch?v=3TbdoVhgQmE&ab_channel=CodeWithCal
    var timer: Timer?
    var timePassed = 0
    
    //MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func newGameButtonPressed(_ sender: Any) {
        interactionCount = 0
        scoreData = 0
        movesCountLabel.text = "0"
        
        timePassed = -1
        loadPlayfields()
        
    }
    
    //MARK: - Setup Elements
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        newGameButton.modify()
        backGameButton.modify()
        self.setupTimerLabel()
        
        playfieldPopUp.image = popUpImage
        playfieldPopUp.isHidden = true
        loadPlayfields()
    }
    
    // MARK: - Load both playfields from scratch
    
    func loadPlayfields() {
        imageArrayOne = imageRecieved
        imageArrayOne.shuffle()
        playfieldOne.reloadData()
        for image in mixedImages {
            if let image = image {
                imageArrayOne.append(image)
            }
        }
        
        if imageArrayTwo.count >= 0 {
            if let blank = UIImage(named: "Placeholder2") {
                var temp = [UIImage]()
                for _ in imageRecieved {
                    temp.append(blank)
                }
                imageArrayTwo = temp
                playfieldTwo.reloadData()
            }
        }
    }
    
    //MARK: - Setup for Timer
    
    func setupTimerLabel() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }

    @objc func timerCounter() {
        timePassed += 1
        let time = secondsToHoursMinutesSeconds(seconds: timePassed)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
    }

    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }

    func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String {
        var timeString = ""
        timeString += String(format: "%01d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    //MARK: - Configure CollectionViews
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.playfieldOne ? imageArrayOne.count : imageArrayTwo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayfieldViewCollectionViewOne", for: indexPath) as! PlayfieldViewCVOne
        
        // CollectionView 1
        if collectionView == playfieldOne {
            let width = (playfieldOne.frame.size.width - 30) / 6
            let layout = playfieldOne.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: width)
            cell.playfieldViewCVOneImageView.image = imageArrayOne[indexPath.item]
            
        // CollectionView 2
        } else {
            let width = (playfieldTwo.frame.size.width - 10) / 4
            let layout = playfieldTwo.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: width)
            cell.playfieldViewCVOneImageView.image = imageArrayTwo[indexPath.item]
        }
        return cell
    }
    
    //MARK: - Setup for PopUpImage
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == (imageArrayOne.count - 1) {
            playfieldPopUp.isHidden = false
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.hidePopUpImage), userInfo: nil, repeats: false)
        }
    }
    
    @objc func hidePopUpImage() {
        playfieldPopUp.isHidden = true
    }
    
}

    // MARK: - Drop and drag
extension GameViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIDropInteractionDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        self.indexPath = indexPath
        let item: UIImage
        let image = imageArrayOne[indexPath.item]
        if (image == mixedImages.last) || (image == mixedImages.first) {
            return []
        }
        if collectionView == playfieldOne {
            item = image
        } else {
            item = (self.imageArrayTwo[indexPath.row])
        }
        let itemProvider = NSItemProvider(object: item as UIImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if destinationIndexPath?.row == 16 || destinationIndexPath?.row == 17 {
            return UICollectionViewDropProposal(operation: .forbidden)
        } else if collectionView === playfieldTwo {
            return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
        } else if collectionView === playfieldOne && playfieldTwo.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let dip: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            dip = indexPath
        } else {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            dip = IndexPath(row: row, section: section)
        }
        if dip.row == 16 || dip.row == 17 {
            return
        }
        if collectionView === playfieldTwo {
            moveItems(coordinator: coordinator, destinationIndexPath: dip, collectionView: collectionView)
        } else if collectionView === playfieldOne {
            return
        }
    }
    
    // Drop and drag interactions
    private func moveItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        let items = coordinator.items
        updateInteractionCount(interactionData: interactionCount + 1) // total touches
        collectionView.performBatchUpdates({
            let dragItem = items.first!.dragItem.localObject as! UIImage
            if dragItem === imageRecieved[destinationIndexPath.item] {
                scoreData += 1
                self.imageArrayTwo.insert(items.first!.dragItem.localObject as! UIImage, at: destinationIndexPath.row)
                playfieldTwo.insertItems(at: [destinationIndexPath])
                if let selected = indexPath {
                    imageArrayOne.remove(at: selected.row)
                    if let temp = UIImage(named: "Placeholder2") {
                        let blank = temp
                        imageArrayOne.insert(blank, at: selected.row)
                    }
                    playfieldOne.reloadData()
                }
            }
        })
        collectionView.performBatchUpdates({
            if items.first!.dragItem.localObject as! UIImage === imageRecieved[destinationIndexPath.item] {
                self.imageArrayTwo.remove(at: destinationIndexPath.row + 1)
                let nextIndexPath = NSIndexPath(row: destinationIndexPath.row + 1, section: 0)
                playfieldTwo.deleteItems(at: [nextIndexPath] as [IndexPath])
            } else {
                
            }
        })
        coordinator.drop(items.first!.dragItem, toItemAt: destinationIndexPath)
        if scoreData == imageArrayTwo.count {
            winTheGamePuzzle()
        }
    }
}


    // MARK: - Scoring
extension GameViewController {
    func updateInteractionCount(interactionData: Int) {
        self.interactionCount += 1
        movesCountLabel.text = "\(interactionData)"
    }
    
    private func winTheGamePuzzle() {
        timePassed = -1
        timer?.invalidate()
        timer = nil
        
        newGameButton.isEnabled = false
        newGameButton.backgroundColor = .white
        
        winAlert(title: "Great game! 🎉🎉🎉", message: "Congratulations! You have successfully completed this puzzle! Your score is: \(interactionCount)")
    }
    
    /// Popup an win message
    ///
    /// - Parameter message: Description of the issue
    func winAlert(title: String?, message: String?) {
      let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "Cancel", style: .cancel)
      alertController.addAction(alertAction)
      present(alertController, animated: true)
    }
}
