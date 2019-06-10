//
//  CardTableView.swift
//  dealing
//
//  Created by T  on 2019-06-09.
//  Copyright © 2019 T . All rights reserved.
//

import UIKit

class CardTableView: UIView {
    
    enum ViewName: Int {
        case NewGame = 1
        case Deal = 2
        case Set = 3
    }
    
    lazy var cardButtons = [CardView]()
    var numberOfCardsOnTable = 0
    lazy var dealView = viewWithTag(ViewName.Deal.rawValue)
    lazy var newGameView = viewWithTag(ViewName.NewGame.rawValue)

    var grid = Grid(layout: .aspectRatio(2))
    
    func getTableArea() -> CGRect
    {
        let newGameViewFrame = newGameView!.frame
        return CGRect(x: frame.minX, y: newGameViewFrame.maxY+5, width: newGameViewFrame.width, height: (dealView!.frame.minY - newGameViewFrame.maxY)*0.9)
    }
    
    func addCardButton(amount: Int) {
        grid.cellCount = numberOfCardsOnTable + amount
        for index in 0..<amount {
            let button = CardView.init(frame: grid[numberOfCardsOnTable +  index]!.insetBy(dx: 10, dy: 10))
            button.alpha = 0.5
            cardButtons.append(button)
            addSubview(button)
        }
        numberOfCardsOnTable += amount
        setNeedsLayout()
    }

    
    // Remove all subviews
    func clearTable() {
//        print("viewFrame.maxX: " + self.frame.maxX.description)
        numberOfCardsOnTable = 0
        cardButtons.forEach{$0.removeFromSuperview()}
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let tableArea = getTableArea()
        print("layoutSubviews.tableArea.maxX: " + tableArea.maxX.description)
        grid.frame = tableArea
        if (!cardButtons.isEmpty) {
            for index in 0..<numberOfCardsOnTable {
                cardButtons[index].frame = grid[index]!.insetBy(dx: 10, dy: 10)
                cardButtons[index].number = index
                cardButtons[index].backgroundColor = UIColor.purple
            }
            let v = UIView.init(frame: grid[0]!)
            v.backgroundColor = UIColor.orange
            self.addSubview(v)
//            print("grid[0].maxX: " + grid[0]!.maxX.description)
//            print("CardButtons[0].maxX: " + cardButtons[0].frame.maxX.description)
        }
        
    }
}
