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
         print(description)
        CardTableView.clearTable()
        CardTableView.addCardButton(amount: nrOfInitialCards)
        AnimateDealCard(amount: nrOfInitialCards)
    }
    
    @IBAction func ClickDeal(_ sender: UIButton) {
        CardTableView.addCardButton(amount: 3)
        AnimateDealOneCard(to: CardTableView.cardButtons[4])
    }
    
    private func AnimateDealOneCard(to dest: CardView) {
        print(dest.description)
        let animateCard = CardView.init(frame: DealButton.frame)
        animateCard.backgroundColor = UIColor.black
        view.addSubview(animateCard)
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5, delay: 1, options: [],
            animations: {
                let snap = UISnapBehavior(item: animateCard, snapTo: dest.center)
                snap.damping = 1.0
                self.animator.addBehavior(snap)
                animateCard.alpha = 0.1
        }
            , completion:{
                _ in
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.5, delay: 7, options:[], animations: {
                        UIView.transition(
                            with: dest,
                            duration: 0.3,
                            options: .transitionFlipFromRight,
                            animations: {
                                dest.isFaceUp = true
                                dest.alpha = 1
                        },
                            completion: {
                                _ in
                                animateCard.removeFromSuperview()
                        }
                        )
                }
                )
        }
        )
        
//        self.cardBehavior.Snap(item: animateCard, dest: dest.center)
////        animateCard.alpha=0
//        CardView.transition(with: dest, duration: 1, options: .transitionFlipFromLeft, animations: {dest.isFaceUp = true}//, completion: {_ in animateCard.removeFromSuperview()}
//        )
       
    }
    
    
    private func AnimateDealCard(amount: Int) {
        let cardButtons = CardTableView.cardButtons
        AnimateDealOneCard(to: cardButtons[0] )
        // create a subview with the same size of Deal button
        // snap it to the destination
        // show the card
      //  CardTableView.displayCard(index: 0)
        // flip card to face up
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

