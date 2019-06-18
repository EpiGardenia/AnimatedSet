//
//  ViewController.swift
//  Proj4_AnimatedSet
//
//  Created by En G on 2018-06-22.
//  Copyright © 2018 En G. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet var flipCountLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var timeUsed: UILabel!

    lazy var emojiChoices = "🍣🥗🍳🍤🥘🍜🍱🍙"
    lazy var themeColor = [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]

    var emojiThemes : [Any]? {
        didSet {
            emojiChoices = emojiThemes?.first as! String
            remainingEmojiChoices = emojiChoices
            // reset emoji
            emoji = [:]
            themeColor = emojiThemes?.last as! [UIColor]
            updateViewFromModel()
        }
    }
    
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
 //   lazy var randomIndex = Int(arc4random_uniform(UInt32(emojiThemes.count)))

    lazy var remainingEmojiChoices = emojiChoices
    @IBAction func startNewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        view.backgroundColor = themeColor.last
        remainingEmojiChoices = emojiChoices
        game.timeUsed = 0.0
        updateViewFromModel()
    }
    
    @IBAction func touchButton(_ sender: UIButton) {
        // flip the given card
        if let cardNumber = cardButtons.firstIndex(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel();
        } else {
            print("No collection")
        }
    }
    
    func updateViewFromModel() {
        view.backgroundColor = themeColor.last
        if cardButtons != nil {
            timeUsed.text = "Time: \(game.timeUsed.rounded())"
            scoreLabel.text = "Score : \(game.score)"
            
            if game.isFinished == false {
                flipCountLabel.text = "Flips : \(game.flipCount)"
            }
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp, game.isFinished == false{
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : themeColor.first
                }
            }
        }
    }
    
    
    //dictionary
    var emoji = [Int:String] ()
    
    func emoji(for card: ConcentrationCard) -> String {
        if emoji[card.identifier] == nil, remainingEmojiChoices.count > 0  {
            let randomIndex = emojiChoices.index(remainingEmojiChoices.startIndex, offsetBy: Int(arc4random_uniform(UInt32(remainingEmojiChoices.count))))
           // let randomIndex = Int(arc4random_uniform(UInt32(remainingEmojiChoices.count)))
            emoji[card.identifier] = String(remainingEmojiChoices.remove(at: randomIndex))
        }
        return emoji[card.identifier] ?? "?"
    }
}

