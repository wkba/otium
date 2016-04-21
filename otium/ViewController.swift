//
//  ViewController.swift
//  otium
//
//  Created by 若林俊輔 on 2016/04/17.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var pulse: UIView!
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: Configuration.UUID())!, identifier: "Estimotes")
    let colors = [
        0: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        1: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        2: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1),
        3: UIColor(red: 209/255, green: 22/255, blue: 49/255, alpha: 1)
    ]
    let pulsator = Pulsator()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pulse.layer.superlayer?.insertSublayer(pulsator, below: pulse.layer)
        setupInitialValues()
        pulsator.start()
        
        setBackgroundColor()
        //animetion()

        
        //MARK: central
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeaconsInRegion(region)
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
            self.view.backgroundColor = self.colors[closestBeacon.minor.integerValue % 3]
            print(closestBeacon.accuracy)
            print(beacons)
            
        }
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
        pulsator.numPulse = 3
        pulsator.radius = 240.0
        pulsator.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).CGColor
    }


}

