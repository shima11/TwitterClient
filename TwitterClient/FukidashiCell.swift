//
//  TweetCell.swift
//  Twiroll
//
//  Created by shima jinsei on 2015/12/31.
//  Copyright © 2015年 Jinsei Shima. All rights reserved.
//

import UIKit
import SwiftyJSON
import WebImage

class FukidashiCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var tweetTimeLabel: UILabel!
    @IBOutlet weak var accountIDLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var reTweetAccountNameLabel: UILabel!
    @IBOutlet weak var reTweetProfileImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImageView.layer.cornerRadius = 6.0
        self.reTweetAccountNameLabel.text = ""
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //普通のツイートの場合
    func updateTweet(tweet:NSDictionary) {
        let tweet = JSON(tweet)
        //cellに各種テキスト情報の表示
        self.accountNameLabel?.text = tweet["user"]["name"].string
        self.accountIDLabel?.text = bindingString("@", str2: tweet["user"]["screen_name"].string!)
        self.descriptionLabel?.text = tweet["test"].string
        let dateString:String = tweet["created_at"].string!
        self.tweetTimeLabel?.text = DateTransfer.dateTrans(dateString)
        
        self.reTweetAccountNameLabel.text = ""
        
        // プロフィール画像の表示
        let urlStr:String = tweet["user"]["profile_image_url_https"].string!
        let url: NSURL = NSURL(string: urlStr)!
        profileImageView.sd_setImageWithURL(url)
        
        
        //リツイートした人のプロフィール画像を表示しない
        reTweetProfileImageView.sd_setImageWithURL(nil)
        
        // 関連画像の表示
        let mediaImageURLString = tweet["entities"]["media"][0]["media_url_https"].string
        if mediaImageURLString?.characters.count > 0{
            let mediaImageURL:NSURL = NSURL(string: mediaImageURLString!)!
            self.mediaImageView.sd_setImageWithURL(mediaImageURL)
        } else {
            self.mediaImageView.sd_setImageWithURL(nil)
        }
        
    }
    
    /*
    リツイートの場合
    tweetdata: リツートした人のデータ
    retweetdata: リツートされた人のデータ
    */
    func updateReTweet(tweetdata:NSDictionary, retweetdata:NSDictionary) {
        let tweet = JSON(tweetdata)
        let reTweet = JSON(retweetdata)
        //cellに各種テキスト情報の表示
        self.accountNameLabel?.text = tweet["user"]["name"].string
        self.accountIDLabel?.text = bindingString("@", str2: reTweet["user"]["screen_name"].string!)
        self.descriptionLabel?.text = reTweet["text"].string
        let dateString:String = reTweet["creat_at"].string!
        self.tweetTimeLabel?.text = DateTransfer.dateTrans(dateString)
        let retweetNameString = tweet["user"]["name"].string
        self.reTweetAccountNameLabel.text = retweetNameString! + "さんがリツイート"
        
        // プロフィール画像の表示
        let urlStr:String = reTweet["user"]["profile_image_url_https"].string!
        let url: NSURL = NSURL(string: urlStr)!
        profileImageView.sd_setImageWithURL(url)
        
        //リツイートした人のプロフィール画像の表示
        let retweetUrlStr:String = tweet["user"]["profile_image_url_https"].string!
        let retweetUrl: NSURL = NSURL(string: retweetUrlStr)!
        reTweetProfileImageView.sd_setImageWithURL(retweetUrl)
        
        // 関連画像の表示
        let mediaImageURLString = reTweet["entities"]["media"][0]["media_url_https"].string
        if mediaImageURLString?.characters.count > 0{
            let mediaImageURL:NSURL = NSURL(string: mediaImageURLString!)!
            self.mediaImageView.sd_setImageWithURL(mediaImageURL)
        } else {
            self.mediaImageView.sd_setImageWithURL(nil)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //横幅の計算
        self.accountNameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.accountNameLabel.bounds)
        self.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.descriptionLabel.bounds)
    }
    
    
    func bindingString(str1: String, str2: String) -> String {
        return str1 + str2
    }
}
