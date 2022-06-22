//
//  resultsCell.swift
//  ChatApp
//
//  Created by Valsamis Elmaliotis on 11/5/14.
//  Copyright (c) 2014 Valsamis Elmaliotis. All rights reserved.
//

import UIKit

class resultsCell: UITableViewCell {

    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let theWidth = UIScreen.main.bounds.width
        
        contentView.frame = CGRect(x: 0, y: 0, width: theWidth, height: 120)
        
        profileImg.center = CGPoint(x: 60, y: 60)
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        profileNameLbl.center = CGPoint(x:230,y: 55)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
