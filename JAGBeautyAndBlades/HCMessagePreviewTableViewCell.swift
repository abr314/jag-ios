//
//  HCMessagePreviewTableViewCell.swift
//  JAGBeautyAndBlades
//
//  Created by Abraham Brovold on 2/8/16.
//  Copyright © 2016 Hill Country Angel Network. All rights reserved.
//

import UIKit

class HCMessagePreviewTableViewCell: UITableViewCell {

    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!

    @IBOutlet weak var messagePreviewTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
