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
        
        var minHP : Float!
        var posMinHP: Float!
        var i : Int! = Int(arc4random_uniform(4))
        var damage : Float! = 0.0
        var conclusion : Array<Float>! = []
        conclusion = [0.0, 0.0, 0.0, 0.0]
        
        switch difficulty
        {
        // A first example of AI for the enemy attack. In this simple case, the enemy will randomly choose someone to attack. If this person has more HP than the one directly at it's side (considering the team a circle), it will attack it. Otherwise, it will attack it's neighbour.
        case "easyAtt1":
            do{
            if party[i].HP > 0 && enemyAtt > party[i].Def{
                damage = Float(enemyAtt - party[i].Def)
            }
            }while party[i].HP == 0
            conclusion[i]=damage
            return conclusion
            
        case "easyAtt2":
            minHP = party[0].HP
            posMinHP=0
            for i in 0..<3{
                if minHP != 0{
                    if minHP > party[i+1].HP{
                        minHP=party[i+1].HP
                        posMinHP = Float(i+1)
                    }
                }
                else{
                    minHP=party[i+1].HP
                    posMinHP = Float(i+1)
                }
            }
            damage = Float(enemyAtt - party[Int(posMinHP)].Def)
            conclusion[Int(posMinHP)] = damage
            return conclusion
            
        case "easyAtt":
            
            
            
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
            i=0;
            for i in 0...party.count{
                if party[i].RawValue==GameData.sharedInstance.Maxcharacter{
                    break;
                }
            }
            damage = Float(enemyAtt - party[i].Def);
            conclusion[i] = damage
            
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
            // A first example of AI defense. In this case, the enemy will simply analyze how many points each character did during the current round. With that, he will act accordingly. If a character was only able to hit for 60 points (minimum of 3 pieces), the enemy will use it's natural defense. If, on the other hand this points escalate up to 130, he will double his defense in order to adapt to the harder hit. And, the same goes if the attack surpasses such case, making the enemy reach a maximum of the triple of his original defense.
        case "easyDef1":
            i=Int(arc4random_uniform(4))
            if teamAtt != 0{
                do{
                    if party[i].Att > 0{
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
                }while party[i].Att == 0
                return enemyDefending
            }
            else{
                return [0, 0, 0, 0]
            }
        case "easyDef":
            
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
