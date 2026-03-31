//
//  Binding+Optional.swift
//  LootBox
//
//  Created by Matej on 17/10/2022.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import SwiftUI

// https://stackoverflow.com/questions/68624001/how-to-use-published-optional-properties-correctly-for-swiftui
extension Binding {
    
    /// Converts a Binding<T?> into Binding<T>?
    /// - Returns: An optional binding with the object unwrapped. Returns nil if the object is nil
    func optionalBinding<T>() -> Binding<T>? where T? == Value {
        if let wrappedValue {
            return Binding<T>(
                get: { wrappedValue },
                set: { self.wrappedValue = $0 }
            )
        } else {
            return nil
        }
    }
    
    func unwrap<Wrapped>() -> Binding<Wrapped>? where Value == Wrapped? {
        guard let wrappedValue = self.wrappedValue else { return nil }
        
        return Binding<Wrapped>(
            get: { wrappedValue },
            set: { newValue in self.wrappedValue = newValue }
        )
    }
}
