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
        generateCards()
    }
    
    private func generateCards() {
        var imageCountDict: [String: Int] = [:]
        var idCount = 0
        for _ in 0..<cardsCount {
            for _ in 0..<2 {
                var randomImage = getRandomImage()
            
                while let count = imageCountDict[randomImage], count >= 2 {
                    randomImage = getRandomImage()
                }
                imageCountDict[randomImage, default: 0] += 1
                cards.append(Card(
                    id: idCount,
                    img: randomImage,
                    isFaceUp: false,
                    isMatched: false))
                idCount += 1
            }
        }
    }
    
    private func getRandomImage() -> String {
        let randomInt = Int.random(in: 0..<cardsSrs.count)
        return cardsSrs[randomInt]
    }
    
}
