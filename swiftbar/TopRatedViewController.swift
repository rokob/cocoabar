//
//  TopRatedViewController.swift
//  swiftbar
//
//  Created by Andrew Weiss on 2/9/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

import UIKit

class TopRatedViewController: UITableViewController {
    
    var dataSource: TopRatedDataSource!
    
    init() {
        super.init(style: .grouped)
        dataSource = TopRatedDataSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = dataSource
        self.tableView.dataSource = dataSource
    }
}

class TopRatedDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var data = [(String, String)]()
    var loadingData = false
    var loadingError: String?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count == 0 ? 1 : data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "subtitleCell")
        
        if data.count == 0 {
            let label = loadingError != nil ? loadingError : "Load Data"
            cell.textLabel?.text = label
            cell.detailTextLabel?.text = ""
            return cell
        }
        let (title, subtitle) = data[indexPath.row]
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if data.count == 0 && indexPath.row == 0 && !loadingData {
            self.loadingData = true
            self.loadingError = nil
            getJSONData(tableView)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getJSONData(_ tableView: UITableView) {
        let url = URL(string: "http://headers.jsontest.com")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String: String] {
                        var newData = [(String, String)]()
                        for (key,value) in json {
                            newData.append((key, value))
                        }
                        newData.sort(by: { return $0.0 < $1.0 })
                        self.data = newData
                        DispatchQueue.main.async {
                            self.loadingData = false
                            tableView.reloadData()
                        }
                    }
                } catch let parseError {
                    DispatchQueue.main.async {
                        self.loadingData = false
                        self.loadingError = parseError.localizedDescription
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.loadingData = false
                    self.loadingError = error.localizedDescription
                }
            }
        }
        
        task.resume()
    }
}




