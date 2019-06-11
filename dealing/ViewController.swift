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
    @IBOutlet weak var CardTableView: CardTableView!
    
    @IBOutlet weak var DealButton: UIButton!
    @IBOutlet weak var SetCountLabel: UILabel!
    
    let nrOfInitialCards = 1
    lazy var setGame = SetGame()
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(in: animator)
    
    @IBAction func ClickNewGame(_ sender: UIButton) {
        CardTableView.clearTable()
        let newCards = setGame.pickCards(of: nrOfInitialCards)
        CardTableView.addCardButton(contentOfCards: newCards)
    }
    
    @IBAction func ClickDeal(_ sender: UIButton) {
        let newCards = setGame.pickCards(of: 3)
        CardTableView.addCardButton(contentOfCards: newCards)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

