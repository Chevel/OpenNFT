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
@objc(CGPointValueTransformer)
public final class CGPointValueTransformer: ValueTransformer {

    // MARK: -

    override public class func transformedValueClass() -> AnyClass {
        return NSValue.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    // MARK: -
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let point = value as? CGPoint else { return nil }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: NSValue(cgPoint: point), requiringSecureCoding: true)
        } catch {
            assertionFailure("Failed to transform `CGRect` to `Data`")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData, !data.isEmpty else { return nil }
        
        do {
            guard let point = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSValue.self, from: data as Data)?.cgPointValue else {
                return nil
            }
            return point
        } catch {
            assertionFailure("Failed to transform `Data` to `CGRect`")
            return nil
        }
    }
}

extension CGPointValueTransformer {
    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: CGPointValueTransformer.self))

    /// Registers the value transformer with `ValueTransformer`.
    public static func register() {
        let transformer = CGPointValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
#elseif os(macOS)

import Foundation

@objc(CGPointValueTransformer)
public final class CGPointValueTransformer: ValueTransformer {

    // MARK: -

    override public class func transformedValueClass() -> AnyClass {
        return NSValue.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    // MARK: -
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let point = value as? CGPoint else { return nil }
        
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: NSValue(point: point), requiringSecureCoding: true)
        } catch {
            assertionFailure("Failed to transform `CGRect` to `Data`")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData, !data.isEmpty else { return nil }
        
        do {
            guard let point = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSValue.self, from: data as Data)?.pointValue else {
                return nil
            }
            return point
        } catch {
            assertionFailure("Failed to transform `Data` to `CGRect`")
            return nil
        }
    }
}

extension CGPointValueTransformer {
    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: CGPointValueTransformer.self))

    /// Registers the value transformer with `ValueTransformer`.
    public static func register() {
        let transformer = CGPointValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}

#endif
