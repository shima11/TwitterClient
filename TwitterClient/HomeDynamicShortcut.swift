//
//  HomeDynamicShortcut.swift
//  TwitterClient
//
//  Created by shima jinsei on 2016/01/10.
//  Copyright © 2016年 Jinsei Shima. All rights reserved.
//

import Foundation
import UIKit

class HomeDynamicShortcut {
    enum ShortcutType: String {
        case Timetable = "Timetable"
        case Board = "Board"
    }
    
    @available(iOS 9.0, *)
    class func shortcuts() -> [UIApplicationShortcutItem] {
        let shortcut1 = UIMutableApplicationShortcutItem(
            type: ShortcutType.Timetable.rawValue,
            localizedTitle: "時間割",
            localizedSubtitle: nil,
            icon: UIApplicationShortcutIcon(templateImageName: "timetableIcon"),
            userInfo: ["shortcutKey": ShortcutType.Timetable.rawValue]
        )
        
        let shortcut2 = UIMutableApplicationShortcutItem(
            type: ShortcutType.Board.rawValue,
            localizedTitle: "掲示板",
            localizedSubtitle: nil,
            icon: UIApplicationShortcutIcon(templateImageName: "boardIcon"),
            userInfo: ["shortcutKey": ShortcutType.Board.rawValue]
        )
//        let now = Timetable.getNow()
//        let nextClassWeekDay = now.0
//        var nextClassPeriod = now.1
//        let timetable = Timetable()
//        var nextClass: TimetableData?
        
//        for _ in 0...7 {
//            if let data = timetable.get(day: nextClassWeekDay, period: nextClassPeriod) {
//                nextClass = data
//                break
//            } else {
//                nextClassPeriod++
//            }
//        }
//        var title = "今日はもう授業はありません"
//        var subTitle: String?
//        if let nextClass = nextClass {
//            title = "次は" + nextClass.name
//            subTitle = nextClass.place
//        }
//        let shortcut3 = UIMutableApplicationShortcutItem(
//            type: ShortcutType.Board.rawValue,
//            localizedTitle: title,
//            localizedSubtitle: subTitle,
//            icon: UIApplicationShortcutIcon(templateImageName: "classIcon"),
//            userInfo: ["shortcutKey": ShortcutType.NextClass.rawValue]
//        )
        
        return [shortcut1, shortcut2]
    }
    
}