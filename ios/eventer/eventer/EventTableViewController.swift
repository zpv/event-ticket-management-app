//
//  EventTableViewController.swift
//  LitTix
//
//  Created by Eric Mikulin on 2017-03-18.
//  Copyright © 2017 Eric Mikulin. All rights reserved.
//

import Foundation
import UIKit

class EventTableViewController: UITableViewController {
    
    @IBOutlet weak var eventList: UITableView!
    
    var events = [Event]()
    
    private func loadSampleEvents() {
        let photo1 = UIImage(named: "kek")
        let photo2 = UIImage(named: "kek")
        let photo3 = UIImage(named: "kek")
        
        guard let event1 = Event(name: "NW Hacks After Party", photo: photo1, desc: "Lit Party") else {
            fatalError("Unable to instantiate event")
        }
        
        guard let event2 = Event(name: "After After Party", photo: photo2, desc: "Lit Party") else {
            fatalError("Unable to instantiate event")
        }
        
        guard let event3 = Event(name: "The Party", photo: photo3, desc: "Lit Party") else {
            fatalError("Unable to instantiate event")
        }
        
        events += [event1, event2, event3]
    }
    
    func tableView(_tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "EventTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EventTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let event = events[indexPath.row]
        
        cell.titleLabel.text = event.name
        cell.imageIconView.image = event.photo
        cell.descLabel.text = event.desc
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadSampleEvents()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
