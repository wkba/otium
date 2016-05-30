//
//  notification.swift
//  otium
//
//  Created by 若林俊輔 on 2016/05/29.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//

//

import UIKit
import SafariServices
import Firebase


class NotificationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    ///
    var imageUrl = ["q.jpg", "w.jpg", "w.jpg", "q.jpg"]
    
    /// 名前
    var imageTitles = ["1", "2", "3", "4"]
    
    /// 説明
    var imageDescriptions = [
        "test1",
        "test2",
        "test3",
        "test4"
    ]
    private let connectFirebase = ConnectFirebase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // 編集中のセル選択を許可.
        tableView.allowsSelectionDuringEditing = true
        // TableViewを再読み込み.
        imageUrl = []
        
        /// 名前
        imageTitles = []
        
        /// 説明
        imageDescriptions = [
        ]

        
        var likeUserId = "non"
        
        //ToDo ワカバヤシ　遅延評価
        var userURL = connectFirebase.returnUserURL()
        Firebase(url: userURL).childByAppendingPath("like_list").observeEventType(.ChildAdded, withBlock: { snapshot in
            if let name = snapshot.value.objectForKey("targetId") as? String {
                print( "now" )
                let delay = 0.1 * Double(NSEC_PER_SEC)
                var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    print( "0.1s後" )
                    likeUserId = "\(name)"
                    print(likeUserId)
                    self.imageUrl.append("https://pbs.twimg.com/profile_images/721704165613830145/FZxf-yyF_400x400.jpg")
                    self.imageTitles.append("わかばやし～")
                    self.imageDescriptions.append("数学を教えてください。")
                    self.tableView.reloadData()
                })
            }else{
                print("error!!!!!")
            }
        })        
        setBackgroundColor()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("select cell #\(indexPath.row)")
        // URLを指定
        let _url:NSURL = NSURL(string:"https://twitter.com/wakabbbaa/")!
        let _brow = SFSafariViewController(URL: _url, entersReaderIfAvailable: true)
        presentViewController(_brow, animated: true, completion: nil)
    }

    /// セルの個数を指定するデリゲートメソッド（必須）
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageUrl.count
    }
    
    //セルの削除許可を設定
    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    /*
    Cellを挿入または削除しようとした際に呼び出される
    */
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // 削除のとき.
        if editingStyle == UITableViewCellEditingStyle.Delete {
            print("削除")
            
            // 指定されたセルのオブジェクトをmyItemsから削除する.
            imageUrl.removeAtIndex(indexPath.row)
            imageTitles.removeAtIndex(indexPath.row)
            imageDescriptions.removeAtIndex(indexPath.row)
            
            // TableViewを再読み込み.
            tableView.reloadData()
        }
    }
    
    /// セルに値を設定するデータソースメソッド（必須）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルを取得
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell") as! CustomTableViewCell
        cell.backgroundColor = UIColor.clearColor()

        // セルに値を設定
        cell.setCell(imageUrl[indexPath.row] , titleText: imageTitles[indexPath.row], descriptionText: imageDescriptions[indexPath.row])
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // setBackgroundColor
    func setBackgroundColor(){
        //グラデーションの開始色
        let topColor = UIColor(red:255/255, green:94/255, blue:3/94, alpha:1)
        //グラデーションの開始色
        let bottomColor = UIColor(red:255/255, green:42/255, blue:104/255, alpha:1)
        //グラデーションの色を配列で管理
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        //グラデーションレイヤーを作成
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        //グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = gradientColors
        //グラデーションレイヤーをスクリーンサイズにする
        gradientLayer.frame = self.view.bounds
        //グラデーションレイヤーをビューの一番下に配置
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    

}

