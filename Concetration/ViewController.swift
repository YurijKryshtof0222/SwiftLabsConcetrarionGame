//
//  ViewContoller.swift
//  Concetration
//
//  Created by Admin on 02/11/2023.
//  Copyright © 2023 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var game:Game!
    
    var isHidden = false
    
    @IBOutlet var cardViews: [CardView]!
    
    var compareCardView: CardView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pairCount = cardViews.count / 2
        game = Game(count: pairCount)
        loadIcons()
    }
    
    func loadIcons () {
        for i in 0..<game.cards.count {
            cardViews[i].configure(card: game.cards[i])
            cardViews[i].delegate = self
        }
    }
}

extension ViewController: CardViewDelegate {
    
    func didClicked(sender: CardView) {
        sender.flip(sender.btn)
        if compareCardView == nil {
            compareCardView = sender
        } else {
            if sender.card.img != compareCardView?.card.img {
//                sleep(1)
                compareCardView!.flip(compareCardView!.btn)
                sender.flip(sender.btn)
            }
            
            compareCardView = nil
        }
    }
}
