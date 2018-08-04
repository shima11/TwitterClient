//
//  MyAccountViewController.swift
//  Twiroll
//
//  Created by shima jinsei on 2015/12/15.
//  Copyright © 2015年 Jinsei Shima. All rights reserved.
//

import UIKit
import Accounts
import SwiftyJSON

class MyAccountViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    private var effectView : UIVisualEffectView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "アカウント"
        
        let balloon = BalloonView(frame: CGRectMake((view.bounds.size.width - 280) / 2, 100, 280, 100))
        balloon.backgroundColor = UIColor.whiteColor()
        view.addSubview(balloon)
        
        /*
            アカウントを取得する
        */
        if TwitterClient.sharedInstance.myId() >= 0
        {
            let myID:Int = TwitterClient.sharedInstance.myId()
            
            // アカウントの一覧の取得
            TwitterClient.sharedInstance.getAccounts { (accounts: [ACAccount]) -> Void in
                //取得完了後、アカウントを指定
                TwitterClient.sharedInstance.twAccount = accounts[myID]
                // ユーザ情報を取得
                TwitterClient.sharedInstance.getUser(self.onGetUser)
                // バナー画像を取得
                TwitterClient.sharedInstance.getBanner(self.onGetBanner)
            }
        }else{
            print("アカウントが選択されていません")
        }
    }
    
    
    //GDCのメインスレッド処理
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    
    //アカウントを選択（アクションシートの出現）
    @IBAction func loginAction(sender: AnyObject) {
        //actionsheetの表示
        TwitterClient.sharedInstance.getAccounts { (accounts: [ACAccount]) -> Void in
            self.dispatch_async_main {
                self.showAccountSelectSheet(accounts)
            }
        }
    }

    
    //アカウントの選択
    private func showAccountSelectSheet(accounts: [ACAccount]) {
        
        let alert:UIAlertController = UIAlertController(title: "Twitter", message: "アカウントを選択してください",preferredStyle: .ActionSheet)
        print("account select")
        var i = 0;
        for account in accounts {
                alert.addAction(UIAlertAction(title: account.username,
                    style: .Default,
                    handler: { (action) -> Void in
                        // アカウントの選択
                        TwitterClient.sharedInstance.twAccount = account
                        // ユーザ情報を取得
                        TwitterClient.sharedInstance.getUser(self.onGetUser)
                        //選択したユーザを保存
                        TwitterClient.sharedInstance.setId(accounts.count - i)
                }))
            i++;
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //ユーザ情報の取得
    private func onGetUser(data: NSMutableDictionary) {
        print("ユーザ情報の取得")
        
        //ユーザ名の表示
        self.userNameLabel.text = data["name"] as AnyObject? as? String
        
        // プロフィール画像の表示
        let urlStr:String = data["profile_image_url_https"] as! String
        let url: NSURL = NSURL(string: urlStr)!
        let imgData:NSData? = NSData(contentsOfURL: url)
        if let imgData:NSData = imgData{
            let img:UIImage = UIImage(data: imgData)!
            profileImageView.sd_setImageWithURL(url)
            profileImageView.frame = CGRect(x: 10, y: 10, width: img.size.width, height: img.size.height)
        }else{
            print("profile画像が設定されていない。")
        }
        
        
        //アカウントの紹介文
        print(data["description"])
        
    }
    
    //バナー画像の表示
    private func onGetBanner(data: NSMutableDictionary)
    {
        let json = JSON(data)
        let urlStr:String = json["sizes"]["mobile_retina"]["url"].string!
        if urlStr.characters.count > 0 {
            let url: NSURL = NSURL(string: urlStr)!
            let imgData:NSData? = NSData(contentsOfURL: url)
            if let imgData:NSData = imgData{
                let img:UIImage = UIImage(data: imgData)!
                bannerImageView.sd_setImageWithURL(url)
                bannerImageView.frame = CGRect(x: 10, y: 200, width: img.size.width, height: img.size.height)
            }
        }else {
            print("banner画像が設定されていない。")
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
