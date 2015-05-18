//
//  Enemy_AI.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 30/04/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import Foundation

class Enemy_AI{

    func easyAIAttack(turns : Int!) -> Array<Float>! 
    {
    
        if turns%2 == 0 {
        
        return [1.0, 1.0, 1.0, 1.0] // Completly arbitrary
        
        }
    
        else{
        
        return [0.0, 0.0, 0.0, 0.0] // Completly arbitrary
        }
    }


    func easyAIDefense(turns : Int!) -> Int!  {
         // Should probably pass it's Defense stat so it can be used in the AI Formula
        if turns%2 == 0 {
            
            return 0
            
        }
            
        else{
            
            return 90
        }
    }

}