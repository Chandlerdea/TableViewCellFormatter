//
//  TableViewRow.swift
//  rip-harambe-workout-tracker
//
//  Created by Chandler De Angelis on 7/27/17.
//  Copyright © 2017 Chandler De Angelis. All rights reserved.
//

import Foundation
import UIKit

public protocol TableViewRow {
    
    associatedtype Cell
    
    var indexPath: IndexPath { get }
    
    var cellReuseIdentifier: String { get }
    
    func configure(_ cell: Cell)
    
    func registerCell(with tableView: UITableView)
}

extension TableViewRow {
    
    public func registerCell(with tableView: UITableView) {
        tableView.register(Cell.self as? AnyClass, forCellReuseIdentifier: self.cellReuseIdentifier)
    }
}

public struct AnyTableViewRow<CellType: UITableViewCell>: TableViewRow {
    
    private var _configure: (CellType) -> Void
    private var _indexPath: IndexPath
    private var _cellReuseIdentifier: String
    
    public init<R: TableViewRow>(row: R) where R.Cell == CellType {
        self._configure = row.configure
        self._indexPath = row.indexPath
        self._cellReuseIdentifier = row.cellReuseIdentifier
    }
    
    public init(indexPath: IndexPath, configure: ((CellType) -> Void)? = nil) {
        self._indexPath = indexPath
        if let unwrappedConfigure: (CellType) -> Void = configure {
            self._configure = unwrappedConfigure
        } else {
            self._configure = { _ in }
        }
        self._cellReuseIdentifier = CellType.reuseIdentifier
    }
    
    // MARK: TableViewRow
    
    public var indexPath: IndexPath {
        return self._indexPath
    }
    
    public var cellReuseIdentifier: String {
        return self._cellReuseIdentifier
    }
    
    public func configure(_ cell: CellType) {
        self._configure(cell)
    }
}

