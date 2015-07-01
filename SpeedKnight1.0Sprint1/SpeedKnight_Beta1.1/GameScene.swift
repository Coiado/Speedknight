//
//  GameScene.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 15/04/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
// testando pull

import SpriteKit

class GameScene: SKScene {
    
    var selectionSprite = SKSpriteNode()
    let tilesLayer = SKNode()
    var swipeFromColumn: Int?
    var swipeFromRow: Int?
    var swipeHandler: ((Swap) -> ())? // This (closure/function) takes a Swap object as its parameter and returns nothing. The question mark indicates that it can be nil... (right?).
    var teamDeaths : Array<Int>! = []
   // var animationsNode : SKNode! = SKNode()
    let monster = SKSpriteNode (imageNamed: GameData.sharedInstance.enemyImage)
    
    
    public var level: Level!
    var animations : Animations! = Animations()

    
    let TileWidthOriginal:CGFloat = 32.0
    let TileHeightOriginal:CGFloat = 36.0
    
    let TileWidth: CGFloat = adjustX(32.0)
    let TileHeight: CGFloat = adjustY(36.0)
    
    let gameLayer = SKNode()
    let movesLayer = SKNode()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: GameData.sharedInstance.backgroundImage) // Why?
        addChild(background)

        addChild(monster)
        
       // addChild(animationsNode)
        
        addChild(gameLayer)
        
        let layerPosition =  adjustPoint(CGPoint(
            x: -TileWidthOriginal * CGFloat(NumColumns) / 2,
            y: (-TileHeightOriginal * CGFloat(NumRows) / 2) - 170))
        
        tilesLayer.position = layerPosition
        gameLayer.addChild(tilesLayer)
        
        movesLayer.position = layerPosition
        gameLayer.addChild(movesLayer)
        
        swipeFromColumn = nil
        swipeFromRow = nil
        
        // Check to make a system that alters the Level value here (or maybe try to do it in the GameViewController)
        self.level = Level(levelFilename: GameData.sharedInstance.levelFile)

    }
    
    func createMovesLayer(){
        movesLayer.position = adjustPoint(CGPoint(
            x: -TileWidthOriginal * CGFloat(NumColumns) / 2,
            y: (-TileHeightOriginal * CGFloat(NumRows) / 2) - 170))
        gameLayer.addChild(movesLayer)
    }
    
    // Show highlighted images
    func highlightMove(move: Move) {
        if selectionSprite.parent != nil {
            selectionSprite.removeFromParent()
        }
        
        if let sprite = move.sprite {
            let texture = SKTexture(imageNamed: move.moveType.highlightedSpriteName)
            selectionSprite.size = texture.size()
            selectionSprite.runAction(SKAction.setTexture(texture))
            
            sprite.addChild(selectionSprite)
            selectionSprite.alpha = 1.0
        }
    }
    
    // Hide the images
    func hideSelectionIndicator() {
        selectionSprite.runAction(SKAction.sequence([
            SKAction.fadeOutWithDuration(0.3),
            SKAction.removeFromParent()]))
    }
    
    // Tile is not showing up, for some reason...
    func addTiles() {
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                if let tile = level.tileAtColumn(column, row: row) {
                    let tileNode = SKSpriteNode(imageNamed: "Tile") // Look up: "SKSpriteNode", to check the tileNode
                    tileNode.position = pointForColumn(column, row: row)
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

        // It converts the touch location to a point relative to the layer
        for touch: AnyObject in touches{
            
            
//            var location = (touch as! UITouch).locationInNode(self)
            var location = (touch as! UITouch).locationInNode(movesLayer)   //original

             // Then, it finds out if the touch is inside a square on the level grid by calling the method below
            let (success, column, row) = convertPoint(location)
//            if movesLayer.containsPoint(location){
            
        if success { //original
            println("Entrou")
            // Next, the method sees if the move you're touching is actua1lly alive.
            if !contains(teamDeaths!, level.moveAtColumn(column, row: row)!.moveType.rawValue){ // VERIFY! Constantly shows that it found "nil"
                // Next, the method verifies that the touch is on a move rather than on an empty square.
                if let move = level.moveAtColumn(column, row: row) { // Now the same 'nil unwrapping error' is happenning here....
                
                    swipeFromColumn = column
                    swipeFromRow = row
                    highlightMove(move)
                }
            }
        }
        else{
            println("FUDEU MUITO \n")
            }
        }
    }
    
    func addSpritesForMoves(deadMembers : Array<Int>!, moves: Array<Move>) {
        var displayCharacterImage: String!
        for move in moves {
            let moves = Array<Move>()
            
            // Checks to see whether the player the move is alive or not, changing it's pic accordingly.
            if contains(deadMembers, move.moveType.rawValue){
            displayCharacterImage = move.moveType.deadSpriteName
            }
                
            else {
            displayCharacterImage = move.moveType.spriteName
            }
            //println("Passei aqui")// Isn't being called, ever!
            let sprite = SKSpriteNode(imageNamed: displayCharacterImage)
            sprite.position = pointForColumn(move.column, row:move.row)
            sprite.size = adjustSize(sprite.size)
            sprite.alpha = 1.0
            movesLayer.addChild(sprite)
            move.sprite = sprite
            
        }
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint { // Making mistakes in the calculations, maybe? (Unlikely, but...). It's possible that the  CGPoint is not generating a value lower than 0
        
        return adjustPoint(CGPoint(
            x: CGFloat(column)*TileWidthOriginal + TileWidthOriginal/2,
            y: CGFloat(row)*TileHeightOriginal + TileHeightOriginal/2))
    }
    
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth &&
            point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
                return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0)  // invalid location
            //return (false, Int(point.x / TileWidth), Int(point.y / TileHeight))

        }
    }
    
    func trySwapHorizontal(horzDelta: Int, vertical vertDelta: Int) {
        // You calculate the column and row numbers of the move to swap with.
        let toColumn = swipeFromColumn! + horzDelta
        let toRow = swipeFromRow! + vertDelta
    
        if toColumn < 0 || toColumn >= NumColumns { return }
        if toRow < 0 || toRow >= NumRows { return }
        // Next, the method checks if the move with which it intends to switch is actually alive (not-dead)
        if contains(teamDeaths, level.moveAtColumn(toColumn, row: toRow)!.moveType.rawValue) { return } // FUCKING BITCHES IN DA HOUSE :) !!!
    
        if let toMove = level.moveAtColumn(toColumn, row: toRow) {
            if let fromMove = level.moveAtColumn(swipeFromColumn!, row: swipeFromRow!) {
               // if !contains(teamDeaths, fromMove.moveType.rawValue) || !contains(teamDeaths, toMove.moveType.rawValue){
                // When you get here, it means everything is ok and this is a valid swap
                    if let handler = swipeHandler {
                        let swap = Swap(moveA: fromMove, moveB: toMove)
                        handler(swap) // Seems fine, so far.... (5)
                    }
                //}
            }
        }
        
    }
    
    
    // Apparently alright, still... (6)
    
    // The move that was the origin of the swipe is in moveA and the animation looks best if that one appears on top, so this method is supposed to adjust the relative zPosition between the two move sprites. Not only that, it will, then, wait for the animation to be completed, so the player can finally do a next move.
    
    
    func animateSwap(swap: Swap, completion: () -> ()) {
        let spriteA = swap.moveA.sprite!
        let spriteB = swap.moveB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let Duration: NSTimeInterval = 0.3
        
        let moveA = SKAction.moveTo(spriteB.position, duration: Duration)
        moveA.timingMode = .EaseOut
        spriteA.runAction(moveA, completion: completion)
        
        let moveB = SKAction.moveTo(spriteA.position, duration: Duration)
        moveB.timingMode = .EaseOut
        spriteB.runAction(moveB)
    }
    
    func animateMatchedMoves(chains: Array<Chain>, completion: () -> ()) {
        for chain in chains {
            for move in chain.moves {
                if let sprite = move.sprite {
                    if sprite.actionForKey("removing") == nil {
                        let scaleAction = SKAction.scaleTo(0.1, duration: 0.3)
                        scaleAction.timingMode = .EaseOut
                        sprite.runAction(SKAction.sequence([scaleAction, SKAction.removeFromParent()]),
                            withKey:"removing")
                    }
                }
            }
        }
        //runAction(matchSound)             <- Will put the sound later!
        runAction(SKAction.waitForDuration(0.3), completion: completion)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {

        if selectionSprite.parent != nil && swipeFromColumn != nil {
            hideSelectionIndicator()
        }
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {

        touchesEnded(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
       
        /*If swipeFromColumn is nil, then either the swipe began outside the valid area or the game has already swapped the moves and you need to ignore the rest of the motion. You could keep track of this in a separate boolean but using swipeFromColumn is just as easy — that’s why you made it an optional.*/
        
        if swipeFromColumn == nil { return }
        
        
        for touch: AnyObject in touches{
            let location = (touch as! UITouch).locationInNode(movesLayer)
        
        
        let (success, column, row) = convertPoint(location)
            
        if success {
            
            // Here the method figures out the direction of the player’s swipe by simply comparing the new column and row numbers to the previous ones.
            var horzDelta = 0, vertDelta = 0
            if column < swipeFromColumn! {          // swipe left
                horzDelta = -1
            } else if column > swipeFromColumn! {   // swipe right
                horzDelta = 1
            } else if row < swipeFromRow! {         // swipe down
                vertDelta = -1
            } else if row > swipeFromRow! {         // swipe up
                vertDelta = 1
            }
            
            
            if horzDelta != 0 || vertDelta != 0 {
                trySwapHorizontal(horzDelta, vertical: vertDelta)
                hideSelectionIndicator()
                
             // By setting swipeFromColumn back to nil, the game will ignore the rest of this swipe motion.
                swipeFromColumn = nil
            }
        }
        }
        
    }
    
    func animateFallingMoves(columns: [[Move]], completion: () -> ()) {

        var longestDuration: NSTimeInterval = 0
        for array in columns {
            for (idx, move) in enumerate(array) {
                let newPosition = pointForColumn(move.column, row: move.row)
                // The higher up the move is, the bigger the delay on the animation.
                let delay = 0.05 + 0.15*NSTimeInterval(idx)
                let sprite = move.sprite!
                let duration = NSTimeInterval(((sprite.position.y - newPosition.y) / TileHeight) * 0.1)
                // Calculates which animation is the longest
                longestDuration = max(longestDuration, duration + delay)
                
                let moveAction = SKAction.moveTo(newPosition, duration: duration)
                moveAction.timingMode = .EaseOut
                sprite.runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(delay),
                        SKAction.group([moveAction])]))
            }
        }
        
        runAction(SKAction.waitForDuration(longestDuration), completion: completion)
    }
    
    // Animates the new moves being generated, rendering their random sprites.
    func animateNewMoves(columns: [[Move]], completion: () -> ()) {
        var longestDuration: NSTimeInterval = 0
        
        for array in columns {
            let startRow = array[0].row + 1
            
            for (idx, move) in enumerate(array) {
                let sprite = SKSpriteNode(imageNamed: move.moveType.spriteName)
                sprite.position = pointForColumn(move.column, row: startRow)
                sprite.size = adjustSize(sprite.size)
                movesLayer.addChild(sprite)
                move.sprite = sprite
                
                let delay = 0.1 + 0.2 * NSTimeInterval(array.count - idx - 1)
                let duration = NSTimeInterval(startRow - move.row) * 0.1
                longestDuration = max(longestDuration, duration + delay)
                let newPosition = pointForColumn(move.column, row: move.row)
                let movingAction = SKAction.moveTo(newPosition, duration: duration)
                movingAction.timingMode = .EaseOut
                sprite.alpha = 0
                sprite.runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(delay),
                        SKAction.group([
                            SKAction.fadeInWithDuration(0.05),
                            movingAction])
                        ]))
            }
        }
        runAction(SKAction.waitForDuration(longestDuration), completion: completion)
        }

}