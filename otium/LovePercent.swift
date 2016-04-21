//
//  LovePercent.swift
//  otium
//
//  Created by 若林俊輔 on 2016/04/22.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//

//相手のIDと自分のIDを受けっとて相性をIntで返す
import Foundation

  var targetID = 0
  var myID = 0

class LovePercent {
    init(target:Int, my:Int){
        targetID = target
        myID = my
    }
    func getPercent()->Int{
        //Demo Date
        //ここで計算をする。
        return 65
    }
}