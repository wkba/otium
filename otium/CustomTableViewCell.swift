//
//  CustomTableViewCell.swift
//  otium
//
//  Created by 若林俊輔 on 2016/05/30.
//  Copyright © 2016年 p6iwi6q. All rights reserved.
//
import UIKit


class CustomTableViewCell: UITableViewCell
{
    var titleLabel = UILabel();
    var contentLabel = UILabel();
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        //First Call Super
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel(frame: CGRectMake(10, 2, 300, 15));
        titleLabel.text = "";
        titleLabel.font = UIFont.systemFontOfSize(12)
        self.addSubview(titleLabel);
        
        contentLabel = UILabel(frame: CGRectMake(10, 20, 300, 15));
        contentLabel.text = "";
        contentLabel.font = UIFont.systemFontOfSize(22)
        self.addSubview(contentLabel);
        
        
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
}
