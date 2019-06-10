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
    
    let nrOfInitialCards = 2
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(in: animator)
    
    @IBAction func ClickNewGame(_ sender: UIButton) {
        CardTableView.ClearTable()
        CardTableView.addCardButton(amount: nrOfInitialCards)
//        AnimateDealOneCard(card: CardTableView.cardButtons[0])
        //AnimateDealCard(amount: nrOfInitialCards)
    }
    
    @IBAction func ClickDeal(_ sender: UIButton) {
        CardTableView.addCardButton(amount: 3)
        
    //    AnimateDealOneCard(to: CardTableView.cardButtons[4].frame)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

