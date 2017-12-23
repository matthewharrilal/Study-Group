//
//  TableViewAbstraction.swift
//  Study-Groups
//
//  Created by Matthew Harrilal on 12/13/17.
//  Copyright © 2017 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit

typealias TableViewCellCallBack = (UITableView, IndexPath) -> UITableViewCell

class TableViewDataSource<Items>: NSObject, UITableViewDataSource {
    var items = [Items]()
    
    var configureCell: TableViewCellCallBack?
    
    init(items: [Items]) {
        self.items = items
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let configureCell = configureCell else {
            precondition(false, "Please configure a cell")
        }
        return configureCell(tableView, indexPath)
    }
}
