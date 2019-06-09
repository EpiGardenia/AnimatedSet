//
//  CardTableView.swift
//  dealing
//
//  Created by T  on 2019-06-09.
//  Copyright © 2019 T . All rights reserved.
//

import UIKit

class CardTableView: UIView {
    
    lazy var cardButtons = [CardView]()
    var numberOfCardsOnTable = 0
    var grid = Grid(layout: .aspectRatio(0.6))
    
    func addCardButton(amount: Int) {
        print(description)
        grid.cellCount = numberOfCardsOnTable + amount
        for index in 0..<amount {
            let button = CardView.init(frame: grid[numberOfCardsOnTable +  index]!.insetBy(dx: 10, dy: 10))
            button.backgroundColor = UIColor.purple
            cardButtons.append(button)
            addSubview(button)
        }
        numberOfCardsOnTable += amount
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.frame = self.bounds
        if (!cardButtons.isEmpty) {
            for index in 0..<numberOfCardsOnTable {
                cardButtons[index].frame = grid[index]!.insetBy(dx: 10, dy: 10)
            }
        }
        
    }
}
