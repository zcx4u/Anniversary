//
//  AddNoteView.swift
//  Anniversary
//
//  Created by 周传祥 on 2018/11/21.
//  Copyright © 2018 zcx. All rights reserved.
//

import UIKit


class AddNoteView: UIView {
    let backGroundColor = UIColor.colorWithRGBA(r: 30, g: 144, b: 255, a: 1)
    let littleFont = UIFont.italicSystemFont(ofSize: 12);
    let title = UITextField();
    let timeText = UITextField();
    let remindLabel = UILabel();
    let remind = UISwitch();
    let gift = UISwitch();
    let giftLabel = UILabel();
    let dayType = UISegmentedControl(items: ["生日","纪念日"]);
    let str = ["一天","一周","一月"];
    let remindType = UISegmentedControl(items: ["一天","一周","一月"]);
    let submit  = UIButton();
    let littleLable = UILabel();
    var viewA = UIView();
    var viewB = UIView();
    var viewC = UIView();
    var viewD = UIView();
    var viewE = UIView();
    let titleImage = UIImageView(image: UIImage(named: "edit"))
    let timeImage = UIImageView(image: UIImage(named: "date"))
    
    override init (frame: CGRect) {
        super.init(frame:frame);
        myInit();
    }
    func myInit () {
        
        self.addSubview(viewA)
        self.addSubview(viewB)
        self.addSubview(viewC)
        self.addSubview(viewD)
        self.addSubview(viewE)
        self.addSubview(dayType)
        self.addSubview(submit)
        viewA.addSubview(title)
        viewA.addSubview(titleImage)
        viewB.addSubview(timeText)
        viewB.addSubview(timeImage)
        viewC.addSubview(remindLabel)
        viewC.addSubview(remind)
        viewD.addSubview(giftLabel)
        viewD.addSubview(gift)
        viewE.addSubview(remindType)
        viewE.addSubview(littleLable)
        title.placeholder = "什么事 ？";
        timeText.placeholder = "什么时候发生的 ？"
        dayType.selectedSegmentIndex = 0
        remindLabel.text = "周年提醒";
        remind.isOn = false
        giftLabel.text = "提醒我准备礼物";
        gift.isOn = false
        remindType.isHidden = true
        remindType.selectedSegmentIndex = 0
        littleLable.text = "提前一天提示"
        littleLable.isHidden = true
        submit.setTitle("确定", for: .normal);
        submit.backgroundColor = backGroundColor
        gift.onTintColor = backGroundColor
        remind.onTintColor = backGroundColor
        dayType.tintColor = backGroundColor
        remindType.tintColor = backGroundColor
        remind.addTarget(self, action: #selector(giftChanged(_:)), for: .valueChanged);
        remindType.addTarget(self, action: #selector(giftChanged(_:)), for: .valueChanged)
        littleLable.font = littleFont
        littleLable.textColor = UIColor.gray
        submit.layer.cornerRadius = 10
        
        for item in [viewA,viewB,viewC,viewD] {
            item.layer.borderColor = backGroundColor.cgColor
            item.layer.borderWidth = 1
            item.layer.cornerRadius = 5
        }
    }
    
    
    override func layoutSubviews () {
        
        let  viewWidth = self.bounds.width - 40
        let  labelWidth : CGFloat = 100.0
        let  height : CGFloat = 40.0
        let  imageSize : CGFloat = 38.0
        let  viewLeftSpace : CGFloat = 20.0
        let  viewTopSpace : CGFloat = 20
        let  textfieldLeftSpace : CGFloat = 50
        let  basePoint : CGPoint = CGPoint(x: 0, y: 104)
        let  zeroPoint = CGPoint(x: 0, y: 0)
        let  labelLeftSpace : CGFloat = 5.0
        viewA.frame = CGRect(x: viewLeftSpace, y: basePoint.y, width: viewWidth, height: height)
        titleImage.frame = CGRect(x: zeroPoint.x, y: zeroPoint.y, width: imageSize, height: imageSize)
        title.frame = CGRect(x: zeroPoint.x + textfieldLeftSpace, y: zeroPoint.y, width: viewWidth-textfieldLeftSpace, height: height)
        viewB.frame = CGRect(x: viewLeftSpace, y: viewA.frame.maxY + viewTopSpace, width: viewWidth, height: height)
        timeImage.frame = CGRect(x: zeroPoint.x, y: zeroPoint.y, width: imageSize, height: imageSize)
        timeText.frame = CGRect(x: zeroPoint.x + textfieldLeftSpace, y: zeroPoint.y, width: viewWidth-textfieldLeftSpace, height: height)
        dayType.frame = CGRect(x: viewLeftSpace, y: viewB.frame.maxY + viewTopSpace, width: viewWidth, height: height);
        viewC.frame = CGRect(x: viewLeftSpace, y: dayType.frame.maxY + viewTopSpace, width: viewWidth, height: height)
        remindLabel.frame = CGRect(x: zeroPoint.x + labelLeftSpace, y:zeroPoint.y, width: labelWidth * 2, height: height)
        remind.frame = CGRect(x: viewC.bounds.width-60, y: 5, width: 60, height: height)
        viewD.frame = CGRect(x: viewLeftSpace, y: viewC.frame.maxY + viewTopSpace, width: viewWidth, height: height)
        giftLabel.frame = CGRect(x: zeroPoint.x + 5, y: zeroPoint.y, width: labelWidth * 2, height: height)
        gift.frame = CGRect(x: viewD.bounds.width - 60, y: 5, width: 60, height: height)
        viewE.frame = CGRect(x: viewLeftSpace, y: viewD.frame.maxY + viewTopSpace, width: viewWidth, height: height+10)
        remindType.frame = CGRect(x: zeroPoint.x, y: zeroPoint.y, width: viewWidth, height: height)
        littleLable.frame = CGRect(x: zeroPoint.x, y: remindType.frame.maxY+5, width: viewWidth, height: height/4)
        submit.frame = CGRect(x: (self.bounds.width-100)/2, y: self.bounds.height-140, width: labelWidth, height: height);
       
    }
    
    @objc func giftChanged( _ sender : AnyObject){
        if let gift = sender as? UISwitch{
            self.remindType.isHidden = !gift.isOn
            littleLable.isHidden = !gift.isOn
        }
        if let remindtype = sender as? UISegmentedControl
        {
            littleLable.text = "提前\(str[remindtype.selectedSegmentIndex])提示"
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
