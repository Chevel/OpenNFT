//
//  UIColorValueTransformer 2.swift
//  LootBox
//
//  Created by Matej on 14. 12. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import UIKit

/// A value transformer which transforms `UIImage` instances into data using `NSSecureCoding`.
@objc(UIImageValueTransformer)
public final class UIImageValueTransformer: ValueTransformer {

    // MARK: -

    override public class func transformedValueClass() -> AnyClass {
        return UIImage.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    // MARK: -
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage else { return nil }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: image, requiringSecureCoding: true)
        } catch {
            assertionFailure("Failed to transform `UIImage` to `Data`")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIImage.self, from: data as Data)
        } catch {
            assertionFailure("Failed to transform `Data` to `UIImage`")
            return nil
        }
    }
}

extension UIImageValueTransformer {
    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: UIImageValueTransformer.self))

    /// Registers the value transformer with `ValueTransformer`.
    public static func register() {
        let transformer = UIImageValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
#elseif os(macOS)

import Foundation
import AppKit

/// A value transformer which transforms `UIImage` instances into data using `NSSecureCoding`.
@objc(NSImageValueTransformer)
public final class NSImageValueTransformer: ValueTransformer {

    // MARK: -

    override public class func transformedValueClass() -> AnyClass {
        return NSImage.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    // MARK: -
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? NSImage else { return nil }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: image, requiringSecureCoding: true)
        } catch {
            assertionFailure("Failed to transform `UIImage` to `Data`")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: NSImage.self, from: data as Data)
        } catch {
            assertionFailure("Failed to transform `Data` to `UIImage`")
            return nil
        }
    }
}

extension NSImageValueTransformer {
    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: NSImageValueTransformer.self))

    /// Registers the value transformer with `ValueTransformer`.
    public static func register() {
        let transformer = NSImageValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}

#endif
