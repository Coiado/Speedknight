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
        
        var minDef : Int!
        var posMinDef: Int!
        var i : Int! = Int(arc4random_uniform(4))
        var damage : Float! = 0.0
        var conclusion : Array<Float>! = []
        conclusion = [0.0, 0.0, 0.0, 0.0]
        
        switch difficulty
        {
        // A first example of AI for the enemy attack. In this simple case, the enemy will randomly choose someone to attack.
        case "easyAtt1":
            do{
            i=Int(arc4random_uniform(4))
            if party[i].HP > 0 {
                damage = Float(enemyAtt - party[i].Def)
                break
            }
            }while party[i].HP == 0
            conclusion[i]=damage
            return conclusion
        //Attack the character with less defense
        case "easyAtt2":
            minDef = 1000
            posMinDef=0
            for i in 0..<4{
                if party[i].HP != 0{
                    if minDef > party[i].Def{
                        minDef=party[i].Def
                        posMinDef = i
                    }
                }
            }
            damage = Float(enemyAtt - party[Int(posMinDef)].Def)
            conclusion[Int(posMinDef)] = damage
            return conclusion
            
//        case "easyAtt":
//            
//            
//            
//            if i < 3 && party[i].HP > party[i+1].HP
//            {
//                damage = Float(enemyAtt - party[i].Def)
//            }
//                
//            else if i == 3 && party[i].HP > party[0].HP
//            {
//                damage = Float(enemyAtt - party[i].Def)
//            }
//                
//            else if i < 3 && (party[i].HP < party[i+1].HP || party[i].HP == party[i+1].HP)
//            {
//                damage = Float(enemyAtt - party[i+1].Def)
//            }
//            
//            conclusion[i] = damage
//            
//            return conclusion
        //Attack the character with more pieces in the table
        case "mediumAtt":
            var j:Int=0;
            for j in 0..<party.count{
                if party[j].RawValue==GameData.sharedInstance.Maxcharacter{
                    damage = Float(enemyAtt - party[j].Def);
                    conclusion[j] = damage
                    break;
                }
            }
            
            return conclusion
            
        default:
            return [0.0, 0.0, 0.0, 0.0]
        }
    }


    // The defensive AI mechanism
    func defenseAI(difficulty: String!, roundActions: Array<Int>!) -> Array<Int>!  {
        
        var j: Int! = 0
        var teamAtt: Int! = 0
        var i: Int! = 0
        var enemyDefending: Array<Int>! = [0, 0, 0, 0]
        for j in 0..<4
        {
            teamAtt = teamAtt+party[i].Att
        }
        
        switch difficulty
        {
        //The 
        case "easyDef1":
            i=Int(arc4random_uniform(4))
            if teamAtt != 0{
                for j in 0..<4{
                    if roundActions[i] > 0{
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
                    i=i+1
                    i=i%4
                }
                return enemyDefending
            }
            else{
                return [0, 0, 0, 0]
            }
            // A first example of AI defense. In this case, the enemy will simply analyze how many points each character did during the current round. With that, he will act accordingly. If a character was only able to hit for 60 points (minimum of 3 pieces), the enemy will use it's natural defense. If, on the other hand this points escalate up to 130, he will double his defense in order to adapt to the harder hit. And, the same goes if the attack surpasses such case, making the enemy reach a maximum of the triple of his original defense.
//        case "easyDef":
//            
//            for i in 0..<4
//            {
//                if roundActions[i] == 60{
//                    enemyDefending[i] = enemyDef
//                }
//                else if roundActions[i] > 60 && (roundActions[i] < 130 || roundActions[i] == 130){
//                    enemyDefending[i] = 2*enemyDef
//                }
//                else if roundActions[i] > 130 {
//                    enemyDefending[i] = 3*enemyDef
//                }
//                else if roundActions[i] == 0{
//                    enemyDefending[i] = 10
//                }
//            }
//            
//            return enemyDefending
            
        default:
            return [0, 0, 0, 0]
        
        }
    }

}
