//
//  connectFirebase.swift
//  otium
//
//  Created by 若林俊輔 on 2016/04/22.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//

import Foundation
import Firebase

class ConnectFirebase{

    private var userURL = Firebase(url:"https://otium.firebaseio.com")

    init(){

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
    
}