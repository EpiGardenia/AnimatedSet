//
//  CardView.swift
//  dealing
//
//  Created by T  on 2019-06-09.
//  Copyright © 2019 T . All rights reserved.
//

import UIKit

class CardView: UIButton {
    
    var number = 0 {didSet{setNeedsDisplay()}}
    var isFaceUp = false { didSet{ setNeedsDisplay()}}
    
    override func draw(_ rect: CGRect) {
  
        if (isFaceUp == true) {
                  print(#line)
            self.setTitle(String(number), for: .normal)
            self.setTitleColor(.yellow, for: .normal)
        } else {
                  print(#line)
            self.setTitle(String("BACK"), for: .normal)
            let l = UIBezierPath(rect: CGRect(x: bounds.midX, y:bounds.midY , width: 10, height: 10))
            UIColor.white.setStroke()
            UIColor.gray.setFill()
            l.stroke()
            l.fill()
        }
      
    }

 

}
