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
    
    func addCardButton(contentOfCards:[SetGameCard]) {
        let amount = contentOfCards.count
         let dealFrame = self.viewWithTag(ViewName.Deal.rawValue)!.frame
        grid.cellCount = numberOfCardsOnTable + amount
        for index in 0..<amount {
            let newCell = grid[numberOfCardsOnTable +  index]!.insetBy(dx: 10, dy: 10)
            dealOneCardAnimate(from: dealFrame, to: newCell, content: contentOfCards[index])
        }
        numberOfCardsOnTable += amount
    }
    
    // send card from "from" to "dest" invisibly, and send it back with visibility
    private func dealOneCardAnimate(from : CGRect, to dest: CGRect, content: SetGameCard){
        let button = CardView.init(frame: dest, content: content)
//        button.number = numberOfCardsOnTable + index
        button.backgroundColor = UIColor.purple
        cardButtons.append(button)
        addSubview(button)
        button.alpha = 0
        layoutIfNeeded()
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0, delay: 0, options: .curveEaseIn,
            animations: {
                button.frame = from
        }
            ,completion: { _ in
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.5, delay: 0.4, options: [],
                    animations: {
                      //  print(#line)
                        button.alpha = 1;
                        button.frame = dest
                },
                    completion: { _ in
                        UIView.transition(with: button, duration: 0.5, options: .transitionFlipFromLeft,
                                          animations: {
                                            //      print(#line)
                                            button.isFaceUp = true
                                             //      print(#line)
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
        //        print("layoutSubviews")
        super.layoutSubviews()
        updateSubviews()
        //        if (self.frame != viewFrame) {
        //            updateSubviews()
        //            viewFrame = self.frame
        //        }
    }
    
    private func updateSubviews() {
      //          print("updateSubViews")
        let tableArea = self.viewWithTag(ViewName.CardTable.rawValue)
        grid.frame = tableArea!.frame
        if (!cardButtons.isEmpty) {
            for index in 0..<numberOfCardsOnTable {
                cardButtons[index].frame = grid[index]!.insetBy(dx: 10, dy: 10)
               // cardButtons[index].number = index
            }
        }
    }
}
