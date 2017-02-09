//
//  FavoritesViewController.swift
//  swiftbar
//
//  Created by Andrew Weiss on 2/9/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController {
    
    var dataSource: FavoritesDataSource!
    
    init() {
        super.init(style: .grouped)
        dataSource = FavoritesDataSource()
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

enum Bork: Error {
    case Bork
}

class FavoritesDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    static let errors: Array = [
        ("Null Pointer", nullpointer),
        ("Thrown Error", thrown),
        ("Out of Bounds", outofbounds),
        ("Async", async),
        ("Log a message", logmsg)
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesDataSource.errors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "subtitleCell")
        let (title, _) = FavoritesDataSource.errors[indexPath.row]
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (_, function) = FavoritesDataSource.errors[indexPath.row]
        try! function(self)()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func nullpointer() {
        var x: String? = nil
        x!.append("Hello")
    }
    
    func thrown() throws {
        throw Bork.Bork
    }
    
    func outofbounds() {
        var a = [Int]()
        for i in 0...5 {
            if Double(arc4random()) / Double(UINT32_MAX) < 0.5 {
                a.append(i)
            }
        }
        print(a[6])
    }
    
    func async() {
        DispatchQueue.global().async {
            var x: String? = nil
            x!.append("Hello")
        }
    }

    func logmsg() {
        Rollbar.log(withLevel: "warning", message: "Hello friend")
    }
}




