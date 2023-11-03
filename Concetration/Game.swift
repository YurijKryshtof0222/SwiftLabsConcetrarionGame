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
    
    var imageCountDict: [String: Int] = [:]
    
    init (count maxCount:Int) {
    cardsCount = maxCount
    for _ in 0..<maxCount {
        for _ in 0..<2 {
            var randomImage = getRandomImage()
            
            while let count = imageCountDict[randomImage], count >= 2 {
                randomImage = getRandomImage()
            }
            imageCountDict[randomImage, default: 0] += 1
            cards.append(Card(id: 0, img: randomImage, isFaceUp: false, isMatched: false))
            }
        }
    }

    
    private func getRandomImage() -> String {
        let randomInt = Int.random(in: 0..<cardsSrs.count)
        return cardsSrs[randomInt]
    }
    
    func flipCard(at index: Int) {}
    
    func checkForMatch() {}
    
    func isGameWon() -> Bool {
        return false
    }
    
    func restartGame() {}
    
}
