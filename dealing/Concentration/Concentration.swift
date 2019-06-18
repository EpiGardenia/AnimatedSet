//
//  Concentration.swift
//  Proj4_AnimatedSet
//
//  Created by En G on 2018-06-22.
//  Copyright © 2018 En G. All rights reserved.
//

import Foundation

// class get free init, as long as all var are initialized
class Concentration
{
    var cards = [ConcentrationCard]()
    var indexOfOnAndOnlyFaceUpCard : Int?
    var score = 0
    var flipCount = 0
    var startTime = Date.init()
    var remainingCards : Int
    var timeUsed = 0.0
    var isFinished = false
    
    func chooseCard(at index: Int) {
        if isFinished == false {
            if flipCount == 0 {
                startTime = Date()
                debugPrint("startTime:",startTime)
            }
            flipCount += 1
            // ignore the card which is already matched
            if !cards[index].isMatched {
                if let matchIndex = indexOfOnAndOnlyFaceUpCard, matchIndex != index {
                    // one card faceup: match or not
                    if cards[matchIndex].identifier == cards[index].identifier {
                        cards[matchIndex].isMatched = true
                        cards[index].isMatched = true
                        score += 2
                        remainingCards -= 2
                        // end of game
                        if remainingCards == 0 {
                            isFinished = true
                            let currentTime = Date()
                            timeUsed = currentTime.timeIntervalSince(startTime as Date)
                              debugPrint("timeUsed:",timeUsed)
                            // adjust score according to time spent
                            score -= Int(timeUsed / 10)
                        }
                    } else { // not match
                        if cards[index].seenCount > 0 {
                            score -= 1
                        }
                        if cards[matchIndex].seenCount > 0 {
                            score -= 1
                        }
                        cards[index].seenCount += 1
                        cards[matchIndex].seenCount += 1
                    }
                    
                    cards[index].isFaceUp = true
                    indexOfOnAndOnlyFaceUpCard = nil
                } else { // two cards or no card faceup
                    for flipDownIndex in cards.indices {
                        cards[flipDownIndex].isFaceUp = false
                    }
                    cards[index].isFaceUp = true
                    indexOfOnAndOnlyFaceUpCard = index
                }
            }
        }
    }
    
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card, card]
        }
        
        // shuffle cards
        var newCards = [ConcentrationCard] ()
        for _ in cards.indices {
            let indexToBePassed = Int(arc4random_uniform(UInt32(cards.count)))
            newCards += [cards.remove(at: indexToBePassed)]
        }
        cards = newCards
        remainingCards = cards.count
    }
}
