//
//  DateTransfer.swift
//  Twiroll
//
//  Created by shima jinsei on 2015/12/30.
//  Copyright © 2015年 Jinsei Shima. All rights reserved.
//

import UIKit
import Foundation

final class DateTransfer {

    
    /*
        twitterAPIからの日付を渡すと
        mm/dd/hh:mm のかたちに整形して返す
    */
    class func dateTrans(dateString: String) -> String {
        //dateString-sample
        //Tue Dec 29 09:28:46 +0000 2015
        
        //月を取り出す
        var month = (dateString as NSString).substringWithRange(NSRange(location: 4, length: 3))  // World!
        switch month {
            case "Jan" :
                month = "01"
                break
            case "Feb" :
                month = "02"
                break
            case "Mar" :
                month = "03"
                break
            case "Apr" :
                month = "04"
                break
            case "May" :
                month = "05"
                break
            case "Jun" :
                month = "06"
                break
            case "Jul" :
                month = "07"
                break
            case "Aug" :
                month = "08"
                break
            case "Sep" :
                month = "09"
                break
            case "Oct" :
                month = "10"
                break
            case "Nov" :
                month = "11"
                break
            case "Dec" :
                month = "12"
                break
            default :
                month = ""
                break
        }
        //日付を取り出す
        let day = (dateString as NSString).substringWithRange(NSRange(location:8, length:2))
        
        //時間を取り出す
        let time = (dateString as NSString).substringWithRange(NSRange(location: 11, length: 5))
        
        //print(month + "/" + day + "/" + time)
        
        return month + "/" + day + "/" + time
    }
}
