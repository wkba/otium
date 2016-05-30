//
//  CustomTableViewCell.swift
//  otium
//
//  Created by 若林俊輔 on 2016/05/30.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTitleLabel: UILabel!
    @IBOutlet weak var myDescriptionLabel: UILabel!

    func setCell(image:String, titleText: String, descriptionText: String) {
        fetchImage(image)
        myTitleLabel.text = titleText
        myDescriptionLabel.text = descriptionText
        
    }
    func fetchImage(target_url:String){
        if(target_url != "error"){
            let url = NSURL(string: target_url);
            let imgData: NSData
            do {
                imgData = try NSData(contentsOfURL:url!,options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let img = resizeProfileImage(UIImage(data:imgData)!)
                myImageView.layer.cornerRadius = 20;
                myImageView.clipsToBounds = true;
                myImageView.image = img
                
                //imgView.frame = CGRectMake(width/2 - 100, height/2 - 100, 200, 200)
                print("fetch and set image")
            } catch {
                print("Error: can't fetch and set image.")
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
    
}
