//
//  Enemy_AI.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 30/04/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import Foundation

class Enemy_AI{

    // Maybe keep the general as it is, which means: intead of making a tuple containing both the attack and defense, we could keep it this way, since it could generate more variety to the enemy's strategys (can have a level 1 attack and level 2 defense, for an instance).
    
    /* What I plan on doing: 
    
    - Create priority array to choose which characters will be attacked.
    - Define how the priority shall be generated
    - [Make a possibility of landing critical hits]
    
    */

    func easyAIAttack(turns : Int!) -> Float! /*First for attack caused. Second for defense points. See the problems with the tuple*/  {
    
        if turns%2 == 0 {
        
        return 125.0
        
        }
    
        else{
        
        return 0.0
        }
    }


    func easyAIDefense(turns : Int!) -> Int!  {
        
        if turns%2 == 0 {
            
            return 0
            
        }
            
        else{
            
            return 90
        }
    }

}