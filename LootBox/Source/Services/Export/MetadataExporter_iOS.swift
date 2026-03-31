//
//  ArchiveOutputStream.swift
//  LootBox
//
//  Created by Matej on 30. 11. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import UIKit
import SwiftUI
import ZIPFoundation
import UniformTypeIdentifiers

enum MetadataExporter {
    
    static var output: JSONBatchDocument?

    static func prepareBatchForExport(metadata: [NftRenderer.NftJson], filename: String) throws {
        // Create a temporary directory for JSON files
        let tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
        
        // Write each JSON item as a separate file
        for (index, item) in metadata.enumerated() {
            let jsonFileURL = tempDirectory.appendingPathComponent(item.name+"-#\(index).json")
            let jsonData = try JSONEncoder().encode(item)
            try jsonData.write(to: jsonFileURL)
        }
        
        // Create a ZIP archive from the temporary directory
        let zipFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(filename).zip")
        
        // Clean up any existing ZIP file
        if FileManager.default.fileExists(atPath: zipFileURL.path) {
            try FileManager.default.removeItem(at: zipFileURL)
        }
        
        // Create a ZIP archive from the temporary directory
        try FileManager.default.zipItem(at: tempDirectory, to: zipFileURL)

        // Clean up the temporary directory
        try FileManager.default.removeItem(at: tempDirectory)
        
        // Set the ZIP file URL for export
        MetadataExporter.output = JSONBatchDocument(fileURL: zipFileURL)
    }
}

extension MetadataExporter {

    struct JSONBatchDocument: FileDocument {
        static var readableContentTypes: [UTType] { [.zip] }

        var fileURL: URL

        init(fileURL: URL) {
            self.fileURL = fileURL
        }

        init(configuration: ReadConfiguration) throws {
            fatalError("Reading is not implemented.")
        }

        func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
            let data = try Data(contentsOf: fileURL)
            return FileWrapper(regularFileWithContents: data)
        }
    }
}
#endif
