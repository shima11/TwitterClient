//
//  ViewController.swift
//  TwitterAccountSample
//
//  Created by himara2 on 2014/11/02.
//  Copyright (c) 2014年 himara2. All rights reserved.
//

import Foundation
import UIKit
import Accounts
import SwiftyJSON
import ObjectMapper
import RealmSwift

class ViewController: UIViewController{

    var refreshControl:UIRefreshControl = UIRefreshControl()
    var isLoading:Bool = false
    var maxIdStr:String = ""
    var tweetArray: NSMutableArray = NSMutableArray()
    
    weak var timer = NSTimer()
    let timerInterval = 0.04
    let autoScrollSpeed = CGFloat(2)
    
    var scrollBeginingPoint = CGPoint(x: 0, y: 0)
    var scrollPoint = CGPoint(x:0,y:0)
    
    var scrollDirection:Bool = true //true:下 faults:上
    var isScrolling:Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "time line"
        
        // 長押しジェスチャを設定
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "cellLongPressed:")
        longPressRecognizer.delegate = self
        // tableViewにrecognizerを追加
        tableView.addGestureRecognizer(longPressRecognizer)
        
        // タップジェスチャーを設定
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "tapped:")
        gestureRecognizer.delegate = self
        //navigationBar全体にタップジェスチャを追加
//        navigationController?.view.addGestureRecognizer(gestureRecognizer)
//        navigationController?.view.userInteractionEnabled = true
        //タイトルの文字部分だけ
        navigationItem.titleView?.addGestureRecognizer(gestureRecognizer)
        navigationItem.titleView?.userInteractionEnabled = true
        
        //refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        //カスタムセルを指定
        let nib1  = UINib(nibName: "TweetCell", bundle:nil)
        tableView.registerNib(nib1, forCellReuseIdentifier:"tweetcell")
        let nib2  = UINib(nibName: "ReTweetCell", bundle:nil)
        tableView.registerNib(nib2, forCellReuseIdentifier:"retweetcell")
        
        //tableviewのcellの高さを可変に(AutomaticDimensionで自動的に計算してくれる)
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //アカウントの取得
        if TwitterClient.sharedInstance.myId() >= 0
        {
            let myID:Int = TwitterClient.sharedInstance.myId()
            // アカウントの一覧の取得
            TwitterClient.sharedInstance.getAccounts { (accounts: [ACAccount]) -> Void in
                //取得完了後、アカウントを指定
                TwitterClient.sharedInstance.twAccount = accounts[myID]
                //timelineの取得
                TwitterClient.sharedInstance.getTimeline(self.onGetTimeLine)
            }
        }else{
            //ゲストユーザで利用する
            print("アカウントが選択されていますせん")
        }
        
        //インターネットに接続されていない状態の処理
        
        //Realm確認
        do {
            let realm = try Realm()
            print("realm.count:")
            print(realm.objects(TweetItem).count)
        } catch {
            print("error")
        }
        
    }
    
    
    
    //更新処理
    func refresh()
    {
        print("refresh")
        maxIdStr = ""
        //timelineの取得
        TwitterClient.sharedInstance.getTimeline(self.onGetTimeLine)
        //更新終了（refreshcontrolの停止）
        refreshControl.endRefreshing()
    }
    //tableviewの更新
    private func reloadTableView(){
        //メインスレッドでtableviewの更新を行う
        dispatch_async_main {
            self.tableView.reloadData()
        }
    }
    //GDCのメインスレッド処理
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    //JSONマッピング
    func jsonMapping(data:NSMutableArray){
        if let item_data_arr:[TweetItem] = Mapper<TweetItem>().mapArray(data) {
            do {
                let realm = try Realm()
                for hoge in item_data_arr {
                    // Bookオブジェクトを保存.
                    realm.beginWrite()
                    realm.add(hoge)
                    try realm.commitWrite()
                }
            } catch {
                print("error")
            }
        }
    }
    
    
    /*
        Twitter機能
    */
    //タイムラインの更新
    private func onGetTimeLine(data: NSMutableArray)
    {
        tweetArray.removeAllObjects()
        tweetArray.addObjectsFromArray(data as [AnyObject])
        
        jsonMapping(data)
        
        reloadTableView()
    }
    //タイムラインの追加取得
    private func onGetPreTimeLine(data: NSMutableArray)
    {
        tweetArray.addObjectsFromArray(data as [AnyObject])
        
        //maxidを指定してAPIを取得すると同じ値でかぶるので削除
        tweetArray.removeObjectAtIndex(self.tweetArray.count - 10)
        
        print("tweet count:\(tweetArray.count)")
        
        reloadTableView()
    }
    
    
    
    /*
        timer action
    */
    func onAutoScrollTimer(){
        //tableviewを自動スクロール
        if scrollDirection == true {
            scrollPoint.y += autoScrollSpeed
        }else{
            scrollPoint.y -= autoScrollSpeed
        }
        if (scrollPoint.y > 0) {
            tableView.contentOffset = scrollPoint
        }else{
            stopTimer()
        }
    }
    func startTimer(){
        scrollPoint = tableView.contentOffset
        timer = NSTimer.scheduledTimerWithTimeInterval(timerInterval, target: self, selector:"onAutoScrollTimer", userInfo: nil, repeats: true)
    }
    func stopTimer(){
        timer?.invalidate()
        isScrolling = false
    }
    
}



/*
    tableview datasourceの拡張
*/
extension ViewController : UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let json = JSON(self.tweetArray)
        
        //最下部までスクロールしたかの判定
        if self.tweetArray.count > indexPath.row {
            maxIdStr = json[indexPath.row]["id_str"].string!
            if (self.tweetArray.count - 1) == indexPath.row && self.maxIdStr != ""{
                print("refresh button")
                //timelineの更新
                TwitterClient.sharedInstance.getPreTimeline(maxIdStr, countStr: "10", callbabk: self.onGetPreTimeLine)
            }
        }
        
        //セルの生成
        var cell = tableView.dequeueReusableCellWithIdentifier("tweetcell") as? TweetCell // cell recycle
        if cell == nil {
            cell = TweetCell(style:UITableViewCellStyle.Default, reuseIdentifier:"tweetcell")
        }
        
        //リツイートかどうかの判定
        let retweetstatus = json[indexPath.row]["retweeted_status"].dictionaryObject
        if retweetstatus?.count > 0 {
            //リツイート
            cell?.updateReTweet(json[indexPath.row].dictionaryObject!, retweetdata: retweetstatus!)
        }else{
            //ツイート
            cell?.updateTweet(json[indexPath.row].dictionaryObject!)
        }

        return cell!
    }
    
}


/*
    tableview delegateの拡張
*/
extension ViewController: UITableViewDelegate{
    
    //heaterの高さ
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    //cellがタップされた時
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("cell selected")
        stopTimer()
    }
    
    
    //スクロールスタート
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollBeginingPoint = scrollView.contentOffset;
    }
    //スクロール中
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentPoint = scrollView.contentOffset
        if scrollBeginingPoint.y <= currentPoint.y {
            //print("下へスクロール")
            scrollDirection = true
        }else{
            //print("上へスクロール")
            scrollDirection = false
        }
    }
    
    //スクロールで指がは離れた時
    func scrollViewDidEndDragging(scrollView: UIScrollView,willDecelerate decelerate: Bool){
        print("did end dragging")
        //startTimer()
    }
    //スクロールストップ
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        print("did end decelerating")
    }
}

/*
    gesture recognizer delegate
*/
extension ViewController: UIGestureRecognizerDelegate{
    
    /*
    cellを長押しした際に呼ばれるメソッド
    */
    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        
        // 押された位置でcellのPathを取得
        let point = recognizer.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        if indexPath == nil {
            
        } else if recognizer.state == UIGestureRecognizerState.Began  {
            // 長押しされた場合の処理
            print("長押しされたcellのindexPath:\(indexPath?.row)")
            //ツイートをお気に入りに追加
        }
    }
    
    //navigationbarのタップ検知
    func tapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("tapped.")
        //一番下まで自動スクロール
        //self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height), animated: false)
        //一番上まで自動スクロール
        self.tableView.setContentOffset(CGPointMake(0, 0), animated:true)
    }
    
}


