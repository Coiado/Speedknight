//
//  TutorialViewController.swift
//  SpeedKnight_Beta1.1
//
//  Created by Lucas Coiado Mota on 10/06/15.
//  Copyright (c) 2015 Ogari Pata Pacheco. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    @IBOutlet weak var tutorialScrollView: UIScrollView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

//        self.playButton.addSubview(view)
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
    
    
    override func viewWillAppear(animated: Bool) {
    
            
            super.viewWillAppear(true)
            
            let page1: UIView! = NSBundle.mainBundle().loadNibNamed("page1",
                owner: self,options: nil)[0] as! UIView
            
            let page2: UIView! = NSBundle.mainBundle().loadNibNamed("page2",
                owner: self,options: nil)[0] as! UIView
            
            let page3: UIView! = NSBundle.mainBundle().loadNibNamed("page3",
                owner: self,options: nil)[0] as! UIView
            
            let page4: UIView! = NSBundle.mainBundle().loadNibNamed("page4",
                owner: self,options: nil)[0] as! UIView
            
            let page5: UIView! = NSBundle.mainBundle().loadNibNamed("page5",
                owner: self,options: nil)[0] as! UIView
        
            let page6: UIView! = NSBundle.mainBundle().loadNibNamed("page6",
            owner: self,options: nil)[0] as! UIView
        
            let pages: [UIView!] = [page1,page2,page3,page4,page5,page6]
            
            for page in pages {
                page.frame = CGRectOffset(page.frame,tutorialScrollView.contentSize.width, 0)
                tutorialScrollView.addSubview(page)
                
                tutorialScrollView.contentSize = CGSizeMake(tutorialScrollView.contentSize.width +
                    self.view.frame.width,0.7*(self.view.frame.height))
            }

    }
    

}
