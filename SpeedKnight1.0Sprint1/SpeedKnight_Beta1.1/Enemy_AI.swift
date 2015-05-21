//
//  Enemy_AI.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 30/04/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import Foundation

class Enemy_AI{

    var party: [(HP: Float, Att: Int, Def: Int, Picture: String, RawValue : Int)]! = GameData.sharedInstance.team
    var enemyAtt : Int! = GameData.sharedInstance.enemyAttack
    var enemyDef : Int! = GameData.sharedInstance.enemyDefense
    
    
// The attacking AI mechanism
    func attackAI(difficulty: String!) -> Array<Float>!
    {
    
        
        switch difficulty
        {
        // A first example of AI for the enemy attack. In this simple case, the enemy will randomly choose someone to attack. If this person has more HP than the one directly at it's side (considering the team a circle), it will attack it. Otherwise, it will attack it's neighbour.
        case "easyAtt":
            
            var i : Int! = Int(arc4random_uniform(4))
            var damage : Float! = 0.0
            var conclusion : Array<Float>! = []
            conclusion = [0.0, 0.0, 0.0, 0.0]
            
            if i < 3 && party[i].HP > party[i+1].HP
            {
                damage = Float(enemyAtt - party[i].Def)
            }
                
            else if i == 3 && party[i].HP > party[0].HP
            {
                damage = Float(enemyAtt - party[i].Def)
            }
                
            else if i < 3 && (party[i].HP < party[i+1].HP || party[i].HP == party[i+1].HP)
            {
                damage = Float(enemyAtt - party[i+1].Def)
            }
            
            conclusion[i] = damage
            
            return conclusion
            
            case "mediumAtt":
            
            return [100.0, 0.0, 0.0, 0.0]
            
        default:
            return [0.0, 0.0, 0.0, 0.0]
        }
    }


    // The defensive AI mechanism
    func defenseAI(difficulty: String!, roundActions: Array<Int>!) -> Array<Int>!  {
      
        
        switch difficulty
        {
            // A first example of AI defense. In this case, the enemy will simply analyze how many points each character did during the current round. With that, he will act accordingly. If a character was only able to hit for 60 points (minimum of 3 pieces), the enemy will use it's natural defense. If, on the other hand this points escalate up to 130, he will double his defense in order to adapt to the harder hit. And, the same goes if the attack surpasses such case, making the enemy reach a maximum of the triple of his original defense.
        case "easyDef":
            
            var i: Int! = 0
            var enemyDefending: Array<Int>! = [0, 0, 0, 0]
            
            for i in 0..<4
            {
                if roundActions[i] == 60{
                    enemyDefending[i] = enemyDef
                }
                else if roundActions[i] > 60 && (roundActions[i] < 130 || roundActions[i] == 130){
                    enemyDefending[i] = 2*enemyDef
                }
                else if roundActions[i] > 130 {
                    enemyDefending[i] = 3*enemyDef
                }
                else if roundActions[i] == 0{
                    enemyDefending[i] = 10
                }
            }
            
            return enemyDefending
            
        default:
            return [0, 0, 0, 0]
        }
    }

}