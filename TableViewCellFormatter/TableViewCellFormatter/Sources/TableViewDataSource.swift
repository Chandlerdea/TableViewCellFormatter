//
//  TableViewDataSource.swift
//  rip-harambe-workout-tracker
//
//  Created by Chandler De Angelis on 7/27/17.
//  Copyright © 2017 Chandler De Angelis. All rights reserved.
//

import Foundation
import UIKit

public protocol TableViewDataSource: class {
    
    var sections: [TableViewSection] { get }
    
    func registerCells(with tableView: UITableView)
}


