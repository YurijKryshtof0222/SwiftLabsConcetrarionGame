class Game {
    
    let cardsCount:Int
    let cardsSrs:[String] = [
        "image1",
        "image2",
        "image3",
        "image4",
        "image5",
        "image6"
    ]
    var cards: [Card] = []
    
    init (count maxCount:Int) {
        cardsCount = maxCount
        var remainingCardSrs = cardsSrs
        for _ in 0..<maxCount {
            
            if remainingCardSrs.isEmpty {
                remainingCardSrs = cardsSrs
            }
            
            let randomIndex = Int.random(in: 0..<remainingCardSrs.count)
            let selectedImage = remainingCardSrs.remove(at: randomIndex)
            
            for _ in 0..<2 {
                cards.append(Card(id: 0, img: selectedImage, isFaceUp: false, isMatched: false))
            }
        }
    }
    
    func flipCard(at index: Int) {}
    
    func checkForMatch() {}
    
    func isGameWon() -> Bool {
        return false
    }
    
    func restartGame() {}
    
}
