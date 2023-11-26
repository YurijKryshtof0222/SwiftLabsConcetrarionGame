//
//  ViewContoller.swift
//  Concetration
//
//  Created by Admin on 02/11/2023.
//  Copyright © 2023 Admin. All rights reserved.
//

import UIKit

enum Constants {
    static let delayDuration: TimeInterval = 1.0
    static let cellSpacing: CGFloat = 0.5
    static let lineSpacing: CGFloat = 5
    
    static let defaultRowCount = 4
    static let defaultColCount = 3
}

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pauseBtn: UIButton!
    
    var game:CardsGenerator!
    var isDelayInProgress = false
    var compareCardView: CardView? = nil
    var gameConfig = GameConfig(rows: Constants.defaultRowCount, cols: Constants.defaultColCount)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pauseBtn.addTarget(self, action: #selector(pauseBtnAction), for: .touchUpInside)
        
        let pairCount = gameConfig.cardCount / 2
        game = CardsGenerator(count: pairCount)

        collectionView.dataSource = self
        collectionView.collectionViewLayout = configureLayout()
    }
    
    func configureLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = calculateItemSize()
        layout.minimumInteritemSpacing = Constants.cellSpacing
//        layout.minimumLineSpacing = Constants.lineSpacing
        
        return layout
    }
    
    func calculateItemSize() -> CGSize {
        let width  = collectionView.frame.size.width / CGFloat(gameConfig.cols) - CGFloat(gameConfig.cols)
        let height = collectionView.frame.size.height / CGFloat(gameConfig.rows) - CGFloat(gameConfig.cols)
        return CGSize(width: width, height: height)
    }
    
    func restart(rows: Int, cols: Int) {
        gameConfig = GameConfig(rows: rows, cols: cols)
        compareCardView = nil
        let pairCount = gameConfig.cardCount / 2
        
        for (index, indexPath) in collectionView.indexPathsForVisibleItems.enumerated() {
            if let cell = collectionView.cellForItem(at: indexPath) {
                if let cardView = cell.contentView as? CardView {
                    if cardView.card.isFaceUp {
                        cardView.flip(cardView.btn)
                        cardView.card.isFaceUp = false
                    }
                    cardView.configure(card: game.cards[index])
                }
            }
        }
        game = CardsGenerator(count: pairCount)

        collectionView.dataSource = self
        collectionView.collectionViewLayout = configureLayout()
        collectionView.reloadData()
    }
    
    
    
    @objc func pauseBtnAction(sender: UIButton!) {
        let alertController = UIAlertController(
            title: "Pause",
            message: "Game is stopped",
            preferredStyle: .alert)
        
        let continueAction = UIAlertAction(
            title: "Continue",
            style: .default,
            handler: {
                action in
        })
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Enter rows(from 2 to 5): "
            textField.keyboardType = .numberPad
            textField.delegate = self
        }
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Enter cols(from 2 to 5): "
            textField.keyboardType = .numberPad
            textField.delegate = self
        }
        
        let errorAlert = UIAlertController(
            title: "Oops!",
            message: "Count of card must be even",
            preferredStyle: .alert)
        errorAlert.addAction(continueAction)
                              
        
        let restartAction = UIAlertAction(
            title: "Restart",
            style: .default,
            handler: {
                action in
                let setRows = Int(alertController.textFields![0].text!) ?? 1
                let setCols = Int(alertController.textFields![1].text!) ?? 1
                
                if (setRows * setCols) % 2 != 0 {
                    self.present(errorAlert, animated: true, completion: nil)
                }
                else {
                    self.restart(rows: setRows, cols: setCols)
                }
        })
        alertController.addAction(continueAction)
        alertController.addAction(restartAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showYouWinAlert() {
        let alertController = UIAlertController(
            title: "",
            message: "You won",
            preferredStyle: .alert)

        let action = UIAlertAction(
            title: "Restart",
            style: .default,
            handler: {
                action in

                self.restart(rows: self.gameConfig.rows, cols: self.gameConfig.cols)
        })

        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "2345")
        let replacementStringCharacterSet = CharacterSet(charactersIn: string)
        
        if (textField.text!.count <= 2) {
            textField.deleteBackward()
        }
    
        return allowedCharacterSet.isSuperset(of: replacementStringCharacterSet)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gameConfig.cardCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath)
        
        let cardView = cell.contentView as! CardView
        cardView.layer.cornerRadius = 5
        cardView.layer.masksToBounds = true
        
        let card = game.cards[indexPath.item]
        cardView.configure(card: card)
        cardView.delegate = self

        return cell
    }

}


extension ViewController: CardViewDelegate {
    func click(sender: CardView) {
        if isDelayInProgress || sender.card.isFaceUp {
            return
        }
        sender.flip(sender.btn)

        if compareCardView == nil {
            compareCardView = sender
        } else {
            if sender.card.img != compareCardView?.card.img {
                isDelayInProgress = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.compareCardView?.flip(self.compareCardView!.btn)
                    sender.flip(sender.btn)
                    self.compareCardView = nil

                    self.isDelayInProgress = false
                }
            } else {
                sender.card.isMatched = true
                self.compareCardView?.card.isMatched = true
                self.compareCardView = nil
                game.matchedCount += 1
            }
        }

        if game.matchedCount == game.cardsCount {
            showYouWinAlert()
        }
    }
    
}
