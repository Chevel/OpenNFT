//
//  FilePickerView.swift
//  LootBox
//
//  Created by Matej on 21. 10. 24.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//


// "Not used currently, but a nice to have code."
#if os(iOS)
import SwiftUI

struct FilePickerIcon: View {

    @Environment(AppStateManager.self) private var appStateManager: AppStateManager
    @State private var isImporting: Bool = false
    @State private var wasTapped = false

    var view: any View
    var didSelectedFile: ((Result<ImageData, Error>) -> Void)

    var body: some View {
        Button(action: {

            isImporting = true

            wasTapped.toggle()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                wasTapped.toggle()
            }
        }, label: {
            AnyView(view)
        })
        .scaleEffect(wasTapped ? 1.15 : 1)
        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.image], onCompletion: { result in
            switch result {
            case .success(let url):
                
                // Request temporary access to the security-scoped resource
                let isFileAccessGranted = url.startAccessingSecurityScopedResource()
                guard isFileAccessGranted else {
                    return
                }
                
                // file
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    didSelectedFile(.success(ImageData(name: url.filenameWithoutFileTypeExtension, image: image)))
                }

                // Stop accessing the resource after use
                url.stopAccessingSecurityScopedResource()
                
            case .failure:
                didSelectedFile(.failure(AppError.parse))
            }
        })
    }
}

// MARK: - Data

extension FilePickerIcon {
    
    struct ImageData {
        let name: String
        let image: UIImage
    }
}
#endif
