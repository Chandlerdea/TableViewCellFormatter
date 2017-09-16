//
//  ReusableViewType.swift
//  rip-harambe-workout-tracker
//
//  Created by Chandler De Angelis on 7/25/17.
//  Copyright © 2017 Chandler De Angelis. All rights reserved.
//

import Foundation
import UIKit

public protocol ReusableViewType {
    static var reuseIdentifier: String { get }
}

extension ReusableViewType where Self: NSObject {
    static public var reuseIdentifier: String {
        let typeString: String = String(describing: self)
        if let decimalIndex: String.CharacterView.Index = typeString.characters.index(of: ".") {
            return typeString.substring(to: decimalIndex)
        } else {
            return typeString
        }
    }
}

extension UITableViewHeaderFooterView: ReusableViewType {}
extension UITableViewCell: ReusableViewType {}
extension UICollectionReusableView: ReusableViewType {}
extension UIViewController: ReusableViewType {}

