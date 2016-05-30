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
    /// 画像・タイトル・説明文を設定するメソッド
//    func setCell(imageName: String, titleText: String, descriptionText: String) {
//        myImageView.image = UIImage(named: imageName)
//        myTitleLabel.text = titleText
//        myDescriptionLabel.text = descriptionText
//    }
    func setCell(image:String, titleText: String, descriptionText: String) {
        myImageView.image = UIImage(named: image)
        myTitleLabel.text = titleText
        myDescriptionLabel.text = descriptionText
    }

}
