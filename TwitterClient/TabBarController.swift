//
//  TabBarController.swift
//  Twiroll
//
//  Created by shima jinsei on 2015/12/05.
//  Copyright © 2015年 Jinsei Shima. All rights reserved.
//

import UIKit
import FontAwesome

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let font:UIFont! = UIFont(name:"HelveticaNeue-Bold",size:10)
        let selectedAttributes:Dictionary! = [NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor(red:0.25, green:0.64, blue:0.88, alpha:1)]

        //テキストの色とフォント
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, forState: UIControlState.Selected)
        
         //アイコンの色
        UITabBar.appearance().tintColor = UIColor(red:0.25, green:0.64, blue:0.88, alpha:1)
        
        // 背景色変えたい
        //UITabBar.appearance().barTintColor = UIColor(red: 0.13, green: 0.55, blue: 0.83, alpha: 1.0)

        
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

}
