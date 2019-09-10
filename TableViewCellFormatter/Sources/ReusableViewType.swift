//
//  ReusableViewType.swift
//
//  Created by Chandler De Angelis on 7/25/17.
//

import Foundation
import UIKit

protocol ReusableViewType {
    static var reuseIdentifier: String { get }
}

extension ReusableViewType where Self: NSObject {
    static var reuseIdentifier: String {
        let typeString: String = String(describing: self)
        if let decimalIndex: String.Index = typeString.firstIndex(of: ".") {
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

