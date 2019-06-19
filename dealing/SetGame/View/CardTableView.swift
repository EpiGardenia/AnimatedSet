//
//  CardTableView.swift
//  dealing
//
//  Created by T  on 2019-06-09.
//  Copyright © 2019 T . All rights reserved.
//


import UIKit

class CardTableView: UIView {
    
    lazy var viewFrame = self.frame
    
    enum ViewName: Int {
        case NewGame = 1
        case Deal = 2
        case Set = 3
        case CardTable = 4
    }
    
    lazy var cardButtons = [CardView]()
    var numberOfCardsOnTable = 0
    var grid = Grid(layout: .aspectRatio(2))
    
    func addAndDealCards(contentOfCards:[SetGameCard]) -> [CardView]{
        var newCells: [CGRect] = []
        let amount = contentOfCards.count
        grid.cellCount = numberOfCardsOnTable + amount
        for index in 0..<amount {
            newCells.append(grid[numberOfCardsOnTable +  index]!.insetBy(dx: 10, dy: 10))
        }
        let newButtons = addCardButtons(contents: contentOfCards, on: newCells)
        numberOfCardsOnTable += amount
        return newButtons
    }
    
    func addCardButtons(contents cards: [SetGameCard], on frames: [CGRect]) -> [CardView] {
        var result: [CardView] = []
        let cardPosPair = zip(cards, frames)
        for (card, frame) in cardPosPair {
            result.append(addACardButton(content: card, on: frame))
        }
        return result
    }
    
    
    func addACardButton(content card:SetGameCard, on frame: CGRect) -> CardView {
        let cardButton = drawACardButtonOnFrame(draw: card, on: frame)
        layoutIfNeeded()
        dealOneCardAnimate(cardButton: cardButton)
        cardButtons.append(cardButton)
        return cardButton
    }
    
    
    func drawACardButtonOnFrame(draw cardContent: SetGameCard, on frame: CGRect) -> CardView {
        let button = CardView.init(frame: frame, content: cardContent)
        button.backgroundColor = UIColor.purple
        button.isFaceUp = false
        addSubview(button)
        button.alpha = 0
        return button
    }
    
    // new Cards can be empty
    func updateMatchedSubviews(matchedCards:[SetGameCard], newCards: [SetGameCard]?, setCount: Int) {
        let setFrame = self.viewWithTag(ViewName.Set.rawValue)!.frame
        // Get indices of matchcards in cardsbuttons
        var matchedIndices: [Int] = []
        var copiedMatchCardsForAnimate: [CardView] = []
        for (matchedCard, NewCardIndex) in zip(matchedCards, 0...2) {
            if let index = cardButtons.firstIndex(where: {$0.cardContent == matchedCard}) {
                matchedIndices.append(index)
                let copyButton = CardView.init(frame: cardButtons[index].frame, content: cardButtons[index].cardContent!)
                copyButton.isFaceUp = true
                addSubview(copyButton)
                copiedMatchCardsForAnimate.append(copyButton)
                cardButtons[index].alpha = 0
                if newCards != nil {
                    cardButtons[index].cardContent = newCards![NewCardIndex]
                }
            } else {
                assertionFailure("can't find matching card in cardsButton")
            }
        }
        
        // Animate matchedCards to set label
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 1, delay: 0.2, options: .curveEaseInOut,
            animations: {
                copiedMatchCardsForAnimate.forEach{
                    $0.alpha = 0.7
                    $0.center = CGPoint(x: setFrame.midX, y: setFrame.midY)
                }},
            completion: {_ in copiedMatchCardsForAnimate.forEach{$0.alpha = 0}
                if newCards != nil {
                    _ = matchedIndices.map{ self.dealOneCardAnimate(cardButton:self.cardButtons[$0])}
                } else {
                    matchedIndices.sort()
                    matchedIndices.forEach{self.cardButtons[$0].removeFromSuperview()}
                    self.cardButtons.remove(at: matchedIndices[0])
                    self.cardButtons.remove(at: matchedIndices[1]-1)
                    self.cardButtons.remove(at: matchedIndices[2]-2)
                    self.grid.cellCount -= 3
                    self.setNeedsLayout()
                }
                copiedMatchCardsForAnimate.removeAll()
                if let setLabel = self.viewWithTag(ViewName.Set.rawValue) as? UILabel {
                    setLabel.text = "Set: \(setCount)"
                }
        }
        )
        
    }
    
    func dealOneCardAnimate(cardButton: CardView) {
        let dealFrame = self.viewWithTag(ViewName.Deal.rawValue)!.frame
        let posFrame = cardButton.frame
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0, delay: 0, options: .transitionFlipFromLeft,
            animations: {
                cardButton.frame = dealFrame
                cardButton.isFaceUp = false
        }
            ,
            completion: { _ in
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1, delay: 0.4, options: [], animations: {
                        cardButton.alpha = 1
                        cardButton.frame = posFrame
                        
                }, completion:{ _ in
                    UIView.transition(
                        with: cardButton, duration: 0.4, options: .transitionFlipFromLeft,
                        animations: {
                            cardButton.isFaceUp = true
                    })
                }
                )
        }
        )
    }
    
    
    // Remove all subviews
    func clearTable() {
        //        print(description)
        numberOfCardsOnTable = 0
        cardButtons.forEach{$0.removeFromSuperview()}
        cardButtons.removeAll()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let tableArea = self.viewWithTag(ViewName.CardTable.rawValue)
        grid.frame = tableArea!.frame
        if (!cardButtons.isEmpty) {
            for index in 0..<cardButtons.count {
                cardButtons[index].frame = grid[index]!.insetBy(dx: 10, dy: 10)
            }
        }
    }
}
