//
//  NSLayoutConstraint+Factory.swift
//  KeyboardFieldPrompt
//
//  Created by Andrew J Wagner on 9/1/19.
//

import UIKit

/// Create readable constraints and then activate them all at once
struct ConstraintFactory {
    var constraints: [NSLayoutConstraint] = []

    func activateAll() {
        self.constraints.forEach({ $0.isActive = true })
    }

    @discardableResult
    mutating func add(_ constraint: NSLayoutConstraint) -> NSLayoutConstraint {
        self.constraints.append(constraint)
        return constraint
    }

    /// Constrain for the same attribute of two different items
    @discardableResult
    mutating func constrain(_ attribute: NSLayoutConstraint.Attribute, ofBoth item1: Any, and item2: Any, by constant: CGFloat = 0, relatedBy: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return self.add(NSLayoutConstraint(item: item1, attribute: attribute, relatedBy: relatedBy, toItem: item2, attribute: attribute, multiplier: 1, constant: constant))
    }

    /// Create constraints for multiple attributes of two items at the same time
    @discardableResult
    mutating func constrain(_ attributes: [NSLayoutConstraint.Attribute], ofBoth item1: Any, and item2: Any, by constant: CGFloat = 0) -> [NSLayoutConstraint] {
        return attributes.map({ self.constrain($0, ofBoth: item1, and: item2, by: constant)})
    }

    /// Constrain an attribute to a constant
    @discardableResult
    mutating func constrain(_ attribute: NSLayoutConstraint.Attribute, of item: Any, to constant: CGFloat) -> NSLayoutConstraint {
        return self.add(NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant))
    }
}
