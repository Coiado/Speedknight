//
//  Swap.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 17/04/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

struct Swap: Printable, Hashable { 
    let moveA: Move
    let moveB: Move
    
    init(moveA: Move, moveB: Move) {
        self.moveA = moveA
        self.moveB = moveB
    }
    
    var description: String {
        return "swap \(moveA) with \(moveB)"
    }
    
    var hashValue: Int {
        return moveA.hashValue ^ moveB.hashValue
    }

}

func ==(lhs: Swap, rhs: Swap) -> Bool {
    return (lhs.moveA == rhs.moveA && lhs.moveB == rhs.moveB) ||
        (lhs.moveB == rhs.moveA && lhs.moveA == rhs.moveB)
}