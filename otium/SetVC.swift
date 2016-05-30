//
//  SetVC.swift
//  otium
//
//  Created by 若林俊輔 on 2016/05/24.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//
import UIKit
import Eureka
import Firebase


class SetVC: FormViewController {
    
    private let connectFirebase = ConnectFirebase()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        form +++ Section()
            <<< TextRow("Name"){
                $0.title = "名前を入力"
                $0.placeholder = "JohnLennonWars"
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
        form +++ Section()
            <<< TextRow("TextFiled"){
                $0.title = "目的"
                $0.placeholder = "歌を歌いたい"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    
}