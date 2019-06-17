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
    
    let nrOfInitialCards = 12
    lazy var setGame = SetGame()
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(in: animator)
    
    @IBAction func ClickNewGame(_ sender: UIButton) {
        startNewGame()
    }
    
    
    private func createCardButtons(of number: Int) {
        let newCards = setGame.pickCards(of: number)
        let newButtons = cardTableView.addAndDealCards(contentOfCards: newCards)
        newButtons.forEach{$0.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)}
    }
    
    
    private func startNewGame() {
        setGame = SetGame()
        cardTableView.clearTable()
        createCardButtons(of: nrOfInitialCards)
        SetCountLabel.text = "Set: 0"
        DealButton.isEnabled = true
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
        print(cardbutton.cardContent!.description)
        // get cards to be updated
        let updatedCards = setGame.tappedCard(card: &cardbutton.cardContent!)
        // update view by change the card content        
        if updatedCards.first?.status != .match {
            for updateCard in updatedCards {
                let toUpdateView = cardTableView.cardButtons.filter{$0.cardContent == updateCard}.first
                toUpdateView?.cardContent?.updateStatus(newStatus: updateCard.status)
            }
        } else {
            // flyout and deal new cards
            cardTableView.updateMatchedSubviews(
                matchedCards: Array(updatedCards[0...2]),
                newCards: updatedCards.count == 6 ? Array(updatedCards[3...5]) : nil, setCount: setGame.setCount)
            if setGame.cardsOnDeck.count == 0 {
                DealButton.isEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

