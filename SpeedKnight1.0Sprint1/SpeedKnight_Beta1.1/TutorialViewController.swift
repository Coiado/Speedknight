//
//  TutorialViewController.swift
//  SpeedKnight_Beta1.1
//
//  Created by Lucas Coiado Mota on 10/06/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    
   
   
    @IBOutlet weak var tutorialImage: UIImageView!
    var nextCont: Int!
    var images :[String!] = []
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.hidden=true
        self.nextCont = 0
        self.images = ["tutorial1","tutorial2","tutorial3","tutorial4","tutorial5","tutorial6"]
        self.tutorialImage.image = UIImage(named: images[nextCont])
//        self.tutorialImage.image = UIImage(named: "tutorial2")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func backButton(sender: AnyObject) {
        if self.nextCont > 0{
            self.nextCont = self.nextCont-1
            self.tutorialImage.image = UIImage(named: images[self.nextCont])
        }
    }
    
    
    @IBAction func nextButton(sender: AnyObject) {
        if self.nextCont < self.images.count-1{
            self.nextCont = self.nextCont+1
            self.tutorialImage.image = UIImage(named: images[self.nextCont])
        }
        if nextCont == self.images.count-1{
            self.playButton.hidden=false
        }
    }
    override func viewWillAppear(animated: Bool) {
    
            
            super.viewWillAppear(true)
        
        


    }
    

}
