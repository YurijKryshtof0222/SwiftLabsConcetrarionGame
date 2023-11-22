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
    
    var game:CardsGenerator!
    var isDelayInProgress = false
    var compareCardView: CardView? = nil
//    var cardsCount = 12
    var gameConfig = GameCoinfig(rows: 3, cols: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pairCount = gameConfig.cardCount / 2
        game = CardsGenerator(count: pairCount)

        collectionView.dataSource = self
        collectionView.collectionViewLayout = configureLayout()
    }
    
    func configureLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.size.width / CGFloat(gameConfig.cols),
                                 height: collectionView.frame.size.height / CGFloat(gameConfig.rows))
        layout.minimumInteritemSpacing = Constants.cellSpacing
//        layout.minimumLineSpacing = Constants.cellSpacing
        
        return layout
    }
    
    func restart() {
        let pairCount = gameConfig.cardCount / 2
        collectionView.dataSource = self
        
        game = CardsGenerator(count: pairCount)
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

                self.restart()

        })

        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

}
