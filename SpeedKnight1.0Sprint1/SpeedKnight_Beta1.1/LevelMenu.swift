//
//  LevelMenu.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 14/05/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import UIKit
import Foundation

class LevelMenu : UIViewController {
    
    let data:GameData = GameData.sharedInstance
    
    @IBAction func LevelOne(sender: AnyObject) {
        
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle("Level_0") {
            data.backgroundImage = dictionary["background"] as! String
            data.enemyAttack = dictionary["enemyAttack"] as! Int
            data.enemyDefense = dictionary["enemyDefense"] as! Int
            data.enemyImage = dictionary["enemyImage"] as! String
        }
        data.levelFile = "Level_0"
        data.attackAI = "easyAtt2"
        data.defenseAI = "easyDef"
        performSegueWithIdentifier("GameViewControllerSegue", sender: self)
    }

    @IBAction func LevelTwo(sender: AnyObject) {
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle("Level_1") {
            data.backgroundImage = dictionary["background"] as! String
            data.enemyAttack = dictionary["enemyAttack"] as! Int
            data.enemyDefense = dictionary["enemyDefense"] as! Int
            data.enemyImage = dictionary["enemyImage"] as! String
        }
        data.levelFile = "Level_1"
        data.attackAI = "easyAtt1"
        data.defenseAI = "easyDef"
        //presentViewController(GameViewController, animated: true, completion: nil)
        performSegueWithIdentifier("GameViewControllerSegue", sender: self)
    }

    @IBAction func LevelThree(sender: AnyObject) {
        
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle("Level_2") {
            data.backgroundImage = dictionary["background"] as! String
            data.enemyAttack = dictionary["enemyAttack"] as! Int
            data.enemyDefense = dictionary["enemyDefense"] as! Int
            data.enemyImage = dictionary["enemyImage"] as! String
        }
        
        data.levelFile = "Level_2"
        data.attackAI = "easyAtt"
        data.defenseAI = "easyDef"
        performSegueWithIdentifier("GameViewControllerSegue", sender: self)
    }

    @IBAction func LevelFour(sender: AnyObject) {
        
        if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle("Level_3") {
            
            data.backgroundImage = dictionary["background"] as! String
            data.enemyAttack = dictionary["enemyAttack"] as! Int
            data.enemyDefense = dictionary["enemyDefense"] as! Int
            data.enemyImage = dictionary["enemyImage"] as! String
        }
        
        data.levelFile = "Level_3"
        data.attackAI = "mediumAtt"
        data.defenseAI = "easyDef"
        performSegueWithIdentifier("GameViewControllerSegue", sender: self)
    }
 
}