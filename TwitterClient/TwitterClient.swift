//
//  TwitterClient.swift
//  Twiroll
//
//  Created by shima jinsei on 2015/12/17.
//  Copyright © 2015年 Jinsei Shima. All rights reserved.
//

import UIKit
import Accounts
import Social
import SwiftyJSON

class TwitterClient:NSObject{
    
    class var sharedInstance: TwitterClient {
        struct Singleton{
            static let instance: TwitterClient = TwitterClient()
        }
        return Singleton.instance
    }
    
    var accountStore:ACAccountStore = ACAccountStore()
    var twAccount: ACAccount?
    var accounts:[ACAccount]?
    var tweets = []
    
    func initWithId(id:Int) {
        setId(id);
    }
    
    func setId(id:Int)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(id, forKey: "TwitterUserListIndex")
        defaults.synchronize()
    }
    
    func myId() -> Int
    {
        return NSUserDefaults.standardUserDefaults().objectForKey("TwitterUserListIndex")!.integerValue
    }
    
    func myAccount() -> ACAccount
    {
        return accountList()[myId()]
    }
    
    func accountList() -> [ACAccount]
    {
        return accounts!
    }
    
    
    
    //アカウントの取得
    internal func getAccounts(callback: [ACAccount] -> Void) {
        
        let accountType:ACAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted: Bool, error: NSError?) -> Void in
            if error != nil {
                print("error! \(error)")
                return
            }
            
            if !granted {
                print("error! Twitterアカウントの利用が許可されていません")
                return
            }
            
            let accounts = self.accountStore.accountsWithAccountType(accountType) as! [ACAccount]
            if accounts.count == 0 {
                print("error! 設定画面からアカウントを設定してください")
                return
            }
            
            callback(accounts)
        }
    }
    
    // 新しいタイムラインを取得する
    internal func getTimeline(callbabk: NSMutableArray -> Void) {
        let url:NSURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!

        sendRequest(url, requestMethod: .GET, params: nil) { (responseData, urlResponse) -> Void in
            let json = JSON(responseData)
            let array:NSMutableArray = json.arrayObject as NSMutableArray
            callbabk(array)
//            do {
//                let result:NSMutableArray = try NSJSONSerialization.JSONObjectWithData(responseData, options: .AllowFragments) as! NSMutableArray
//                print("count1:\(result.count)")
//                callbabk(result)
//            } catch {
//                print("エラーが発生しました")
//            }
        }
    }
    
    // 過去のタイムラインを取得する
    internal func getPreTimeline(maxIdStr: String, countStr: String, callbabk: NSMutableArray -> Void) {
        let url:NSURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")!

        let params = ["max_id":maxIdStr,"count":countStr]
        sendRequest(url, requestMethod: .GET, params: params) { (responseData, urlResponse) -> Void in
            do {
                let result:NSMutableArray = try NSJSONSerialization.JSONObjectWithData(responseData, options: .AllowFragments) as! NSMutableArray
                print("count2:\(result.count)")
                callbabk(result)
            } catch {
                print("エラーが発生しました")
            }
        }
    }
    
    // ユーザの情報を取得
    internal func getUser(callback: NSMutableDictionary -> Void) {
        let url:NSURL = NSURL(string: "https://api.twitter.com/1.1/users/show.json")!
        let params = ["screen_name" : (twAccount?.username)!]
        sendRequest(url, requestMethod: .GET, params: params) { (responseData, urlResponse) -> Void in
            do {
                let result:NSMutableDictionary = try NSJSONSerialization.JSONObjectWithData(responseData, options: .AllowFragments) as! NSMutableDictionary
                callback(result)
            } catch {
                print("エラーが発生しました")
            }
        }
    }
    
    // ユーザのバナー画像を取得
    internal func getBanner(callback: NSMutableDictionary -> Void) {
        
        let url:NSURL = NSURL(string: "https://api.twitter.com/1.1/users/profile_banner.json")!
        let params = ["screen_name" : (twAccount?.username)!]
        
        sendRequest(url, requestMethod: .GET, params: params) { (responseData, urlResponse) -> Void in
            do {
                let result: NSMutableDictionary = try NSJSONSerialization.JSONObjectWithData(responseData, options: .AllowFragments) as! NSMutableDictionary
                callback(result)
            } catch {
                print("エラーが発生しました")
            }
        }
    }
    
    // 投稿
    internal func postTweet(msg:String) {
        let url:NSURL = NSURL(string: "https://api.twitter.com/1.1/statuses/update.json")!
        let params = ["status" : msg]
        
        sendRequest(url, requestMethod: .POST, params: params) { (responseData, urlResponse) -> Void in
            // 投稿完了ハンドラ
            print(responseData)
        }
    }
    
    // リクエスト
    private func sendRequest(url: NSURL, requestMethod: SLRequestMethod, params: AnyObject?, responseHandler: (responseData: NSData!, urlResponse: NSHTTPURLResponse!) -> Void) {
        let request:SLRequest = SLRequest(
            forServiceType: SLServiceTypeTwitter,
            requestMethod: requestMethod,
            URL: url,
            parameters: params as? [NSObject : AnyObject]
        )
        request.account = twAccount
        request.performRequestWithHandler { (responseData: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
            if error != nil {
                print("error is \(error)")
            } else {
                responseHandler(responseData: responseData, urlResponse: urlResponse)
            }
        }
    }

}
