//
//  UIView+Rotate.swift
//  LootBox
//
//  Created by Matej on 6. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import UIKit.UIImage

extension UIImage {
    
    func boundingBoxForRotatedRectangleWithOrigin(givenSize: CGSize, angle: CGFloat) -> CGRect {
        // Convert degrees to radians
        let radians = angle * .pi / 180
        
        // Calculate half-dimensions for easier rotation calculations
        let halfWidth = givenSize.width / 2
        let halfHeight = givenSize.height / 2
        
        // Calculate the four corners of the rectangle after rotation
        let points = [
            CGPoint(x: -halfWidth, y: -halfHeight),
            CGPoint(x: halfWidth, y: -halfHeight),
            CGPoint(x: halfWidth, y: halfHeight),
            CGPoint(x: -halfWidth, y: halfHeight)
        ]
        
        // Apply rotation to each point
        let rotatedPoints = points.map { point -> CGPoint in
            let x = point.x * cos(radians) - point.y * sin(radians)
            let y = point.x * sin(radians) + point.y * cos(radians)
            return CGPoint(x: x, y: y)
        }
        
        // Find the bounding box for the rotated points
        let minX = rotatedPoints.map { $0.x }.min() ?? 0
        let maxX = rotatedPoints.map { $0.x }.max() ?? 0
        let minY = rotatedPoints.map { $0.y }.min() ?? 0
        let maxY = rotatedPoints.map { $0.y }.max() ?? 0
        
        // Calculate new size and origin of the bounding box
        let newSize = CGSize(width: maxX - minX, height: maxY - minY)
        let newOrigin = CGPoint(x: minX, y: minY)

        return CGRect(origin: newOrigin, size: newSize)
    }

    
    func boundingBoxForRotatedRectangle(givenSize: CGSize, angle: CGFloat) -> CGSize {
        // Calculate the sine and cosine of the rotation angle
        let radians = angle * .pi / 180 // Convert degrees to radians if needed
        let cosAngle = abs(cos(radians))
        let sinAngle = abs(sin(radians))
        
        // Calculate the new width and height of the bounding box
        let newWidth = givenSize.width * cosAngle + givenSize.height * sinAngle
        let newHeight = givenSize.height * cosAngle + givenSize.width * sinAngle
        
        return CGSize(width: newWidth, height: newHeight)
    }

    func rotate(angle: Angle) -> UIImage? {
        let radians = angle.radians
        let newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
            
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
    
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
#elseif os(macOS)

import AppKit
import SwiftUI

extension NSImage {
    
    func boundingBoxForRotatedRectangleWithOrigin(givenSize: CGSize, angle: CGFloat) -> CGRect {
        // Convert degrees to radians
        let radians = angle * .pi / 180
        
        // Calculate half-dimensions for easier rotation calculations
        let halfWidth = givenSize.width / 2
        let halfHeight = givenSize.height / 2
        
        // Calculate the four corners of the rectangle after rotation
        let points = [
            CGPoint(x: -halfWidth, y: -halfHeight),
            CGPoint(x: halfWidth, y: -halfHeight),
            CGPoint(x: halfWidth, y: halfHeight),
            CGPoint(x: -halfWidth, y: halfHeight)
        ]
        
        // Apply rotation to each point
        let rotatedPoints = points.map { point -> CGPoint in
            let x = point.x * cos(radians) - point.y * sin(radians)
            let y = point.x * sin(radians) + point.y * cos(radians)
            return CGPoint(x: x, y: y)
        }
        
        // Find the bounding box for the rotated points
        let minX = rotatedPoints.map { $0.x }.min() ?? 0
        let maxX = rotatedPoints.map { $0.x }.max() ?? 0
        let minY = rotatedPoints.map { $0.y }.min() ?? 0
        let maxY = rotatedPoints.map { $0.y }.max() ?? 0
        
        // Calculate new size and origin of the bounding box
        let newSize = CGSize(width: maxX - minX, height: maxY - minY)
        let newOrigin = CGPoint(x: minX, y: minY)

        return CGRect(origin: newOrigin, size: newSize)
    }
    
    func boundingBoxForRotatedRectangle(givenSize: CGSize, angle: CGFloat) -> CGSize {
        // Calculate the sine and cosine of the rotation angle
        let radians = angle * .pi / 180 // Convert degrees to radians if needed
        let cosAngle = abs(cos(radians))
        let sinAngle = abs(sin(radians))
        
        // Calculate the new width and height of the bounding box
        let newWidth = givenSize.width * cosAngle + givenSize.height * sinAngle
        let newHeight = givenSize.height * cosAngle + givenSize.width * sinAngle
        
        return CGSize(width: newWidth, height: newHeight)
    }

    func rotate(angle: Angle) -> NSImage? {
         let radians = -angle.radians
         let newSize = CGRect(origin: .zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
             
         let newImage = NSImage(size: newSize)
         newImage.lockFocus()
         guard let context = NSGraphicsContext.current?.cgContext else { return nil }
         
         // Move origin to middle
         context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
         
        // Rotate around middle
         context.rotate(by: CGFloat(radians))
        
        // Draw the image at its center
         let drawRect = CGRect(
             x: -self.size.width / 2,
             y: -self.size.height / 2,
             width: self.size.width,
             height: self.size.height
         )
         self.draw(in: drawRect, from: .zero, operation: .sourceOver, fraction: 1.0)
         
         newImage.unlockFocus()
         return newImage
     }
}
#endif
