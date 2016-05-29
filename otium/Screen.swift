//
//  Screen.swift
//  otium
//
//  Created by 若林俊輔 on 2016/04/21.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//

import Foundation

class Screen{

}

//
//  notification.swift
//  otium
//
//  Created by 若林俊輔 on 2016/05/29.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//

//

//import UIKit
//
//
//class NotificationVC: UIViewController {
//    
//    @IBOutlet weak var bellBtn: UIButton!
//    @IBOutlet weak var settingBtn: UIButton!
//    var imgView:UIButton!
//    let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setBackgroundColor()
//        
//        settingBtn.frame = CGRectMake(20, 40, 45, 45)
//        settingBtn.setImage(UIImage(named: "gear.png"), forState: .Normal)
//        settingBtn.imageView?.contentMode = .ScaleAspectFit
//        
//        
//        bellBtn.frame = CGRectMake(myBoundSize.width - 20 - 45, 40, 45, 45)
//        bellBtn.setImage(UIImage(named: "bell.png"), forState: .Normal)
//        bellBtn.imageView?.contentMode = .ScaleAspectFit
//        bellBtn.alpha = 0.6
//        self.view.addSubview(settingBtn)
//        self.view.addSubview(bellBtn)
//        
//    }
//    
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    // setBackgroundColor
//    func setBackgroundColor(){
//        //グラデーションの開始色
//        let topColor = UIColor(red:255/255, green:94/255, blue:3/94, alpha:1)
//        //グラデーションの開始色
//        let bottomColor = UIColor(red:255/255, green:42/255, blue:104/255, alpha:1)
//        //グラデーションの色を配列で管理
//        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
//        //グラデーションレイヤーを作成
//        let gradientLayer: CAGradientLayer = CAGradientLayer()
//        //グラデーションの色をレイヤーに割り当てる
//        gradientLayer.colors = gradientColors
//        //グラデーションレイヤーをスクリーンサイズにする
//        gradientLayer.frame = self.view.bounds
//        //グラデーションレイヤーをビューの一番下に配置
//        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
//    }
//    
//}
