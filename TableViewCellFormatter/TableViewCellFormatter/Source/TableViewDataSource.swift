//
//  TableViewDataSource.swift
//  rip-harambe-workout-tracker
//
//  Created by Chandler De Angelis on 7/27/17.
//  Copyright © 2017 Chandler De Angelis. All rights reserved.
//

import Foundation
import UIKit

public protocol TableViewDataSource {
    
    var sectionCount: Int { get }
    
    func rowCount(for section: Int) -> Int
    
    func cell(for indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell
    
}
