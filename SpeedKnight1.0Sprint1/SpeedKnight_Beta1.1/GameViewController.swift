//
//  GameViewController.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 15/04/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var scene: GameScene!
    let ai : Enemy_AI! = Enemy_AI()
    
    @IBOutlet weak var enemyHpBar: UIImageView!
    
    // Comment on all later!!!
    
    var counter : Int! = 0
    var resultsBox : UIImageView!
    var buttonNext : UIButton!
    var newMoves : Array<Move>! = Array<Move>()
    var turnNumber : Int! = 0
    var partyHP : Float! = 100.0
    var enemyHP : Int! = 1000
    var partyAttack : Int! = 0
    
    // Idiotic code... See it later!
    var battleResultAt : Float!
    var battleResultDef : Int!
    
   // var level: Level!
    
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

        let viewSize = self.view.frame
        
        println("\(viewSize)")
        
        initialTextBox  = UIImageView(frame:adjustRectSize(CGRectMake(27, 410, 320, 220)));
        initialTextBox.image = UIImage(named:"TesteGame_Textbox_1.png")
        self.view.addSubview(initialTextBox)
        
        // Creates the "YES" and "NO" buttons respectively
        
        buttonYes = UIButton() as UIButton // Needs to be made custom so you can alter the image.
        buttonYes.frame = adjustRectSize(CGRectMake(253, 545, 75, 58))
        // Image not showing up
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
        
    }
    
    // Method that decides whether or not the player will begin the level!
    
    func play_or_not(sender:UIButton!)
    {
        if buttonYes.touchInside == true {
            println("YES tapped")
            
            // Removes each individual piece of the initial text box (the box and the 2 buttons)
            
            initialTextBox.removeFromSuperview()
            buttonNo.removeFromSuperview()
            buttonYes.removeFromSuperview()

            
            beginGame()

        }
            
        else if buttonNo.touchInside == true {
            println("NO tapped")
            
            // Will be used to go back to the main menu
        }
    }
    
    
    func battleSystem (at: Float!, def: Int!){
        
        var i : Int! = 0
        
        for i in 0..<5 {
        
        partyAttack = partyAttack + self.scene.level.teamPerformance[i]
        
        }
        
        partyHP = partyHP - at
        
        if partyAttack > def  && (partyAttack - def) < enemyHP{
            
        enemyHP = enemyHP - (partyAttack - def)
            
        }
        
        else if (partyAttack - def) > enemyHP {
        
        enemyHP = 0
        
        }
        
    }
    
    // Method that controls the battleTimer logic
    func fightTime (){

       // var timer : NSTimer!
        
    timerCount = timerCount - 1
    battleTimerLabel.text = "\(timerCount)"
        if timerCount < 1 {
            timer.invalidate()
            
            // Once the time has ended,it will verify all the matches and remove them, calculating their meaning!
            
            handleMatches()
            presentResults(self.scene.level.teamPerformance)
            
            // Remember so it keeps on repeaing just fine.
            timerRunning = false
            timerCount = 13
            battleTimerLabel.text = "\(timerCount)"
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
        newMoves = scene.level.shuffle()
        scene.addSpritesForMoves(newMoves)
    
    }
    
    func presentResults(actions: Array<Int>!){
        
        if counter == 5 {
            
            battleResultAt = ai.easyAIAttack(turnNumber)
            battleResultDef = ai.easyAIDefense(turnNumber)
            battleSystem(battleResultAt, def: battleResultDef)
            enemyHp()
            resultsBox.removeFromSuperview()
            buttonNext.removeFromSuperview()
            beginGame()
            counter = 0
            
        }
        else {
            resultsBox = UIImageView(frame:adjustRectSize(CGRectMake(27, 110, 320, 220))) //y:410
            resultsBox.image = UIImage(named:"Character_Battle_Profile_Teste(\(counter))")
            println(self.scene.level.teamPerformance[counter]) // It's where the class (level) has the property.
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
  /*
    func updateInfo() {
    
    Sugestion to use it as a method to update with everything that happened. (holding the points each piece made, plus what the enemy did and so on)
    
    } */
    
    func enemyHp() {

        switch enemyHP
        {
        case 0:
            enemyHpBar.image = UIImage(named: "HP_Enemy_0")
        case 1...50:
            enemyHpBar.image = UIImage(named: "HP_Enemy_5")
        case 51...100:
            enemyHpBar.image = UIImage(named: "HP_Enemy_10")
        case 101...150:
            enemyHpBar.image = UIImage(named: "HP_Enemy_15")
        case 151...200:
            enemyHpBar.image = UIImage(named: "HP_Enemy_20")
        case 201...250:
            enemyHpBar.image = UIImage(named: "HP_Enemy_25")
        case 251...300:
            enemyHpBar.image = UIImage(named: "HP_Enemy_30")
        case 301...350:
            enemyHpBar.image = UIImage(named: "HP_Enemy_35")
        case 351...400:
            enemyHpBar.image = UIImage(named: "HP_Enemy_40")
        case 401...450:
            enemyHpBar.image = UIImage(named: "HP_Enemy_45")
        case 451...500:
            enemyHpBar.image = UIImage(named: "HP_Enemy_50")
        case 501...550:
            enemyHpBar.image = UIImage(named: "HP_Enemy_55")
        case 551...600:
            enemyHpBar.image = UIImage(named: "HP_Enemy_60")
        case 601...650:
            enemyHpBar.image = UIImage(named: "HP_Enemy_65")
        case 651...700:
            enemyHpBar.image = UIImage(named: "HP_Enemy_70")
        case 701...750:
            enemyHpBar.image = UIImage(named: "HP_Enemy_75")
        case 751...800:
            enemyHpBar.image = UIImage(named: "HP_Enemy_80")
        case 801...850:
            enemyHpBar.image = UIImage(named: "HP_Enemy_85")
        case 851...900:
            enemyHpBar.image = UIImage(named: "HP_Enemy_90")
        case 901...950:
            enemyHpBar.image = UIImage(named: "HP_Enemy_95")
        default:
            enemyHpBar.image = UIImage(named: "HP_Enemy_100")
        }
    
    }
    
    func handleSwipe(swap: Swap) {
        view.userInteractionEnabled = false
        
        scene.level.performSwap(swap)
        
        scene.animateSwap(swap) {
            self.view.userInteractionEnabled = true
            
       // let chains = self.scene.level.removeMatches() // AHHH MULEKE!!!!
       // self.scene.animateMatchedMoves(chains) {
       // self.view.userInteractionEnabled = true
       //     }
        }
    }
    
    func handleMatches() {
        let chains = self.scene.level.removeMatches()
        
        if chains.count == 0 {
            beginNextTurn()
            return
        }
        scene.animateMatchedMoves(chains) {
            let columns = self.scene.level.fillHoles()
            self.scene.animateFallingMoves(columns) {
            let columns = self.scene.level.topUpMoves()
            self.scene.animateNewMoves(columns) {
            self.handleMatches()// *Need to create the animations, so that the player will see what each character did. While the animations play, the User Interaction with the View will be disabled. But, as soon as it ends, it shall be enabled. Potential solution: create a transparent view right above the pieces that shall only disappear once the animation is over (which works both for delay time and the player to click the buttons)
                }
            }
        }
    }
    
    func beginNextTurn() {
        self.scene.level.detectPossibleSwaps()
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
        
        
       // level = Level(filename: "Level_1")
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
