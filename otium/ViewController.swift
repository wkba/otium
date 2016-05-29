//
//  ViewController.swift
//  otium
//
//  Created by 若林俊輔 on 2016/04/17.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//

import UIKit
import CoreLocation
import Pulsator
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var noFriendLabel: UILabel!
    @IBOutlet weak var pulse: UIView!
    var receiveFirebase: Firebase!
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: Configuration.UUID())!, identifier: "Estimotes")
    let colors = [
        0: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        1: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        2: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1),
        3: UIColor(red: 209/255, green: 22/255, blue: 49/255, alpha: 1)
    ]
    let pulsator = Pulsator()
    let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
    
    private var pageControl: UIPageControl!
    private var scrollView: UIScrollView!
    private var newsLabel: UILabel!
   // private let major = Configuration.Major()
    //private let minor = Configuration.Minor()
    private let connectFirebase = ConnectFirebase()
    var distance = 0.00
    var fetched_beacon = [String]()
    var twitterId = "error"
    var twitterName = "error"
    var twitterImageUrl = "error"
    var purpose = "未設定。声をかけて教えてあげよう"
    var beacon_id = ""
    var imgView:UIButton!
    var myBeaconId = ""
    //UIViewController.viewの座標取得
    var x:CGFloat = 0.0
    var y:CGFloat = 0.0
    
    //UIViewController.viewの幅と高さを取得
    var width:CGFloat = 0.0
    var height:CGFloat = 0.0
    var current_page = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //UIViewController.viewの座標取得
        x = self.view.bounds.origin.x
        y = self.view.bounds.origin.y
        // ビューの縦、横のサイズを取得する.
        width = self.view.frame.maxX
        height = self.view.frame.maxY
        
        Peripheral.startAdvertising()

        setBackgroundColor()
        pulse.layer.superlayer?.insertSublayer(pulsator, below: pulse.layer)
        setupInitialValues()
        pulsator.start()
        //animetion()
        
        

        //MARK: central
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeaconsInRegion(region)
        
        
        
        
        

        let defaults = NSUserDefaults.standardUserDefaults()
        //前回の保存内容があるかどうかを判定
        var otium_major = ""
        var otium_minor = ""
        if((defaults.objectForKey("otium_major")) != nil){
            //objectsを配列として確定させ、前回の保存内容を格納
            otium_major = defaults.objectForKey("otium_major")! as! String
            print("Major:\(otium_major)")
        }else{
            print("error:Major")
        }
        //前回の保存内容があるかどうかを判定
        if((defaults.objectForKey("otium_minor")) != nil){
            //objectsを配列として確定させ、前回の保存内容を格納
            otium_minor = defaults.objectForKey("otium_minor")! as! String
            print("Major:\(otium_minor)")
        }else{
            print("error:Minor")
        }
        myBeaconId = otium_major + otium_minor
        
        
 
        // 背景の色をCyanに設定する.
        //self.view.backgroundColor = UIColor.cyanColor()
        // ScrollViewを取得する.
        scrollView = UIScrollView(frame: self.view.frame)
        // ページ数を定義する.
        let pageSize = 4
        // 縦方向と、横方向のインディケータを非表示にする.
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false
        // ページングを許可する.
        scrollView.pagingEnabled = true
        // ScrollViewのデリゲートを設定する.
        scrollView.delegate = self
        // スクロールの画面サイズを指定する.
        scrollView.contentSize = CGSizeMake(CGFloat(pageSize) * width, 0)
        // ScrollViewをViewに追加する.
        self.view.addSubview(scrollView)
        // ページ数分ボタンを生成する.
        for var i = 0; i < pageSize; i++ {
            // ページごとに異なるラベルを生成する.
            let myLabel:UILabel = UILabel(frame: CGRectMake(CGFloat(i) * width + width/2 - 40, height/2 - 40, 80, 80))
            myLabel.backgroundColor = UIColor.blackColor()
            myLabel.textColor = UIColor.whiteColor()
            myLabel.textAlignment = NSTextAlignment.Center
            myLabel.layer.masksToBounds = true
            myLabel.text = "Page\(i)"
            myLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
            myLabel.layer.cornerRadius = 40.0
            //scrollView.addSubview(myLabel)
            
            newsLabel = UILabel(frame: CGRectMake(CGFloat(i) * width + width/2 - 130, height - 50, 260, 30))
            newsLabel.textColor = UIColor.whiteColor()
            newsLabel.textAlignment = NSTextAlignment.Center
            newsLabel.text = ""
            newsLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
            //scrollView.addSubview(newsLabel)
        }
        
        // PageControlを作成する.
        pageControl = UIPageControl(frame: CGRectMake(0, self.view.frame.maxY - 100, width, 50))
        //pageControl.backgroundColor = UIColor.orangeColor()
        
        // PageControlするページ数を設定する.
        pageControl.numberOfPages = pageSize
        
        // 現在ページを設定する.
        pageControl.currentPage = 0
        pageControl.userInteractionEnabled = false
        
        self.view.addSubview(pageControl)
        //connectFirebase.receivedLike()
        self.receiveFirebase = Firebase(url:"https://otium.firebaseio.com/\(myBeaconId)/like_list")
        self.receiveFirebase.observeEventType(.ChildAdded, withBlock: { snapshot in
            if let targetId = snapshot.value.objectForKey("targetId") as? String {
                print("get いいね from \(targetId)")
            }else{
                print("error: ChildAdded")
            }
        })
        // 接続直後に呼び出されるイベントハンドラ
        self.receiveFirebase.observeEventType(.Value, withBlock: { snapshot in
            if let isNull = snapshot.value as? NSNull {
                return
            }
            if let targetId = snapshot.value.objectForKey("targetId") as? String {
                //print("observeEventType(.Value,")
            }else{
                //print("error: Value")
            }
        })
        
    }
 
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pulse.layer.layoutIfNeeded()
        pulsator.position = pulse.layer.position
    }
    
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
         // print(beacons)
            self.noFriendLabel.hidden = true
            //self.noFriendLabel.text = "友達発見！\(closestBeacon.major) : \(closestBeacon.minor):  \(closestBeacon.accuracy)"
            if(fabs(distance - closestBeacon.accuracy) > 0.15){
                FixPulsaor(closestBeacon.accuracy)
                print("MianVC: changed パルス")
            }
            distance = closestBeacon.accuracy
            beacon_id = "\(closestBeacon.major)\(closestBeacon.minor)"
            //print("start")
            if(twitterId != "error" && twitterName != "error" && twitterImageUrl != "error"){
                //print(fetched_beacon)
                if fetched_beacon.indexOf(twitterId) == nil{
                    print("unkownID")
                    fetched_beacon.append(twitterId)
                    setImage(twitterImageUrl, current_page: pageControl.currentPage, name:twitterName)
                }else{
                    //print("exsitingID")
                }
            }else{
                twitterId = connectFirebase.read_userID(beacon_id)
                twitterName = connectFirebase.read_userName(beacon_id)
                twitterImageUrl = connectFirebase.read_image(beacon_id)
                //print("could not get twitterInfo")
            }
            //var purpose = connectFirebase.read_purpose(id)
            //print(twitterId)
           // print(twitterName)
           // print(twitterImageUrl)
            //print(knownBeacons)

        }else{
            self.noFriendLabel.hidden = false
            self.noFriendLabel.text = "周りに誰もいません。"
        }
        //print(knownBeacons[0].minor)
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
    
    func animetion(){
        // CAReplicatorLayerを生成、追加
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = view.bounds
        view.layer.addSublayer(replicatorLayer)
        
        // sourceになるSublayerを生成、追加
        let circle = CALayer()
        circle.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        circle.position = view.center
        circle.position.x = 5
        circle.backgroundColor = UIColor.whiteColor().CGColor
        circle.cornerRadius = 5
        replicatorLayer.addSublayer(circle)
        
        replicatorLayer.instanceCount = 20
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(20, 0.0, 0.0)
        
        // 上下のアニメーション
        let animation = CABasicAnimation(keyPath: "position.y")
        //高さ
        animation.toValue = view.center.y + 20
        //速さ
        animation.duration = 1
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        circle.addAnimation(animation, forKey: "animation")
        
        replicatorLayer.instanceDelay = 0.1

    }
    
    private func setupInitialValues() {
        pulsator.numPulse = 1
        pulsator.radius = 240.0
        pulsator.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).CGColor
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        // スクロール数が1ページ分になったら時.
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            // ページの場所を切り替える.
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }
    
    func FixPulsaor(accuracy: CLLocationAccuracy){
        pulsator.radius = 240.0
        if(accuracy<1){
            pulsator.numPulse = 3
        }else if(accuracy<5){
            pulsator.numPulse = 2
        }else{
            pulsator.numPulse = 1
        }
        pulsator.start()
    }
    
    func setImage(target_url:String, current_page:Int, name:String){
        if(target_url != "error"){
            let url = NSURL(string: target_url);
            let imgData: NSData
            do {
                imgData = try NSData(contentsOfURL:url!,options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let img = resizeProfileImage(UIImage(data:imgData)!)
                imgView = UIButton(frame: CGRectMake(CGFloat(current_page) * width + width/2 - 100, height/2 - 100, 200, 200))
                imgView.layer.cornerRadius = 20;
                imgView.clipsToBounds = true;
                imgView.setImage(img, forState: .Normal)
                //タップした状態の色
                imgView.setTitleColor(UIColor.redColor(), forState: .Highlighted)
                
                imgView.addTarget(self, action: "tappedImage:", forControlEvents:.TouchUpInside)

                //imgView.frame = CGRectMake(width/2 - 100, height/2 - 100, 200, 200)
                scrollView.addSubview(imgView)
                
                print("set image")
            } catch {
                print("Error: can't create image.")
            }
        }
    }
    func resizeProfileImage(preImage:UIImage)->UIImage{
        let size = CGSize(width: 200, height: 200)
        UIGraphicsBeginImageContext(size)
        preImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage
    }
    
    func tappedImage(sender: UIButton) {
        //print("tappedImage")
        setAlert()
    }
    func setAlert(){
        //UIAlertView
        let alert:UIAlertController = UIAlertController(title:"\(twitterName)",
            message: "\(purpose)",
            preferredStyle: UIAlertControllerStyle.Alert)
        //Cancel 一つだけしか指定できない
        let cancelAction:UIAlertAction = UIAlertAction(title: "戻る",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                print("もどる")
        })
        
        //Default 複数指定可
        let defaultAction:UIAlertAction = UIAlertAction(title: "いいね！",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                print("いいね！")
                self.connectFirebase.set_like(self.beacon_id)
                //self.removeImage()
        })
        
        //Destructive 複数指定可
        let destructiveAction:UIAlertAction = UIAlertAction(title: "Blockする",
            style: UIAlertActionStyle.Destructive,
            handler:{
                (action:UIAlertAction!) -> Void in
                print("Blockする")
                self.connectFirebase.set_hate(self.beacon_id)
                //self.removeImage()
        })
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        alert.addAction(destructiveAction)
  
        //表示。UIAlertControllerはUIViewControllerを継承している。
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func removeImage(){
        imgView.hidden = true
    }
}