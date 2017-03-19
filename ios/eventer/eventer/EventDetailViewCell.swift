//
//  EventDetailViewCell.swift
//  LitTix
//
//  Created by Eric Mikulin on 2017-03-19.
//  Copyright © 2017 Eric Mikulin. All rights reserved.
//

import UIKit

class EventDetailViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
