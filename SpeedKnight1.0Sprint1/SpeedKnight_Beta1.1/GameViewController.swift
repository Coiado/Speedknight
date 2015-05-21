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
    
    
    var buttonYes : UIButton!
    var buttonNo : UIButton!
    
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
        
        //level = Level(filename: "Level1")
        timerCount = 13
        timerRunning = false
        timer = NSTimer()
        
        // Just for testing right now...
        
        totalEnemyHP = scene.level.enemyHP // Passes the HP from the enemy of the level
        currentEnemyHP = totalEnemyHP
        
        // Check to load the team here
        
        initialTextBox  = UIImageView(frame:adjustRectSize(CGRectMake(27, 410, 320, 220)));
        initialTextBox.image = UIImage(named:"TesteGame_Textbox_1.png")
        self.view.addSubview(initialTextBox)
        
        // Creates the "YES" and "NO" buttons respectively
        
        buttonYes = UIButton() as UIButton // Needs to be made custom so you can alter the image.
        buttonYes.frame = adjustRectSize(CGRectMake(253, 545, 75, 58))
        buttonYes.setImage(yesImage, forState: UIControlState.Normal)
        buttonYes.addTarget(self, action: "play_or_not:", forControlEvents: UIControlEvents.TouchUpInside) // Remeber to put ":" after the selector's name (in this case the "play_or_not" method)
        
        self.view.addSubview(buttonYes)
        
        buttonNo = UIButton() as UIButton
        buttonNo.frame = adjustRectSize(CGRectMake(52, 545, 75, 58))
        // Image not showing up
        buttonNo.setImage(noImage, forState: UIControlState.Normal)
        buttonNo.addTarget(self, action: "play_or_not:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(buttonNo)
        
        shuffle()
        
    } // As soon as it ends, the problem begins
    
    // Method that decides whether or not the player will begin the level!
    
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
            if partyMembers[i].HP < 0{
                partyMembers[i].HP = 0.0
            }
            if partyMembers[i].HP == 0.0  {
            self.scene.teamDeaths.append(partyMembers[i].RawValue)
            }
        }
        //self.scene.level.roundDefensiveInstance = 0
        
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
            timer.invalidate()
            
            // Once the time has ended,it will verify all the matches and remove them, calculating their meaning!
            handleMatches()
            
            //presentResults(self.scene.level.teamPerformance)
            
            // Remember so it keeps on repeaing just fine.
            timerRunning = false
            timerCount = 13
            battleTimerLabel.text = "\(timerCount)"
          //println("\nTestando o handleMatches\n")
          //  scene.movesLayer.removeAllChildren()
            turnNumber?++

            }
  
    }

    
    // Method that is responsible for all the current level logic
    
    func beginGame() {
        
        battleTimerLabel.hidden = false
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
        scene.addSpritesForMoves(newMoves)
    
    }
    
    func presentResults(actions: Array<Int>!){
        
        if counter == 4 { // <- Watch out for the shield
            
            enemyDamageDealt = ai.attackAI(data.attackAI)
            enemyDefense = ai.defenseAI(data.defenseAI, roundActions: self.scene.level.teamPerformance)
            battleSystem(enemyDamageDealt, def: enemyDefense)
            println("Party Defense: \(self.scene.level.roundDefensiveInstance)")
            println("Enemy Defense: \(self.enemyDefense[0]) \(self.enemyDefense[1]) \(self.enemyDefense[2]) \(self.enemyDefense[3])")
            enemyHpDisplay()
            resultsBox.removeFromSuperview()
            buttonNext.removeFromSuperview()
            beginGame()
            counter = 0
            self.scene.level.teamPerformance = [0,0,0,0]
            println("Party HP:\(partyMembers[0].HP)      \(partyMembers[1].HP)       \(partyMembers[2].HP)       \(partyMembers[3].HP)")
            
        }
        else {
            resultsBox = UIImageView(frame:adjustRectSize(CGRectMake(27, 110, 320, 220))) //y:410
            resultsBox.image = UIImage(named:"Character_Battle_Profile_Teste(\(counter))")
            println("Character Attack: \(self.scene.level.teamPerformance[counter])") // It's where the class (level) has the property.
            self.view.addSubview(resultsBox)
        
            buttonNext = UIButton() as UIButton // Needs to be made custom so you can alter the image.
            buttonNext.frame = adjustRectSize(CGRectMake(253, 245, 75, 58)) //y:545
            buttonNext.setImage(yesImage, forState: UIControlState.Normal)
            buttonNext.addTarget(self, action: "nextResult:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(buttonNext)
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
