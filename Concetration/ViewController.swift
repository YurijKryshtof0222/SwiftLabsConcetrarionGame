//
//  ViewContoller.swift
//  Concetration
//
//  Created by Admin on 02/11/2023.
//  Copyright © 2023 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var game:Game!
    var isDelayInProgress = false
    var compareCardView: CardView? = nil
    var cardsCount = 12
    
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pairCount = cardsCount / 2
        game = Game(count: pairCount)

        collectionView.dataSource = self
        collectionView.collectionViewLayout = configureLayout()
    }
    
    func configureLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.size.width / 3 - 3 ,
                                 height: collectionView.frame.size.height / 3 - 3)
        layout.minimumInteritemSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        return layout
    }
    
    func restart() {
        let pairCount = cardsCount / 2
        i = 0
        collectionView.dataSource = self
        
        game = Game(count: pairCount)
        for (index, indexPath) in collectionView.indexPathsForVisibleItems.enumerated() {
            if let cell = collectionView.cellForItem(at: indexPath) {
                if let cardView = cell.contentView as? CardView {
                    cardView.flip(cardView.btn)
                    cardView.configure(card: game.cards[index])
                }
            }
        }
        
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cardsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath)
        let cardView = cell.contentView as! CardView
        cardView.configure(card: game.cards[i])
        cardView.delegate = self
        i += 1
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

                self.restart()

        })

        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

}
