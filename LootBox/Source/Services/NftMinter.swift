//
//  NftMinter.swift
//  LootBox
//
//  Created by Matej on 01/05/2023.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation

enum NftMinter {
    
    private static let service = NFTPortService(session: .shared)
    
    static func mint(nft: NFTMetadata, for walletAddress: String) async throws {
        let metadata = NFTPortService.RequestData.EasyMint.NftMetadata(
            nftName: nft.name,
            nftDescription: nft.description,
            walletAddress: walletAddress,
            localFileURL: nft.localImageFileURL,
            fileName: nft.fileName)
        let response = try await Self.service.easyMint(metadata: metadata)
        if !response.success {
            throw AppError.mintFailed
        }
    }

}
