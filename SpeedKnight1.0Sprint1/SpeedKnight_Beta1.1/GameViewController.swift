//
//  GameViewController.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 15/04/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import UIKit
import SpriteKit

// Check the logic after the first round, since it is now allowing the moves to be instantly destryed afterwards [X] -> Problem solved! Now just add a check to see if the enemy died (or you)! And, if so, end the level! Than focus on the battle system
class GameViewController: UIViewController {
    var scene: GameScene!
    let ai : Enemy_AI! = Enemy_AI()
    let data : GameData = GameData.sharedInstance
    
    @IBOutlet weak var enemyHpBar: UIImageView!
    
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
    var labelAtack: UILabel = UILabel()
    var labelDefense: UILabel = UILabel()
    var labelShuffle: UILabel = UILabel()
    
    var buttonYes : UIButton!
    var buttonNo : UIButton!
    var buttonShuffle : UIButton!
    
    var qtdShuffle : Int!
    
    
    // Images for the "YES" an "NO" buttons for the initialTextox + the image for the actual TextBox, respectively
    let yesImage = UIImage(named: "Game_TextBox_YesButton1") as UIImage?
    let noImage = UIImage(named: "Game_TextBox_NoButton1") as UIImage?
    var initialTextBox : UIImageView!
    
    // Below are the variables responsible for the timer logic.
    @IBOutlet weak var battleTimerLabel: UILabel!
    var timerCount : Int!
    var timerRunning : Bool!
    var timer : NSTimer!

    
    
    // Creates the  box to warn the player of the fight!
    override func viewDidAppear(animated: Bool) {
        
        self.view.userInteractionEnabled = false
        
        labelAtack.font = UIFont(name: ("Bradley Hand"), size: 20)
        labelAtack.textColor = UIColor.whiteColor()
        labelAtack.frame = adjustRectSize(CGRectMake(73, 75, 400, 400))
        labelAtack.hidden = true
        self.view.addSubview(labelAtack)
        labelDefense.font = UIFont(name: ("Bradley Hand"), size: 20)
        labelDefense.textColor = UIColor.whiteColor()
        labelDefense.frame = adjustRectSize(CGRectMake(73, 55, 400, 400))
        labelDefense.hidden = true
        self.view.addSubview(labelDefense)
        labelHP.font = UIFont(name: ("Bradley Hand"), size: 20)
        labelHP.textColor = UIColor.whiteColor()
        labelHP.frame = adjustRectSize(CGRectMake(73, 95, 400, 400))
        labelHP.hidden = true
        self.view.addSubview(labelHP)
        labelPartyHP0.font = UIFont(name: ("Bradley Hand"), size: 20)
        labelPartyHP0.textColor = UIColor.whiteColor()
        labelPartyHP0.frame = adjustRectSize(CGRectMake(73, 115, 400, 400))
        labelPartyHP0.hidden = true
        self.view.addSubview(labelPartyHP0)
        labelPartyHP1.font = UIFont(name: ("Bradley Hand"), size: 20)
        labelPartyHP1.textColor = UIColor.whiteColor()
        labelPartyHP1.frame = adjustRectSize(CGRectMake(73, 135, 400, 400))
        labelPartyHP1.hidden = true
        self.view.addSubview(labelPartyHP1)
        labelPartyHP2.font = UIFont(name: ("Bradley Hand"), size: 20)
        labelPartyHP2.textColor = UIColor.whiteColor()
        labelPartyHP2.frame = adjustRectSize(CGRectMake(73, 155, 400, 400))
        labelPartyHP2.hidden = true
        self.view.addSubview(labelPartyHP2)
        labelPartyHP3.font = UIFont(name: ("Bradley Hand"), size: 20)
        labelPartyHP3.textColor = UIColor.whiteColor()
        labelPartyHP3.frame = adjustRectSize(CGRectMake(73, 175, 400, 400))
        labelPartyHP3.hidden = true
        self.view.addSubview(labelPartyHP3)
        
        
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
        
        buttonShuffle = UIButton() as UIButton
        buttonShuffle.frame = adjustRectSize(CGRectMake(200, 55, 100, 100))
        buttonShuffle.setTitle("Shuffle", forState: UIControlState.Normal)
        buttonShuffle.addTarget(self, action: "troca", forControlEvents: UIControlEvents.TouchUpInside)
        self.qtdShuffle = 3
        self.view.addSubview(buttonShuffle)
        
        //labelShuffle.font = UIFont(name: ("Bradley Hand"), size: 20)
        labelShuffle.textColor = UIColor.whiteColor()
        labelShuffle.frame = adjustRectSize(CGRectMake(280, 80, 50, 50))
        labelShuffle.text = "x\(self.qtdShuffle)"
        self.view.addSubview(labelShuffle)
        
        shuffle()
        startGame()
        
    } // As soon as it ends, the problem begins
    
    // Method that decides whether or not the player will begin the level!
    
    func startGame() {
        var prepareLabel = UILabel()
        prepareLabel.text = "PREPARE FOR FIGHT"
        prepareLabel.font = UIFont(name: "Comic Sans", size: 60)
        prepareLabel.frame = adjustRectSize(CGRectMake(110, 140, 500, 500))
        prepareLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(prepareLabel)
        let block = SKAction.runBlock()
            {
                prepareLabel.text = "FIGHT!!!!"
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
        // Add the defense points against each one's attack
        opponentDefense = opponentDefense + def[i]
        // Each character takes the damage of the round
        partyMembers[i].HP = returnMin(partyMembers[i].HP, num2: ((partyMembers[i].HP - at[i]) + 2*Float(self.scene.level.roundDefensiveInstance)))
        GameData.sharedInstance.team[i].HP = partyMembers[i].HP
            if partyMembers[i].HP < 0{
                partyMembers[i].HP = 0.0
                GameData.sharedInstance.team[i].HP = 0.0
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
    
    func presentResults(actions: Array<Int>!){
        
        //if counter == 4 { // <- Watch out for the shield
            
        let ataqueTotal = self.scene.level.teamPerformance[0]+self.scene.level.teamPerformance[1]+self.scene.level.teamPerformance[2]+self.scene.level.teamPerformance[3]
        
            labelAtack.text = ("Ataque Total:\(ataqueTotal)")
            labelDefense.text = ("defesa Total: \(self.scene.level.roundDefensiveInstance)")
            labelHP.text = ("Party HP:")
            labelDefense.hidden = false
            labelAtack.hidden = false
            labelHP.hidden = false

            enemyDamageDealt = ai.attackAI(data.attackAI)
            enemyDefense = ai.defenseAI(data.defenseAI, roundActions: self.scene.level.teamPerformance)
            battleSystem(enemyDamageDealt, def: enemyDefense)
            println("Party Defense: \(self.scene.level.roundDefensiveInstance)")
            println("Enemy Defense: \(self.enemyDefense[0]) \(self.enemyDefense[1]) \(self.enemyDefense[2]) \(self.enemyDefense[3])")
        
        
        if( ataqueTotal > 0){
            var sprite = self.scene.monster
            //sprite.hidden = true
            let waitAction = SKAction.waitForDuration(1)
            let changeColor = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.7)
            let backColor = SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.7)
            
            sprite.runAction(SKAction.sequence([changeColor,backColor]))
        }
        
            enemyHpDisplay()
        
        
            self.scene.level.teamPerformance = [0 , 0 , 0 ,0]
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
        self.view.userInteractionEnabled = true
        self.showEndGame("LevelComplete")
        }
        
        else {
        self.view.userInteractionEnabled = true
        self.showEndGame("GameOver")
        }
    }
    
    func nextResult(sender:UIButton!){
        counter?++
        resultsBox.removeFromSuperview()
        buttonNext.removeFromSuperview()
        presentResults(self.scene.level.teamPerformance)
    }

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
}
