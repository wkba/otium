//
//  SetVC.swift
//  otium
//
//  Created by 若林俊輔 on 2016/05/24.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//
import UIKit
import Eureka


class SetVC: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section()
            <<< TextRow("Name"){
                $0.title = "名前を入力"
                $0.placeholder = "ここに書いてね"
                }.onChange{row in
                    
                    let userDefault = NSUserDefaults.standardUserDefaults()
                    userDefault.setValue(row.value, forKey: "Name")
                    
            }
            <<< SegmentedRow<String>("sex"){
                $0.options = ["男", "女"]
                $0.title = "性別"
                $0.value = "男"
                }.onChange{ row in
                    let userDefault = NSUserDefaults.standardUserDefaults()
                    userDefault.setValue(row.value, forKey: "Sex")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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