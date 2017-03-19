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
    
    var events = [Event]()
    var strdata: Data?
    
    private func getRequest(){
        var request = URLRequest(url: URL(string: "https://ubc.design/get-events")!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            self.strdata = data
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    private func loadSampleEvents() {
        getRequest()
        sleep(1)
        var names = [String]()
        var imageUrls = [String]()
        
        do {
            if let data = strdata,
                let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                for item in json {
                    if let name = item["name"] as? String {
                        names.append(name)
                    }
                    if let iurl = item["image"] as? String {
                        imageUrls.append(iurl)
                    }
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        
        print(names)
        
        for ind in 0...(names.count-1) {
            // let tphotoName = imageUrls[ind]
            let tphotoName = "bop1"
            let tevent = Event(name: names[ind], photo: UIImage(named: tphotoName), desc: "lit AF")
            events.append(tevent!)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        cell.titleView.text = event.name
        cell.previewIcon.image = event.photo
        cell.descView.text = event.desc
        
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
