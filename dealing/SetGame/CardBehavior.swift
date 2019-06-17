//
//  CardBehavior.swift
//  dealing
//
//  Created by T  on 2019-06-10.
//  Copyright © 2019 T . All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    lazy var gravityBehavior: UIGravityBehavior = {
        let gravity = UIGravityBehavior()
        return gravity
    } ()
        
    func Snap(item: UIDynamicItem, dest: CGPoint) {
        let snap = UISnapBehavior(item: item, snapTo: dest)
        addChildBehavior(snap)
    }
    
    func DealingCardAnimation(item: UIDynamicItem, dest: UIButton) {
        Snap(item: item, dest: dest.center)
    }
    
    override init() {
        super.init()
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
