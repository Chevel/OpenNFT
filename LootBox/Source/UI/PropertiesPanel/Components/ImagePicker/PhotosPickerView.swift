//
//  PhotosPickerView.swift
//  LootBox
//
//  Created by Matej on 21. 10. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

#if os(iOS)
import SwiftUI
import PhotosUI

struct PhotosPickerView: View {

    @Environment(AppStateManager.self) var appStateManager: AppStateManager
    
    @State private var selectedItems = [PhotosPickerItem]()
    @State private var selectedImages = [ImageData]()
    @State private var isShown = false

    var view: any View
    var didSelectedImages: ((Result<[ImageData], AppError>) -> Void)

    var body: some View {
        AnyView(view)
            .onTapGesture {
                isShown = true
            }
            .photosPicker(isPresented: $isShown, selection: $selectedItems, matching: .images)
            .onChange(of: selectedItems) { _, newItems in
                Task {
                    guard !newItems.isEmpty else { return }
                    defer {
                        selectedItems = []
                        selectedImages = []
                        appStateManager.isLoadingPhotos = false
                        isShown = false
                    }
                    
                    appStateManager.isLoadingPhotos = true
                    do {
                        for item in newItems {
                            let url = try await getURL(item: item)
                            if let imageData = try await item.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                                selectedImages.append(ImageData(name: url.filenameWithoutFileTypeExtension, image: image))
                            }
                        }
                        didSelectedImages(.success(selectedImages))
                    } catch {
                        didSelectedImages(.failure(.generic))
                    }
                }
            }
    }
}

private extension PhotosPickerView {

    func getURL(item: PhotosPickerItem) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            // Step 1: Load as Data object.
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let contentType = item.supportedContentTypes.first {
                        
                        // Step 1: https://www.hackingwithswift.com/books/ios-swiftui/writing-data-to-the-documents-directory
                        // find all possible documents directories for this user
                        // just send back the first one, which ought to be the only one
                        var getDocumentsDirectory: URL? { FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first }
                        
                        // Step 2: make the URL file name and a get a file extention.
                        let url = getDocumentsDirectory?.appendingPathComponent("\(UUID().uuidString).\(contentType.preferredFilenameExtension ?? "")")
                        if let data = data, let url {
                            do {
                                // Step 3: write to temp App file directory and return in completionHandler
                                try data.write(to: url)
                                continuation.resume(returning: url)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        }
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

// MARK: - Data

extension PhotosPickerView {
    
    struct ImageData {
        let name: String
        let image: UIImage
    }
}
#endif
