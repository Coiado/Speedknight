//
//  GameViewController.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 15/04/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import AVFoundation
import UIKit
import SpriteKit

// Check the logic after the first round, since it is now allowing the moves to be instantly destryed afterwards [X] -> Problem solved! Now just add a check to see if the enemy died (or you)! And, if so, end the level! Than focus on the battle system
class GameViewController: UIViewController {
    var scene: GameScene!
    let ai : Enemy_AI! = Enemy_AI()
    let data : GameData = GameData.sharedInstance
    var animations : Animations! = Animations()
    
    @IBOutlet weak var enemyHpBar: UIImageView!
    
    var multiplierDefense: Float! = 1.0
    var multiplier: Float! = 1.0
    var specialDamage:Int! = 0
    var counter : Int! = 0
    var resultsBox : UIImageView!
    var buttonNext : UIButton!
    var newMoves : Array<Move>! = Array<Move>()
    var turnNumber : Int! = 0
    var currentEnemyHP : Int! = 0
    var totalEnemyHP : Int! = 0
    var partyAttack : Int! = 0
    var partyMembers: [(HP: Float, Att: Int, Def: Int, Picture: String, RawValue : Int)]! = GameData.sharedInstance.team
    var enemyDamageDealt : Array<Float>! = []
    var enemyDefense: Array<Int>!
    var labelPartyHP0: UILabel = UILabel()
    var labelPartyHP1: UILabel = UILabel()
    var labelPartyHP2: UILabel = UILabel()
    var labelPartyHP3: UILabel = UILabel()
    var labelHP: UILabel = UILabel()
    var labelPartyMember0: UIImageView = UIImageView()
    var labelPartyMember1: UIImageView = UIImageView()
    var labelPartyMember2: UIImageView = UIImageView()
    var labelPartyMember3: UIImageView = UIImageView()
    var labelAtack: UILabel = UILabel()
    var labelDefense: UILabel = UILabel()
    var labelShuffle: UILabel = UILabel()
    
    var buttonYes : UIButton!
    var buttonNo : UIButton!
    var buttonShuffle : UIButton!
    
    var qtdShuffle : Int!
    
    var backgroundMusic = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Volatile Reaction", ofType: "mp3")!)
    var backgroundSong = AVAudioPlayer()
    
    // Images for the "YES" an "NO" buttons for the initialTextox + the image for the actual TextBox, respectively
 //   let yesImage = UIImage(named: "Game_TextBox_YesButton1") as UIImage?
 //   let noImage = UIImage(named: "Game_TextBox_NoButton1") as UIImage?
    var initialTextBox : UIImageView!
    
    // Below are the variables responsible for the timer logic.
    @IBOutlet weak var battleTimerLabel: UILabel!
    var timerCount : Int!
    var timerRunning : Bool!
    var timer : NSTimer!
    
    
    // Creates the  box to warn the player of the fight!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
     //   let backgroundMusic = SKAction.repeatActionForever(SKAction.playSoundFileNamed("Volatile Reaction.mp3", waitForCompletion: true))
        initialValues()
        backgroundSong.play()
        
        self.view.userInteractionEnabled = false
        labelHP.font = UIFont(name: ("Papyrus"), size: 20)
        labelHP.textColor = UIColor.whiteColor()
        labelHP.frame = adjustRectSize(CGRectMake(13, -80, 400, 400))
        labelHP.hidden = true
        self.view.addSubview(labelHP)
        
        labelPartyHP0.font = UIFont(name: ("Papyrus"), size: 20)
        labelPartyHP0.textColor = UIColor.whiteColor()
        labelPartyHP0.frame = adjustRectSize(CGRectMake(53, -45, 400, 400))
        labelPartyHP0.hidden = true
        self.view.addSubview(labelPartyHP0)
        
        labelPartyMember0 = UIImageView((frame:adjustRectSize(CGRectMake(13, 138, 30, 30))))
        labelPartyMember0.image = UIImage(named:data.team[0].Picture )
        labelPartyMember0.hidden = true
        self.view.addSubview(labelPartyMember0)
        
        labelPartyHP1.font = UIFont(name: ("Papyrus"), size: 20)
        labelPartyHP1.textColor = UIColor.whiteColor()
        labelPartyHP1.frame = adjustRectSize(CGRectMake(53, -15, 400, 400))
        labelPartyHP1.hidden = true
        self.view.addSubview(labelPartyHP1)
        
        labelPartyMember1 = UIImageView((frame:adjustRectSize(CGRectMake(13, 168, 30, 30))))
        labelPartyMember1.image = UIImage(named:data.team[1].Picture )
        labelPartyMember1.hidden = true
        self.view.addSubview(labelPartyMember1)
        
        labelPartyHP2.font = UIFont(name: ("Papyrus"), size: 20)
        labelPartyHP2.textColor = UIColor.whiteColor()
        labelPartyHP2.frame = adjustRectSize(CGRectMake(53, 15, 400, 400))
        labelPartyHP2.hidden = true
        self.view.addSubview(labelPartyHP2)
        
        labelPartyMember2 = UIImageView((frame:adjustRectSize(CGRectMake(13, 198, 30, 30))))
        labelPartyMember2.image = UIImage(named:data.team[2].Picture )
        labelPartyMember2.hidden = true
        self.view.addSubview(labelPartyMember2)
        
        labelPartyHP3.font = UIFont(name: ("Papyrus"), size: 20)
        labelPartyHP3.textColor = UIColor.whiteColor()
        labelPartyHP3.frame = adjustRectSize(CGRectMake(53, 45, 400, 400))
        labelPartyHP3.hidden = true
        self.view.addSubview(labelPartyHP3)
        
        labelPartyMember3 = UIImageView((frame:adjustRectSize(CGRectMake(13, 228, 30, 30))))
        labelPartyMember3.image = UIImage(named:data.team[3].Picture )
        labelPartyMember3.hidden = true
        self.view.addSubview(labelPartyMember3)
        
        
        //level = Level(filename: "Level1")
        timerCount = 13
        timerRunning = false
        timer = NSTimer()
        
        // Just for testing right now...
        
        totalEnemyHP = scene.level.enemyHP // Passes the HP from the enemy of the level
        currentEnemyHP = totalEnemyHP
        
        // Check to load the team here
        
//        initialTextBox  = UIImageView(frame:adjustRectSize(CGRectMake(27, 410, 320, 220)));
//        initialTextBox.image = UIImage(named:"TesteGame_Textbox_1.png")
//        self.view.addSubview(initialTextBox)
//        
//        // Creates the "YES" and "NO" buttons respectively
//        
//        buttonYes = UIButton() as UIButton // Needs to be made custom so you can alter the image.
//        buttonYes.frame = adjustRectSize(CGRectMake(253, 545, 75, 58))
//        buttonYes.setImage(yesImage, forState: UIControlState.Normal)
//        buttonYes.addTarget(self, action: "play_or_not:", forControlEvents: UIControlEvents.TouchUpInside) // Remeber to put ":" after the selector's name (in this case the "play_or_not" method)
//        
//        self.view.addSubview(buttonYes)
//        
//        buttonNo = UIButton() as UIButton
//        buttonNo.frame = adjustRectSize(CGRectMake(52, 545, 75, 58))
//        // Image not showing up
//        buttonNo.setImage(noImage, forState: UIControlState.Normal)
//        buttonNo.addTarget(self, action: "play_or_not:", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        self.view.addSubview(buttonNo)
        
        let shuffleImage = UIImage(named: "ShuffleButton") as UIImage?
        
        buttonShuffle = UIButton() as UIButton
        buttonShuffle.frame = adjustRectSize(CGRectMake(250, 105, 75, 58))
        buttonShuffle.setImage(shuffleImage, forState: UIControlState.Normal)
        buttonShuffle.addTarget(self, action: "troca", forControlEvents: UIControlEvents.TouchUpInside)
        self.qtdShuffle = 3
        self.view.addSubview(buttonShuffle)
        
        labelShuffle.font = UIFont(name: ("Papyrus"), size: 20)
        labelShuffle.textColor = UIColor.whiteColor()
        labelShuffle.frame = adjustRectSize(CGRectMake(337, 110, 50, 50))
        labelShuffle.text = "x\(self.qtdShuffle)"
        self.view.addSubview(labelShuffle)
        
        shuffle()
        startGame()
        
    } // As soon as it ends, the problem begins
    
    // Method that decides whether or not the player will begin the level!
    
    func startGame() {
        multiplier = 1.0
        multiplierDefense = 1.0
        var prepareLabel = UILabel()
        prepareLabel.text = "PREPARE TO FIGHT"
        prepareLabel.font = UIFont(name: "Papyrus", size: 24)
        prepareLabel.frame = adjustRectSize(CGRectMake(75, 100, 400, 400))
        prepareLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(prepareLabel)
        
        let block = SKAction.runBlock()
            {
                prepareLabel.text = "           FIGHT!" // <- Preguica
                self.beginGame()
            }
        let remove = SKAction.runBlock()
            {
                prepareLabel.removeFromSuperview()
            }
        let wait = SKAction.waitForDuration(3)
        self.scene.runAction(SKAction.sequence([wait,block,wait,remove]))
        
    }
    
    func troca()
    {
        if(self.qtdShuffle > 0){
            self.qtdShuffle = self.qtdShuffle - 1
            self.labelShuffle.text =  "x\(self.qtdShuffle)"
            self.scene.movesLayer.removeFromParent()
            self.scene.movesLayer.removeAllChildren()
            self.scene.createMovesLayer()
            shuffle()
        }
    }
    
    func play_or_not(sender:UIButton!)
    {
        if buttonYes.touchInside == true {
            //println("YES tapped")
            
            // Removes each individual piece of the initial text box (the box and the 2 buttons)
            
            initialTextBox.removeFromSuperview()
            buttonNo.removeFromSuperview()
            buttonYes.removeFromSuperview()

            
            beginGame()

        }
            
        else if buttonNo.touchInside == true {
            //println("NO tapped")
            
            // Will be used to go back to the main menu
        }
    }
    
    
    func returnMin(num1: Float , num2: Float) -> Float!
    {
        if(num1 < num2){
            return num1
        }
        return num2
    }
    
    func battleSystem (at: Array<Float>!, def: Array<Int>!){
        
        var opponentDefense : Int! = 0
        
        var i : Int! = 0
        partyAttack = 0
        
        for i in 0..<4 {
        
        // Add the attack of each character
        partyAttack = partyAttack + self.scene.level.teamPerformance[i]
        // Add the defense points against each one's attac
        opponentDefense = opponentDefense + def[i]
        // Each character takes the damage of the round
        partyMembers[i].HP = returnMin(partyMembers[i].HP, num2: ((partyMembers[i].HP - at[i]) + 2*Float(self.scene.level.roundDefensiveInstance)))
        GameData.sharedInstance.team[i].HP = partyMembers[i].HP
        self.ai.party[i].HP = partyMembers[i].HP
            if partyMembers[i].HP < 0{
                partyMembers[i].HP = 0.0
                GameData.sharedInstance.team[i].HP = 0.0
                self.ai.party[i].HP = 0.0
            }
            if partyMembers[i].HP == 0.0  {
            self.scene.teamDeaths.append(partyMembers[i].RawValue)
            var currentField : Array<Move>! = self.scene.level.determineFieldOfMoves()
            scene.movesLayer.removeAllChildren()
            scene.addSpritesForMoves(self.scene.teamDeaths, moves: currentField)
            }
        }
        self.scene.level.roundDefensiveInstance = 0
        
        if partyAttack > opponentDefense  && (partyAttack - opponentDefense) < currentEnemyHP
        {
        currentEnemyHP = currentEnemyHP - (partyAttack - opponentDefense)
        }
        
        else if (partyAttack - opponentDefense) > currentEnemyHP
        {
        currentEnemyHP = 0
        }
        
    }
    
    // Method that controls the battleTimer logic
    func fightTime (){
        
    timerCount = timerCount - 1
    battleTimerLabel.text = "\(timerCount)"
        if timerCount < 1 {
            self.view.userInteractionEnabled = false
            timer.invalidate()
            
            // Once the time has ended,it will verify all the matches and remove them, calculating their meaning!
            
            //presentResults(self.scene.level.teamPerformance)
            
            // Remember so it keeps on repeaing just fine.
            timerRunning = false
            timerCount = 13
            battleTimerLabel.text = "\(timerCount)"
          //  scene.movesLayer.removeAllChildren()
            turnNumber?++
            //self.view.userInteractionEnabled = true 
            handleMatches()

            }
  
    }

    
    // Method that is responsible for all the current level logic
    
    func beginGame() {
        
        battleTimerLabel.hidden = false
        self.view.userInteractionEnabled = true
        if timerRunning == false {
        
        timer = NSTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("fightTime"), userInfo: nil, repeats: true) // No need to put ":" after the selector when using "Selector(selector's name)"
        timerRunning = true
            }
        //shuffle()
    }
    
    
    func shuffle() {
        
        //println("Passei aqui") // <- Entered here
        newMoves = scene.level.shuffle() 
        scene.addSpritesForMoves(self.scene.teamDeaths, moves: newMoves)
    
    }
    
    func specialHealHP(value: Float){
        
        for i in 0..<4
        {
            if(partyMembers[i].HP != 0){
            partyMembers[i].HP = partyMembers[i].HP + value
                if(partyMembers[i].HP > 100.0)
                {
                    partyMembers[i].HP = 100.0
                }
            }
        }

        let nskey : String! = NSBundle.mainBundle().pathForResource("HealingParticles", ofType: "sks")
        let heal1 = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        let heal2 = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        let heal3 = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        let heal4 = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        
        let addEffects : SKAction! = SKAction.runBlock()
            {
                
                heal1.position = adjustPoint(CGPointMake(-153, 90))
                heal2.position = adjustPoint(CGPointMake(-153, 120))
                heal3.position = adjustPoint(CGPointMake(-153, 150))
                heal4.position = adjustPoint(CGPointMake(-153, 180))
                
                self.scene.addChild(heal1)
                self.scene.addChild(heal2)
                self.scene.addChild(heal3)
                self.scene.addChild(heal4)
                
                self.labelPartyHP0.textColor = UIColor.greenColor()
                self.labelPartyHP1.textColor = UIColor.greenColor()
                self.labelPartyHP2.textColor = UIColor.greenColor()
                self.labelPartyHP3.textColor = UIColor.greenColor()
                
        }
        
        let wait : SKAction! = SKAction.waitForDuration(2.5)
        
        let removeEffects : SKAction! = SKAction.runBlock()
            {
                heal1.removeFromParent()
                heal2.removeFromParent()
                heal3.removeFromParent()
                heal4.removeFromParent()
                
                self.labelPartyHP0.textColor = UIColor.whiteColor()
                self.labelPartyHP1.textColor = UIColor.whiteColor()
                self.labelPartyHP2.textColor = UIColor.whiteColor()
                self.labelPartyHP3.textColor = UIColor.whiteColor()
        }
        
        self.scene.runAction(SKAction.sequence([addEffects,wait,removeEffects]))

    }
    
    // Ai meu saco!
    func specialDeath(){
        let number = self.scene.teamDeaths.count + 1
        specialDamage = specialDamage + 70 * number
        
        let nskey : String! = NSBundle.mainBundle().pathForResource("SingleSwordMove", ofType: "sks")
        let specialTrail = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        let swordImage : SKSpriteNode! = SKSpriteNode(imageNamed: "SpecialSingleSword")
        
        swordImage.size = CGSize(width: 85,height: 85) // Adicionar correção de tamanho para demais devices
        
        let movingRL = SKAction.moveTo(adjustPoint(CGPointMake(-75, -5)), duration: 1.8)
        let movingLR = SKAction.moveTo(adjustPoint(CGPointMake(75, -5)), duration: 1.8)
        let rotation = SKAction.rotateToAngle(2160.0, duration: 2.0)
        movingRL.timingMode = .EaseOut
        movingLR
        
        let blueExplosion = SKAction.runBlock()
            {
                specialTrail.particlePositionRange = CGVector(dx: 150.0, dy: 150.0) // -> need to be made changeable according to device
                specialTrail.yAcceleration = 0.0
        }
        
        let slashRightLeft : SKAction! = SKAction.runBlock()
            {
                specialTrail.position = adjustPoint(CGPointMake(50, 200))
                specialTrail.name = "OrangePower"
                self.scene.addChild(specialTrail)
                self.scene.childNodeWithName("OrangePower")?.runAction(SKAction.sequence([SKAction.moveTo(adjustPoint(CGPoint(x: -50,y: 7)), duration: 2), SKAction.fadeAlphaTo(0.0, duration: 0.3)]))
                
                swordImage.position = adjustPoint(CGPointMake(50, 200))
                self.scene.addChild(swordImage)
                swordImage.runAction(
                    SKAction.sequence([
                        SKAction.group([
                            SKAction.fadeInWithDuration(0.05),
                            movingRL]), SKAction.fadeAlphaTo(0.0, duration: 0.3)
                        ]))
                
        }
        
        let slashLeftRight : SKAction! = SKAction.runBlock() // You have to change the alpha channels back to 1.0 (also try using easeOut); put the picture as -90 degrees
            {
                specialTrail.alpha = 1.0
                specialTrail.position = adjustPoint(CGPointMake(-50, 200))
                specialTrail.name = "OrangePower"
//                self.scene.addChild(specialTrail)
                self.scene.childNodeWithName("OrangePower")?.runAction(SKAction.sequence([SKAction.moveTo(adjustPoint(CGPoint(x: 50,y: 7)), duration: 2), SKAction.fadeOutWithDuration(0.6)]))
               
                swordImage.alpha = 1.0
                swordImage.position = adjustPoint(CGPointMake(-50, 200))
//                self.scene.addChild(swordImage)
                swordImage.runAction(
                    SKAction.sequence([
                        SKAction.group([
                            SKAction.fadeInWithDuration(0.05),
                            movingLR]), SKAction.fadeOutWithDuration(0.6)
                        ]))
                
        }
//
//        let slashMiddle : SKAction! = SKAction.runBlock()
//            {
//                specialTrail.position = adjustPoint(CGPointMake(0, 220))
//                specialTrail.name = "OrangePower"
//                self.scene.addChild(specialTrail)
//                self.scene.childNodeWithName("OrangePower")?.runAction(SKAction.moveTo(adjustPoint(CGPoint(x: 0,y: 10)), duration: 2.1))
//                self.scene.childNodeWithName("OrangePower")?.runAction(SKAction.sequence([SKAction.waitForDuration(2.2)]))
//                
//                axeImage.position = adjustPoint(CGPointMake(0, 220))
//                self.scene.addChild(axeImage)
//                axeImage.runAction(
//                    SKAction.sequence([
//                        SKAction.group([
//                            SKAction.fadeInWithDuration(0.05),
//                            movingAction, rotation])
//                        ]))
//                
//        }
//        
//        let animationRunning : SKAction! = SKAction.runBlock()
//            {
//                axeImage.runAction(SKAction.sequence([rotation, SKAction.waitForDuration(0.2), SKAction.fadeOutWithDuration(0.2)]))
//                specialTrail.runAction(SKAction.sequence([SKAction.waitForDuration(1.8), blueExplosion, SKAction.waitForDuration(0.2), SKAction.fadeOutWithDuration(0.2)]))
//                
//        }
        
        self.scene.runAction(SKAction.sequence([slashRightLeft]))
        
    }
    
    func specialMultiplier(value: Float){
        multiplier = multiplier + value
        let nskey : String! = NSBundle.mainBundle().pathForResource("AttackBoostParticles", ofType: "sks")
        let attackBoost1 = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        let attackBoost2 = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        let attackBoost3 = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        let attackBoost4 = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        
        let attackSign1 : SKSpriteNode! = SKSpriteNode(imageNamed: "AttackBoost")
        let attackSign2 : SKSpriteNode! = SKSpriteNode(imageNamed: "AttackBoost")
        let attackSign3 : SKSpriteNode! = SKSpriteNode(imageNamed: "AttackBoost")
        let attackSign4 : SKSpriteNode! = SKSpriteNode(imageNamed: "AttackBoost")
        attackSign1.size = CGSize(width: 38,height: 38)
        attackSign2.size = CGSize(width: 38,height: 38)
        attackSign3.size = CGSize(width: 38,height: 38)
        attackSign4.size = CGSize(width: 38,height: 38)





        let addEffects : SKAction! = SKAction.runBlock()
            {
                
                attackBoost1.position = adjustPoint(CGPointMake(-153, 90))
                attackBoost2.position = adjustPoint(CGPointMake(-153, 120))
                attackBoost3.position = adjustPoint(CGPointMake(-153, 150))
                attackBoost4.position = adjustPoint(CGPointMake(-153, 180))

                self.scene.addChild(attackBoost1)
                self.scene.addChild(attackBoost2)
                self.scene.addChild(attackBoost3)
                self.scene.addChild(attackBoost4)
                
                attackSign1.position = adjustPoint(CGPointMake(-73, 90))
                attackSign2.position = adjustPoint(CGPointMake(-73, 120))
                attackSign3.position = adjustPoint(CGPointMake(-73, 150))
                attackSign4.position = adjustPoint(CGPointMake(-73, 180))

                self.scene.addChild(attackSign1)
                self.scene.addChild(attackSign2)
                self.scene.addChild(attackSign3)
                self.scene.addChild(attackSign4)
                
                
        
            }
        
        let wait : SKAction! = SKAction.waitForDuration(2.5)
        
        let removeEffects : SKAction! = SKAction.runBlock()
            {
                attackBoost1.removeFromParent()
                attackBoost2.removeFromParent()
                attackBoost3.removeFromParent()
                attackBoost4.removeFromParent()
                
                attackSign1.removeFromParent()
                attackSign2.removeFromParent()
                attackSign3.removeFromParent()
                attackSign4.removeFromParent()
            }
    
        self.scene.runAction(SKAction.sequence([addEffects,wait,removeEffects]))
        
    }
    
    func specialDefense(value: Float){
        multiplierDefense = value + multiplierDefense
        let nskey : String! = NSBundle.mainBundle().pathForResource("DefenseBoostParticles", ofType: "sks")
        let defenseBoost1 = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        let defenseBoost2 = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        let defenseBoost3 = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        let defenseBoost4 = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        
        let defenseSign1 : SKSpriteNode! = SKSpriteNode(imageNamed: "DefenseBoost")
        let defenseSign2 : SKSpriteNode! = SKSpriteNode(imageNamed: "DefenseBoost")
        let defenseSign3 : SKSpriteNode! = SKSpriteNode(imageNamed: "DefenseBoost")
        let defenseSign4 : SKSpriteNode! = SKSpriteNode(imageNamed: "DefenseBoost")
        defenseSign1.size = CGSize(width: 38,height: 38)
        defenseSign2.size = CGSize(width: 38,height: 38)
        defenseSign3.size = CGSize(width: 38,height: 38)
        defenseSign4.size = CGSize(width: 38,height: 38)
        
        let addEffects : SKAction! = SKAction.runBlock()
            {
                
                defenseBoost1.position = adjustPoint(CGPointMake(-153, 90))
                defenseBoost2.position = adjustPoint(CGPointMake(-153, 120))
                defenseBoost3.position = adjustPoint(CGPointMake(-153, 150))
                defenseBoost4.position = adjustPoint(CGPointMake(-153, 180))
                
                self.scene.addChild(defenseBoost1)
                self.scene.addChild(defenseBoost2)
                self.scene.addChild(defenseBoost3)
                self.scene.addChild(defenseBoost4)
                
                defenseSign1.position = adjustPoint(CGPointMake(-73, 90))
                defenseSign2.position = adjustPoint(CGPointMake(-73, 120))
                defenseSign3.position = adjustPoint(CGPointMake(-73, 150))
                defenseSign4.position = adjustPoint(CGPointMake(-73, 180))
                
                self.scene.addChild(defenseSign1)
                self.scene.addChild(defenseSign2)
                self.scene.addChild(defenseSign3)
                self.scene.addChild(defenseSign4)
                
        }
        
        let wait : SKAction! = SKAction.waitForDuration(2.5)
        
        let removeEffects : SKAction! = SKAction.runBlock()
            {
                defenseBoost1.removeFromParent()
                defenseBoost2.removeFromParent()
                defenseBoost3.removeFromParent()
                defenseBoost4.removeFromParent()
                
                defenseSign1.removeFromParent()
                defenseSign2.removeFromParent()
                defenseSign3.removeFromParent()
                defenseSign4.removeFromParent()

        }
        
        self.scene.runAction(SKAction.sequence([addEffects,wait,removeEffects]))
    }
    
    func specialDamage(value: Int!){
        
        specialDamage = specialDamage + value
        let nskey : String! = NSBundle.mainBundle().pathForResource("AxeMove", ofType: "sks")
        let specialTrail = NSKeyedUnarchiver.unarchiveObjectWithFile(nskey) as! SKEmitterNode
        let axeImage : SKSpriteNode! = SKSpriteNode(imageNamed: "SpecialAxe")
        
        axeImage.size = CGSize(width: 80,height: 80) // Adicionar correção de tamanho para demais devices
        
        let movingAction = SKAction.moveTo(adjustPoint(CGPointMake(0, 0)), duration: 2.0)
        let rotation = SKAction.rotateToAngle(2160.0, duration: 2.0)
        movingAction.timingMode = .EaseOut
        
        let blueExplosion = SKAction.runBlock()
            {
            specialTrail.particlePositionRange = CGVector(dx: 150.0, dy: 150.0) // -> need to be made changeable according to device
            specialTrail.yAcceleration = 0.0
            }
        
        let animationBeginning : SKAction! = SKAction.runBlock()
            {
                specialTrail.position = adjustPoint(CGPointMake(0, 220))
                specialTrail.name = "BluePower"
                self.scene.addChild(specialTrail)
                self.scene.childNodeWithName("BluePower")?.runAction(SKAction.moveTo(adjustPoint(CGPoint(x: 0,y: 10)), duration: 2.1))
                self.scene.childNodeWithName("BluePower")?.runAction(SKAction.sequence([SKAction.waitForDuration(2.2)]))
                
                axeImage.position = adjustPoint(CGPointMake(0, 220))
                self.scene.addChild(axeImage)
                axeImage.runAction(
                    SKAction.sequence([
                        SKAction.group([
                            SKAction.fadeInWithDuration(0.05),
                            movingAction, rotation])
                        ]))

            }
        
        let animationRunning : SKAction! = SKAction.runBlock()
            {
                axeImage.runAction(SKAction.sequence([rotation, SKAction.waitForDuration(0.2), SKAction.fadeOutWithDuration(0.2)]))
                specialTrail.runAction(SKAction.sequence([SKAction.waitForDuration(1.8), blueExplosion, SKAction.waitForDuration(0.2), SKAction.fadeOutWithDuration(0.4)]))

            }
        
            self.scene.runAction(SKAction.sequence([animationBeginning, animationRunning]))

    }
    
    func specialIgnore() {
        for i in 0..<4
        {
            enemyDefense[i] = 0
        }
        
        let defenseDeny : SKSpriteNode! = SKSpriteNode(imageNamed: "NoEnemyDefense")
        defenseDeny.size = CGSize(width: 120,height: 120)
        
        let animation : SKAction! = SKAction.runBlock()
            {
               defenseDeny.position = CGPoint(x: 0,y: 0)
                self.scene.addChild(defenseDeny)
                defenseDeny.runAction(SKAction.sequence([SKAction.fadeAlphaTo(0.0, duration: 1.0), SKAction.fadeAlphaTo(1.0, duration: 1.0), SKAction.fadeOutWithDuration(1.0) ]))
            }
        
        self.scene.runAction(animation)
    }
    
    func applySpecial(){
        
        var  allActions : Array<SKAction>! = []
        var actionsInOrder : Array<SKAction>! = []
        
        for aux in 0..<(self.scene.level.specialAttacks.count)
        {
            switch self.scene.level.specialAttacks[aux]!{
            case 0:
                
                
                allActions.append(SKAction.runBlock(){self.specialDefense(0.1)})
//                specialDefense(0.1)
                println("Multiplicou defesa\n")
                
                
                
            case 1:
                
                allActions.append(SKAction.runBlock(){self.specialDamage(80)})
//                specialDamage(80)
                println("Dano\n")
            
            case 2:
                
                allActions.append(SKAction.runBlock(){self.specialDeath()})
//                specialDeath()
                println("Dano pelos aliados\n")
                
            case 3:
                
                allActions.append(SKAction.runBlock(){self.specialIgnore()})
//                specialIgnore()
                println("Ignorou defesa\n")
                
            case 4:
                
                allActions.append(SKAction.runBlock(){self.specialMultiplier(0.1)})
//                specialMultiplier(0.1)
                println("Multiplicou ATK\n")
                
            case 5:
                
                allActions.append(SKAction.runBlock(){self.specialHealHP(20)})
//                specialHealHP(20)
                println("Curou\n")
                
            default:
                
                println("Error Especial\n")
            
            }
            
            for aux in 0..<(allActions.count)
            {
            actionsInOrder.append(SKAction.sequence([allActions[aux], SKAction.waitForDuration(0.5)]))
            }
            
            self.scene.runAction(SKAction.sequence(actionsInOrder))
            
        }
        
    }
    
    func multiplyAttack()->Int{
        
        var total:Int = 0
        
        for i in 0..<4
        {
            var numerador = Float(self.scene.level.teamPerformance[i]) * multiplier
            total = total + Int(numerador)
        }
        println("\(total)\n")
        return total
    }
    
    func displayAttack()
    {
        var i = 0
        let goTo = SKAction.moveTo((CGPoint(x: 100.0, y: 100.0)), duration: 1.5)
        var teste = SKLabelNode()
        let waitAction = SKAction.waitForDuration(1)
        let changeColor = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.7)
        let backColor = SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.7)
        let sprite = self.scene.monster
        
        let remove = SKAction.runBlock()
            {
                SKAction.waitForDuration(1.5)
                teste.removeFromParent()
            }
        teste.fontName = "Pappirus-Bold"
        teste.fontSize = 30
        teste.fontColor = UIColor.redColor()
        //teste.text = "\(self.multiplyAttack())"
        //self.scene.addChild(teste)
        
        let create = SKAction.runBlock()
            {
                let ataque = Float(self.scene.level.teamPerformance[i])*self.multiplier
                teste.text = "\(Int(ataque))"
                self.scene.addChild(teste)
                println("CRIOU")
            }
        
        let scale = SKAction.scaleBy(2, duration: 1.5)
        
        var group = Array<SKAction>()
        group.append(goTo)
        group.append(scale)
        
        let groupAction = SKAction.group(group)
        
        teste.runAction(SKAction.sequence([create,groupAction]))
        
        sprite.runAction(SKAction.sequence([changeColor,backColor]))
        
    }
    
    
    func presentResults(actions: Array<Int>!){
        
        self.scene.level.findCharacters()
        
        let ataqueTotal = multiplyAttack()+specialDamage
        
        //if counter == 4 { // <- Watch out for the shield
        
            labelHP.text = ("Party HP:")
            labelDefense.hidden = false
            labelAtack.hidden = false
            labelHP.hidden = false

            enemyDamageDealt = ai.attackAI(data.attackAI)
            enemyDefense = ai.defenseAI(data.defenseAI, roundActions: self.scene.level.teamPerformance)
        
            applySpecial()
            self.scene.level.specialAttacks.removeAll(keepCapacity: false)
        
            battleSystem(enemyDamageDealt, def: enemyDefense)
        
            println("Party Defense: \(self.scene.level.roundDefensiveInstance)")
            println("Ataque total: \(ataqueTotal)\n")
            println("Enemy Defense: \(self.enemyDefense[0]) \(self.enemyDefense[1]) \(self.enemyDefense[2]) \(self.enemyDefense[3])")
        
        
        if( ataqueTotal > 0)
        {
            let goTo = SKAction.moveTo((CGPoint(x: 0, y: 100.0)), duration: 1.5)
            var teste = SKLabelNode()
            let waitAction = SKAction.waitForDuration(1)
            let changeColor = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.7)
            let backColor = SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.7)
            let sprite = self.scene.monster
            
            let remove = SKAction.runBlock()
                {
                    teste.removeFromParent()
                }
            teste.text = "\(ataqueTotal)"
            teste.fontName = "Pappirus-Bold"
            teste.fontSize = 30
            teste.fontColor = UIColor.redColor()

            self.scene.addChild(teste)
            teste.runAction(SKAction.sequence([goTo,remove]))
            
            //sprite.hidden = true
            sprite.runAction(SKAction.sequence([changeColor,backColor]))
            //displayAttack()
        }
        
            enemyHpDisplay()
        
        
            self.scene.level.teamPerformance = [0 , 0 , 0 ,0]
            self.specialDamage = 0
            //resultsBox.removeFromSuperview()
            //buttonNext.removeFromSuperview()
        
            //counter = 0

            labelPartyHP0.text = ("\(partyMembers[0].HP)")
            labelPartyHP1.text = ("\(partyMembers[1].HP)")
            labelPartyHP2.text = ("\(partyMembers[2].HP)")
            labelPartyHP3.text = ("\(partyMembers[3].HP)")
            labelPartyHP0.hidden = false
            labelPartyHP1.hidden = false
            labelPartyHP2.hidden = false
            labelPartyHP3.hidden = false
//            labelPartyHP0.textColor = UIColor.whiteColor()
//            labelPartyHP1.textColor = UIColor.whiteColor()
//            labelPartyHP2.textColor = UIColor.whiteColor()
//            labelPartyHP3.textColor = UIColor.whiteColor()
            labelPartyMember0.hidden = false
            labelPartyMember1.hidden = false
            labelPartyMember2.hidden = false
            labelPartyMember3.hidden = false
        
            var totalPartyHP : Float = 0.0
        
            for i in 0..<3{
                self.ai.party[i].HP = partyMembers[i].HP
                totalPartyHP = totalPartyHP + partyMembers[i].HP
            }
            println("Party HP:\(partyMembers[0].HP)      \(partyMembers[1].HP)       \(partyMembers[2].HP)       \(partyMembers[3].HP)")
            timerRunning = false
        
            // Logic to check whether the level is over or not
        if currentEnemyHP > 0 && totalPartyHP > 0.0 {
              beginGame()
        }
            
        else if currentEnemyHP == 0 && totalPartyHP > 0.0{
        // Mother of God......
            // To restart the HP of the characters
            self.view.userInteractionEnabled = true
            self.showEndGame("LevelComplete")
        }
        
        else if totalPartyHP <= 0.0{
            
            self.view.userInteractionEnabled = true
            self.showEndGame("GameOver")
        }
    }
    
//    func nextResult(sender:UIButton!){
//        counter?++
//        resultsBox.removeFromSuperview()
//        buttonNext.removeFromSuperview()
//        presentResults(self.scene.level.teamPerformance)
//    }

    func enemyHpDisplay() {

        switch ((currentEnemyHP)*100/totalEnemyHP)
        {
        case 0:
            enemyHpBar.image = UIImage(named: "HP_Enemy_0")
        case 1...5:
            enemyHpBar.image = UIImage(named: "HP_Enemy_5")
        case 6...10:
            enemyHpBar.image = UIImage(named: "HP_Enemy_10")
        case 11...15:
            enemyHpBar.image = UIImage(named: "HP_Enemy_15")
        case 16...20:
            enemyHpBar.image = UIImage(named: "HP_Enemy_20")
        case 21...25:
            enemyHpBar.image = UIImage(named: "HP_Enemy_25")
        case 26...30:
            enemyHpBar.image = UIImage(named: "HP_Enemy_30")
        case 31...35:
            enemyHpBar.image = UIImage(named: "HP_Enemy_35")
        case 36...40:
            enemyHpBar.image = UIImage(named: "HP_Enemy_40")
        case 41...45:
            enemyHpBar.image = UIImage(named: "HP_Enemy_45")
        case 46...50:
            enemyHpBar.image = UIImage(named: "HP_Enemy_50")
        case 51...55:
            enemyHpBar.image = UIImage(named: "HP_Enemy_55")
        case 56...60:
            enemyHpBar.image = UIImage(named: "HP_Enemy_60")
        case 61...65:
            enemyHpBar.image = UIImage(named: "HP_Enemy_65")
        case 66...70:
            enemyHpBar.image = UIImage(named: "HP_Enemy_70")
        case 71...75:
            enemyHpBar.image = UIImage(named: "HP_Enemy_75")
        case 76...80:
            enemyHpBar.image = UIImage(named: "HP_Enemy_80")
        case 81...85:
            enemyHpBar.image = UIImage(named: "HP_Enemy_85")
        case 86...90:
            enemyHpBar.image = UIImage(named: "HP_Enemy_90")
        case 91...96:
            enemyHpBar.image = UIImage(named: "HP_Enemy_95")
        default:
            enemyHpBar.image = UIImage(named: "HP_Enemy_100")
        }
    
    }
    
    func handleSwipe(swap: Swap) {
        view.userInteractionEnabled = false
        
      //  if self.scene.level.isPossibleSwap(swap) {
        scene.level.performSwap(swap)
        
        scene.animateSwap(swap) {
            self.view.userInteractionEnabled = true
            
       // let chains = self.scene.level.removeMatches() // AHHH MULEKE!!!!
       // self.scene.animateMatchedMoves(chains) {
       // self.view.userInteractionEnabled = true
       //     }
       // }
            
    }
        /* else
        {
        self.view.userInteractionEnabled = true
        } */

    }
    
    func handleMatches(){
        let chains = self.scene.level.removeMatches()
        if chains.count == 0 {
           // beginNextTurn()
            presentResults(self.scene.level.teamPerformance)
            //return
        }
        
        else {
        
            scene.animateMatchedMoves(chains) {
            let columns = self.scene.level.fillHoles()
            self.scene.animateFallingMoves(columns) {
            let columns = self.scene.level.topUpMoves()
            self.scene.animateNewMoves(columns) {
            self.handleMatches()// * Need to create the animations, so that the player will see what each character did. While the animations play, the User Interaction with the View will be disabled. But, as soon as it ends, it shall be enabled.
                }
            }
        }
    }
}
    
    func beginNextTurn() {
       // self.scene.level.detectPossibleSwaps()
        view.userInteractionEnabled = true
    }
    
    func showEndGame(imageName: String) {
        let outcomeImage = UIImage(named:imageName) as UIImage!
        
        let endLevelResult = UIButton() as UIButton // Needs to be made custom so you can alter the image.
        endLevelResult.frame = adjustRectSize(CGRectMake(43, 195, 300, 300))
        endLevelResult.setImage(outcomeImage, forState: UIControlState.Normal)
        endLevelResult.userInteractionEnabled = true
        endLevelResult.addTarget(self, action: "hideEndGame", forControlEvents: UIControlEvents.TouchUpInside) // Remeber to put ":" after the selector's name (in this case the "play_or_not" method)
        
        self.scene.view!.addSubview(endLevelResult)
        self.scene.view!.bringSubviewToFront(endLevelResult)
    }
    
    
    func hideEndGame()
    {
        
        scene.userInteractionEnabled = true
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let levelMenuViewController = storyBoard.instantiateViewControllerWithIdentifier("LevelMenuID") as! LevelMenu!
        self.presentViewController(levelMenuViewController, animated:true, completion:nil)
        
    }

    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // endGameResult.hidden = true
        
        backgroundSong = AVAudioPlayer(contentsOfURL: backgroundMusic, error: nil)
        backgroundSong.prepareToPlay()
        
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        scene = GameScene(size: self.view.frame.size)
        
       // scene.level = level
        scene.addTiles()


        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        scene.swipeHandler = handleSwipe 
        
        // Present the scene.
        skView.presentScene(scene)
      
    }
    
    func initialValues(){
        var i = 0
        for i in 0..<4 {
            self.ai.party[i].HP = 100.0
            self.partyMembers[i].HP = 100.0
            self.partyMembers[i].Att = 0
            self.partyMembers[i].Def = 0
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let skView = view as! SKView
        skView.presentScene(nil)
        backgroundSong.stop()
    }
}
