//
//  NFTPort.Response.swift
//  LootBox
//
//  Created by Matej on 01/05/2023.
//  Copyright © 2020 Matej Kokosinek. All rights reserved.
//

import Foundation

extension NFTPortService {
    
    enum RequestData {
        enum EasyMint {
            struct NftMetadata: Encodable {
                let nftName: String
                let nftDescription: String
                let walletAddress: String
                let localFileURL: URL
                let fileName: String
            }
            
            struct Response: Decodable {
                /// Response status, either OK or NOK.
                let response: String
                var success: Bool { response == "OK" }
                let message: String?
            }
        }
        
        enum UploadToIPFS {
            struct Response: Decodable {
                let response: String
                let ipfs_url: String
                let file_name: String
                let content_type: String
                let file_size: Int
                let file_size_mb: Decimal
            }
        }
    }

}
