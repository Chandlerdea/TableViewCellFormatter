//
//  UIView+Helpers.swift
//  rip-harambe-workout-tracker
//
//  Created by Chandler De Angelis on 7/25/17.
//  Copyright © 2017 Chandler De Angelis. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutXAxisAnchor {
    
    public func constraint(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        return constraint
    }
    
    public func constraint(equalTo anchor: NSLayoutXAxisAnchor, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = self.constraint(equalTo: anchor)
        constraint.priority = priority
        return constraint
    }
}

extension NSLayoutYAxisAnchor {
    
    public func constraint(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        return constraint
    }
    
    public func constraint(equalTo anchor: NSLayoutYAxisAnchor, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = self.constraint(equalTo: anchor)
        constraint.priority = priority
        return constraint
    }
}

extension NSLayoutDimension {
    
    public func constraint(equalTo anchor: NSLayoutDimension, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        return constraint
    }
    
    public func constraint(equalTo anchor: NSLayoutDimension, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint = self.constraint(equalTo: anchor)
        constraint.priority = priority
        return constraint
    }
}

extension UIView {
    
    public static let separatorHeight: CGFloat = 0.5

    public class public func autolayoutView<T: UIView>() -> T {
        let result: T = T(frame: CGRect.zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }

    public func addSubviews(_ subviews: [UIView]) {
        subviews.forEach(self.addSubview(_:))
    }
    
    public func activateAllSideAnchors(relativeToMargins: Bool! = false, padding: UIEdgeInsets! = nil, priorities: UIEdgeInsets! = nil) {
        guard let superview = self.superview else {
            fatalError("Must have a superview")
        }
        
        let leftConstraint = relativeToMargins == true ? self.leftAnchor.constraint(equalTo: superview.layoutMarginsGuide.leftAnchor) : self.leftAnchor.constraint(equalTo: superview.leftAnchor)
        let rightConstraint = relativeToMargins == true ? self.rightAnchor.constraint(equalTo: superview.layoutMarginsGuide.rightAnchor) : self.rightAnchor.constraint(equalTo: superview.rightAnchor)
        let topConstraint = relativeToMargins == true ? self.topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor) : self.topAnchor.constraint(equalTo: superview.topAnchor)
        let bottomConstraint = relativeToMargins == true ? self.bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor) : self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        if let padding = padding {
            leftConstraint.constant = padding.left
            rightConstraint.constant = -padding.right
            topConstraint.constant = padding.top
            bottomConstraint.constant = -padding.bottom
        }
        if let priorities = priorities {
            leftConstraint.priority = UILayoutPriority(Float(priorities.left))
            rightConstraint.priority = UILayoutPriority(Float(priorities.right))
            topConstraint.priority = UILayoutPriority(Float(priorities.top))
            bottomConstraint.priority = UILayoutPriority(Float(priorities.bottom))
        }
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
    }
    
    @discardableResult public func addSeparator(inset: CGFloat, yOrigin: CGFloat? = nil, height: CGFloat? = nil, color: UIColor? = nil) -> CALayer {
        let finalOrigin: CGPoint
        let finalSize: CGSize
        
        if let unwrappedYOrigin: CGFloat = yOrigin, height == nil {
            finalOrigin = CGPoint(x: inset, y: unwrappedYOrigin)
            finalSize = CGSize(width: self.bounds.width - inset, height: UIView.separatorHeight)
        } else if let unwrappedHeight: CGFloat = height, yOrigin == nil {
            finalOrigin = CGPoint(x: inset, y: self.bounds.height - unwrappedHeight)
            finalSize = CGSize(width: self.bounds.width - inset, height: unwrappedHeight)
        } else if let unwrappedYOrigin: CGFloat = yOrigin, let unwrappedHeight: CGFloat = height {
            finalOrigin = CGPoint(x: inset, y: unwrappedYOrigin)
            finalSize = CGSize(width: self.bounds.width - inset, height: unwrappedHeight)
        } else {
            finalOrigin = CGPoint(x: inset, y: self.bounds.height - UIView.separatorHeight)
            finalSize = CGSize(width: self.bounds.width - inset, height: UIView.separatorHeight)
        }
        
        let separator: CALayer = CALayer()
        if let color: UIColor = color {
            separator.backgroundColor = color.cgColor
        } else {
            separator.backgroundColor = UIColor.groupTableViewBackground.cgColor
        }
        
        separator.frame = CGRect(origin: finalOrigin, size: finalSize)
        self.layer.addSublayer(separator)
        return separator
    }
    
    /**
     Resigns the first responder of a view withing the heirarchy of a given view
     - returns:              The view that was the first responder
     */
    @discardableResult public func resignSubviewFirstResponder() -> UIView? {
        /**
         Resigns the first responder and stops if resigned
         - parameter view:           The view to check as first responder
         - parameter shouldStop:     The flag to determine if this view is the first responder
         - returns:                  Whether we want to recurse into the subview
         */
        func resignFirstResponderAndStop(_ view: UIView, _ shouldStop: inout Bool) -> Bool {
            guard view.isFirstResponder else {
                return true
            }
            view.resignFirstResponder()
            shouldStop = true
            return false
        }
        
        for view in self.subviews {
            var newStop: Bool = false
            if resignFirstResponderAndStop(view, &newStop) {
                return view.resignSubviewFirstResponder()
            } else if newStop {
                return view
            }
        }
        return .none
    }
}

extension UILayoutPriority {
    
    public static var almostRequired: UILayoutPriority {
        return self.init(999)
    }
}

