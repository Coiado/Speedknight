//
//  SelectView.swift
//  Teste
//
//  Created by Lucas Coiado Mota on 18/05/15.
//  Copyright (c) 2015 Lucas Coiado Mota. All rights reserved.
//

import UIKit

class SelectView: UIView {
    
    
    
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var image4: UIImageView!
    
    var heroList: Array<UIImageView> = []
    var heroName: Array<String> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        
    }
    
    func setupView(){
        
        var i: Int! = 0
        self.heroList.append(image1)
        self.heroList.append(image2)
        self.heroList.append(image3)
        self.heroList.append(image4)
        
        for i in 0 ..< (self.heroList.count) {
            
            self.addSubview(self.heroList[i])
            
        }
        
        
    }
    
    
    func hasElement(vetor: Array<String>, element:String) -> Bool{
        var check: Bool! = false
        var i: Int! = 0
        if !vetor.isEmpty{
            for i in 0..<vetor.count {
                check = equal(vetor[i], element)
                if check==true{
                    break
                }
            }
        }
        return check
    }
    
    @IBAction func removeHero(sender: AnyObject) {
        if heroName.count>0{
            heroList[heroName.count-1].image=nil
            heroName.removeLast()
        }
        
    }
    
    @IBAction func TwoSwordButton(sender: AnyObject) {
        if !hasElement(heroName, element: "TwoSwordsProfilePic"){
            if heroName.count<4{
                heroName.append("TwoSwordsProfilePic")
                heroList[(heroName.count-1)].image = UIImage(named: "TwoSwordsProfilePic")
            }
            
        }
        
    }
    
    @IBAction func ArrowButton(sender: AnyObject) {
        if !hasElement(heroName, element: "BowArrowProfilePic"){
            if heroName.count<4{
                heroName.append("BowArrowProfilePic")
                heroList[(heroName.count-1)].image = UIImage(named: "BowArrowProfilePic")
            }
            
        }
        
    }
    
    @IBAction func MageButton(sender: AnyObject) {
        if !hasElement(heroName, element: "MageStaffProfilePic"){
            if heroName.count<4{
                heroName.append("MageStaffProfilePic")
                heroList[(heroName.count-1)].image = UIImage(named: "MageStaffProfilePic")
            }
            
        }
    }
    
    @IBAction func SingleSwordButton(sender: AnyObject) {
        if !hasElement(heroName, element: "DualWieldProfilePic"){
            if heroName.count<4{
                heroName.append("DualWieldProfilePic")
                heroList[(heroName.count-1)].image = UIImage(named: "DualWieldProfilePic")
            }
        }
    }
    
    @IBAction func AxeButton(sender: AnyObject) {
        if !hasElement(self.heroName, element: "AxeProfilePic"){
            if self.heroName.count<4{
                self.heroName.append("AxeProfilePic")
                self.heroList[(self.heroName.count-1)].image = UIImage(named: "AxeProfilePic")
            }
            
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}

