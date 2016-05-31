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
    var myInfo:[String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMyInfo()
        print(myInfo)
    
        form +++ Section()
            <<< TextRow("Name"){
                $0.title = "名前を入力"
                $0.placeholder = myInfo[1]
                }.onChange{row in
                    self.saveName(row.value!)
        }
        
        form +++ Section()
            <<< TextRow("TextFiled"){
                $0.title = "目的"
                $0.placeholder = myInfo[2]
                }.onChange{row in
                    self.savePurpose(row.value!)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchMyInfo(){
        let myApp = UIApplication.sharedApplication().delegate as! AppDelegate
        self.myInfo = myApp.myInfo
    }
    func saveName(name:String){
        self.myInfo[1] = name
        let myApp = UIApplication.sharedApplication().delegate as! AppDelegate
        myApp.myInfo[1] = name
        self.connectFirebase.set_userName(name)
        print("savedName:\(myInfo)")
    }
    func savePurpose(purpose:String){
        self.myInfo[2] = purpose
        let myApp = UIApplication.sharedApplication().delegate as! AppDelegate
        myApp.myInfo[2] = purpose
        self.connectFirebase.set_purpose(purpose)
        print("savedPurpose:\(myInfo)")
    }
    
}