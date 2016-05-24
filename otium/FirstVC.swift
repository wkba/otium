//
//  FirstVC.swift
//  otium
//
//  Created by 若林俊輔 on 2016/05/24.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

class FirstVC: UIViewController {
    
    var UserName:String!
    var UserImage:String!
    let client = TWTRAPIClient()
    private var json:NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Logged In",
                    message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                self.UserName = session!.userName
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                // ログイン成功したら遷移する
                self.getStatus(session!.userName)
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
            // make requests with client
        }
        
        // TODO: Change where the log in button is positioned in your view
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        setBackgroundColor()
     
        
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
    func getStatus(id:String) {
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/show.json"
        let params = ["screen_name": id]
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                print("json: \(json)")
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }

}