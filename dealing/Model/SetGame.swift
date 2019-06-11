//
//  SetGame.swift
//  dealing
//
//  Created by T  on 2019-06-11.
//  Copyright © 2019 T . All rights reserved.
//

import Foundation

class SetGame {
    
    lazy var allSetCards = getAllCards()
    private var cardsOnDeck : [SetGameCard] = []
    var cardsOnTable : [SetGameCard] = []
    
    
    func pickCards(of number: Int) -> [SetGameCard] {
        var pickedCards: [SetGameCard] = []
        for _ in 0..<number {
            if let newCard = cardsOnDeck.randomElement() {
                pickedCards.append(newCard)
            }
        }
        cardsOnTable.append(contentsOf: pickedCards)
        return pickedCards
    }
    
    private func getAllCards() -> [SetGameCard]{
        var allCards = [SetGameCard] ()
        for number in SetGameCard.SetNumber.allCases{
            for shading in SetGameCard.SetShading.allCases {
                for color in SetGameCard.SetColor.allCases {
                    for symbol in SetGameCard.SetSymbol.allCases {
                        let card = SetGameCard(ofNumber: number, ofShading: shading, ofColor: color, ofSymbol:symbol)
                        allCards.append(card)
                    }
                }
            }
        }
        return allCards
    }
    
    init() {
        cardsOnDeck = allSetCards
       // selectedCards.removeAll()
       // score = 0
    }
}


