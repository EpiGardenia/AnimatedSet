//
//  ViewController.swift
//  dealing
//
//  Created by T  on 2019-06-08.
//  Copyright © 2019 T . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var NewGameButton: UIButton!
    @IBOutlet weak var cardTableView: CardTableView!
        {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(deal3CardClickedActionObjc))
            swipe.direction = [.down]
            cardTableView.addGestureRecognizer(swipe)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(buttonClicked(sender:)))
            cardTableView.addGestureRecognizer(tap)
        }}
    
    @IBOutlet weak var DealButton: UIButton!
    @IBOutlet weak var SetCountLabel: UILabel!
    
    let nrOfInitialCards = 1
    lazy var setGame = SetGame()
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(in: animator)
    
    @IBAction func ClickNewGame(_ sender: UIButton) {
        startNewGame()
    }
    
    
    private func createCardButtons(of number: Int) {
        let newCards = setGame.pickCards(of: number)
        let newButtons = cardTableView.addCardButton(contentOfCards: newCards)
        newButtons.forEach{$0.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)}
    }
    
    
    private func startNewGame() {
        cardTableView.clearTable()
        createCardButtons(of: nrOfInitialCards)
    }
    
    @IBAction func ClickDeal(_ sender: UIButton) {
       dealThree()
    }
    
    @objc func deal3CardClickedActionObjc() {
      dealThree()
    }
    
    private func dealThree() {
        if DealButton.isEnabled {
            createCardButtons(of: 3)
        }
    }
    
    @objc func buttonClicked (sender: UIButton) {
        if let card = sender as? CardView {
            if cardTableView.cardButtons.contains(card) {
                tapAcard(cardbutton: card)
            }
        } else if sender == NewGameButton {
            startNewGame()
        } else if sender == DealButton {
            dealThree()
        }
    }
    
    private func tapAcard (cardbutton: CardView) {
        print("Hi")
    }
    
    
        
//        if buttonList.contains(sender) {
//            game.touchACard(of: game.cardsOnTable[buttonList.firstIndex(of: sender)!])
//            paramsUpdate()
//        } else if sender == DealThreeCardsButton! {
//            deal3CardClickedAction()
//        } else if sender == newGameButton! {
//            initSetup()
//        } else {
//            assert(true)
//        }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

