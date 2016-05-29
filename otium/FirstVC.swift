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
import CoreLocation
import SwiftyJSON


class FirstVC: UIViewController {
    
    var UserName:String!
    var UserImage:String!
    let client = TWTRAPIClient()
    private var json:NSDictionary!
    private let connectFirebase = ConnectFirebase()
    @IBOutlet weak var skip_btn: UIButton!
    @IBAction func skip_btn(sender: AnyObject) {
        //remove here
        setUserInfo()
        connectFirebase.save("userID")
        goMainVC()
    }
    
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
            self.setUserInfo()
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
        let statusesShowEndpoint = "https://api.twitter.com/1.1/users/show.json"
        let params = ["id": id]
        var clientError : NSError?
        
        let request = client.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError)")
            }
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                //print("json: \(json)")
                let fixed_json = JSON(json)
                //print(fixed_json)
                self.connectFirebase.set_userID(fixed_json["id_str"].string!)
                self.connectFirebase.set_userName(fixed_json["name"].string!)
                self.connectFirebase.set_image(fixed_json["profile_image_url"].string!)
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
    
    func goMainVC(){
        let MainViewController: UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("MainVC") as! UINavigationController
        // アニメーションを設定する.
        //secondViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        // 値渡ししたい時 hoge -> piyo
        //secondViewController.piyo = self.hoge
        // Viewの移動する.
        self.presentViewController(MainViewController, animated: true, completion: nil)
    }
    
    func setUserInfo(){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var otium_major = ""
        var otium_minor = ""
        
        //前回の保存内容があるかどうかを判定
        if((defaults.objectForKey("otium_major")) != nil){
            //objectsを配列として確定させ、前回の保存内容を格納
            otium_major = defaults.objectForKey("otium_major")! as! String
            print("FirstVC:Major:\(otium_major)")
        }else{
            print("FirstVC:nil:Major")
            otium_major = String(CLBeaconMajorValue(arc4random() % 100))
            defaults.setObject(otium_major, forKey:"otium_major")
            defaults.synchronize()
        }
        if((defaults.objectForKey("otium_minor")) != nil){
            otium_minor = defaults.objectForKey("otium_minor") as!  String
            print("FirstVC:Minorr:\(otium_minor)")
        }else{
            print("FirstVC:nil:Minor")
            otium_minor = String(CLBeaconMinorValue(arc4random() % 100))
            defaults.setObject(otium_minor, forKey:"otium_minor")
            defaults.synchronize()
        }
        connectFirebase.inital_set(otium_major+otium_minor)
        connectFirebase.set_major(otium_major)
        connectFirebase.set_minor(otium_minor)
    }
    
}