//
//  UIColorValueTransformer 2.swift
//  LootBox
//
//  Created by Matej on 14. 12. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import UIKit

/// A value transformer which transforms `CGRect` instances into data using `NSSecureCoding`.
@objc(CGRectValueTransformer)
public final class CGRectValueTransformer: ValueTransformer {

    // MARK: - ValueTransformer

    override public class func transformedValueClass() -> AnyClass {
        return NSValue.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let rect = value as? CGRect else { return nil }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: NSValue(cgRect: rect), requiringSecureCoding: true)
        } catch {
            assertionFailure("Failed to transform `CGRect` to `Data`")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        
        do {
            guard let rect = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSValue.self, from: data as Data)?.cgRectValue else {
                return nil
            }
            return rect
        } catch {
            assertionFailure("Failed to transform `Data` to `CGRect`")
            return nil
        }
    }
}

extension CGRectValueTransformer {
    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: CGRectValueTransformer.self))

    /// Registers the value transformer with `ValueTransformer`.
    public static func register() {
        let transformer = CGRectValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
#elseif os(macOS)
import Foundation

/// A value transformer which transforms `CGRect` instances into data using `NSSecureCoding`.
@objc(CGRectValueTransformer)
public final class CGRectValueTransformer: ValueTransformer {

    // MARK: - ValueTransformer

    override public class func transformedValueClass() -> AnyClass {
        return NSValue.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let rect = value as? CGRect else { return nil }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: NSValue(rect: rect), requiringSecureCoding: true)
        } catch {
            assertionFailure("Failed to transform `CGRect` to `Data`")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        
        do {
            guard let rect = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSValue.self, from: data as Data)?.rectValue else {
                return nil
            }
            return rect
        } catch {
            assertionFailure("Failed to transform `Data` to `CGRect`")
            return nil
        }
    }
}

extension CGRectValueTransformer {
    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: CGRectValueTransformer.self))

    /// Registers the value transformer with `ValueTransformer`.
    public static func register() {
        let transformer = CGRectValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
#endif
