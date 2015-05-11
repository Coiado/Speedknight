//
//  Move.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 15/04/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import SpriteKit

enum MoveType: Int {
    case Unknown = 0, IconeAxe, IconeShield, IconeSingleSwordDualWield, IconeDualSword, IconeSingleSword

    var spriteName: String {
        let spriteNames = [
            "Icone-Axe",
            "Icone-Shield",
            "Icone-SingleSword(DualWield)",
            "Icone-DualSword",
            "Icone-SingleSword"]
        
        return spriteNames[rawValue]
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Selecionado"
    }
    
    static func random() -> MoveType {
        
        return MoveType(rawValue: Int(arc4random_uniform(5)))!

        //return MoveType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }

}

class Move: Printable, Hashable {
    
    var description: String {
        return "type:\(moveType) square:(\(column),\(row))"
    }
    
    var hashValue: Int {
        return row*10 + column
    }
    
    var column: Int
    var row: Int
    let moveType: MoveType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, moveType: MoveType) {
        self.column = column
        self.row = row
        self.moveType = moveType
    }
}

func ==(lhs: Move, rhs: Move) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}