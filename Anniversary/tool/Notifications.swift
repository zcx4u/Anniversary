//
//  Notifations.swift
//  Anniversary
//
//  Created by 周传祥 on 2018/11/29.
//  Copyright © 2018 zcx. All rights reserved.
//

import Foundation
import UserNotifications

struct myNotifications {
    
    /// 根据标识符删除通知请求和通知
    ///
    /// - Parameter indentifer: note的title
    func deleteMyNotification(with indentifer:String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [indentifer])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [indentifer])
    }
    
    /// 根据字典中的值添加t本地通知 分别提前一天 七天 三十天 通知
    ///
    /// - Parameter data: note字典
    func addMyNotification(with data:NSMutableDictionary) {
        let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "yyyy-MM-dd"
        let content = UNMutableNotificationContent()
        
        if  let isRemind = data.value(forKey: "isRemind") as? String,
            let time :String = data.value(forKey: "time") as? String ,
            let title:String = data.value(forKey: "title")as? String ,
            let gift:String = data.value(forKey: "isNeedGift")as? String,
            var dateTime = dateFormatter.date(from: time),
            let remindType:String = data.value(forKey: "remindType") as? String,
            let dayType = data.value(forKey: "dayType") as? String {
//          isRemind ：是否周年提醒
            if(isRemind == "false") {
                return
            }
            var timeDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day],   from:dateTime )
            //
            if dayType == "纪念日" {
                let today = Date()
                let days = dateTools.compare2Date(FromDate: dateTime, ToDate:today)
                let year :Int = days / 365
                if  let timeDay = timeDateCom.day ,let timeMonth = timeDateCom.month {
                    content.body = "\(timeMonth)-\(timeDay)是\(title)\(year)周年纪念日哦"
                }
            } else {
                content.body = "\(time)是\(title)的生日哦"
            }
            content.sound = UNNotificationSound.default
            //
            if gift == "true" {
                content.subtitle = "记得准备礼物哦"
            }else {
                content.subtitle = "这一天一定要过的开心哦"
            }
            var components = DateComponents()
            //
            switch remindType {
            case "一天" :
                var interval = dateTime.timeIntervalSince1970
                interval -= 86400
                dateTime = Date(timeIntervalSince1970: interval)
                components = Calendar.current.dateComponents([.month, .day],   from: dateTime)
                break
            case "一周":
                var interval = dateTime.timeIntervalSince1970
                interval -= 86400 * 7
                dateTime = Date(timeIntervalSince1970: interval)
                components = Calendar.current.dateComponents([.month, .day],   from: dateTime)
                break
            case "一月":
                var interval = dateTime.timeIntervalSince1970
                interval -= 86400 * 30
                dateTime = Date(timeIntervalSince1970: interval)
                components = Calendar.current.dateComponents([.month, .day],   from: dateTime)
                break
            default:
                break
            }
            
            components.hour = 8
            components.minute = 0
            
            let calanderTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let req  = UNNotificationRequest(identifier: title, content: content, trigger: calanderTrigger)
            UNUserNotificationCenter.current().add(req) { (error) in
                if let error = error {
                    print("error:\(error)")
                } else {
                    print("add done")
                }
            }
            print("正在添加本地通知")
            
        }
    }
    
}
