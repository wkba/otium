//
//  connectFirebase.swift
//  otium
//
//  Created by 若林俊輔 on 2016/04/22.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class ConnectFirebase{

    private var userURL = Firebase(url:"https://otium.firebaseio.com")
    private var targetURL = Firebase(url:"https://otium.firebaseio.com")
    var target_major = "error"
    var major = "error"
    var minor = "error"
    var name = "error"
    var screenName = "error"

    var id = "error"
    var imageUrl = "error"
    var outCount = "error"
    var comment = "error"
    var purpose = "error"
    var otium_major = ""
    var otium_minor = ""
    var myId = ""
    var likeUser = "error"



    init(){
        let defaults = NSUserDefaults.standardUserDefaults()
        //前回の保存内容があるかどうかを判定
        if((defaults.objectForKey("otium_major")) != nil){
            //objectsを配列として確定させ、前回の保存内容を格納
            otium_major = defaults.objectForKey("otium_major")! as! String
        }else{
        }
        if((defaults.objectForKey("otium_minor")) != nil){
            otium_minor = defaults.objectForKey("otium_minor") as!  String
        }else{
        }
        self.myId = otium_major + otium_minor
        userURL = Firebase(url:"https://otium.firebaseio.com/\(myId)")
        print(userURL)
    }
    
    func save(words:String){
        
    }
    
    func inital_set(id:String){
        userURL = Firebase(url:"https://otium.firebaseio.com/\(id)")
        // Write data to Firebase
    }
    
    func set_major(major:String){
        userURL.childByAppendingPath("major").setValue(major)
    }
    func set_minor(minor:String){
        userURL.childByAppendingPath("minor").setValue(minor)
    }
    func set_userID(id:String){
        userURL.childByAppendingPath("userID").setValue(id)
    }
    func set_userName(name:String){
        userURL.childByAppendingPath("userName").setValue(name)
    }
    func set_twitterName(name:String){
        userURL.childByAppendingPath("twitterName").setValue(name)
    }
    func set_image(image_url:String){
        userURL.childByAppendingPath("image").setValue(image_url)
    }
    func set_out_count(){
        userURL.childByAppendingPath("out").setValue("out")
    }
    func set_comment(comment:String){
        userURL.childByAppendingPath("comment").setValue(comment)
    }
    func set_purpose(purpose:String){
        userURL.childByAppendingPath("purpose").setValue(purpose)
    }
    func set_like(targetId:String){
        targetURL.childByAppendingPath(targetId).childByAppendingPath("like_list").childByAutoId().childByAppendingPath("targetId").setValue(myId)
    }
    func set_hate(targetId:String){
        targetURL.childByAppendingPath(targetId).childByAppendingPath("hate_list").childByAutoId().childByAppendingPath("targetId").setValue(myId)
    }
    
    func read_major(id:String) -> String{
        
        targetURL.childByAppendingPath(id).childByAppendingPath("major").observeEventType(.Value, withBlock: {
            snapshot in
            self.target_major = "\(snapshot.value)"
        })
        return target_major
    }
    func read_minor(id:String){
        userURL.childByAppendingPath("minor").setValue(minor)
    }
    func read_userID(target_id:String) -> String{
        targetURL.childByAppendingPath(target_id).childByAppendingPath("userID").observeEventType(.Value, withBlock: {
            snapshot in
            self.id = "\(snapshot.value)"
        })
        return id
    }
    func read_userName(id:String) -> String{
        targetURL.childByAppendingPath(id).childByAppendingPath("userName").observeEventType(.Value, withBlock: {
            snapshot in
            self.name = "\(snapshot.value)"
        })
        return name
    }
    func read_screenName(id:String) -> String{
        targetURL.childByAppendingPath(id).childByAppendingPath("twitterName").observeEventType(.Value, withBlock: {
            snapshot in
            self.screenName = "\(snapshot.value)"
        })
        return screenName
    }
    func read_image(id:String) -> String{
        targetURL.childByAppendingPath(id).childByAppendingPath("image").observeEventType(.Value, withBlock: {
            snapshot in
            self.imageUrl = "\(snapshot.value)"
        })
        return imageUrl
    }
    func read_out_count(){
        //ToDo:若林
        userURL.childByAppendingPath("out").setValue("out")
    }
    func read_comment(id:String)->String{
        targetURL.childByAppendingPath(id).childByAppendingPath("comment").observeEventType(.Value, withBlock: {
            snapshot in
            self.comment = "\(snapshot.value)"
        })
        return comment
    }
    func read_purpose(id:String)->String{
        targetURL.childByAppendingPath(id).childByAppendingPath("purpose").observeEventType(.Value, withBlock: {
            snapshot in
            self.purpose = "\(snapshot.value)"
        })
        return purpose
    }
    
    
    func receivedLike(){
        // Child追加時のイベントハンドラ
        userURL.childByAppendingPath("like_list").observeEventType(.ChildAdded, withBlock: { snapshot in
            if let _ = snapshot.value.objectForKey("targetId") as? String {
                print("observeEventType(.ChildAdded")
            }
        })
        // 接続直後に呼び出されるイベントハンドラ
        userURL.childByAppendingPath("like_list").observeEventType(.Value, withBlock: { snapshot in
            if let _ = snapshot.value as? NSNull {
                return
            }
            
            if let _ = snapshot.value.objectForKey("targetId") as? String {
                print("observeEventType(.Value,")
            }
        })
    }
    func returnUserURL()->String{
        return String(userURL)
    }
    
    func like_list_array(id:String)->[String]{
        var ids:[String] = []
        targetURL.childByAppendingPath(id).childByAppendingPath("like_list").observeEventType(.Value, withBlock: {
            snapshot in
            ids.append("\(snapshot.value)")
        })
        return ids
    }
    
}