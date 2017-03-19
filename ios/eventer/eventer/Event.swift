//
//  Event.swift
//  LitTix
//
//  Created by Eric Mikulin on 2017-03-18.
//  Copyright © 2017 Eric Mikulin. All rights reserved.
//

import Foundation
import UIKit

class Event {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var desc: String
    
    init?(name: String, photo: UIImage?, desc: String) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.desc = desc
        
    }
    
}
