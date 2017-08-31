//
//  TableViewRow.swift
//  rip-harambe-workout-tracker
//
//  Created by Chandler De Angelis on 7/27/17.
//  Copyright © 2017 Chandler De Angelis. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewRow {
    
    associatedtype Cell
    
    var indexPath: IndexPath { get }
    
    var cellReuseIdentifier: String { get }
    
    func configure(_ cell: Cell)
}

struct AnyTableViewRow<CellType: UITableViewCell>: TableViewRow {
    
    private var _configure: (CellType) -> Void
    private var _indexPath: IndexPath
    private var _cellReuseIdentifier: String
    
    init<R: TableViewRow>(row: R) where R.Cell == CellType {
        self._configure = row.configure
        self._indexPath = row.indexPath
        self._cellReuseIdentifier = row.cellReuseIdentifier
    }
    
    init(indexPath: IndexPath, configure: @escaping (CellType) -> Void) {
        self._indexPath = indexPath
        self._configure = configure
        self._cellReuseIdentifier = CellType.reuseIdentifier
    }
    
    // MARK: TableViewRow
    
    var indexPath: IndexPath {
        return self._indexPath
    }
    
    var cellReuseIdentifier: String {
        return self._cellReuseIdentifier
    }
    
    func configure(_ cell: CellType) {
        self._configure(cell)
    }
}

