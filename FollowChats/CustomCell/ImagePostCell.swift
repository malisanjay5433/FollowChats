//
//  CellTableViewCell.swift
//  HappayAssignment
//
//  Created by Sanjay Mali on 16/12/17.
//  Copyright © 2017 Sanjay Mali. All rights reserved.
//

import UIKit

class ImagePostCell: UITableViewCell {
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var imageHiehgtConstraint: NSLayoutConstraint!
    @IBOutlet weak var discrptionLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImageView: RoundImageView!
    @IBOutlet weak var vframe:VideoPlayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//            self.vframe = nil
        
    }
}
