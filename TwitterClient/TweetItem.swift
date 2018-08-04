//
//  TweetItem.swift
//  Twiroll
//
//  Created by shima jinsei on 2016/01/08.
//  Copyright © 2016年 Jinsei Shima. All rights reserved.
//

//import Foundation
//import Realm
import RealmSwift
import ObjectMapper

class TweetItem: Object {
    
    dynamic var accountName = ""
    dynamic var accountIDName = ""
    dynamic var createAt = ""
    dynamic var tweetContent = ""
    dynamic var rtScreenName = ""
    dynamic var rtAccountIDName = ""
    dynamic var profileImageURLString = ""
    dynamic var mediaImageURLString = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
}


extension TweetItem:Mappable{
    func mapping(map: Map) {
        accountName <- map["user.name"]
        accountIDName <- map["user.screen_name"]
        createAt <- map["created_at"]
        tweetContent <- map["text"]
        rtScreenName <- map["retweeted_status.user.name"]
        rtAccountIDName <- map["retweeted_status.user.screen_name"]
        profileImageURLString <- map["user.profile_image_url_https"]
        mediaImageURLString <- map["entities.media.0.media_url_https"]
    }
}