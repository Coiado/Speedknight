//
//  Move.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 15/04/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import SpriteKit

enum MoveType: Int {
    case Unknown = 0, IconeShield, IconeAxe, IconeSingleSwordDualWield, IconeDualSword, IconeBowArrow, IconeStaff

    // Alter here to put, instead of the sprites themselves, already, make a method to choose only the ones that shall actually appear (based on the players of the round)
    var spriteName: String {
        let spriteNames = [
            "Icone-Shield",
            "Icone-Axe",
            "Icone-SingleSword(DualWield)",
            "Icone-DualSword",
            "Icone-BowArrow",
            "Icone-Staff"]
        
        return spriteNames[rawValue]
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Selecionado"
    }
    
    var deadSpriteName: String {
        return spriteName + "-Morto"
    }
    
    static func random() -> MoveType {

        var aux : Int! = Int(arc4random_uniform(6))
        
        // Here it will check whether the random rawValue is of a character that is actually in the match. If it is, it shall be displayed. Otherwise, it will call the function again, recursively.
        
        if (aux == GameData.sharedInstance.team[0].RawValue) || (aux == GameData.sharedInstance.team[1].RawValue) || (aux == GameData.sharedInstance.team[2].RawValue) || (aux == GameData.sharedInstance.team[3].RawValue) || (aux == 0) // This is the Shield (special case)
        {
        return MoveType(rawValue: aux)!
        }
        
        
        else
        {
        return random()
        }
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