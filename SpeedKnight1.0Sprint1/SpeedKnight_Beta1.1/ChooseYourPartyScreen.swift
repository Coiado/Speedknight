//
//  ChooseYourParty-Screen.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 13/05/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import UIKit
import Foundation

class ChooseYourPartyScreen : UIViewController {

    var counter : Int! = 0
    var checkAxe : Bool! = false
    var check2Swords : Bool! = false
    var checkDualWield : Bool! = false
    var checkSingleSword : Bool! = false
    var checkBowArrow : Bool! = false
    let data: GameData = GameData.sharedInstance
    
    // Just so the array is initialized
    override func viewDidAppear(animated: Bool) {
        for counter in 0..<4{
            data.team.append(HP: 0.0, Att: 0, Def: 0, Picture: "", RawValue: 0)
        }
        counter = 0
    }
    
    @IBAction func removeCharacter(sender: AnyObject) {
        if counter > 0{
            if data.team[counter-1].Picture == "AxeProfilePic.png" {
                checkAxe = false
            }
            if data.team[counter-1].Picture == "TwoSwordsProfilePic.png" {
                check2Swords = false
            }
            if data.team[counter-1].Picture == "DualWieldProfilePic.png" {
                checkDualWield = false
            }
            if data.team[counter-1].Picture == "MageStaffProfilePic.png"{
                checkSingleSword = false
            }
            if data.team[counter-1].Picture == "BowArrowProfilePic.png" {
                checkBowArrow  = false
            }
            counter=counter-1
        }
    }
    // * -> Once after it's done and working, create a method to replicate this actions, since they are all literally the same
    
    
    @IBAction func CharacterAxe(sender: AnyObject) {
        if (!checkAxe) && (counter < 4){
        
                
                if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle("Character_0") {
                    
                        data.team[counter].HP = dictionary["allyHP"] as! Float
                        data.team[counter].Att = dictionary["allyAttack"] as! Int
                        data.team[counter].Def = dictionary["allyDefense"] as! Int
                        data.team[counter].Picture = dictionary["allyPicture"] as! String
                        data.team[counter].RawValue = dictionary["allyRawValue"] as! Int

                    
                }
            counter = counter + 1
            checkAxe = true
        }
    }
    
    @IBAction func Character2Swords(sender: AnyObject) {
        if (!check2Swords) && (counter < 4){
            
            
            if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle("Character_1") {
                
                data.team[counter].HP = dictionary["allyHP"] as! Float
                data.team[counter].Att = dictionary["allyAttack"] as! Int
                data.team[counter].Def = dictionary["allyDefense"] as! Int
                data.team[counter].Picture = dictionary["allyPicture"] as! String
                data.team[counter].RawValue = dictionary["allyRawValue"] as! Int
                
                
            }
            counter = counter + 1
            check2Swords = true
        }
    }
    
    @IBAction func CharacterDualWield(sender: AnyObject) {
        if (!checkDualWield) && (counter < 4){
            
            
            if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle("Character_2") {
                
                data.team[counter].HP = dictionary["allyHP"] as! Float
                data.team[counter].Att = dictionary["allyAttack"] as! Int
                data.team[counter].Def = dictionary["allyDefense"] as! Int
                data.team[counter].Picture = dictionary["allyPicture"] as! String
                data.team[counter].RawValue = dictionary["allyRawValue"] as! Int
                
                
            }
            counter = counter + 1
            checkDualWield = true
        }
    }
    
    // This is actually going to be a mage's staff. IGNORE THE NAME OF THE METHOD FOR NOW!
    @IBAction func Mage(sender: AnyObject) {
        if (!checkSingleSword) && (counter < 4){
            
            
            if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle("Character_3") {
                
                data.team[counter].HP = dictionary["allyHP"] as! Float
                data.team[counter].Att = dictionary["allyAttack"] as! Int
                data.team[counter].Def = dictionary["allyDefense"] as! Int
                data.team[counter].Picture = dictionary["allyPicture"] as! String
                data.team[counter].RawValue = dictionary["allyRawValue"] as! Int
                
                
            }
            counter = counter + 1
            checkSingleSword = true
        }
    }
    
    @IBAction func CharacterBowArrow(sender: AnyObject) {
    
        if (!checkBowArrow) && (self.counter < 4){
            
            
            if let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle("Character_4") {
                
                data.team[counter].HP = dictionary["allyHP"] as! Float
                data.team[counter].Att = dictionary["allyAttack"] as! Int
                data.team[counter].Def = dictionary["allyDefense"] as! Int
                data.team[counter].Picture = dictionary["allyPicture"] as! String
                data.team[counter].RawValue = dictionary["allyRawValue"] as! Int
                
                
            }
            counter = counter + 1
            checkBowArrow = true
        }
    
    }
    
    @IBAction func VerifyingParty(sender: AnyObject) {
        let alertController = UIAlertController(title: "Error", message: "Choose 4 characters", preferredStyle: UIAlertControllerStyle.Alert)
        if !(counter == 4) {
        alertController.addAction(UIAlertAction(title: "Dismiss", style:UIAlertActionStyle.Default,handler: nil))
            
        self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

