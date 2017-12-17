//
//  CollectionViewRow.swift
//  rip-harambe-workout-tracker
//
//  Created by Chandler De Angelis on 8/16/17.
//  Copyright © 2017 Chandler De Angelis. All rights reserved.
//

import Foundation
import UIKit

public protocol CollectionViewRow {
    
    associatedtype Cell
    
    var indexPath: IndexPath { get }
    
    var cellReuseIdentifier: String { get }
    
    func configure(_ cell: Cell)
}

public struct AnyCollectionViewRow<CellType: UICollectionViewCell>: CollectionViewRow {
    
    private var _configure: (CellType) -> Void
    private var _indexPath: IndexPath
    private var _cellReuseIdentifier: String
    
    public init<R: CollectionViewRow>(row: R) where R.Cell == CellType {
        self._configure = row.configure
        self._indexPath = row.indexPath
        self._cellReuseIdentifier = row.cellReuseIdentifier
    }
    
    public init(indexPath: IndexPath, configure: ((CellType) -> Void)?) {
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
