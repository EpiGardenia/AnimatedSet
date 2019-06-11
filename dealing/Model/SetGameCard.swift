//
//  Card.swift
//  dealing
//
//  Created by T  on 2019-06-11.
//  Copyright © 2019 T . All rights reserved.
//

import Foundation
struct SetGameCard : CustomStringConvertible, Hashable
{
    var description: String { return "\(ofNumber),\(ofColor),\n \(ofSymbol),\(ofShading)"}
    
    enum SetOption : Int, CaseIterable, Hashable {
        case A = 0, B, C
    }
    
    enum SetNumber : Int, CaseIterable, Hashable{
        case One = 1, two, three
    }
    
    enum SetShading : CaseIterable, Hashable{
        case solid, striped, open
    }
    
    enum SetColor : CaseIterable, Hashable{
        case red, green, purple
    }
    
    enum SetSymbol : CaseIterable, Hashable{
        case diamond, squiggle, oval
    }
    
    var ofNumber : SetNumber
    var ofShading : SetShading
    var ofColor : SetColor
    var ofSymbol : SetSymbol
    
    static func ==(lhs: SetGameCard, rhs: SetGameCard) -> Bool {
        return (lhs.ofNumber == rhs.ofNumber) &&
            (lhs.ofColor == rhs.ofColor) &&
            (lhs.ofSymbol == rhs.ofSymbol) &&
            (lhs.ofShading == rhs.ofShading)
    }
}
