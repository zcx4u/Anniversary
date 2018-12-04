//
//  CommonHelper.swift
//  EWDatePicker
//
//  Created by Ethan.Wang on 2018/8/27.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import Foundation
import UIKit

struct ScreenInfo {
    static let Frame = UIScreen.main.bounds
    static let Height = Frame.height
    static let Width = Frame.width
    static let navigationHeight:CGFloat = navBarHeight()
    
    static func isIphoneX() -> Bool {
        return UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812))
    }
    static private func navBarHeight() -> CGFloat {
        return isIphoneX() ? 88 : 64;
    }
}
//便捷的类方法
extension UIColor {
    class func colorWithRGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}
struct dateTools {
    
    static var currentDateCom: DateComponents = Calendar.current.dateComponents([.year, .month, .day],   from: Date())
    
    
    static func dataNow() -> String{
        
        let date = Date.init()
        
        let timeFormatter = DateFormatter.init()
        
        timeFormatter.dateFormat="yyyyMMddHHmmss"
        
        return timeFormatter.string(from: date)
        
    }
//    str to date
    /// 字符串转日期（带上要转的格式字符串）
    ///
    /// - Parameters:
    ///   - string: 日期字符串
    ///   - dateFormat: 格式化字符串默认 yyyy-MM-dd HH:mm:ss
    /// - Returns: Date？
    static func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: string)
        return date
    }

    /// 年月日转中国农历
    ///
    /// - Parameters:
    ///   - year: int
    ///   - month: int
    ///   - day: int
    /// - Returns: 字符串 eg：2018年正月十五
    static  func solarToLunar(year: Int, month: Int, day: Int) -> String {
        //初始化公历日历
        let solarCalendar = Calendar.init(identifier: .gregorian)
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone.init(secondsFromGMT: 60 * 60 * 8)
        let solarDate = solarCalendar.date(from: components)
        
        //初始化农历日历
        let lunarCalendar = Calendar.init(identifier: .chinese)
        //日期格式和输出
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.calendar = lunarCalendar
        return formatter.string(from: solarDate!)
    }
    
    /// 计算距离下一个日期还有几天
    ///
    /// - Parameter birthday: 目标日期
    /// - Returns: 间隔天数
    static  func calcunateCuntdownDays(birthday: String) -> Int {
        let defaultDateFormatter = DateFormatter()
        defaultDateFormatter.locale = Locale.current
        //返回值 countDown
        var countDown = 0
        // 1. 获取当前日期
        let currentDay = Date()
        //print(currentDay)
        // 2. 组建当年生日
        defaultDateFormatter.dateFormat = "yyyy"
        let currentYear = defaultDateFormatter.string(from: currentDay)
        var newBirthdayString = birthday
        newBirthdayString.replaceSubrange(newBirthdayString.startIndex ..< newBirthdayString.index(newBirthdayString.startIndex, offsetBy: 4), with: currentYear)
        defaultDateFormatter.dateFormat = "yyyy-MM-dd"
        let birthDay = defaultDateFormatter.date(from: newBirthdayString)
        //print(birthDay)
        // 3. 比较两个日期
        if let birthDay = birthDay {
            if birthDay <= currentDay {
                //4.1 如果生日已过，加一年，生成新的生日
                let yearsToAdd = 1
                var newDateComponent = DateComponents()
                newDateComponent.year = yearsToAdd
                let newBirthDay = Calendar.current.date(byAdding: newDateComponent, to: birthDay)
                // 5 计算差值
                countDown = compare2Date(FromDate: currentDay, ToDate: newBirthDay!)
            }else {
                countDown = compare2Date(FromDate: currentDay, ToDate: birthDay)
            }
        }
        return countDown + 2
    }
    
    //计算两个日期差天数
    /// 计算两个日期差天数
    ///
    /// - Parameters:
    ///   - FromDate: 开始日期
    ///   - ToDate: 结束日期
    /// - Returns: 天数
    static  func compare2Date(FromDate: Date, ToDate: Date) -> Int {
        var result = 0
        let interval = ToDate.timeIntervalSince(FromDate)
        result = Int(round(interval / 86400.0))
        return result - 1
    }
    
    /// 判断一个日期是否是今天
    ///
    /// - Parameter date: 日期
    /// - Returns: bool
    static func isToday(date:Date)->Bool{
       return Calendar.current.isDate(date, inSameDayAs: Date())
    }
    static func isTodayInYear(m:Int,d:Int) ->Bool{
        if(currentDateCom.month == m && currentDateCom.day == d ){
            return true
        }
        return false
    }
}


extension UIView {
    
    
    public enum ShakeDirection: Int {
        case horizontal  //水平抖动
        case vertical  //垂直抖动
    }
    
    /// 扩展UIView增加抖动方法
    ///
    /// - Parameters:
    ///   - direction: 抖动方向（默认是水平方向）
    ///   - times: 抖动次数（默认5次）
    ///   - interval: 每次抖动时间（默认0.1秒）
    ///   - delta: 抖动偏移量（默认2）
    ///   - completion: 抖动动画结束后的回调
    public func shake(direction: ShakeDirection = .horizontal, times: Int = 5,
                      interval: TimeInterval = 0.1, delta: CGFloat = 2,
                      completion: (() -> Void)? = nil) {
        //播放动画
        UIView.animate(withDuration: interval, animations: { () -> Void in
            switch direction {
            case .horizontal:
                self.layer.setAffineTransform( CGAffineTransform(translationX: delta, y: 0))
                break
            case .vertical:
                self.layer.setAffineTransform( CGAffineTransform(translationX: 0, y: delta))
                break
            }
        }) { (complete) -> Void in
            //如果当前是最后一次抖动，则将位置还原，并调用完成回调函数
            if (times == 0) {
                UIView.animate(withDuration: interval, animations: { () -> Void in
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (complete) -> Void in
                    completion?()
                })
            }
                //如果当前不是最后一次抖动，则继续播放动画（总次数减1，偏移位置变成相反的）
            else {
                self.shake(direction: direction, times: times - 1,  interval: interval,
                           delta: delta * -1, completion:completion)
            }
        }
        
    }
}
