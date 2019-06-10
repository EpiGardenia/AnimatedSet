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
    
    
    @IBAction func ClickNewGame(_ sender: UIButton) {
        CardTableView.addCardButton(amount: 2)
    }
    
    @IBAction func ClickDeal(_ sender: UIButton) {
        CardTableView.addCardButton(amount: 3)
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}

