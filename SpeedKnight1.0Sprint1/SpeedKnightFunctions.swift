//
//  SpeedKnightFunctions.swift
//  SpeedKnight_Beta1.1
//
//  Created by Ogari Pata Pacheco on 30/04/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import UIKit


func adjustX(x:CGFloat)->CGFloat {
    let bounds = UIScreen.mainScreen().bounds.size

    return x*(bounds.width/375)
}

func adjustY(y:CGFloat)->CGFloat {
    let bounds = UIScreen.mainScreen().bounds.size
    
    return y*(bounds.height/667)
}


func adjustPoint(originalPoint:CGPoint)->CGPoint {
    let bounds = UIScreen.mainScreen().bounds.size
    
   
    return CGPoint(x: originalPoint.x*(bounds.width/375), y: originalPoint.y*(bounds.height/667))
}

func adjustSize(originalSize:CGSize)->CGSize {
    let bounds = UIScreen.mainScreen().bounds.size
    
    
    return CGSize(width: originalSize.width*(bounds.width/375), height: originalSize.height*(bounds.height/667))
}


func adjustRectSize(originalRectangle:CGRect)->CGRect {
    
    
    let bounds = UIScreen.mainScreen().bounds.size
     println("\(bounds)")
    
    
    return CGRect(x: originalRectangle.origin.x*(bounds.width/375),
        y: originalRectangle.origin.y*(bounds.height/667),
        width: originalRectangle.size.width*(bounds.width/375),
        height: originalRectangle.size.height*(bounds.height/667))
}
