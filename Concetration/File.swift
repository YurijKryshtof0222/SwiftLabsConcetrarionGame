//
//  File.swift
//  Concetration
//
//  Created by Admin on 19/11/2023.
//  Copyright © 2023 Admin. All rights reserved.
//

import Foundation

//class ViewController: UIViewController {
    
//    var game:Game!
//    var isDelayInProgress = false
//    @IBOutlet var cardViews: [CardView]!
//    var compareCardView: CardView? = nil
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let pairCount = cardViews.count / 2
//        game = Game(count: pairCount)
//        loadIcons()
//    }
    
//    func loadIcons () {
//        for (index, card) in game.cards.enumerated() {
//            cardViews[index].configure(card: card)
//            cardViews[index].delegate = self
//        }
//    }
//
//    func restart() {
//        let pairCount = cardViews.count / 2
//        for x in cardViews {
//            x.flip(x.btn)
//        }
//        game = Game(count: pairCount)
//        loadIcons()
//    }
//}

//extension ViewController: CardViewDelegate {
//    func click(sender: CardView) {
//        guard !isDelayInProgress else {
//            return
//        }
//        sender.flip(sender.btn)
//
//        if compareCardView == nil {
//            compareCardView = sender
//        } else {
//            if sender.card.img != compareCardView?.card.img {
//                isDelayInProgress = true
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    self.compareCardView?.flip(self.compareCardView!.btn)
//                    sender.flip(sender.btn)
//                    self.compareCardView = nil
//
//                    self.isDelayInProgress = false
//                }
//            } else {
//                sender.card.isMatched = true
//                self.compareCardView?.card.isMatched = true
//                self.compareCardView = nil
//                game.matchedCount += 1
//            }
//        }
//
//        if game.matchedCount == game.cardsCount {
//            showYouWinAlert()
//        }
//
//    }
//
//
//    func showYouWinAlert() {
//        let alertController = UIAlertController(
//            title: "",
//            message: "You won",
//            preferredStyle: .alert)
//
//        let action = UIAlertAction(
//            title: "Restart",
//            style: .default,
//            handler: {
//                action in
//
//                self.restart()
//
//        })
//
//        alertController.addAction(action)
//        self.present(alertController, animated: true, completion: nil)
//    }
//}
