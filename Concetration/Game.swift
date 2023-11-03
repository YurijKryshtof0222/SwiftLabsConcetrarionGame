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
        for _ in 0..<maxCount {
            for _ in 0..<2 {
                let randomInt = Int.random(in: 0..<cardsSrs.count)
                cards.append(Card(id: 0, img: cardsSrs[randomInt], isFaceUp: false, isMatched: false))
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
