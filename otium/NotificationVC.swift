//
//  notification.swift
//  otium
//
//  Created by 若林俊輔 on 2016/05/29.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//

//

import UIKit


class NotificationVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // セルに表示するテキスト
    let items = []
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(CustomTableViewCell.self, forCellReuseIdentifier: "customCell")
 
        setBackgroundColor()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! CustomTableViewCell
        
        cell.titleLabel.text = self.items[indexPath.row] as! String
        cell.contentLabel.text = "test date";
        cell.backgroundColor = UIColor.clearColor()
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("select cell #\(indexPath.row)")
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

