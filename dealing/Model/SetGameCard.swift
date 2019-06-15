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
    var description: String { return "\(ofNumber),\(ofColor),\(ofSymbol),\(ofShading), status:\(status)"}
    
    enum SetOption: Int, CaseIterable, Hashable {
        case A = 0, B, C
    }
    
    enum SetNumber: Int, CaseIterable, Hashable{
        case One = 1, two, three
    }
    
    enum SetShading: CaseIterable, Hashable{
        case solid, striped, open
    }
    
    enum SetColor: CaseIterable, Hashable{
        case red, green, purple
    }
    
    enum SetSymbol: CaseIterable, Hashable{
        case diamond, squiggle, oval
    }
    
    enum CardStatus: Hashable{
        case inDeck, unselected, selected, match, notMatch
    }
    
    var ofNumber : SetNumber
    var ofShading : SetShading
    var ofColor : SetColor
    var ofSymbol : SetSymbol
    var status: CardStatus = .inDeck
    
    static func ==(lhs: SetGameCard, rhs: SetGameCard) -> Bool {
        return (lhs.ofNumber == rhs.ofNumber) &&
            (lhs.ofColor == rhs.ofColor) &&
            (lhs.ofSymbol == rhs.ofSymbol) &&
            (lhs.ofShading == rhs.ofShading)
    }
    
    mutating func updateStatus(newStatus: CardStatus) {
        status = newStatus
    }
    
 
}
