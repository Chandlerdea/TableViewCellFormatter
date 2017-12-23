//
//  CollectionViewSection.swift
//  rip-harambe-workout-tracker
//
//  Created by Chandler De Angelis on 8/16/17.
//  Copyright © 2017 Chandler De Angelis. All rights reserved.
//

import Foundation
import UIKit

public protocol CollectionViewSection {
    
    var rowCount: Int { get }
    
    func cell(for indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell
    
    
    func willDisplay(cell: UICollectionViewCell, at indexPath: IndexPath)
    
    func didEndDisplaying(cell: UICollectionViewCell, at indexPath: IndexPath)
}

extension CollectionViewSection {
    
    public func willDisplay(cell: UICollectionViewCell, at indexPath: IndexPath) {
        
    }
    
    public func didEndDisplaying(cell: UICollectionViewCell, at indexPath: IndexPath) {
        
    }
}
