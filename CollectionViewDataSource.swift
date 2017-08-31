//
//  CollectionViewDataSource.swift
//  rip-harambe-workout-tracker
//
//  Created by Chandler De Angelis on 8/16/17.
//  Copyright © 2017 Chandler De Angelis. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewDataSource {
    
    var sectionCount: Int { get }
    
    func rowCount(for section: Int) -> Int
    
    func cell(for indexPath: IndexPath, in collectionView: UICollectionView) -> UICollectionViewCell
    
}
