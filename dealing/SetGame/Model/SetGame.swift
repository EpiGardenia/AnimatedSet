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
    var cardsOnDeck : [SetGameCard] = []
    var cardsOnTable: [SetGameCard] = []
    var selectedCards: [SetGameCard] = []
    var setCount = 0
    
    func pickCards(of number: Int) -> [SetGameCard] {
        var pickedCards: [SetGameCard] = []
        for _ in 0..<number {
            if let newCard = cardsOnDeck.randomElement() {
                cardsOnDeck = cardsOnDeck.filter() {$0 != newCard}
                pickedCards.append(newCard)
            }
        }
        cardsOnTable.append(contentsOf: pickedCards)
        return pickedCards
    }
    
    // return all cards which have been changed status
    func tappedCard(card: inout SetGameCard) -> [SetGameCard] {
        var updatedCards: [SetGameCard] = []
        // this is before 3rd card tappd
        if selectedCards.count < 2 {
            if selectedCards.contains(card) { // tap on a card previously tapped
                card.status = .unselected
                selectedCards.remove(at: selectedCards.firstIndex(of: card)!)
            } else { // tap on a card not yet tapped
                card.status = .selected
                selectedCards.append(card)
            }
            updatedCards.append(card)
        } else if selectedCards.count == 2 { // 3rd tap
            if selectedCards.contains(card) { // tap on a card previously tapped
                card.status = .unselected
                selectedCards.remove(at: selectedCards.firstIndex(of: card)!)
                updatedCards.append(card)
            } else { // check if match
                selectedCards.append(card)
                if isValidSet(of: selectedCards){ // if match set
                    // update selected cards to match
                    for k in selectedCards {
                        var j = k
                        j.updateStatus(newStatus: .match)
                        updatedCards.append(j)
                        cardsOnTable.remove(at: cardsOnTable.firstIndex(of: j)!)
                    }
                    // pick 3 more cards if not empty
                    updatedCards.append(contentsOf: pickCards(of: 3))
                    setCount += 1
                } else { // not match
                    for k in selectedCards {
                        var j = k
                        j.updateStatus(newStatus: .notMatch)
                        updatedCards.append(j)
                    }
                }
            }
        } else if selectedCards.count == 3 { // 4th tap, remove unmatched
            for k in selectedCards {
                var j = k
                j.updateStatus(newStatus: .unselected)
                updatedCards.append(j)
            }
            selectedCards.removeAll()
            card.updateStatus(newStatus: .selected)
            selectedCards.append(card)
            updatedCards.append(card)
        }
        return updatedCards
    }
    
    
    private func isValidSet(of cards : [SetGameCard]) -> Bool {
        return isAttributeValid(cards.compactMap{$0.ofColor}) && isAttributeValid(cards.compactMap{$0.ofNumber}) && isAttributeValid(cards.compactMap{$0.ofShading}) && isAttributeValid(cards.compactMap{$0.ofSymbol})
    }
    
    private func allDiff<T:Equatable>(_ cardAttribute : [T]) -> Bool {
        let rest = cardAttribute.dropFirst()
        return rest.isEmpty ? true : !rest.contains(cardAttribute.first!) && allDiff(Array(rest))
    }
    
    private func isAttributeValid<T:Equatable>(_ cardAttribute : [T]) -> Bool {
        return cardAttribute.allSatisfy{$0 == cardAttribute.first} || allDiff(cardAttribute)
    }
    
    private func getAllCards() -> [SetGameCard]{
        var allCards = [SetGameCard] ()
        for number in SetGameCard.SetNumber.allCases{
            for shading in SetGameCard.SetShading.allCases {
                for color in SetGameCard.SetColor.allCases {
                    for symbol in SetGameCard.SetSymbol.allCases {
                        let card = SetGameCard(ofNumber: number, ofShading: shading, ofColor: color, ofSymbol:symbol, status: .unselected)
                        allCards.append(card)
                    }
                }
            }
        }
        return allCards//.dropLast(66)
    }
    
    
    init() {
        cardsOnDeck = allSetCards
        selectedCards.removeAll()
        setCount = 0
    }
}


