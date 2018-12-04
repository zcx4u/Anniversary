//
//  CollectionViewController.swift
//  Anniversary
//
//  Created by 周传祥 on 2018/11/22.
//  Copyright © 2018 zcx. All rights reserved.
//

import UIKit
import UserNotifications
class CollectionViewController: UIViewController {
    
    let myColor = UIColor.colorWithRGBA(r: 65, g: 105, b: 225, a: 1);
    var collection:UICollectionView!;
    var data :NSMutableArray = [];
    var num :Int = 0;
    let leftimg = UIImageView(image: UIImage(named: "change"))
    let rightimg = UIImageView(image: UIImage(named: "delete"))
    var selectIndex:IndexPath?
    let notification = myNotifications()
    let imageSize:CGFloat = 40
    override func viewDidLoad() {
        super.viewDidLoad();
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollection), name: UIApplication.didBecomeActiveNotification, object: nil)
        self.data = NSMutableArray.init();
        if let myData = UserDefaults.standard.array(forKey: "notes") {
            for item in myData
            {
                self.data.add(item as? NSDictionary ?? NSDictionary())
            }
        }
        num = data.count;
        let layout = UICollectionViewFlowLayout()
        let screen = UIScreen.main;
        layout.itemSize = CGSize(width: screen.bounds.width-40, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 15, right: 20)
        layout.minimumLineSpacing = 20
        let  colFrame = CGRect(origin:CGPoint(x:0,y:0), size:CGSize(width: screen.bounds.width, height: screen.bounds.height-ScreenInfo.navigationHeight))
        collection = UICollectionView(frame:colFrame, collectionViewLayout: layout)
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier:"collectionCell")
        collection.backgroundColor = UIColor.clear
        collection.delegate = self;
        collection.dataSource = self;
        view.addSubview(collection);
        collection.addSubview(leftimg)
        collection.addSubview(rightimg)
        leftimg.isUserInteractionEnabled = true
        rightimg.isUserInteractionEnabled = true
        leftimg.frame.size = CGSize(width: imageSize, height: imageSize)
        rightimg.frame.size =  CGSize(width: imageSize, height: imageSize)
        let leftGesTouch = UITapGestureRecognizer(target: self, action: #selector(editTapGestureWithLeftImage(_:)))
        let rightGesTouch = UITapGestureRecognizer(target: self, action: #selector(deleteTapGestureWithRightImage(_:)))
        leftimg.addGestureRecognizer(leftGesTouch)
        rightimg.addGestureRecognizer(rightGesTouch)
        leftimg.isHidden = true
        rightimg.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.navigationBar.barTintColor = myColor
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.view.backgroundColor = myColor;
        self.navigationItem.title = "Days";
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "barbuttonadd"), style: .plain, target: self, action: #selector(nextVC))
    }
    
    @objc func reloadCollection() {
        collection.reloadData()
    }
    @objc func nextVC() {
        let vc = AddPageViewController();
        vc.delegate = self;
        let  nav = UINavigationController(rootViewController: vc)
        if let index = selectIndex, let cell = collection.cellForItem(at: index) {
            cell.center = CGPoint(x: ScreenInfo.Width/2, y: cell.center.y)
            leftimg.isHidden = true
            rightimg.isHidden = true
        }
        self.present(nav, animated: true) {
        }
    }
}
//MARK: collection DataSource
extension CollectionViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return num;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collection.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell;
        let cellData = data[indexPath.row] as! NSDictionary;
        if(cell.isEqual(nil))
        {
            cell = CollectionViewCell(frame: CGRect(x: 0, y: 0, width: 200, height: 100));
        }
        cell.initData(cellData);
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(_:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        cell.addGestureRecognizer(longPress)
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        cell.addGestureRecognizer(leftSwipe)
        cell.addGestureRecognizer(rightSwipe)
        cell.addGestureRecognizer(tap)
        return cell;
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = data[sourceIndexPath.row]
        data.removeObject(at: sourceIndexPath.row)
        data.insert(temp, at: destinationIndexPath.row)
        UserDefaults.standard.setValue(self.data, forKey: "notes");
    }
}
//MARK:手势定义
extension CollectionViewController{
    @objc func longPressGesture(_ sender:UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            //取得要移动cell的索引
            let selectedCellIndex = collection.indexPathForItem(at: sender.location(in: collection))
            //开始移动
            collection.beginInteractiveMovementForItem(at: selectedCellIndex!)
        case .changed:
            //移动ing
            collection.updateInteractiveMovementTargetPosition(sender.location(in: collection))
        case .ended:
            //结束移动
            collection.endInteractiveMovement()
        default:
            //取消移动
            collection.cancelInteractiveMovement()
        }
        
    }
    
    @objc func swipeGesture(_ sender :UISwipeGestureRecognizer){
    
        let selectedCellIndex = collection.indexPathForItem(at: sender.location(in: collection))
        if(sender.direction == .left) {
            swipeToLeftAnimation(with: selectedCellIndex)
            self.selectIndex = selectedCellIndex
        }else if(sender.direction == .right){
            swipeToRightAnimation(with: selectedCellIndex)
        }
    }
        
    
    @objc func editTapGestureWithLeftImage(_ sender :UITapGestureRecognizer) {
        let vc = AddPageViewController();
        vc.delegate = self;
        let  nav = UINavigationController(rootViewController: vc)
        if let index = self.selectIndex {
            let cellData = self.data.object(at: index.row) 
            vc.data = cellData as! NSMutableDictionary
            self.present(nav, animated: true, completion: nil)
            swipeToRightAnimation(with: selectIndex)
        }
        
    }
    @objc func deleteTapGestureWithRightImage(_ sender :UITapGestureRecognizer) {
       
        let alertController = UIAlertController(title: "删除", message: "确认要删除吗", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "删除", style: .destructive) { (okAction) in
            self.swipeToRightAnimation(with: self.selectIndex)
            if let index = self.selectIndex{
                let dict = self.data[index.row] as? NSDictionary
                let identifer = dict?.value(forKey: "title") as? String
                self.notification.deleteMyNotification(with: identifer ?? "nil")
                self.data.removeObject(at: index.row)
                self.num = self.data.count
                self.collection.reloadData()
                
                UserDefaults.standard.setValue(self.data, forKey: "notes")
            }
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    @objc func tapGesture(_ sender :UIGestureRecognizer) {
        swipeToRightAnimation(with: selectIndex)
    }
    
}
//MARK:addview回调
extension CollectionViewController:addOneNoteProtocol{
    func callBack(newData: NSMutableDictionary, editType: String) {
        if(editType == "add") {
            self.data.add(newData);
            UserDefaults.standard.setValue(self.data, forKey: "notes");
            num = self.data.count;
            self.collection.reloadData();
        }else {
            if let index = self.selectIndex, let lastDict :NSDictionary = data[index.row] as? NSDictionary {
                notification.deleteMyNotification(with: lastDict["title"] as? String ?? "nil" )
                self.data.removeObject(at: index.row)
                self.data.insert(newData, at: index.row)
                UserDefaults.standard.setValue(self.data, forKey: "notes")
                collection.reloadItems(at: [index])
            }
            
        }
        
        notification.addMyNotification(with: newData)
        self.dismiss(animated: true) 
        
    }
    
    func dismisVC() {
        self.dismiss(animated: true)
    }
}

//MARK:CELL移动
extension CollectionViewController {
    
    /// 当前cell左移上一个cell还原
    ///
    /// - Parameter thisIndex: 当前选择的cell index
    func swipeToLeftAnimation(with thisIndex:IndexPath?)  {
        if let lastIndex = selectIndex,let thisIndex = thisIndex,let cell = collection.cellForItem(at: thisIndex){
            if(lastIndex.row != thisIndex.row) {
                swipeToRightAnimation(with: selectIndex)
            }else  if cell.center.x == 20{
                return
            }
        }
        if let thisIndex = thisIndex ,let cell = collection.cellForItem(at: thisIndex) {
            
            let center:CGPoint = cell.center
            let maxX = cell.frame.maxX
            leftimg.center = CGPoint(x: maxX + 20 , y: center.y)
            rightimg.center = CGPoint(x: maxX + 20 , y: center.y)
            UIView.animate(withDuration: 0.5) {
                cell.center = CGPoint(x: 20, y: center.y)
                self.leftimg.isHidden = false
                self.rightimg.isHidden = false
                self.leftimg.center = CGPoint(x:center.x + 50, y: self.leftimg.center.y)
                self.rightimg.center = CGPoint(x:center.x + 130, y: self.leftimg.center.y)
            }
        }
        
    }
    
    /// cell右移
    ///
    /// - Parameter thisIndex: 需要右移的cell index
    func swipeToRightAnimation(with thisIndex:IndexPath?) {
        if let thisIndex = thisIndex, let cell = collection.cellForItem(at: thisIndex){
        let center:CGPoint = cell.center
            if(center.x<ScreenInfo.Width/2) {
                UIView.animate(withDuration: 0.5) {
                    cell.center = CGPoint(x: ScreenInfo.Width/2, y: center.y)
                    self.leftimg.isHidden = true
                    self.rightimg.isHidden = true
                }
            }
       
    }
}
    
    
    
}
