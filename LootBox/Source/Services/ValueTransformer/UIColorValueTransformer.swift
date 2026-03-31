//
//  UIColorValueTransformer.swift
//  LootBox
//
//  Created by Matej on 14. 12. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import UIKit

/// A value transformer which transforms `UIColor` instances into data using `NSSecureCoding`.
@objc(UIColorValueTransformer)
public final class UIColorValueTransformer: ValueTransformer {

    // MARK: -

    override public class func transformedValueClass() -> AnyClass {
        return UIColor.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    // MARK: -
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
        } catch {
            assertionFailure("Failed to transform `UIColor` to `Data`")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data as Data)
        } catch {
            assertionFailure("Failed to transform `Data` to `UIColor`")
            return nil
        }
    }
}

extension UIColorValueTransformer {
    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: UIColorValueTransformer.self))

    /// Registers the value transformer with `ValueTransformer`.
    public static func register() {
        let transformer = UIColorValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
#elseif os(macOS)

import AppKit
import SwiftUI

/// A value transformer which transforms `UIColor` instances into data using `NSSecureCoding`.
@objc(NSColorValueTransformer)
public final class NSColorValueTransformer: ValueTransformer {

    // MARK: -

    override public class func transformedValueClass() -> AnyClass {
        return NSColor.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    // MARK: -
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? NSColor else { return nil }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
        } catch {
            assertionFailure("Failed to transform `UIColor` to `Data`")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        
        do {
            guard let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data as Data) else {
                assertionFailure("Failed to transform `Data` to `UIColor`")
                return nil
            }
            return NSColor(cgColor: color.cgColor)
        } catch {
            assertionFailure("Failed to transform `Data` to `UIColor`")
            return nil
        }
    }
}

extension NSColorValueTransformer {
    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: NSColorValueTransformer.self))

    /// Registers the value transformer with `ValueTransformer`.
    public static func register() {
        let transformer = NSColorValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}

#endif
