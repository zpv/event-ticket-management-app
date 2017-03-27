//
//  EventDetailViewController.swift
//  LitTix
//
//  Created by Eric Mikulin on 2017-03-19.
//  Copyright © 2017 Eric Mikulin. All rights reserved.
//

import Foundation
import UIKit

class EventDetailViewController: UITableViewController {
    
    var people: [[String]] = Array(repeating: Array(repeating: "-", count: 2), count: 100)
    var strdata: Data?
    
    private func getRequest(){
        var request = URLRequest(url: URL(string: "https://ubc.design/get-tickets")!)
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
        people.removeAll()
        getRequest()
        sleep(1)
        var names = [String]()
        var statuses = [String]()
        
        do {
            if let data = strdata,
                let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                for item in json {
                    if let name = item["name"] as? String{
                        names.append(name)
                    }
                    if let status = item["used"] as? Bool{
                        if status{
                            statuses.append("true")

                        } else { statuses.append("false") }
                    }
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        
        print(names)
        print(statuses)
        
        for ind in 0...(names.count-1) {
            let out = [names[ind], statuses[ind]]
            people.append(out)
        }
        
        people = people.filter() { $0[0] != "-" }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "EventDetailViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventDetailViewCell  else {
            fatalError("The dequeued cell is not an instance of EventTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let person = people[indexPath.row]
        
        cell.nameLabel.text = person[0]
        if person[1] == "false" {
            cell.nameLabel.textColor = UIColor(red:1.00, green:0.00, blue:0.00, alpha:1.0)
        } else {
            cell.nameLabel.textColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0)
        }
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        loadSampleEvents()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
         loadSampleEvents()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
