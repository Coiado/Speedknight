//
//  Level.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 15/04/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import Foundation

let NumColumns = 9
let NumRows = 9

var targetScore = 0
var maximumMoves = 0

class Level {
    
    var teamPerformance : Array<Int>!
    
    private var moves:Array2D<Move>
    private var possibleSwaps = Set<Swap>()
    private var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows) // Was initialized... Why the issue?
    
    func tileAtColumn(column: Int, row: Int) -> Tile? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return tiles[column, row]
    }
    
    // Still, surprisingly, going...
    
    // The idea here is, firstly, to make copies of the moves. And, then, to update them to the Array (Matrix)
    
    func performSwap(swap: Swap) {
        let columnA = swap.moveA.column
        let rowA = swap.moveA.row
        let columnB = swap.moveB.column
        let rowB = swap.moveB.row
        
        moves[columnA, rowA] = swap.moveB
        swap.moveB.column = columnA
        swap.moveB.row = rowA
        
        moves[columnB, rowB] = swap.moveA
        swap.moveA.column = columnB
        swap.moveA.row = rowB
    }

    
    /* So far so good 3 */
    
    init(filename: String) {

        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename) {
 
            if let tilesArray: AnyObject = dictionary["tiles"] {
                
                targetScore = dictionary["targetScore"] as! Int
                maximumMoves = dictionary["moves"] as! Int
                
                for (row, rowArray) in enumerate(tilesArray as! [[Int]]) {
                    let tileRow = NumRows - row - 1
                    
                    for (column, value) in enumerate(rowArray) {
                        if value == 1 {
                            tiles[column, tileRow] = Tile()
                        }
                    }
                }
            }
        }
        
        self.moves = Array2D<Move>(columns: NumColumns, rows: NumRows)
    }


    func moveAtColumn(column: Int, row: Int) -> Move? {
                
        
      assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows) 
        return moves[column, row]
    
        }


    private func createInitialMoves() -> Array<Move> {
        var set = Array<Move>()

                for row in 0..<NumRows {
            for column in 0..<NumColumns {
              
                
                if tiles[column, row] != nil { /* So far so good 4 */
                
                // Responsible for guaranteeing a random move to show at a column and row, but only  if there are less than 3 of the same put together
                    
                //var moveType = MoveType.random()
                    
                    var moveType: MoveType
                    do {
                        moveType = MoveType.random()
                    }
                        while (column >= 2 &&
                            moves[column - 1, row]?.moveType == moveType &&
                            moves[column - 2, row]?.moveType == moveType)
                            || (row >= 2 &&
                                moves[column, row - 1]?.moveType == moveType &&
                                moves[column, row - 2]?.moveType == moveType)
                
                let move = Move(column: column, row: row, moveType: moveType)
                    
                   /* moves[column][row] = moveSquare*/
                    
                /* moves[column][row] = moveSquare (Why didn't it work? Even after following the commands to actually add a vector: '+=' and 'append')*/
                
                self.moves[column,row] =  move
                set.append(move)
            }
            }
        }
        

        
        println("Eu sou -> shuffle \(self)")
        return set
    }
    
    private func detectHorizontalMatches() -> Array<Chain> {
        // 1
        var set = Array<Chain>()
        
        // Loop through the rows and columns. Note that you don’t need to look at the last two columns because these cookies can never begin a new chain.
        
        for row in 0..<NumRows {
            for var column = 0; column < NumColumns - 2 ; {
                
                // Skip over any gaps in the particular level
                
                if let move = moves[column, row] {
                    let matchType = move.moveType
                    
                    // IMPORTANT: You check whether the next two columns have the same cookie type. Normally you have to be careful not to step outside the bounds of the array when doing something like cookies[column + 2, row], but here that can’t go wrong. That’s why the for loop only goes up to NumColumns - 2. Also note the use of optional chaining with the question mark.
                    
                    if moves[column + 1, row]?.moveType == matchType &&
                        moves[column + 2, row]?.moveType == matchType {
                            // 5
                            let chain = Chain(chainType: .Horizontal)
                            do {
                                chain.addMove(moves[column, row]!)
                                ++column
                            }
                                while column < NumColumns && moves[column, row]?.moveType == matchType
                            
                            // make a test: first with column, then with row
                            set.append(chain)
                            continue
                    }
                }
                ++column
            }
        }
        return set
    }
    
    private func detectVerticalMatches() -> Array<Chain> {
        var set = Array<Chain>()
        
        for column in 0..<NumColumns {
            for var row = 0; row < NumRows - 2; {
                if let move = moves[column, row] {
                    let matchType = move.moveType
                    
                    if moves[column, row + 1]?.moveType == matchType &&
                        moves[column, row + 2]?.moveType == matchType {
                            
                            let chain = Chain(chainType: .Vertical)
                            do {
                                chain.addMove(moves[column, row]!)
                                ++row
                            }
                                while row < NumRows && moves[column, row]?.moveType == matchType
                            
                            // Make the same test here, but reversed
                            set.append(chain)
                            continue
                    }
                }
                ++row
            }
        }
        return set
    }
    
    

    
    func removeMatches() -> Array<Chain> {
        var horizontalChains = detectHorizontalMatches()
        var verticalChains = detectVerticalMatches()
       
        // For iteration
        var i : Int!
        
        i = 0
        
        // Responsible for removing the matches and identifying what the contribuition of each character was to the round.
        
        var horizontalActs: [(Int, MoveType)] = [] // The first variable is the Number of Blocks of the line. The second variable is the Character responsible for the line
        
        for i in 0..<horizontalChains.count {
            
            horizontalActs += [(horizontalChains[i].moves.count, horizontalChains[i].moves[0].moveType)] // Note that I put moves[0] since I already know, for sure that all the pieces are of the same type, so, by picking either the first one up to the third I guarantee it's of the same type.
            
        }
        
        var verticalActs: [(Int, MoveType)] = []
        for i in 0..<verticalChains.count {
            
            verticalActs += [(verticalChains[i].moves.count, verticalChains[i].moves[0].moveType)] // Note that I put moves[0] since I already know, for sure that all the pieces are of the same type, so, by picking either the first one up to the third I guarantee it's of the same type.
            
        }
        
        
        self.teamPerformance = roundResults(horizontalActs,vertical: verticalActs)
        
        println("Horizontal matches: \(horizontalChains)")
        println("Vertical matches: \(verticalChains)")
      //  println("TESTING RAW VALUE --> \(verticalActs[0].1)")
        
        removeMoves(horizontalChains)
        removeMoves(verticalChains)
        
        while verticalChains.count > i {
        
        // Here we select all the matches made and return them at once
            
        /*
            calculateScores(horizontalChains)
            calculateScores(verticalChains)
            
            */
            
        horizontalChains.append(verticalChains[i])
        i = i + 1
        
        }
        
        return horizontalChains 
    }
    
    // Method responsible for calculating the results based on the characters actions of the passed round.
    
    func roundResults(horizontal: [( Int, MoveType)], vertical: [(Int, MoveType)]) -> Array<Int>!{
        
        // The array that will hold the points each character made. If they did nothing their position will receive 0.
        var charactersContribuition : Array<Int>! = Array<Int>()
        
        var i : Int! = 0
        var j : Int! = 0
        
        for j in 0..<5
        {
          //  charactersContribuition[j] = 0
            charactersContribuition.append(0)
        }
        
        j = 0
        
        while j < 5{ // It will run 5 times. One for each character that there currently is. By doing so it shall search for the particular character until it's either found or not. By being found it run's the logic to add points.
            
            for i in 0..<horizontal.count{
                
                if horizontal[i].1.rawValue == (j + 1) // Compares to (j + 1) since j = 0 is of type Unknown.
                {
                    
                    // This is the basic logic for scoring: If the character makes a line of 3, he gets 30 points. But, if he gets more than 3, he will receive a boost of 40 points per additional block. *Later, a more developed mechanism can be implemented, such as an Icon getting more points per additional piece of the row, and other special effects
                    if horizontal[i].0 == 3 {
                        
                        charactersContribuition[j] = charactersContribuition[j] + 60
                        
                    }
                        
                    else {
                        
                        charactersContribuition[j] = charactersContribuition[j] + ((horizontal[i].0 - 3)*40 + 60)
                        
                    }
                    
                }
            }
            
            for i in 0..<vertical.count{
                
                if vertical[i].1.rawValue == (j + 1){
                    
                    // This is the basic logic for scoring: If the character makes a line of 3, he gets 30 points. But, if he gets more than 3, he will receive a boost of 40 points per additional block. *Later, a more developed mechanism can be implemented, such as an Icon getting more points per additional piece of the row, and other special effects
                    if vertical[i].0 == 3 {
                        
                        charactersContribuition[j] = charactersContribuition[j] + 60
                        
                    }
                        
                    else {
                        
                        charactersContribuition[j] = charactersContribuition[j] + ((vertical[i].0 - 3)*40 + 60)
                        
                    }
                    
                }
            }
            j?++
        }
        
        return charactersContribuition
        
    }
    
    private func removeMoves(chains: Array<Chain>) {
        for chain in chains {
            for move in chain.moves {
                moves[move.column, move.row] = nil
            }
        }
    }
    
    func isPossibleSwap(swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }
    
    private func hasChainAtColumn(column: Int, row: Int) -> Bool {
        let moveType = moves[column, row]!.moveType
        
        var horzLength = 1
        for var i = column - 1; i >= 0 && moves[i, row]?.moveType == moveType;
            --i, ++horzLength { }
        for var i = column + 1; i < NumColumns && moves[i, row]?.moveType == moveType;
            ++i, ++horzLength { }
        if horzLength >= 3 { return true }
        
        var vertLength = 1
        for var i = row - 1; i >= 0 && moves[column, i]?.moveType == moveType;
            --i, ++vertLength { }
        for var i = row + 1; i < NumRows && moves[column, i]?.moveType == moveType;
            ++i, ++vertLength { }
        return vertLength >= 3
    }
    
    func detectPossibleSwaps() {
        var set = Set<Swap>()
        
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let move = moves[column, row] {
                    
                    // Is it possible to swap this cookie with the one on the right?
                    if column < NumColumns - 1 {
                        if let other = moves[column + 1, row] {
                            moves[column, row] = other
                            moves[column + 1, row] = move
                            
                            if hasChainAtColumn(column + 1, row: row) ||
                                hasChainAtColumn(column, row: row) {
                                set.insert(Swap(moveA: move, moveB: other))
                            }
                            
                            // Swap them back
                            moves[column, row] = move
                            moves[column + 1, row] = other
                        }
                    }
                    
                    if row < NumRows - 1 {
                        if let other = moves[column, row + 1] {
                            moves[column, row] = other
                            moves[column, row + 1] = move
                            
                            // Is either cookie now part of a chain?
                            if hasChainAtColumn(column, row: row + 1) ||
                                hasChainAtColumn(column, row: row) {
                                set.insert(Swap(moveA: move, moveB: other))
                            }
                            
                            // Swap them back
                            moves[column, row] = move
                            moves[column, row + 1] = other
                        }
                    }
                }
            }
        }
        
        possibleSwaps = set
    }
    
    func fillHoles() -> [[Move]] {
        var columns = [[Move]]()
 
        for column in 0..<NumColumns {
            var array = [Move]()
            for row in 0..<NumRows {
                // If there’s a tile at a position but no cookie, then there’s a hole
                if tiles[column, row] != nil && moves[column, row] == nil {
                    // Scan up to find the cookie above the hole
                    for lookup in (row + 1)..<NumRows {
                        if let move = moves[column, lookup] {
                            // Here you put the Move down a space
                            moves[column, lookup] = nil
                            moves[column, row] = move
                            move.row = row
                            // Add the move to array
                            array.append(move)
                            break
                        }
                    }
                }
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    // Puts new moves nto the - now - blank spaces
    func topUpMoves() -> [[Move]] {
        var columns = [[Move]]()
        var moveType: MoveType = .Unknown
        
        for column in 0..<NumColumns {
            var array = [Move]()
        
            for var row = NumRows - 1; row >= 0 && moves[column, row] == nil; --row {
            
                if tiles[column, row] != nil {
                    // You randomly create a new move piece. It can’t be equal to the type of the last new one, so it avoids too many "free-points"
                    var newMoveType: MoveType
                    do {
                        newMoveType = MoveType.random()
                    } while newMoveType == moveType
                    moveType = newMoveType
                    let move = Move(column: column, row: row, moveType: moveType)
                    moves[column, row] = move
                    array.append(move)
                }
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
/*
    private func calculateScores(chains: Set<Chain>) {

    Sugestion to use this method to see everything that each piece did
    
    }
*/

    
    func shuffle() -> Array<Move> {
        return createInitialMoves()
    }
    
    
}
