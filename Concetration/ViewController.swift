//
//  ViewContoller.swift
//  Concetration
//
//  Created by Admin on 02/11/2023.
//  Copyright © 2023 Admin. All rights reserved.
//

import UIKit

struct Constants {
    static let delayDuration: TimeInterval = 1.5
    static let cellSpacing: CGFloat = 0.1
}

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pauseBtn: UIButton!
    
    var game:CardsGenerator!
    var isDelayInProgress = false
    var compareCardView: CardView? = nil
//    var cardsCount = 12
    var gameConfig = GameConfig(rows: 4, cols: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pauseBtn.addTarget(self, action: #selector(pauseBtnAction), for: .touchUpInside)
        
        let pairCount = gameConfig.cardCount / 2
        game = CardsGenerator(count: pairCount)

        collectionView.dataSource = self
        collectionView.collectionViewLayout = configureLayout()
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
            textField.placeholder = "Enter rows: "
            textField.keyboardType = .numberPad
            textField.delegate = self
        }
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Enter cols: "
            textField.keyboardType = .numberPad
            textField.delegate = self
        }
        
        let errorAlert = UIAlertController(
            title: "Error",
            message: "Count of card cannot be odd",
            preferredStyle: .alert)
        errorAlert.addAction(continueAction)
                              
        
        let restartAction = UIAlertAction(
            title: "Restart",
            style: .default,
            handler: {
                action in
                let setRows = Int(alertController.textFields![0].text!)
                let setCols = Int(alertController.textFields![1].text!)
                
                if (setRows! * setCols!) % 2 != 0 {
                    self.present(errorAlert, animated: true, completion: nil)
                }
                else {
                    self.restart(rows: setRows!, cols: setCols!)
                }
        })
        alertController.addAction(continueAction)
        alertController.addAction(restartAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func configureLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:  collectionView.frame.size.width / CGFloat(gameConfig.cols) - CGFloat(gameConfig.cols),
                                 height: collectionView.frame.size.height / CGFloat(gameConfig.rows) - CGFloat(gameConfig.rows))
        layout.minimumInteritemSpacing = Constants.cellSpacing
//        layout.minimumLineSpacing = Constants.cellSpacing
        
        return layout
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
        
        collectionView.dataSource = self
        collectionView.collectionViewLayout = configureLayout()
        collectionView.reloadData()
        
        game = CardsGenerator(count: pairCount)
    }

}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "123456789")
        let replacementStringCharacterSet = CharacterSet(charactersIn: string)

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
