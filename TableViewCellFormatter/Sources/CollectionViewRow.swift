//
//  CollectionViewRow.swift
//  rip-harambe-workout-tracker
//
//  Created by Chandler De Angelis on 8/16/17.
//  Copyright © 2017 Chandler De Angelis. All rights reserved.
//

import Foundation
import UIKit

public protocol CollectionViewRow where Cell: UICollectionViewCell {
    
    associatedtype Cell
    
    var indexPath: IndexPath { get }
    
    var cellReuseIdentifier: String { get }
    
    func configure(_ cell: Cell)
    func willDisplay(_ cell: Cell)
    func didEndDisplaying(_ cell: Cell)
}

extension CollectionViewRow {
    
    public func willDisplay(_ cell: Cell) {
        
    }
    
    public func didEndDisplaying(_ cell: Cell) {
        
    }
}

public struct AnyCollectionViewRow<CellType: UICollectionViewCell>: CollectionViewRow {
    
    private var _configure: (CellType) -> Void
    private var _indexPath: IndexPath
    private var _cellReuseIdentifier: String
    private var _willDisplay: (CellType) -> Void
    private var _didEndDisplaying: (CellType) -> Void
    
    public init<R: CollectionViewRow>(row: R) where R.Cell == CellType {
        self._configure = row.configure
        self._indexPath = row.indexPath
        self._cellReuseIdentifier = row.cellReuseIdentifier
        self._willDisplay = row.willDisplay
        self._didEndDisplaying = row.didEndDisplaying
    }
    
    public init(indexPath: IndexPath, configure: ((CellType) -> Void)?, willDisplay: ((CellType) -> Void)? = nil, didEndDisplaying: ((CellType) -> Void)? = nil) {
        self._indexPath = indexPath
        if let unwrappedConfigure: (CellType) -> Void = configure {
            self._configure = unwrappedConfigure
        } else {
            self._configure = { _ in }
        }
        if let unwrappedWillDisplay: (CellType) -> Void = willDisplay {
            self._willDisplay = unwrappedWillDisplay
        } else {
            self._willDisplay = { _ in }
        }
        if let unwrappedDidEndDisplaying: (CellType) -> Void = didEndDisplaying {
            self._didEndDisplaying = unwrappedDidEndDisplaying
        } else {
            self._didEndDisplaying = { _ in }
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
    
    public func willDisplay(_ cell: CellType) {
        return self._willDisplay(cell)
    }
    
    public func didEndDisplaying(_ cell: CellType) {
        return self._didEndDisplaying(cell)
    }
}
