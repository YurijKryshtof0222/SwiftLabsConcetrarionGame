import UIKit

struct Card {
    var id: Int
    var img: String
    var isFaceUp: Bool
    var isMatched: Bool
}

protocol CardViewDelegate: AnyObject {
    func click(sender: CardView)
}

class CardView: NibLoadingView {

    @IBOutlet weak var btn : UIButton!
    @IBOutlet weak var topCard: UIView!
    @IBOutlet weak var bottomCard: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var card:Card!
    
    weak var delegate: CardViewDelegate?
    
    @IBAction func buttonTapped(_ sender:UIButton){
        if !card.isMatched {
            delegate?.click(sender: self)
        }
    }
    
    func flip(_ sender:UIButton) {
        if (!card.isFaceUp) {
            topCard.flip(to: bottomCard, with: .transitionFlipFromRight)
            card.isFaceUp = true
        } else {
            bottomCard.flip(to: topCard, with: .transitionFlipFromLeft)
            card.isFaceUp = false
        }
    }
    
    
    func configure (card:Card) {
        self.card = card
        //let img = UIImageView(image: UIImage(named: card.img))
        imageView.image = UIImage(named: card.img)
        //img.centerMode = .scaleToFill
        /*img.center = CGPoint(x: bottomCard.frame.size.width/2, y: bottomCard.frame.size.height / 2)*/
        //bottomCard.addSubview(img)
    }
    

}

extension UIView {
    func flip(to view:UIView, with option: AnimationOptions) {
        UIView.transition(from: self, to: view, duration: 0.5, options: [option, .showHideTransitionViews])
    }
}
