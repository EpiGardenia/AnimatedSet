//
//  Card.swift
//  Proj4_AnimatedSet
//
//  Created by En G on 2018-06-22.
//  Copyright © 2018 En G. All rights reserved.
//

import Foundation

struct ConcentrationCard : Hashable
{

    func hash(into hasher: inout Hasher ) {
        hasher.combine(identifier)
    }
    
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    var seenCount = 0
    
    static var identifierFactory = 0
    static func getUniqueIdentifier() -> Int{
        identifierFactory += 1
        return identifierFactory
    }
    
    // init tends to have same external and internal name params
    init() {
        self.identifier = ConcentrationCard.getUniqueIdentifier()
        self.seenCount = 0
    }
}
