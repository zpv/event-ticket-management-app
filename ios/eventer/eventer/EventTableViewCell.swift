//
//  EventTableViewCell.swift
//  LitTix
//
//  Created by Eric Mikulin on 2017-03-18.
//  Copyright © 2017 Eric Mikulin. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var descView: UILabel!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var previewIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
