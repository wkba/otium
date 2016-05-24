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
//            if let unwrappedSession = session {
//                let alert = UIAlertController(title: "Logged In",
//                    message: "User \(unwrappedSession.userName) has logged in",
//                    preferredStyle: UIAlertControllerStyle.Alert
//                )
//                self.UserName = session!.userName
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
//                self.getStatus(session!.userID)
//                
//            } else {
//                NSLog("Login error: %@", error!.localizedDescription);
//            }
            self.UserName = session!.userName
            self.getStatus(session!.userID)
            self.goMainVC()
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
        let topColor = UIColor(red:255/255, green:94/255, blue:3/94, alpha:1)
        let bottomColor = UIColor(red:255/255, green:42/255, blue:104/255, alpha:1)
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    
    func getStatus(id:String) {
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/show.json"
        let params = ["id": id]
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
    
    func goMainVC(){
        let MainViewController: ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainVC") as! ViewController
        // アニメーションを設定する.
        //secondViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        // 値渡ししたい時 hoge -> piyo
        //secondViewController.piyo = self.hoge
        // Viewの移動する.
        self.presentViewController(MainViewController, animated: true, completion: nil)
    }

}