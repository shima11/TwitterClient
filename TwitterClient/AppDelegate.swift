//
//  AppDelegate.swift
//  TwitterClient
//
//  Created by shima jinsei on 2016/01/09.
//  Copyright © 2016年 Jinsei Shima. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //初回起動のみ実行される
        // NSUserdefaultsのfirstLaunchにtrueをセット
        let defaults = NSUserDefaults.standardUserDefaults()
        let dic = ["firstLaunch": true]
        defaults.registerDefaults(dic)
        
        if #available(iOS 9.0, *) {
            application.shortcutItems = HomeDynamicShortcut.shortcuts()
        }
        
        return true
    }

//    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: Bool -> Void) {
//        print("shortcut action")
//        // Do something
//        let succeeded = true
//            
//        completionHandler(succeeded)
//    }
    
    func applicationWillResignActive(application: UIApplication) {
        //アプリが閉じる前
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        //アプリがバックグラウンドになるとき
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        //アプリがフォアグラウンドになるとき
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        //アプリが起動するとき
        
        // 初回起動時のみの処理を記述
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("firstLaunch") {
            
            // Some Process will be here
            //初期化処理
            //(-1はtwitterのaccountをIDを選択していない状態)
            TwitterClient.sharedInstance.initWithId(-1)
            
            // off the flag to know if it is first time to launch
            defaults.setBool(false, forKey: "firstLaunch")
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

