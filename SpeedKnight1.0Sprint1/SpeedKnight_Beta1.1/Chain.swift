//
//  Chain.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 28/04/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import Foundation

class Chain: Hashable, Printable {
  
    var moves = [Move]()
    var score = 0
    
    enum ChainType: Printable {
        case Horizontal
        case Vertical
        
        var description: String {
            switch self {
            case .Horizontal: return "Horizontal"
            case .Vertical: return "Vertical"
            }
        }
    }
    
    var chainType: ChainType
    
    init(chainType: ChainType) {
        self.chainType = chainType
    }
    
    func addMove(move: Move) {
        moves.append(move)
    }
    
    func firstMove() -> Move {
        return moves[0]
    }
    
    func lastMove() -> Move {
        return moves[moves.count - 1]
    }
    
    var length: Int {
        return moves.count
    }
    
    var description: String {
        return "type:\(chainType) moves:\(moves)"
    }
    
    var hashValue: Int {
        return reduce(moves, 0) { $0.hashValue ^ $1.hashValue }
    }
}

func ==(lhs: Chain, rhs: Chain) -> Bool {
    return lhs.moves == rhs.moves
}
