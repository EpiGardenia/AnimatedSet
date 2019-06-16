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
    
///    lazy var dealFrame = viewWithTag(ViewName.Deal.rawValue)!.frame
//
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
         dealOneCardAnimate(cardButton: cardButton)
        cardButtons.append(cardButton)
        return cardButton
    }


    func drawACardButtonOnFrame(draw cardContent: SetGameCard, on frame: CGRect) -> CardView {

        let button = CardView.init(frame: frame, content: cardContent)
        button.backgroundColor = UIColor.purple
        addSubview(button)
        button.alpha = 0.5
        print("drawAcardButtonOnFrame,frame:" + frame.debugDescription + "b.frame  " + button.frame.debugDescription)
      //  layoutIfNeeded()
        return button
    }
//
    // send card from "from" to "dest" invisibly, and send it back with visibility
//    private func dealOneCardAnimate(from : CGRect, to dest: CGRect, content: SetGameCard) -> CardView {
//        print("dealOneCardAnimate: from" + from.debugDescription + "to:" + dest.debugDescription)
//        let button = drawACardButtonOnFrame(draw: content, on: dest)
//          print("dealOneCardAnimate: button" + button.frame.debugDescription)
//        UIViewPropertyAnimator.runningPropertyAnimator(
//            withDuration: 0, delay: 0, options: .curveEaseIn,
//            animations: {
//                button.alpha = 0.4
//                button.frame = from
//                print("dealOneCardAnimate: button.newframe" + button.frame.debugDescription)
//                self.setNeedsLayout()
//        }
////            ,completion: { _ in
////                UIViewPropertyAnimator.runningPropertyAnimator(
////                    withDuration: 0.5, delay: 0.4, options: [],
////                    animations: {
////                      //  print(#line)
////                        button.alpha = 1;
////                        button.frame = dest
////                },
////                    completion: { _ in
////                        UIView.transition(with: button, duration: 0.5, options: .transitionFlipFromLeft,
////                                          animations: {
////                                            button.isFaceUp = true
////                        })
////                }
////                )
////        }
//        )
//        return button
//    }
    
    // new Cards can be empty
    func updateMatchedSubviews(matchedCards:[SetGameCard], newCards: [SetGameCard]?) {
        
        let setFrame = self.viewWithTag(ViewName.Set.rawValue)!.frame
        
        // Get indices of matchcards in cardsbuttons
        var matchedIndices: [Int] = []
        var matchedCardButtons: [CardView] = []
        for matchedCard in matchedCards {
            let index = cardButtons.firstIndex{$0.cardContent == matchedCard}!
            matchedIndices.append(index)
            matchedCardButtons.append(cardButtons[index])
        }
  
        // Animate matchedCards to set label
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5, delay: 0, options: .curveEaseInOut,
            animations: {
                matchedCardButtons.forEach{
                    $0.frame = setFrame
                }},
            completion: {_ in matchedCardButtons.forEach{$0.alpha = 0}}
    )
        // update cardbuttons
        if newCards == nil {
            matchedIndices.forEach{ cardButtons.remove(at: $0)}
        } else {
            let cardWithPosPair = zip(matchedIndices, newCards!)
            
            for (index, cardData) in cardWithPosPair {
                cardButtons[index].cardContent = cardData
                cardButtons[index].alpha = 0
                // Deal card animate
                dealOneCardAnimate(cardButton: cardButtons[index])
            }
        }
    }
    
    func dealOneCardAnimate(cardButton: CardView) {
        let dealFrame = self.viewWithTag(ViewName.Deal.rawValue)!.frame
        let posFrame = cardButton.frame
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0, delay: 0, options: [], animations: {cardButton.frame = dealFrame}, completion: { _ in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                cardButton.frame = posFrame
                cardButton.alpha = 1
            }, completion:{ _ in
                UIView.transition(with: cardButton, duration: 0.4, options: .transitionFlipFromLeft, animations: {cardButton.isFaceUp = true})
            }
        )
        })
    }
    
    
    private func findCardView(of card: SetGameCard) -> CardView? {
        if let button = cardButtons.filter({$0.cardContent == card}).first {
            return button
        }

        return nil
    }
    
    //    private func findFrame(of card: SetGameCard) -> CGRect? {
    //        var frame: CGRect?
//
//        if let cardButton = cardButtons.filter({$0.cardContent == card}).first {
//          frame = cardButton.frame
//        }
//
//        return frame
//    }
    
    
    // Remove all subviews
    func clearTable() {
        //        print(description)
        numberOfCardsOnTable = 0
        cardButtons.forEach{$0.removeFromSuperview()}
        cardButtons.removeAll()
    }
    
    override func layoutSubviews() {
        //        print("layoutSubviews")
        super.layoutSubviews()
        updateSubviews()
        //        if (self.frame != viewFrame) {
        //            updateSubviews()
        //            viewFrame = self.frame
        //        }
    }
    
    private func updateSubviews() {
               print("updateSubViews")
        let tableArea = self.viewWithTag(ViewName.CardTable.rawValue)
        grid.frame = tableArea!.frame
        if (!cardButtons.isEmpty) {
            for index in 0..<cardButtons.count {
                cardButtons[index].frame = grid[index]!.insetBy(dx: 10, dy: 10)
               // cardButtons[index].number = index
            }
        }
    }
    
 
}
