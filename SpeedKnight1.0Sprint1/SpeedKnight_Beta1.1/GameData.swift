//
//  GameData.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 15/05/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import UIKit

class GameData: NSObject {
    
    var levelFile : String! = ""
    var backgroundImage : String! = ""
    var attackAI : String! = ""
    var defenseAI : String! = ""
    var enemyAttack : Int! = 0
    var enemyDefense : Int! = 0
    var team : [(HP: Float, Att: Int, Def: Int, Picture: String, RawValue: Int)]! = []
    var enemyImage : String! = ""
    
    
  
    //         This is interesting! I define a Singleton, which is a class method that is instantiated only ONCE and can be accessed by any other class. This way, all the variables and methods will be able to be accessed, even if they have any dynamic relation, just like this case (where the player chooses his team members)
    //      EVEN MORE IMPORTANT is to remember and understand the issue I've been having:
    //      I had originally created the singleton inside each view (choose character + level menu). That is bad, because a view can be easily deallocated. Since the shared instance was inside the view and and, eventually, the view controller would be closed (due to the segue), it's reference (instance) would be lost and so would the data, that were supposed to be passed down with it. By creating a class and simply altering it's data here, there's no problem anymore, as this class can be retained in the memory, constantly. (It will not simply be deallocated, by changing a view, for example)
    
    class var sharedInstance : GameData {
        struct Static {
            static let instance : GameData = GameData()
        }
        return Static.instance
    }
   
}
